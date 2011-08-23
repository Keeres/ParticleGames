//
//  VolcanicFireball.h
//  mushroom
//
//  Created by Steven Chen on 8/9/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StageEffect.h"

@interface VolcanoFireball : StageEffect {
    b2Fixture *RockSensor;
    b2Body *RockSensorBody;
   // b2Fixture *RockSensorLand;
    
    BOOL hasLanded;
    BOOL isLanding;
    float landingOffset;
    float fireballSpeed;
}

@property BOOL hasLanded;
//@property BOOL isHitLand;
//@property BOOL isHitAir;
@property BOOL isLanding;
@property b2Body *rockSensorBody;
//@property float rockOffset;
@property float fireballSpeed;

-(id) initWithWorld:(b2World *)world;

@end
