//
//  DeviceInterface.h
//  Alpha87a-Frontend
//
//  Created by Adrian Lohr on 30.04.23.
//

#import <Foundation/Foundation.h>
#import <IOKit/serial/IOSerialKeys.h>
#import <IOKit/serial/ioss.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInterface : NSObject

- (void)executeCommand:(NSString *)command;
- (NSString *)read;

@end

NS_ASSUME_NONNULL_END
