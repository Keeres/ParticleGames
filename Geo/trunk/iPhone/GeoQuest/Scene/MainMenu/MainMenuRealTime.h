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
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>

@class MainMenuUI;

@interface MainMenuRealTime : CCLayer { //<ConnectionRequestListener,ZoneRequestListener>{
    CGSize              winSize;
    
    //Layers
    MainMenuUI          *mainMenuUI;
    
    //Button Menu
    CCMenuAdvancedPlus  *realTimeMenu;
    
    //Test variable. Remove later
    int counter;

}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) hideLayerAndObjects;
-(void) showLayerAndObjects;

@end
