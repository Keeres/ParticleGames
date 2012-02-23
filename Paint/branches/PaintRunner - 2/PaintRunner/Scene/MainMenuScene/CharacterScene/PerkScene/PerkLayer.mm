//
//  PerkLayer.m
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PerkLayer.h"

@implementation PerkLayer

#pragma mark Setup Resources

-(void) setupButtons {
    CCMenuItem *backButton = [CCMenuItemImage itemFromNormalImage:@"backButton.png" selectedImage:@"backButton.png" disabledImage:@"backButton.png" target:self selector:@selector(returnToCharacterMenu)];
    backButton.scale = 1.5;
    backButtonMenu = [CCMenu menuWithItems:backButton, nil];
    [backButtonMenu alignItemsVertically];
    backButtonMenu.position = ccp(20.0, winSize.height - 20.0);
    [self addChild:backButtonMenu];
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
    }
    return self;
}


-(void) returnToCharacterMenu {
    CCLOG(@"SkinMenu: Returning to Character Menu");
    [[GameManager sharedGameManager] runSceneWithID:kCharacterScene];
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
