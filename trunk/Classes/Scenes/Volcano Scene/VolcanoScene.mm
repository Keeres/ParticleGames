//
//  GameScene.m
//  mushroom
//
//  Created by Kelvin on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VolcanoScene.h"
//#import "GameActionLayer.h"
//#import "GameUILayer.h"


@implementation VolcanoScene

-(id) init {
    if ((self = [super init])) {
        uiLayer = [GameUILayer node];
        [self addChild:uiLayer z:2];
        
        //GameBackgroundLayer *backgroundLayer = [[[GameBackgroundLayer alloc] init] autorelease];
        
        backgroundLayer = [GameBackgroundLayer node];
        [self addChild:backgroundLayer z:0];

        GameActionLayer *actionLayer = [[[GameActionLayer alloc] initWithGameUILayer:uiLayer andBackgroundLayer:backgroundLayer] autorelease];
        [self addChild:actionLayer z:1];
        
        
    }
    return self;
}

@end
