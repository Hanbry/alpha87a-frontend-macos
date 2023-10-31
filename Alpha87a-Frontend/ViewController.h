//
//  ViewController.h
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 07.02.23.
//

#import <Cocoa/Cocoa.h>
#import "DeviceInterface.h"


@interface ViewController : NSViewController
- (IBAction)mainGroupButton:(NSButton *)sender;
- (IBAction)bandGroupButton:(NSButton *)sender;
- (IBAction)tuneGroupButton:(NSButton *)sender;
- (IBAction)mainSwitchButton:(NSButton *)sender;

@property (weak) IBOutlet NSImageView *tuneSquareLamp1;
@property (weak) IBOutlet NSImageView *tuneSquareLamp2;
@property (weak) IBOutlet NSImageView *tuneSquareLamp3;
@property (weak) IBOutlet NSImageView *tuneSquareLamp4;
@property (weak) IBOutlet NSImageView *tuneSquareLamp5;
@property (weak) IBOutlet NSImageView *tuneSquareLamp6;
@property (weak) IBOutlet NSImageView *tuneSquareLamp7;
@property (weak) IBOutlet NSImageView *tuneSquareLamp8;
@property (weak) IBOutlet NSImageView *tuneSquareLamp9;
@property (weak) IBOutlet NSImageView *tuneSquareLamp10;
@property (weak) IBOutlet NSImageView *tuneSquareLamp11;
@property (weak) IBOutlet NSImageView *tuneSquareLamp12;
@property (weak) IBOutlet NSImageView *tuneSquareLamp13;
@property (weak) IBOutlet NSImageView *tuneSquareLamp14;
@property (weak) IBOutlet NSImageView *tuneSquareLamp15;
@property (weak) IBOutlet NSImageView *tuneSquareLamp16;
@property (weak) IBOutlet NSImageView *tuneSquareLamp17;
@property (weak) IBOutlet NSImageView *tuneSquareLamp18;
@property (weak) IBOutlet NSImageView *tuneSquareLamp19;
@property (weak) IBOutlet NSImageView *tuneSquareLamp20;

@property (weak) IBOutlet NSImageView *rfOutputLamp1;
@property (weak) IBOutlet NSImageView *rfOutputLamp2;
@property (weak) IBOutlet NSImageView *rfOutputLamp3;
@property (weak) IBOutlet NSImageView *rfOutputLamp4;
@property (weak) IBOutlet NSImageView *rfOutputLamp5;
@property (weak) IBOutlet NSImageView *rfOutputLamp6;
@property (weak) IBOutlet NSImageView *rfOutputLamp7;
@property (weak) IBOutlet NSImageView *rfOutputLamp8;
@property (weak) IBOutlet NSImageView *rfOutputLamp9;
@property (weak) IBOutlet NSImageView *rfOutputLamp10;
@property (weak) IBOutlet NSImageView *rfOutputLamp11;
@property (weak) IBOutlet NSImageView *rfOutputLamp12;
@property (weak) IBOutlet NSImageView *rfOutputLamp13;
@property (weak) IBOutlet NSImageView *rfOutputLamp14;
@property (weak) IBOutlet NSImageView *rfOutputLamp15;
@property (weak) IBOutlet NSImageView *rfOutputLamp16;
@property (weak) IBOutlet NSImageView *rfOutputLamp17;
@property (weak) IBOutlet NSImageView *rfOutputLamp18;
@property (weak) IBOutlet NSImageView *rfOutputLamp19;
@property (weak) IBOutlet NSImageView *rfOutputLamp20;

@property (weak) IBOutlet NSImageView *gridCurrentLamp1;
@property (weak) IBOutlet NSImageView *gridCurrentLamp2;
@property (weak) IBOutlet NSImageView *gridCurrentLamp3;
@property (weak) IBOutlet NSImageView *gridCurrentLamp4;
@property (weak) IBOutlet NSImageView *gridCurrentLamp5;
@property (weak) IBOutlet NSImageView *gridCurrentLamp6;
@property (weak) IBOutlet NSImageView *gridCurrentLamp7;
@property (weak) IBOutlet NSImageView *gridCurrentLamp8;
@property (weak) IBOutlet NSImageView *gridCurrentLamp9;

@property (weak) IBOutlet NSImageView *reflectedPowerLamp1;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp2;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp3;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp4;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp5;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp6;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp7;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp8;
@property (weak) IBOutlet NSImageView *reflectedPowerLamp9;

@property (weak) IBOutlet NSImageView *OPRLamp;
@property (weak) IBOutlet NSImageView *STBYLamp;
@property (weak) IBOutlet NSImageView *WAITLamp;
@property (weak) IBOutlet NSImageView *FAULTLamp;
@property (weak) IBOutlet NSImageView *PLATELamp;
@property (weak) IBOutlet NSImageView *TRLamp;

// Non UI properties

@property DeviceInterface *mainDeviceInterface;

@end

