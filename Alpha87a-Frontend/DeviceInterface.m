//
//  DeviceInterface.m
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 30.04.23.
//

#import "DeviceInterface.h"

@interface DeviceInterface ()
@property int fileDescriptor;
@end

@implementation DeviceInterface

- (instancetype)init {
    CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOSerialBSDServiceValue);
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(kIOMainPortDefault, matchingDict, &iterator);
    if (result != KERN_SUCCESS) {
        NSLog(@"Failed to get matching services.");
    }
    
    io_object_t device;
    CFStringRef deviceName;
    while ((device = IOIteratorNext(iterator))) {
        deviceName = IORegistryEntryCreateCFProperty(device, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0);
        NSLog(@"Serial port device name: %@", deviceName);
    }
    
    IOObjectRelease(iterator);
    NSString *deviceNameString = (NSString *)CFBridgingRelease(deviceName);
    const char *cStringDeviceName = [deviceNameString cStringUsingEncoding:NSUTF8StringEncoding];


    self.fileDescriptor = open(cStringDeviceName, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (self.fileDescriptor == -1) {
        NSLog(@"Failed to open serial port.");
    }

    struct termios options;
    tcgetattr(self.fileDescriptor, &options);
    cfsetspeed(&options, B9600);
    options.c_cflag &= ~PARENB;
    options.c_cflag &= ~CSTOPB;
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS8;
    options.c_cflag &= ~CRTSCTS;
    options.c_iflag &= ~(IXON | IXOFF | IXANY);
    tcsetattr(self.fileDescriptor, TCSANOW, &options);


    return self;
}

- (void)executeCommand:(NSString *)command {
    [self sendString:command];
}

- (void)sendString:(NSString *)string {
    const char *messageChars = [string cStringUsingEncoding:NSASCIIStringEncoding];
    size_t msg_size = strlen(messageChars);
    write(self.fileDescriptor, messageChars, msg_size);
}

- (NSString *)read {
    char buffer[2048];
    memset(buffer, 0, 2048);
    ssize_t bytesRead = -1;
    NSString *responseString;
    
    bytesRead = read(self.fileDescriptor, buffer, sizeof(buffer));
    
    if (bytesRead > 0) {
        responseString = [[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSASCIIStringEncoding];
    }
    
    return responseString;
}

//- (NSString *)waitForResponse {
//    NSString *response = @"";
//    
//    while ([response isEqualToString:@""]) {
//        response = [self read];
//    }
//    
//    return response;
//}

- (void)dealloc {
    close(self.fileDescriptor);
}

@end
