//
//  SoloGameScene.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "SoloGameScene.h"


@implementation SoloGameScene

+(id) scene {
    CCScene *scene = [CCScene node];
    
    SoloGameUI *soloGameUI = [SoloGameUI node];
    [scene addChild:soloGameUI z:20];
    
    SoloGameReplay *soloGameReplay = [[[SoloGameReplay alloc] initWithSoloGameUILayer:soloGameUI] autorelease];
    [scene addChild:soloGameReplay z:30];
    
    SoloGameTerritory *soloGameTerritory = [[[SoloGameTerritory alloc] initWithSoloGameUILayer:soloGameUI] autorelease];
    [scene addChild:soloGameTerritory z:30];
    
    SoloGameGameOver *soloGameGameOver = [[[SoloGameGameOver alloc] initWithSoloGameUILayer:soloGameUI] autorelease];
    [scene addChild:soloGameGameOver z:30];
    
    SoloGameBG *soloGameBG = [[[SoloGameBG alloc] initWithSoloGameUILayer:soloGameUI] autorelease];
    [scene addChild:soloGameBG z:10];
    
    /*MainMenuUI *mainMenuUI = [MainMenuUI node];
    [scene addChild:mainMenuUI z:20];
    
    MainMenuBG *mainMenuBG = [[MainMenuBG alloc] initWithMainMenuUILayer:mainMenuUI];
    [scene addChild:mainMenuBG z:10];*/
    
    return scene;
}

@end
