//
//  CharacterLayer.m
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CharacterLayer.h"

@implementation CharacterLayer

-(void) setupBackButton {
    CCMenuItem *backButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" disabledImage:@"pause.png" target:self selector:@selector(returnToMainMenu)];
    backButton.scale = 1.5;
    
    backButtonMenu = [CCMenu menuWithItems:backButton, nil];
    [backButtonMenu alignItemsVertically];
    backButtonMenu.position = ccp(winSize.width - 20.0, winSize.height - 20.0);
    [self addChild:backButtonMenu];
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        CCTexture2D *gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game1atlas.png"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithTexture:gameArtTexture capacity:100];
        
        [self addChild:sceneSpriteBatchNode z:1000];
        self.isTouchEnabled = YES;
        
        [self setupBackButton];
        
    }
    return self;
}


-(void) returnToMainMenu {
    CCLOG(@"GameUILayer: Returning to Main Menu");
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}


@end
