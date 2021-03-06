//
//  MainMenuUI.h
//  GeoQuest
//
//  Created by Kelvin on 10/3/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import <sqlite3.h>
#import "CCMenuAdvanced.h"
#import "CCMenuAdvancedPlus.h"
#import "MainMenuBG.h"
#import "PlayerDB.h"
#import "GeoQuestDB.h"

#define UI_FADE_TIME 0.20 //time to fade in/out menu items
#define UI_MENU_SPACING 10 //points between menu items

@class MainMenuBG;

@interface MainMenuUI : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
    CGSize winSize;
    
    CCSpriteBatchNode   *mainMenuUISheet;
    CCSpriteBatchNode   *usaStatesSheet;
    CCSpriteBatchNode   *usaCapitalsSheet;
    CCSpriteBatchNode   *questionThemesSheet;
    
    //Objects
    CCSprite            *title;
    CCSprite            *sidePanel;
    CCSprite            *compass;
    
    //Variables
    CGPoint             currentPoint;
    CGPoint             previousPoint;
    BOOL                touchedSidePanel;
    BOOL                previouslyTouchedSidePanel;
    BOOL                compassTouched;
    
    //Actions
    CCAction            *compassAction;
    
    //Menus
    CCMenuAdvancedPlus  *gamePlayMenu;
    CCMenuAdvancedPlus  *gameChallengeMenu;
    CCMenuAdvanced      *exitMenu;
    CCMenuAdvanced      *optionMenu;
    
    //Layers
    MainMenuBG          *mainMenuBG;
    
    //Test
    NSMutableDictionary      *challengesData; //JSON data testing    
    
}

-(void) setMainMenuBGLayer:(MainMenuBG *)menuBG;
-(void) toggleSidePanel;

@end
