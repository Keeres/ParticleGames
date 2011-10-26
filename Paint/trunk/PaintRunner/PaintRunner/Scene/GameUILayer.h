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

@class GameActionLayer;

@interface GameUILayer : CCLayer {
    //Variables
    CGSize winSize;
    CCMenu *pauseMenu;
    CCLabelBMFont *scoreLabel;
    BOOL gamePaused;
    
    //Layers
    GameActionLayer *actionLayer;
}

-(void) setGameActionLayer:(GameActionLayer*)gameActionLayer;

@end
