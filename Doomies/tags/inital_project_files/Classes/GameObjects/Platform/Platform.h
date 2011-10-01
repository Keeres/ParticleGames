//
//  Platform.h
//  mushroom
//
//  Created by Kelvin on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    LargePlatformA = 0,
    LargePlatformB,
    LargePlatformC,
    LargePlatformD,
    SmallPlatformA,
    SmallPlatformB,
    SmallPlatformC,
    SmallPlatformD,
    PlatformType_MAX,
}PlatformTypes;

@interface Platform : CCSprite {
    PlatformTypes platformType;
}

+(id) platformWithType:(PlatformTypes) platformType;

@end
