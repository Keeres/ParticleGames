//
//  GameActionLayer.h
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameUILayer.h"
#import "GameBackgroundLayer.h"
#import "Box2D.h"
#import "Box2DSprite.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "Player.h"
#import "PlatformCache.h"
#import "PaintChipCache.h"
#import "MyContactListener.h"
//#import "Obstacles.h"

@class GameUILayer;
@class GameBackgroundLayer;

@interface GameActionLayer : CCLayer {
    //Box2D Variables
    b2World *world;
    b2Body *groundBody;
    
    GLESDebugDraw *debugDraw;
    MyContactListener *contactListener;

    //Variables
    CGSize winSize;
    Player *player;
    PlatformCache *platformCache;
    PaintChipCache *paintChipCache;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    int jumpBufferCount;
    BOOL playerStartJump;
    BOOL playerEndJump;
    BOOL changeDirectionToLeft;
    BOOL levelMovingLeft;
    float screenOffsetX;
    float screenOffsetY;
    float levelTimePassed;
    float paintTimePassed;
    float PIXELS_PER_SECOND;
    float MAX_PIXELS_PER_SECOND;
    float gameScore;
    float highScore;

    
    //Layers
    GameUILayer *uiLayer;
    GameBackgroundLayer *backgroundLayer;
    
    //obstacle variables
    //Obstacles *obstacles;
    CGSize pixelWinSize;
    b2Body *obstacleTopBody;
    b2Body *obstacleBottomBody;
    b2Body *obstacleSideBody;
    float obstacleTimePassed;
    float airObstacleTimePassed;
    int obstacleSpawnTimer;
    int airObstacleSpawnTimer;
    BOOL spawnObstacle;
    BOOL spawnAirObstacle;
    
    NSMutableArray *obstacleCentersX;
    NSMutableArray *obstacleCentersY;
    NSMutableArray *obstacleWidths;
    NSMutableArray *obstacleHeights;
    CGPoint obstacleVertices[100];
    CGPoint tempVertices[100];
    CGPoint obstacleBox2dVertices[100];
    ccColor4F obstacleColor[100];
    
    //platforms
    NSMutableArray *platformsCentersX;
    NSMutableArray *platformsCentersY;
    NSMutableArray *platformsWidths;
    NSMutableArray *platformsHeights;
    CGPoint platformsVertices[100];
    CGPoint platformsBox2dVertices[100];
    int platformCount;
    int nPlatformsVertices;
    int nPlatformsBox2dVertices;
    BOOL initialPlatform;
    BOOL spawnPlatform;
    
    b2Body *platformsTopAndBottomBody;
    b2Body *platformsSideBody;
    int obstacleCount;
    int nObstalceBox2dVertices;
    int nObstalceVertices;
    double PTP_Ratio;  //pixel to point ratio
}

@property (nonatomic, readwrite) MyContactListener *contactListener;
@property (nonatomic, retain) Player *player;
@property float gameScore;
@property float highScore;


-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andBackgroundLayer:(GameBackgroundLayer*)gameBGLayer;
-(void) resetGame;

@end
