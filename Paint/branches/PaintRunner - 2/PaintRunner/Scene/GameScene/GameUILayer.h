//
//  GameUILayer.h
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameActionLayer.h"
#import "GameBackgroundLayer.h"
#import "GameBackgroundLayer2.h"
#import "GameManager.h"

@class GameActionLayer;
@class GameBackgroundLayer2;

@interface GameUILayer : CCLayer {
    //Variables
    CGSize winSize;
    CCMenu *pauseButtonMenu;
    CCMenu *pauseLayerMenu;
    CCMenu *gameOverMenu;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *highScoreLabel;
    CCLabelBMFont *comboLabel;
    CCLabelBMFont *multiplierLabel;
    BOOL gamePaused;
    BOOL gameOverTaskComplete;
    
    //Test Logs
    CCLabelBMFont *speedLabel;
    CCLabelBMFont *timeLabel;
    
    //Layers
    GameActionLayer *actionLayer;
    CCLayer *pauseLayer;
    CCLayer *gameOverLayer;
}

-(void) setGameActionLayer:(GameActionLayer*)gameActionLayer;

@end
