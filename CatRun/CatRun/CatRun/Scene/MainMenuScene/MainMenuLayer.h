//
//  MainMenuLayer.h
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h" 
#import "CharacterMenuLayer.h"
#import "CustomizeMenuLayer.h"
#import "PerksMenuLayer.h"
#import "SpriteHelperLoader.h"
#import "LevelHelperLoader.h"
#import "CCLabelBMFontMultiline.h"

@class CharacterMenuLayer;
@class CustomizeMenuLayer;
@class PerksMenuLayer;

@interface MainMenuLayer : CCLayer <GKLeaderboardViewControllerDelegate>{
    CGSize winSize;
    b2World *world;
    LevelHelperLoader *lHelper;
    SpriteHelperLoader *sHelper;
    
    CharacterMenuLayer *characterMenuLayer;
    CustomizeMenuLayer *customizeMenuLayer;
    PerksMenuLayer *perksMenuLayer;
    CCLayer *nextMenuLayer;
    CCLayer *currentMenuLayer;

    CCMenu *mainMenu;
}

-(id) initWithCharacterLayer:(CharacterMenuLayer *)characterLayer andSkinLayer:(CustomizeMenuLayer *)customizeLayer andPerkLayer:(PerksMenuLayer *)perkLayer andSpriteHelper:(SpriteHelperLoader*)sHelper;

-(void) switchFromMenu:(MenuType)currentLayer ToNextMenu:(MenuType)nextLayer;

@end