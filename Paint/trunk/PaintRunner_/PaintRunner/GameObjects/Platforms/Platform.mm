//
//  Platform.mm
//  PaintRunner
//
//  Created by Kelvin on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"

@implementation Platform

-(id) initWithPlatformType:(PlatformTypes)platformWithType {
    platformType = platformWithType;
    
    NSString *platformName;
    
    switch (platformType) {
        case platformA:
            platformName = @"platformA.png";
            break;
        case platformB:
            platformName = @"platformB.png";
            break;
        case platformC:
            platformName = @"platformC.png";
            break;
            
        default:
            [NSException exceptionWithName:@"Platform Exception" reason:@"unhandled platform type" userInfo:nil];
            break;
    }
    
    if ((self = [super initWithSpriteFrameName:platformName])) {
        self.visible = NO;
    }
    
    return self;
}

+(id) platformWithType:(PlatformTypes)platformType {
    return [[[self alloc] initWithPlatformType:platformType] autorelease];
}

-(void) dealloc {
    [super dealloc];
}

@end
