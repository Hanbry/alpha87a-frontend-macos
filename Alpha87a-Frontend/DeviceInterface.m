//
//  DeviceInterface.m
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 30.04.23.
//

#import <Cocoa/Cocoa.h>
#import "DeviceInterface.h"

@interface DeviceInterface ()
@property int fileDescriptor;
@property BOOL connected;
@end

@implementation DeviceInterface


- (instancetype)init {
    self = [super init];
    if (self) {
    }
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

- (NSArray *)serialDevices {
    
    NSMutableArray *mutableDevices = [[NSMutableArray alloc] init];
    
    CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOSerialBSDServiceValue);
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iterator);
    if (result != KERN_SUCCESS) {
        NSLog(@"Failed to get matching services.");
    }
    
    io_object_t device;
    CFStringRef deviceName;
    while ((device = IOIteratorNext(iterator))) {
        deviceName = IORegistryEntryCreateCFProperty(device, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0);
        [mutableDevices addObject:(NSString *)CFBridgingRelease(deviceName)];
    }
    
    IOObjectRelease(iterator);
    
    return (NSArray *)mutableDevices;
}

- (void)connectDevice:(NSString *)deviceName {
    const char *cStringDeviceName = [deviceName cStringUsingEncoding:NSUTF8StringEncoding];

    self.fileDescriptor = open(cStringDeviceName, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (self.fileDescriptor == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Failed to open serial port."];
        [alert setInformativeText:@"The serial device you have selected does not allow a serial connection."];
        [alert addButtonWithTitle:@"OK"];
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
    
    self.connected = TRUE;
}

- (void)disconnectDevice {
    close(self.fileDescriptor);
}

- (void)dealloc {
    [self disconnectDevice];
}

@end
