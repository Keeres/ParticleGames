//
//  MainMenuRealTime.h
//  GeoQuest
//
//  Created by Kelvin on 4/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "MainMenuUI.h"
#import "CCMenuAdvancedPlus.h"
#import <Parse/Parse.h>

@class MainMenuUI;

@interface MainMenuRealTime : CCLayer {
    CGSize              winSize;
    
    //Layers
    MainMenuUI          *mainMenuUI;
    
    //Button Menu
    CCMenuAdvancedPlus  *realTimeMenu;

}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) hideLayerAndObjects;
-(void) showLayerAndObjects;

@end
