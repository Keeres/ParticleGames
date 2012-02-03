//
//  GameActionLayer.h
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameUILayer.h"
#import "GameForegroundLayer.h"
#import "GameBackgroundLayer.h"
#import "GameBackgroundLayer2.h"
#import "Box2D.h"
#import "Box2DSprite.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "Player.h"
#import "PlatformCache.h"
#import "PaintChipCache.h"
#import "MyContactListener.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

#define MAX_PIXELS_PER_SECOND 300.0
#define INITIAL_PIXELS_PER_SECOND 100.0

@class GameUILayer;
@class GameForegroundLayer;
@class GameBackgroundLayer;
@class GameBackgroundLayer2;

@interface GameActionLayer : CCLayer {
    //Box2D Variables
    b2World *world;
    b2Body *groundBody;
    b2Body *platformsTopAndBottomBody;
    b2Body *platformsSideBody;
    
    GLESDebugDraw *debugDraw;
    MyContactListener *contactListener;

    //Variables
    CGSize winSize;
    Player *player;
    PlatformCache *platformCache;
    PaintChipCache *paintChipCache;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    int jumpBufferCount;
    int platformCounter;
    int numPlatformsNeedToHit;
    BOOL playerStartJump;
    BOOL playerEndJump;
    BOOL changeDirectionToLeft;
    BOOL levelMovingLeft;
    BOOL easySectionChosen;
    BOOL startGame;
    float screenOffsetX;
    float screenOffsetY;
    float levelTimePassed;
    float paintTimePassed;
    float platformTimePassed;
    float platformSpawnTime;
    float playerDistanceTraveled;
    float PIXELS_PER_SECOND;
    float gameScore;
    float highScore;
    float multiplier;
    
    //Layers
    GameUILayer *uiLayer;
    GameForegroundLayer *foregroundLayer;
    GameBackgroundLayer *backgroundLayer;
    GameBackgroundLayer2 *backgroundLayer2;
}

@property (nonatomic, readwrite) MyContactListener *contactListener;
@property (nonatomic, retain) Player *player;
@property (readwrite) int platformCounter;
@property (readwrite) int numPlatformsNeedToHit;
@property (readwrite) float gameScore;
@property (readwrite) float highScore;
@property (readwrite) float multiplier;
@property (readonly) float levelTimePassed;
@property (readonly) float PIXELS_PER_SECOND;


-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andForegroundLayer:(GameForegroundLayer*)gameFGLayer andBackgroundLayer:(GameBackgroundLayer2*)gameBGLayer;
-(void) resetGame;

@end
