//
//  GameActionLayer.h
//  mushroom
//
//  Created by Kelvin on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "GameUILayer.h"
#import "GameBackgroundLayer.h"
#import "MushroomCache.h"
#import "EnemyCache.h"
#import "PlatformCache.h"
#import "MyContactListener.h"
#import "StageEffectCache.h"
#import "Box2DHelpers.h"

@class GameUILayer;
@class MushroomCache;
@class EnemyCache;
//@class StageEffectCache;

@interface GameActionLayer : CCLayer {
    b2World *world;
    b2Body *groundBody;
    b2Body *sideBody;
    CGSize winSize;

    CCArray *totalMushrooms;
    NSMutableArray *visibleMushrooms;
    NSMutableArray *visibleEnemies;
    NSMutableArray *visibleStageEffect;
    
    int jumpCount;
    BOOL touchStarted;
    BOOL jumpStarted;
    BOOL morphStarted;
    BOOL eatStarted;
    BOOL gameStarted;
    float PIXELS_PER_SECOND;
    float currentSpeed;
    float offset;
    float previousOffset;
    float timePassed;
    float mushroomEatTime;
    float mushroomCrampTime;
    float mushroomSpeed;
    CGPoint prevTouchLocation;
    int totalDistance;
    
    GLESDebugDraw *debugDraw;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    GameUILayer *uiLayer;
    GameBackgroundLayer *backgroundLayer;
    
    MushroomCache *mushroomCache;
    EnemyCache *enemyCache;
    PlatformCache *platformCache;
    StageEffectCache *stageEffectCache;

    MyContactListener *contactListener;
}

@property (nonatomic, readwrite) MyContactListener *contactListener;
@property (nonatomic, retain) NSMutableArray *visibleMushrooms;
@property (nonatomic, retain) NSMutableArray *visibleEnemies;


-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andBackgroundLayer:(GameBackgroundLayer*)gameBGLayer;


@end
