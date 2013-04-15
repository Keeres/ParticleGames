//
//  MainMenuUI.h
//  GeoQuest
//
//  Created by Kelvin on 10/3/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
//#import <GameKit/GameKit.h>
#import <sqlite3.h>
#import "CCMenuAdvanced.h"
#import "CCMenuAdvancedPlus.h"
#import "ChallengerMenuItemSprite.h"
#import "MainMenuBG.h"
#import "MainMenuLogin.h"
#import "MainMenuCreateGame.h"
#import "PlayerDB.h"
#import "GeoQuestDB.h"
#import "NetworkController.h"


#define UI_FADE_TIME 0.20 //time to fade in/out menu items
#define UI_MENU_SPACING 10 //points between menu items

@class MainMenuCreateGame;
@class MainMenuLogin;
@class MainMenuBG;

//@interface MainMenuUI : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, NetworkControllerDelegate> {
@interface MainMenuUI : CCLayer <NetworkControllerDelegate> {
    CGSize winSize;
    
    // SpriteSheet
    CCSpriteBatchNode   *mainMenuUISheet;
    CCSpriteBatchNode   *usaStatesSheet;
    CCSpriteBatchNode   *usaCapitalsSheet;
    CCSpriteBatchNode   *questionThemesSheet;
    CCSpriteBatchNode   *countryEuropeSheet;

    
    //Objects
    CCSprite            *title;
    
    //Variables
    CGPoint             currentPoint;
    CGPoint             previousPoint;
    
    //Actions
    
    //Menus
    CCMenuAdvancedPlus  *gameChallengeMenu;

    //Layers
    MainMenuLogin       *mainMenuLogin;
    MainMenuCreateGame  *mainMenuCreateGame;
    MainMenuBG          *mainMenuBG;
}

-(void) setMainMenuBGLayer:(MainMenuBG *)menuBG;
-(void) setMainMenuLoginLayer:(MainMenuLogin*)menuLogin;
-(void) setMainMenuCreateGameLayer:(MainMenuCreateGame*)menuCreateGame;
-(void) setupPlayerDatabase;
-(void) showObjects;
-(void) hideObjects;
-(void) refreshObjects;

//-(void) toggleSidePanel;

@end
