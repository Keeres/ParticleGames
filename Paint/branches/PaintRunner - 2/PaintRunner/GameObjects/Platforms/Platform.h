//
//  Platform.h
//  PaintRunner
//
//  Created by Kelvin on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "CommonProtocols.h"

typedef enum {
    platformA = 0,
    //platformB,
    //platformC,
    //platformD = 0,
    totalPlatformTypes,
} PlatformTypes;

@interface Platform : Box2DSprite {
    //Box2D
    b2World *world;
    b2Fixture *platformFixture;
    
    //Variables
    PlatformTypes platformType;
    BOOL readyToMove;
    BOOL isHit;
    int easyPlatform;
    float finalHeight;
    CGPoint platformFinalPosition;
    int platformNumber;
}

@property (readwrite) BOOL readyToMove;
@property (readwrite) BOOL isHit;
@property (readwrite) int easyPlatform;
@property (readwrite) float finalHeight;
@property (readwrite) int platformNumber;
@property (readwrite) CGPoint platformFinalPosition;

//+(id) platformWithType:(PlatformTypes)platformType inWorld:(b2World*)theWorld;
-(id) initWithWorld:(b2World*)theWorld andPlatformType:(PlatformTypes)platformWithType;
-(id) initSideWithWorld:(b2World*)theWorld;
-(id) initInitialGroundPlatformWithWorld:(b2World*)theWorld;
-(void) despawn;


@end
