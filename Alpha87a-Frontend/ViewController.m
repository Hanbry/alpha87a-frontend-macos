//
//  ViewController.m
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 07.02.23.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.mainDeviceInterface = [DeviceInterface new];
    
    // Set up device information polling routine
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateUI) userInfo:NULL repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(readResponse) userInfo:NULL repeats:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)mainSwitchButton:(NSButton *)sender {
    NSLog(@"Test");
    switch (sender.tag) {
        case 2: {
            [self.mainDeviceInterface executeCommand:@"ac on\r\n"];
            break;
        }
        case 3: {
            [self.mainDeviceInterface executeCommand:@"ac off\r\n"];
        }
        default:
            break;
    }
}

- (IBAction)tuneGroupButton:(NSButton *)sender {
}

- (IBAction)bandGroupButton:(NSButton *)sender {
}

- (IBAction)mainGroupButton:(NSButton *)sender {
    [self.mainDeviceInterface executeCommand:@"ac on\r\n"];
}

- (NSDictionary *)getCurrentSettings {
    NSLog(@"load current settings");
    [self.mainDeviceInterface executeCommand:@"STAT\r\n"];
    return [NSDictionary new];
}

- (void)updateUIFromData:(NSDictionary *)settings {
    
}

- (void)readResponse {
    NSString *response = [self.mainDeviceInterface read];
    NSLog(@"%@", response);
}

- (void)updateUI {
    NSLog(@"updateUI");
//    NSDictionary *settings = [self getCurrentSettings];
    [self getCurrentSettings];
    //[self updateUIFromData:settings];
}


@end
