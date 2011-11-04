//
//  GameUILayer.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUILayer.h"

@implementation GameUILayer

-(void) setGameActionLayer:(GameActionLayer *)gameActionLayer {
    actionLayer = gameActionLayer;
}

-(void) setupPauseButton {
    CCMenuItem *pauseButton = [CCMenuItemImage itemFromNormalImage:@"brush.png" selectedImage:@"brush.png" disabledImage:@"brush.png" target:self selector:@selector(pauseGame)];
    pauseButton.scale = 1.5;
    
    pauseButtonMenu = [CCMenu menuWithItems:pauseButton, nil];
    [pauseButtonMenu alignItemsVertically];
    pauseButtonMenu.position = ccp(winSize.width - 20.0, winSize.height - 20.0);
    [self addChild:pauseButtonMenu];
}

-(void) setupScoreLabel {
    scoreLabel = [CCLabelBMFont labelWithString:@"Score:" fntFile:@"testFont.fnt"];
    
    scoreLabel.position = ccp(winSize.width/2, winSize.height - scoreLabel.contentSize.height/2);
    
    scoreLabel.scale = 0.5;
    
    [self addChild:scoreLabel];
}

-(void) setupPauseLayer {
    pauseLayer = [[[CCLayer alloc] init] autorelease];
    pauseLayer.visible = NO;
    [self addChild:pauseLayer z:1];
    
    CCLabelBMFont* pauseLabel = [CCLabelBMFont labelWithString:@"Paused!" fntFile:@"testFont.fnt"];
    pauseLabel.position = ccp(winSize.width/2, 2*winSize.height/3);
    pauseLabel.scale = 0.50;
    
    CCLabelBMFont* retryLabel = [CCLabelBMFont labelWithString:@"Retry" fntFile:@"testFont.fnt"];
    retryLabel.position = ccp(winSize.width/2, winSize.height/2);
    retryLabel.scale = 0.50;
    
    CCMenuItem *retryButton = [CCMenuItemImage itemFromNormalImage:@"brush.png" selectedImage:@"brush.png" disabledImage:@"brush.png" target:self selector:@selector(restartGame)];
    retryButton.scale = 2.0;
    pauseLayerMenu = [CCMenu menuWithItems:retryButton, nil];
    [pauseLayerMenu alignItemsHorizontally];
    pauseLayerMenu.position = ccp(winSize.width/2 - retryLabel.contentSize.width/2, winSize.height/2);
    
    [pauseLayer addChild:pauseLabel];
    [pauseLayer addChild:retryLabel];
    [pauseLayer addChild:pauseLayerMenu];
}

-(void) setupGameOverLayer {
    gameOverLayer = [[[CCLayer alloc] init] autorelease];
    gameOverLayer.visible = NO;
    [self addChild:gameOverLayer z:1];
    
    highScoreLabel = [CCLabelBMFont labelWithString:@"High Score:" fntFile:@"testFont.fnt"];
    highScoreLabel.position = ccp(winSize.width/2, winSize.height - scoreLabel.contentSize.height/2 - highScoreLabel.contentSize.height/2);
    highScoreLabel.scale = 0.5;
    
    CCLabelBMFont* gameOverLabel = [CCLabelBMFont labelWithString:@"Game Over Bitch!" fntFile:@"testFont.fnt"];
    gameOverLabel.position = ccp(winSize.width/2, 2*winSize.height/3);
    gameOverLabel.scale = 0.50;
    
    CCLabelBMFont* retryLabel = [CCLabelBMFont labelWithString:@"Retry" fntFile:@"testFont.fnt"];
    retryLabel.position = ccp(winSize.width/2, winSize.height/2);
    retryLabel.scale = 0.50;
    
    CCMenuItem *retryButton = [CCMenuItemImage itemFromNormalImage:@"brush.png" selectedImage:@"brush.png" disabledImage:@"brush.png" target:self selector:@selector(restartGame)];
    retryButton.scale = 2.0;
    gameOverMenu = [CCMenu menuWithItems:retryButton, nil];
    [gameOverMenu alignItemsHorizontally];
    gameOverMenu.position = ccp(winSize.width/2 - retryLabel.contentSize.width/2, winSize.height/2);
    
    [gameOverLayer addChild:highScoreLabel];
    [gameOverLayer addChild:gameOverLabel];
    [gameOverLayer addChild:retryLabel];
    [gameOverLayer addChild:gameOverMenu];
}

-(void) pauseGame {
    if (gamePaused == NO && ![actionLayer player].died) {
        pauseLayer.visible = YES;

        [actionLayer unscheduleUpdate];
        gamePaused = YES;
    } else if (gamePaused == YES && ![actionLayer player].died) {
        pauseLayer.visible = NO;

        [actionLayer scheduleUpdate];
        gamePaused = NO;
    }
}

-(void) gameOver {
    if (actionLayer.highScore < actionLayer.gameScore) {
        actionLayer.highScore = actionLayer.gameScore;
    }
    
    [actionLayer unscheduleUpdate];
    gamePaused = YES;
    gameOverLayer.visible = YES;
}

-(void) restartGame {
    gameOverLayer.visible = NO;
    pauseLayer.visible = NO;
    
    [actionLayer scheduleUpdate];
    gamePaused = NO;
    [actionLayer resetGame];
}

-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;
        gamePaused = NO;

        [self setupPauseButton];
        [self setupScoreLabel];
        
        [self setupPauseLayer];
        [self setupGameOverLayer];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)dt {    
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %f", [actionLayer gameScore]]];
    [highScoreLabel setString:[NSString stringWithFormat:@"High Score: %f", [actionLayer highScore]]];
    
    
    if ([actionLayer player].died) {
        [self gameOver];
    }
}

-(void) dealloc {
    [super dealloc];
}

@end
