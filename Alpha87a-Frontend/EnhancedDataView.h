//
//  EnhancedDataView.h
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 28.04.24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedDataView : NSViewController

@property (weak) IBOutlet NSTextField *RFOutputLabel;
@property (weak) IBOutlet NSTextField *gridCurrentLabel;
@property (weak) IBOutlet NSTextField *peakPowerLabel;
@property (weak) IBOutlet NSTextField *reflectedPowerLabel;
@property (weak) IBOutlet NSTextField *VSWRLabel;
@property (weak) IBOutlet NSTextField *frequencyLabel;
@property (weak) IBOutlet NSTextField *amplifierLabel;

@property NSMutableArray *RFOutputValues;
@property NSMutableArray *gridCurrentValues;
@property NSMutableArray *reflectedPowerValues;
@property int frequencyValue;
@property NSString *amplifierValue;

@end

NS_ASSUME_NONNULL_END
