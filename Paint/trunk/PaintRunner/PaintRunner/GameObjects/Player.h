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
    BOOL doubleJumpAvailable;
    float basePlayerScale;
    float previousPlayerScale;
    float jumpTime;
}

@property CGPoint openGLPosition;
@property CGPoint previousPosition;
@property BOOL isJumping;
@property BOOL doubleJumpAvailable;
@property float basePlayerScale;
@property float jumpTime;

-(id) initWithWorld:(b2World*)world;

@end
