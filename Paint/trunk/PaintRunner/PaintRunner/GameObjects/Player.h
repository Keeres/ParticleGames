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
    float basePlayerScale;
    float previousPlayerScale;
    float jumpTime;
}

@property CGPoint openGLPosition;
@property CGPoint previousPosition;
@property BOOL isJumping;
@property BOOL isJumpingLeft;
//@property BOOL isJumpingRight;
@property BOOL doubleJumpAvailable;
@property BOOL died;
@property float basePlayerScale;
@property float jumpTime;

-(id) initWithWorld:(b2World*)world;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andSpeed:(float)speed;
-(void) resetPlayer;

@end
