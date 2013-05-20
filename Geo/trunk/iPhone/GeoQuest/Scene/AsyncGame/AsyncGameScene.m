//
//  AsyncGameScene.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "AsyncGameScene.h"


@implementation AsyncGameScene

+(id) scene {
    CCScene *scene = [CCScene node];
    
    AsyncGameUI *asyncGameUI = [AsyncGameUI node];
    [scene addChild:asyncGameUI z:20];
    
    AsyncGameReplay *asyncGameReplay = [[[AsyncGameReplay alloc] initWithAsyncGameUILayer:asyncGameUI] autorelease];
    [scene addChild:asyncGameReplay z:30];
    
    AsyncGameTerritory *asyncGameTerritory = [[[AsyncGameTerritory alloc] initWithAsyncGameUILayer:asyncGameUI] autorelease];
    [scene addChild:asyncGameTerritory z:30];
    
    AsyncGameGameOver *asyncGameGameOver = [[[AsyncGameGameOver alloc] initWithAsyncGameUILayer:asyncGameUI] autorelease];
    [scene addChild:asyncGameGameOver z:30];
    
    AsyncGameBG *asyncGameBG = [[[AsyncGameBG alloc] initWithAsyncGameUILayer:asyncGameUI] autorelease];
    [scene addChild:asyncGameBG z:10];
    
    [asyncGameReplay loadReplayLayer];
    
    return scene;
}

@end
