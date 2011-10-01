//
//  Platform.h
//  PaintRunner
//
//  Created by Kelvin on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

typedef enum {
    platformA = 0,
    platformB,
    platformC,
    platform_Max,
} PlatformTypes;

@interface Platform : CCSprite {
    PlatformTypes platformType;
}

+(id) platformWithType:(PlatformTypes)platformType;

@end
