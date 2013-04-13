//
//  MainMenuCreateGame.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuUI.h"
#import "GameManager.h"
#import "CCUIViewWrapper.h"
#import "PlayerDB.h"
#import "Challenger.h"
#import "Guid.h"
#import "ChallengesInProgress.h"

@class MainMenuUI;

@interface MainMenuCreateGame : CCLayer {
    CGSize              winSize;
    
    CCMenuAdvancedPlus  *createGameMenu;
    CCMenuAdvancedPlus  *findUserMenu;

    // Layers
    MainMenuUI          *mainMenuUI;
    
    // UIView
    CCUIViewWrapper     *wrapper;
    UIView              *findUserView;
    UITextField         *userField;
}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;


@end
