//
//  MiniGameScene.h
//  CatRun
//
//  Created by Kelvin on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "LevelHelperLoader.h"
#import "LevelHelper.h"
#import "GameState.h"
#import "Constants.h"
#import "DefaultPlayer.h"
#import "DoubleJumpPlayer.h"
#import "GliderPlayer.h"
#import "FlyingPlayer.h"

@interface MiniGameScene : CCLayer
{
	b2World *world;
	GLESDebugDraw *m_debugDraw;
    
	LevelHelperLoader *lh;
    
    LHParallaxNode *parallaxNode;
    //DefaultPlayer *player;
    //DoubleJumpPlayer *player;
    //GliderPlayer *player;
    FlyingPlayer *player;
    b2Body *playerBody;
    LHSprite *finishLine;
    
    ActivePerkTypes typeOfPlayer;
    BOOL    gameStart;
    BOOL    gameOver;
    BOOL    playerBeginTouch;
    BOOL    playerEndTouch;
    int     playerTouchBufferCount;
    
}

+(id) scene;

@end
