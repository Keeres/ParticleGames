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
    float screenOffset;
    float timePassed;
    float PIXELS_PER_SECOND;
    
    //Layers
    GameUILayer *uiLayer;
    GameBackgroundLayer *backgroundLayer;
}

@property (nonatomic, readwrite) MyContactListener *contactListener;

-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andBackgroundLayer:(GameBackgroundLayer*)gameBGLayer;

@end
