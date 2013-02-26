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

@class MainMenuUI;

@interface MainMenuCreateGame : CCLayer {
    CGSize              winSize;
    
    CCMenuAdvancedPlus  *createGameMenu;

    // Layers
    MainMenuUI          *mainMenuUI;
    
}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;


@end
