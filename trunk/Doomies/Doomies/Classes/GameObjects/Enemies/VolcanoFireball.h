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
    b2Fixture *fireballSensor;
    b2Body *fireballSensorBody;
    
    BOOL hasLanded;
    BOOL isLanding;
    float landingOffset;
    float fireballSpeed;
}

@property BOOL hasLanded;
@property BOOL isLanding;
@property b2Body *fireballSensorBody;
@property float fireballSpeed;

-(id) initWithWorld:(b2World *)world;

@end
