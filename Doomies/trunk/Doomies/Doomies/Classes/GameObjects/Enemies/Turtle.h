//
//  Turtle.h
//  mushroom
//
//  Created by Kelvin on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@interface Turtle : Enemy {
    b2Fixture *turtleFixture;
    
    BOOL isHit;
    BOOL isBurning;
    BOOL isFrozen;
    BOOL blueColor;
    BOOL detectMushroom;
    
    CCAnimation *blueWalkAnim;
    CCAnimation *redWalkAnim;
}

@property BOOL isHit;
@property BOOL isBurning;
@property BOOL isFrozen;
@property BOOL blueColor;
@property BOOL detectMushroom;

@property (nonatomic, retain) CCAnimation *blueWalkAnim;
@property (nonatomic, retain) CCAnimation *redWalkAnim;

-(id) initWithWorld:(b2World*)world;


@end
