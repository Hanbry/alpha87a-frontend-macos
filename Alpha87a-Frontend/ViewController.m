//
//  ViewController.m
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 07.02.23.
//

#import "ViewController.h"
#import "EnhancedDataView.h"

@interface ViewController ()
@property NSTimer *mainRcvTimer;
@property EnhancedDataView *enhancedDataViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainDeviceInterface = [DeviceInterface new];
    
    [self.serialDeviceComboBox removeAllItems];
    [self.serialDeviceComboBox addItemsWithObjectValues:[self.mainDeviceInterface serialDevices]];
    [self.serialDeviceComboBox selectItemAtIndex:0];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    NSWindowController *window = segue.destinationController;
    self.enhancedDataViewController = (EnhancedDataView *)window.window.contentViewController;
}

- (IBAction)pushSerialDeviceComboBox:(NSComboBox *)sender {
    [self.mainRcvTimer invalidate];
    [self.mainDeviceInterface disconnectDevice];
    
    [self.mainDeviceInterface connectDevice:sender.stringValue];
    self.mainRcvTimer = [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(updateUI) userInfo:NULL repeats:YES];
}

- (IBAction)mainSwitchButton:(NSButton *)sender {
    switch (sender.tag) {
        case 0: {
            if (sender.state == NSControlStateValueOn) {
                [self.mainDeviceInterface executeCommand:@"MODE HIGH\r\n"];
            } else {
                [self.mainDeviceInterface executeCommand:@"MODE LOW\r\n"];
            }
            break;
        }
        case 1: {
            if (sender.state == NSControlStateValueOn) {
                [self.mainDeviceInterface executeCommand:@"OPER ON\r\n"];
            } else {
                [self.mainDeviceInterface executeCommand:@"OPER OFF\r\n"];
            }
            break;
        }
        case 2: {
            [self.mainDeviceInterface executeCommand:@"AC ON\r\n"];
            break;
        }
        case 3: {
            [self.mainDeviceInterface executeCommand:@"AC OFF\r\n"];
        }
        default:
            break;
    }
}

- (IBAction)tuneGroupButton:(NSButton *)sender {
    [self.meterHVButton setState:NO];
    [self.meterIPButton setState:NO];
    [self.meterTuneButton setState:NO];
    [sender setState:YES];
    switch (sender.tag) {
        case 0:
            [self.mainDeviceInterface executeCommand:@"METER TUNE\r\n"];
            break;
        case 1:
            [self.mainDeviceInterface executeCommand:@"METER IP\r\n"];
            break;
        case 2:
            [self.mainDeviceInterface executeCommand:@"METER HV\r\n"];
            break;
        default:
            break;
    }
}

- (IBAction)bandGroupButton:(NSButton *)sender {
    if (sender.tag <= 8) {
        NSString *bandSetComand = [NSString stringWithFormat:@"BAND %li\r\n", sender.tag + 1];
        [self.mainDeviceInterface executeCommand:bandSetComand];
    }
    
    if (sender.tag > 8) {
        NSString *bandSetComand = [NSString stringWithFormat:@"SEG %li\r\n", sender.tag - 9 + 1];
        [self.mainDeviceInterface executeCommand:bandSetComand];
    }
}

- (IBAction)mainGroupButton:(NSButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.mainDeviceInterface executeCommand:@"DEF\r\n"];
            break;
        case 1:
            [self.mainDeviceInterface executeCommand:@"TUNE DOWN\r\n"];
            break;
        case 2:
            [self.mainDeviceInterface executeCommand:@"TUNE UP\r\n"];
            break;
        case 3:
            [self.mainDeviceInterface executeCommand:@"LOAD DOWN\r\n"];
            break;
        case 4:
            [self.mainDeviceInterface executeCommand:@"LOAD UP\r\n"];
            break;
        case 5:
            [self.mainDeviceInterface executeCommand:@"ENT\r\n"];
            break;
        default:
            break;
    }
    [self.mainDeviceInterface executeCommand:@"ac on\r\n"];
}

- (NSDictionary *)getCurrentSettings {
    [self.mainDeviceInterface executeCommand:@"STAT\r\n"];
    [self.mainDeviceInterface executeCommand:@"PWR\r\n"];
    [self.mainDeviceInterface executeCommand:@"REFL\r\n"];
    [self.mainDeviceInterface executeCommand:@"GRID\r\n"];
    [self.mainDeviceInterface executeCommand:@"METER\r\n"];
    NSDictionary *currentSettings = [self readResponse];
    return currentSettings;
}

- (void)updateUIFromData:(NSDictionary *)settings {
    NSNumber *band = [settings objectForKey:@"BAND"];
    NSNumber *segment = [settings objectForKey:@"SEGMENT"];
    NSString *state = [settings objectForKey:@"STATE"];
    NSString *mode = [settings objectForKey:@"MODE"];
    NSNumber *ip = [settings objectForKey:@"IP"];
    NSNumber *hv = [settings objectForKey:@"HV"];
    NSNumber *rfl = [settings objectForKey:@"RFL"];
    NSNumber *ig = [settings objectForKey:@"IG"];
    NSNumber *fwd = [settings objectForKey:@"FWD"];
    NSNumber *freq = [settings objectForKey:@"FREQUENCY"];
    
    if (self.enhancedDataViewController) {
        if (self.enhancedDataViewController.RFOutputValues.count >= 5) [self.enhancedDataViewController.RFOutputValues removeObjectAtIndex:0];
        if (fwd) [self.enhancedDataViewController.RFOutputValues addObject:fwd];
        if (self.enhancedDataViewController.gridCurrentValues.count >= 5) [self.enhancedDataViewController.gridCurrentValues removeObjectAtIndex:0];
        if (ig) [self.enhancedDataViewController.gridCurrentValues addObject:ig];
        if (self.enhancedDataViewController.reflectedPowerValues.count >= 5) [self.enhancedDataViewController.reflectedPowerValues removeObjectAtIndex:0];
        if (rfl) [self.enhancedDataViewController.reflectedPowerValues addObject:rfl];
        self.enhancedDataViewController.frequencyValue = freq.intValue;
        self.enhancedDataViewController.amplifierValue = [state copy];
    }
    
    NSArray *rfOutLamps = @[self.rfOutputLamp1, self.rfOutputLamp2, self.rfOutputLamp3, self.rfOutputLamp4, self.rfOutputLamp5, self.rfOutputLamp6, self.rfOutputLamp7, self.rfOutputLamp8, self.rfOutputLamp9, self.rfOutputLamp10, self.rfOutputLamp11, self.rfOutputLamp12, self.rfOutputLamp13, self.rfOutputLamp14, self.rfOutputLamp15, self.rfOutputLamp16, self.rfOutputLamp17, self.rfOutputLamp18, self.rfOutputLamp19, self.rfOutputLamp20];
    
    NSDictionary *fwdLedMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @0, @0,
                                    @19, @1,
                                    @53, @2,
                                    @91, @3,
                                    @134, @4,
                                    @184, @5,
                                    @241, @6,
                                    @307, @7,
                                    @383, @8,
                                    @470, @9,
                                    @570, @10,
                                    @683, @11,
                                    @811, @12,
                                    @955, @13,
                                    @1116, @14,
                                    @1296, @15,
                                    @1495, @16,
                                    @1495, @16,
                                    @1715, @17,
                                    @1957, @18,
                                    @2222, @19,
                                    @2512, @20,
                                 nil];
    
    NSArray *gridCurrentLamps = @[self.gridCurrentLamp1, self.gridCurrentLamp2, self.gridCurrentLamp3, self.gridCurrentLamp4, self.gridCurrentLamp5, self.gridCurrentLamp6, self.gridCurrentLamp7, self.gridCurrentLamp8, self.gridCurrentLamp9];
    
    NSArray *reflectedPowerLamps = @[self.reflectedPowerLamp1, self.reflectedPowerLamp2, self.reflectedPowerLamp3, self.reflectedPowerLamp4, self.reflectedPowerLamp5, self.reflectedPowerLamp6, self.reflectedPowerLamp7, self.reflectedPowerLamp8, self.reflectedPowerLamp9];
    
    NSDictionary *rflLedMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @0, @0,
                                    @2, @1,
                                    @8, @2,
                                    @21, @3,
                                    @41, @4,
                                    @66, @5,
                                    @99, @6,
                                    @137, @7,
                                    @182, @8,
                                    @233, @9,
                                 nil];
    
    NSArray *tuneLamps = @[self.tuneSquareLamp1, self.tuneSquareLamp2, self.tuneSquareLamp3, self.tuneSquareLamp4, self.tuneSquareLamp5, self.tuneSquareLamp6, self.tuneSquareLamp7, self.tuneSquareLamp8, self.tuneSquareLamp9, self.tuneSquareLamp10, self.tuneSquareLamp11, self.tuneSquareLamp12, self.tuneSquareLamp13, self.tuneSquareLamp14, self.tuneSquareLamp15, self.tuneSquareLamp16, self.tuneSquareLamp17, self.tuneSquareLamp18, self.tuneSquareLamp19, self.tuneSquareLamp20];
    
    [rfOutLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
        NSNumber *lampValue = [fwdLedMapping objectForKey: [NSNumber numberWithUnsignedLong:idx + 1]];
        if (fwd.floatValue >= lampValue.floatValue) {
            if (idx >= 16) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOn"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOn"]];
            }
        } else {
            if (idx >= 16) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff"]];
            }
        }
    }];
    
    [reflectedPowerLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
        NSNumber *lampValue = [rflLedMapping objectForKey: [NSNumber numberWithUnsignedLong:idx + 1]];
        if (rfl.floatValue >= lampValue.floatValue) {
            if (idx >= 4 && idx <= 5) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOn"]];
            } else if (idx > 5) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOn"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOn"]];
            }
        } else {
            if (idx >= 4 && idx <= 5) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff"]];
            } else if (idx > 5) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff"]];
            }
        }
    }];
    
    [gridCurrentLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
        float idxAmps = (idx + 1) * 17.5;
        float igFloat = ig.floatValue;
        if (idxAmps <= igFloat) {
            if (idx == 6) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOn"]];
            } else if (idx >= 7) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOn"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOn"]];
            }
        } else {
            if (idx == 6) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff"]];
            } else if (idx >= 7) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff"]];
            }
        }
    }];
    
    if (ip) {
        [tuneLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
            float idxAmps = (idx + 1) * 0.075;
            float ipFloat = ip.floatValue;
            if (idxAmps <= ipFloat && (idxAmps + 0.075) > ipFloat) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOn"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOff"]];
            }
        }];
    }
    
    if (hv) {
        [tuneLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
            float idxVolts = (idx + 1) * 150;
            float hvFloat = hv.floatValue;
            if (idxVolts <= hvFloat && (idxVolts + 150) > hvFloat) {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOn"]];
            } else {
                [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOff"]];
            }
        }];
    }
    
    NSArray *bandButtons = @[self.bandButton1, self.bandButton2, self.bandButton3, self.bandButton4, self.bandButton5, self.bandButton6, self.bandButton7, self.bandButton8, self.bandButton9];
    
    [bandButtons enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
        [button setState:(idx + 1) == band.intValue ? NSControlStateValueOn : NSControlStateValueOff];
    }];
    
    NSArray *segmentButtons = @[self.segmentButton1, self.segmentButton2, self.segmentButton3, self.segmentButton4, self.segmentButton5];
    
    [segmentButtons enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
        [button setState:(idx + 1) == segment.intValue ? NSControlStateValueOn : NSControlStateValueOff];
    }];
    
    if ([mode isEqualToString:@"HIGH"]) {
        [self.hiloButton setState:NSControlStateValueOn];
    } else if ([mode isEqualToString:@"LOW"]) {
        [self.hiloButton setState:NSControlStateValueOff];
    }
    
    if ([state isEqualToString:@"OPERATE"]) {
        [self.OPRLamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOn.png"]];
        [self.STBYLamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff.png"]];
        [self.WAITLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.FAULTLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.PLATELamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.TRLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.oprstbyButton setState:NSControlStateValueOn];
    } else if ([state isEqualToString:@"STANDBY"]) {
        [self.oprstbyButton setState:NSControlStateValueOff];
        [self.OPRLamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff.png"]];
        [self.STBYLamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOn.png"]];
        [self.WAITLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.FAULTLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.PLATELamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.TRLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
    } else if ([state isEqualToString:@"WARMUP"]) {
        [self.OPRLamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff.png"]];
        [self.STBYLamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff.png"]];
        [self.WAITLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOn"]];
        [self.FAULTLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.PLATELamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.TRLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
    } else if ([state isEqualToString:@"FAULT"]) {
        [self.OPRLamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff.png"]];
        [self.STBYLamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff.png"]];
        [self.WAITLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.FAULTLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOn"]];
        [self.PLATELamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.TRLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
    } else if ([state isEqualToString:@"OFF"]) {
        [self.OPRLamp setImage:[NSImage imageNamed:@"ALPHA87A-GreenLightOff.png"]];
        [self.STBYLamp setImage:[NSImage imageNamed:@"ALPHA87A-OrangeLightOff.png"]];
        [self.WAITLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.FAULTLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.PLATELamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        [self.TRLamp setImage:[NSImage imageNamed:@"ALPHA87A-RedLightOff"]];
        
        [bandButtons enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
                [button setState:NSControlStateValueOff];
        }];
        
        [segmentButtons enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
                [button setState:NSControlStateValueOff];
        }];
        
        [self.meterHVButton setState:NO];
        [self.meterIPButton setState:NO];
        [self.meterTuneButton setState:NO];
    }
    
    NSString *unmatchedString = [settings objectForKey:@"unmatchedResponse"];
    NSArray *lines = [unmatchedString componentsSeparatedByString:@"\n"];
    
    if ([unmatchedString containsString:@"DEFAULT"]) {
        [self.defaultButton setState:NSControlStateValueOn];
    } else if ([unmatchedString containsString:@"USER"]) {
        [self.defaultButton setState:NSControlStateValueOff];
    }
    
    if ([unmatchedString containsString:@"READY FOR INPUT OF SEGMENT"]) {
        NSTimer *blinkingTimer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.enterMode = kEnterModeOn;
            if ([self.enterButton state] == NSControlStateValueOn) {
                [self.enterButton setState:NSControlStateValueOff];
            } else {
                [self.enterButton setState:NSControlStateValueOn];
            }
        }];
        NSTimer *blinkEndTimer = [NSTimer timerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [blinkingTimer invalidate];
            [timer invalidate];
            self.enterMode = kEnterModeOff;
            [self.enterButton setState:NSControlStateValueOff];
        }];
        
        [[NSRunLoop mainRunLoop] addTimer:blinkingTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:blinkEndTimer forMode:NSDefaultRunLoopMode];
    }
    
    for (NSString *line in lines) {
        NSRange range = [line rangeOfString:@"+"];
        if (range.location != NSNotFound) {
            NSUInteger position = range.location;
            [tuneLamps enumerateObjectsUsingBlock:^(NSImageView *lamp, NSUInteger idx, BOOL *stop) {
                if (idx == position) {
                    [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOn"]];
                } else {
                    [lamp setImage:[NSImage imageNamed:@"ALPHA87A-SquareLightOff"]];
                }
            }];
        }
    }
        
}

- (NSDictionary *)readResponse {
    NSString *response = [self.mainDeviceInterface read];
    
    if ([response isEqualToString:@""] || response == nil) {
        return nil;
    }

    // Aktualisiertes Pattern, um auch Dezimalwerte zu erfassen
    NSString *pattern = @"(\\w+)\\s*=\\s*([\\d\\.]+|\\w+)";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableString *unmatchedString = [NSMutableString string];
    
    __block NSUInteger lastPosition = 0;

    [regex enumerateMatchesInString:response
                                options:0
                                  range:NSMakeRange(0, response.length)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        NSRange rangeBeforeMatch = NSMakeRange(lastPosition, match.range.location - lastPosition);
        [unmatchedString appendString:[response substringWithRange:rangeBeforeMatch]];

        lastPosition = NSMaxRange(match.range);

        if (match.numberOfRanges == 3) {
            NSString *key = [response substringWithRange:[match rangeAtIndex:1]];
            NSString *value = [response substringWithRange:[match rangeAtIndex:2]];

            NSScanner *scanner = [NSScanner scannerWithString:value];
            float floatValue;
            if ([scanner scanFloat:&floatValue]) {
                dictionary[key] = @(floatValue);
            } else {
                dictionary[key] = value;
            }
        }
    }];
    if (lastPosition < response.length) {
        NSRange rangeAfterLastMatch = NSMakeRange(lastPosition, response.length - lastPosition);
        [unmatchedString appendString:[response substringWithRange:rangeAfterLastMatch]];
    }

    if (unmatchedString.length > 0) {
        dictionary[@"unmatchedResponse"] = unmatchedString;
    }

    return dictionary;
}

- (void)updateUI {
    NSDictionary *settings = [self getCurrentSettings];
    [self updateUIFromData:settings];
}


@end
