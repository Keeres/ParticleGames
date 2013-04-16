//
//  MainMenuBG.h
//  GeoQuest
//
//  Created by Kelvin on 10/6/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuUI.h"

@class MainMenuUI;

@interface MainMenuBG : CCLayer {
    
    //CCSpriteBatchNode   *mainMenuBGSheet;
    
    //Variables
    BOOL                    BGTouched; //Has the background been touched?
    
    //Sprites
    CCSprite                *BGMap;
    CCSprite                *backPanel;
    
    //Layers
    MainMenuUI              *mainMenuUI;
    
}

@property BOOL BGTouched;

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;




@end
