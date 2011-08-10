//
//  VolcanicRockAir.h
//  mushroom
//
//  Created by Steven Chen on 8/9/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"

@interface VolcanicRock : Enemy {
    b2Fixture *RockSensorAir;
    b2Fixture *RockSensorLand;
    
    BOOL hasLanded;
    BOOL isHitLand;
    BOOL isHitAir;
  //  float rockOffset;
    float rockSpeed;
}

@property BOOL hasLanded;
@property BOOL isHitLand;
@property BOOL isHitAir;
//@property float rockOffset;
@property float rockSpeed;

-(id) initWithWorld:(b2World *)world;

@end
