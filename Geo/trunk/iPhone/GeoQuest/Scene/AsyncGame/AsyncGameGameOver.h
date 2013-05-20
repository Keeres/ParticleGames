//
//  AsyncGameGameOver.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "AsyncGameUI.h"
#import "AsyncGameReplay.h"
#import "CCMenuAdvanced.h"
#import "GameManager.h"

@class AsyncGameUI;
@class AsyncGameReplay;

@interface AsyncGameGameOver : CCLayer {
    CGSize              winSize;
    
    // Layers
    AsyncGameUI          *asyncGameUI;
    AsyncGameReplay      *asyncGameReplay;
    
    // Menus
    CCMenuAdvanced      *gameOverMenu;

    
}

@property (nonatomic, retain) CCMenuAdvanced *gameOverMenu;

-(id) initWithAsyncGameUILayer:(AsyncGameUI*)asyncUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;
-(void) moveGameOverMenu;
-(void) checkGameOverMenu;

@end
