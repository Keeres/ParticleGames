//
//  SoloGameBG.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "SoloGameBG.h"


@implementation SoloGameBG

-(void) setupBG {
    backPanel = [CCSprite spriteWithSpriteFrameName:@"SoloWoodBG.png"];
    backPanel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:backPanel z:0];
}

-(id) init {
    CCLOG(@"SoloGameBG: Do not use init. Use initWithSoloGameUILayer:(SoloGameUI *)soloUI");
    return [self initWithSoloGameUILayer:NULL];
}

-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        CCLOG(@"SoloGameBG: Background loaded");
        winSize = [[CCDirector sharedDirector] winSize];
        
        soloGameUI = soloUI;
        
        [self setupBG];
    }
    return self;
}

@end
