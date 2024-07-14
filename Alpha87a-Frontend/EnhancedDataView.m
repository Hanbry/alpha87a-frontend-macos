//
//  EnhancedDataView.m
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 28.04.24.
//

#import "EnhancedDataView.h"

@implementation EnhancedDataView

- (void)viewDidLoad {
    [super viewDidLoad];
    _RFOutputValues = [[NSMutableArray alloc] init];
    _gridCurrentValues = [[NSMutableArray alloc] init];
    _reflectedPowerValues = [[NSMutableArray alloc] init];
    _frequencyValue = 0;
    _amplifierValue = @"";
    
    
    [self addObserver:self forKeyPath:@"RFOutputValues" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"gridCurrentValues" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"reflectedPowerValues" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"inputPowerValues" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"frequencyValue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"amplifierValue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (int)peak:(NSArray *)array {
    if (!array)
        return 0;
        
    int peak = 0;
    for (NSNumber *num in array) {
        int val = num.intValue;
        if (val > peak) peak = val;
    }
    return peak;
}

- (float)mean:(NSArray *)array {
    if (!array)
        return 0;
    
    float sum = 0;
    for (NSNumber *num in array) {
        sum += num.intValue;
    }
    
    return sum/array.count;
}

- (void)update {
    float RFOutputMean = [self mean:self.RFOutputValues];
    float reflectedPowerMean = [self mean:self.reflectedPowerValues];
    float gridCurrentMean = [self mean:self.gridCurrentValues];
//    float inputPowerMean = [self mean:self.inputPowerValues];
    int peakPower = [self peak:self.RFOutputValues];
    
    NSString *ampValueString = (self.amplifierValue) ? self.amplifierValue : @"";
    
    float vswrDenominator = sqrt(RFOutputMean) - sqrt(reflectedPowerMean);
    vswrDenominator = (vswrDenominator == 0)? NSIntegerMin : vswrDenominator;
    float vswr = (sqrt(RFOutputMean) + sqrt(reflectedPowerMean)) / vswrDenominator;
    
    [self.RFOutputLabel setStringValue:[NSString stringWithFormat:@"%.2f W", RFOutputMean]];
    [self.gridCurrentLabel setStringValue:[NSString stringWithFormat:@"%.2f mA", gridCurrentMean]];
    [self.peakPowerLabel setStringValue:[NSString stringWithFormat:@"%d W", peakPower]];
    [self.reflectedPowerLabel setStringValue:[NSString stringWithFormat:@"%.2f W", reflectedPowerMean]];
    [self.VSWRLabel setStringValue:[NSString stringWithFormat:@"%.2f", vswr]];
    [self.frequencyLabel setStringValue:[NSString stringWithFormat:@"%d kHz", self.frequencyValue]];
    [self.amplifierLabel setStringValue:ampValueString];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self update];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"RFOutputValues"];
    [self removeObserver:self forKeyPath:@"gridCurrentValues"];
    [self removeObserver:self forKeyPath:@"peakPowerValues"];
    [self removeObserver:self forKeyPath:@"reflectedPowerValues"];
    [self removeObserver:self forKeyPath:@"VSWRValues"];
    [self removeObserver:self forKeyPath:@"inputPowerValues"];
    [self removeObserver:self forKeyPath:@"frequencyValues"];
    [self removeObserver:self forKeyPath:@"amplifierValues"];
}

@end
