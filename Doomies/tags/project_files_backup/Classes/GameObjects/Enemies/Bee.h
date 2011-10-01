//
//  Bee.h
//  mushroom
//
//  Created by Kelvin on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@interface Bee : Enemy {
    b2Fixture *beeFixture;
    
    BOOL isHit;
    BOOL isBurning;
    BOOL blueColor;
    BOOL onLeftSide;
    
    CCAnimation *blueFlyAnim;
    CCAnimation *redFlyAnim;
}

@property BOOL isHit;
@property BOOL blueColor;
@property BOOL onLeftSide;
@property BOOL isBurning;

@property (nonatomic, retain) CCAnimation *blueFlyAnim;
@property (nonatomic, retain) CCAnimation *redFlyAnim;

-(id) initWithWorld:(b2World*)world;


@end
