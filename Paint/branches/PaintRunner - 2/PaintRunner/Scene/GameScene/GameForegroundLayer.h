//
//  GameForegroundLayer.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "TreeCache.h"
#import "GameActionLayer.h"
#import "GameManager.h"

@class GameActionLayer;

@interface GameForegroundLayer : CCLayer {
    //Variables
    CGSize winSize;
    float treeTimePassed;
    float treeSpawnTime;
    
    CCSpriteBatchNode *sceneSpriteBatchNode;
    TreeCache *treeCache;
    
    //Layers
    GameActionLayer *actionLayer;
}

-(void) resetForeground;
-(void) setGameActionLayer:(GameActionLayer*)gameActionLayer;
-(void) updateForegroundWithTime:(ccTime)dt andSpeed:(float)speed andScreenOffsetY:(float)screenOffsetY;
@end
