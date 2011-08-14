//
//  Platform.mm
//  mushroom
//
//  Created by Kelvin on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"

@implementation Platform

-(id) initWithPlatformType:(PlatformTypes) platformWithType {
    platformType = platformWithType;
    
    NSString *platformFrameName;
    
    switch (platformType) {
        case LargePlatformA:
            platformFrameName = @"large_A.png";
            break;
        case LargePlatformB:
            platformFrameName = @"large_B.png";
            break;
        case LargePlatformC:
            platformFrameName = @"large_C.png";
            break;
        case LargePlatformD:
            platformFrameName = @"large_D.png";
            break;
        case SmallPlatformA:
            platformFrameName = @"small_A.png";
            break;
        case SmallPlatformB:
            platformFrameName = @"small_B.png";
            break;
        case SmallPlatformC:
            platformFrameName = @"small_C.png";
            break;
        case SmallPlatformD:
            platformFrameName = @"small_D.png";
            break;
            
        default:
            [NSException exceptionWithName:@"Platform Exception" reason:@"unhandled platform type" userInfo:nil];
            break;
    }
    
    if ((self = [super initWithSpriteFrameName:platformFrameName])) {
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
