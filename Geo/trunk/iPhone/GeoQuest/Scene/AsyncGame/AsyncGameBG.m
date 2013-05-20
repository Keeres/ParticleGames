//
//  AsyncGameBG.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "AsyncGameBG.h"


@implementation AsyncGameBG

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
    CCLOG(@"AsyncGameBG: Do not use init. Use initWithAsyncGameUILayer:(AsyncGameUI *)asyncUI");
    return [self initWithAsyncGameUILayer:NULL];
}

-(id) initWithAsyncGameUILayer:(AsyncGameUI *)asyncUI {
    if ((self = [super init])) {
        CCLOG(@"AsyncGameBG: Background loaded");
        winSize = [[CCDirector sharedDirector] winSize];
        
        asyncGameUI = asyncUI;
        [asyncGameUI setAsyncGameBGLayer:self];
        
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
