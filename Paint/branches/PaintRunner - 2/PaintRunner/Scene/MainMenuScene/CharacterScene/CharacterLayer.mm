//
//  CharacterLayer.m
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CharacterLayer.h"

@implementation CharacterLayer

#pragma mark Setup Resources

-(void) setupButtons {
    CCMenuItem *backButton = [CCMenuItemImage itemFromNormalImage:@"backButton.png" selectedImage:@"backButton.png" disabledImage:@"backButton.png" target:self selector:@selector(returnToMainMenu)];
    backButton.scale = 1.5;
    backButtonMenu = [CCMenu menuWithItems:backButton, nil];
    [backButtonMenu alignItemsVertically];
    backButtonMenu.position = ccp(20.0, winSize.height - 20.0);
    [self addChild:backButtonMenu];
    
    CCLabelBMFont *skinLabel = [CCLabelBMFont labelWithString:@"Skins" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *skinButton = [CCMenuItemLabel itemWithLabel:skinLabel target:self selector:@selector(activateSkinLayer)];
    //skinLabel.anchorPoint = ccp(0.0, 0.5);
    //skinLabel.scale = 1.0;
    skinLabel.color = ccc3(255, 255, 255);
    
    CCLabelBMFont *perkLabel = [CCLabelBMFont labelWithString:@"Perks" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *perkButton = [CCMenuItemLabel itemWithLabel:perkLabel target:self selector:@selector(activatePerkLayer)];
    //perkLabel.anchorPoint = ccp(0.0, 0.5);
    //perkLabel.scale = 1.0;
    perkLabel.color = ccc3(255, 255, 255);
    
    characterMenu = [CCMenu menuWithItems:skinButton, perkButton, nil];
    [characterMenu alignItemsVerticallyWithPadding:25.0];
    characterMenu.position = ccp(winSize.width*0.85, winSize.height*0.25);
    [self addChild:characterMenu];
}

-(void) setupSkinLayer {
    skinLayer = [[[CCLayer alloc] init] autorelease];
    skinLayer.contentSize = CGSizeMake(winSize.width, winSize.height);
    skinLayer.visible = NO;
    [self addChild:skinLayer];
}

-(void) setupActivePerkLayer {
    
}

-(void) setupPassivePerkLayer {
    
}

#pragma mark Initialize

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        CCTexture2D *gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game1atlas.png"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithTexture:gameArtTexture capacity:100];
        
        [self addChild:sceneSpriteBatchNode z:1000];
        self.isTouchEnabled = YES;
        
        [self setupButtons];
        [self setupSkinLayer];
        [self setupActivePerkLayer];
        [self setupPassivePerkLayer];
    }
    return self;
}


-(void) returnToMainMenu {
    CCLOG(@"CharacterMenu: Returning to Main Menu");
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void) activateSkinLayer {
    CCLOG(@"CharacterMenu: Activated Skin Layer");
    [[GameManager sharedGameManager] runSceneWithID:kSkinScene];
}

-(void) activatePerkLayer {
    CCLOG(@"CharacterMenu: Activated Perk Layer");
    [[GameManager sharedGameManager] runSceneWithID:kPerkScene];

}

#pragma mark ccTouches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}



@end
