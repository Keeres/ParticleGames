//
//  RealTimeScene.m
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeScene.h"

@implementation RealTimeScene

+(id) scene {
    CCScene *scene = [CCScene node];
    
    RealTimeUI *realTimeUI = [RealTimeUI node];
    [scene addChild:realTimeUI z:20];
    
    RealTimeRoom *realTimeRoom = [[[RealTimeRoom alloc] initWithRealTimeUILayer:realTimeUI] autorelease];
    [scene addChild:realTimeRoom z:30];
    
    RealTimeBG *realTimeBG = [[[RealTimeBG alloc] initWithRealTimeUILayer:realTimeUI] autorelease];
    [scene addChild:realTimeBG z:10];
    
    return scene;
}


@end
