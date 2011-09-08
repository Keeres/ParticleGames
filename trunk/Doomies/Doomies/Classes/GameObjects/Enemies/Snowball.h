//
//  Snowball.h
//  Doomies
//
//  Created by Steven Chen on 8/27/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "StageEffect.h"

@interface Snowball : StageEffect{
    b2Fixture *snowballFixture;
    b2Fixture *snowballSensorFixture;
    b2Body *snowballBody;
    b2Body *snowballSensor;
    
    BOOL isHit;
}

@property b2Body *snowballSensor;
@property BOOL isHit;

-(id) initWithWorld:(b2World *)world;
    
@end
