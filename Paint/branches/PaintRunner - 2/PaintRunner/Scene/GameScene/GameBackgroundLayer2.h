//
//  GameBackgroundLayer2.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CloudCache.h"
#import "GameActionLayer.h"
#import "GameManager.h"

@class GameActionLayer;

@interface GameBackgroundLayer2 : CCLayer {
    //Variables
    CGSize winSize;
    float cloudTimePassed;
    float cloudSpawnTime;
    
    CCSpriteBatchNode *sceneSpriteBatchNode;
    CloudCache *cloudCache;
    
    CCSprite *background;
    CCSprite *background2;
    CCSprite *city;
    CCSprite *mountain;
    CCSprite *sky;
    CCParticleSystem *leafEmitter;
    
    //Layers
    GameActionLayer *actionLayer;
}

-(void) resetBackground;
-(void) setGameActionLayer:(GameActionLayer*)gameActionLayer;
-(void) updateBackgroundWithTime:(ccTime)dt andSpeed:(float)speed andScreenOffsetY:(float)screenOffsetY;

@end
