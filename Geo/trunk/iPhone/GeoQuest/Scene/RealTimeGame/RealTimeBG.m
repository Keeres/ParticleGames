//
//  RealTimeBG.m
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeBG.h"

@implementation RealTimeBG

-(id) initWithRealTimeUILayer:(RealTimeUI *)realUI {
    if ((self = [super init])) {
        CCLOG(@"RealTimeBG: Initialized");
        winSize = [[CCDirector sharedDirector] winSize];
        
        _realTimeUI = realUI;
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}

@end
