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
    backPanel = [CCSprite spriteWithSpriteFrameName:@"BackgroundSky.png"];
    //int randomBackground = (arc4random() % 16) + 1;
    //backPanel = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Background_%i.png", randomBackground]];
    backPanel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:backPanel z:0];
    
    CCSprite *themeBG = [CCSprite spriteWithSpriteFrameName:@"ThemeBackgroundDesert.png"];
    themeBG.position = ccp(winSize.width/2, themeBG.contentSize.height/2);
    [self addChild:themeBG];
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
        [soloGameUI setSoloGameBGLayer:self];
        
        [self setupBG];
    }
    return self;
}


//Used to test background themes.
-(void) changeBG {
    int randomBackground = (arc4random() % 16) + 1;
    [backPanel setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Background_%i.png", randomBackground]]];
}

@end
