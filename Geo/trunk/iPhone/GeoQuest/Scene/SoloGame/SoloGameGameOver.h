//
//  SoloGameGameOver.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "SoloGameUI.h"
#import "SoloGameReplay.h"
#import "CCMenuAdvanced.h"
#import "GameManager.h"

@class SoloGameUI;
@class SoloGameReplay;

@interface SoloGameGameOver : CCLayer {
    CGSize              winSize;
    
    // Layers
    SoloGameUI          *soloGameUI;
    SoloGameReplay      *soloGameReplay;
    
    // Menus
    CCMenuAdvanced      *gameOverMenu;

    
}

@property (nonatomic, retain) CCMenuAdvanced *gameOverMenu;

-(id) initWithSoloGameUILayer:(SoloGameUI*)soloUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;
-(void) moveGameOverMenu;
-(void) checkGameOverMenu;

@end
