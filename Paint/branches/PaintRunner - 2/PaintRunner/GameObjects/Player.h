//
//  Player.h
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2DSprite.h"
#import "CommonProtocols.h"
#import "Constants.h"
#import "Box2DHelpers.h"

#define jumpVelocity 4.8

@interface Player : Box2DSprite {
    //Box2D
    b2Fixture *playerFixture;
    b2Fixture *playerSensor;
    
    //Variables
    CGSize winSize;
    CGPoint openGLPosition;
    CGPoint previousPosition;
    BOOL isJumping;
    BOOL isJumpingLeft;
    //BOOL isJumpingRight;
    BOOL doubleJumpAvailable;
    BOOL died;
    int platformNumber;
    float basePlayerScale;
    float previousPlayerScale;
    float jumpTime;
    float lastPlatformHeightTouched;
}

@property (readwrite) CGPoint openGLPosition;
@property (readwrite) CGPoint previousPosition;
@property (readwrite) BOOL isJumping;
@property (readwrite) BOOL doubleJumpAvailable;
@property (readwrite) BOOL died;
@property (readwrite) int platformNumber;
@property (readwrite) float basePlayerScale;
@property (readwrite) float jumpTime;
@property (readwrite) float lastPlatformHeightTouched;

-(id) initWithWorld:(b2World*)world;
-(void) spawn;
-(void) despawn;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andSpeed:(float)speed;
-(void) resetPlayer;

@end
