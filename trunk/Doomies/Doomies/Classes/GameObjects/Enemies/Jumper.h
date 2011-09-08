//
//  Jumper.h
//  mushroom
//
//  Created by Kelvin on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@interface Jumper : Enemy {
    b2Fixture *jumperFixture;
    
    BOOL isHit;
    BOOL blueColor;
    BOOL isBurning;
    BOOL isFrozen;
    
    float jumpTimer;
    
    CCAnimation *blueJumpAnim;
    CCAnimation *blueLandAnim;
    CCAnimation *redJumpAnim;
    CCAnimation *redLandAnim;
}

@property BOOL isHit;
@property BOOL blueColor;
@property BOOL isBurning;
@property BOOL isFrozen;

@property (nonatomic, retain) CCAnimation *blueJumpAnim;
@property (nonatomic, retain) CCAnimation *blueLandAnim;
@property (nonatomic, retain) CCAnimation *redJumpAnim;
@property (nonatomic, retain) CCAnimation *redLandAnim;

-(id) initWithWorld:(b2World*)world;
@end
