//
//  MainMenuScene.m
//  GeoQuest
//
//  Created by Kelvin on 10/5/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "MainMenuScene.h"


@implementation MainMenuScene

+(id) scene {
    CCScene *scene = [CCScene node];
    MainMenuUI *mainMenuUI = [MainMenuUI node];
    [scene addChild:mainMenuUI z:20];
    
    MainMenuCreateGame *mainMenuCreateGame = [[[MainMenuCreateGame alloc] initWithMainMenuUILayer:mainMenuUI] autorelease];
    [scene addChild:mainMenuCreateGame z:30];
    
    MainMenuLogin *mainMenuLogin = [[[MainMenuLogin alloc] initWithMainMenuUILayer:mainMenuUI] autorelease];
    [scene addChild:mainMenuLogin z:30];
    
    MainMenuBG *mainMenuBG = [[[MainMenuBG alloc] initWithMainMenuUILayer:mainMenuUI] autorelease];
    [scene addChild:mainMenuBG z:10];
    
    return scene;
}

@end
