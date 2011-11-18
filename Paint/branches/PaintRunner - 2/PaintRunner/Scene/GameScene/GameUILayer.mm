//
//  GameUILayer.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUILayer.h"
#import "GCHelper.h"

@implementation GameUILayer

#pragma mark Setup Layer, Buttons, Text

-(void) setGameActionLayer:(GameActionLayer *)gameActionLayer {
    actionLayer = gameActionLayer;
}

-(void) setupPauseButton {
    CCMenuItem *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" disabledImage:@"pause.png" target:self selector:@selector(pauseGame)];
    pauseButton.scale = 1.5;
    
    pauseButtonMenu = [CCMenu menuWithItems:pauseButton, nil];
    [pauseButtonMenu alignItemsVertically];
    pauseButtonMenu.position = ccp(winSize.width - 20.0, winSize.height - 20.0);
    [self addChild:pauseButtonMenu];
}

-(void) setupScoreLabel {
    scoreLabel = [CCLabelBMFont labelWithString:@"Score:" fntFile:@"testFont.fnt"];
    scoreLabel.anchorPoint = ccp(0.0, 0.5);
    scoreLabel.scale = 0.4;
    
    scoreLabel.position = ccp(10.0, winSize.height - scoreLabel.contentSize.height/2);
    
    [self addChild:scoreLabel];
}

-(void) setupHighScoreLabel {
    highScoreLabel = [CCLabelBMFont labelWithString:@"High Score:" fntFile:@"testFont.fnt"];
    highScoreLabel.anchorPoint = ccp(0.0, 0.5);
    highScoreLabel.scale = 0.4;
    
    highScoreLabel.position = ccp(10.0, winSize.height - 2*scoreLabel.contentSize.height/2);
    
    [self addChild:highScoreLabel];
    
}

-(void) setupSpeedLabel {
    speedLabel = [CCLabelBMFont labelWithString:@"Speed:" fntFile:@"testFont.fnt"];
    speedLabel.anchorPoint = ccp(0.0, 0.5);
    speedLabel.scale = 0.4;
    
    speedLabel.position = ccp(10.0, winSize.height - 3*scoreLabel.contentSize.height/2);
    
    [self addChild:speedLabel];
}

-(void) setupTimeLabel {
    timeLabel = [CCLabelBMFont labelWithString:@"Time:" fntFile:@"testFont.fnt"];
    timeLabel.anchorPoint = ccp(0.0, 0.5);
    timeLabel.scale = 0.4;
    
    timeLabel.position = ccp(10.0, winSize.height - 4*scoreLabel.contentSize.height/2);
    
    [self addChild:timeLabel];
}

-(void) setupComboLabel {
    comboLabel = [CCLabelBMFont labelWithString:@"%i COMBO!" fntFile:@"testFont.fnt"];
    comboLabel.anchorPoint = ccp(0.0, 0.5);
    
    
    comboLabel.position = ccp(10.0, winSize.height/2);
    
    comboLabel.scale = 0.4;
    //comboLabel.visible = NO;
    
    [self addChild:comboLabel];
}

-(void) setupMultiplierLabel {
    multiplierLabel = [CCLabelBMFont labelWithString:@"%0.1fx" fntFile:@"testFont.fnt"];
    
    multiplierLabel.anchorPoint = ccp(0.0, 0.5);
    
    multiplierLabel.position = ccp(10.0, winSize.height/2 - comboLabel.contentSize.height/2);
    
    multiplierLabel.scale = 0.4;
    
    [self addChild:multiplierLabel];
}


-(void) setupPauseLayer {
    pauseLayer = [[[CCLayer alloc] init] autorelease];
    pauseLayer.visible = NO;
    [self addChild:pauseLayer z:1];
    
    CCLabelBMFont* pauseLabel = [CCLabelBMFont labelWithString:@"Paused!" fntFile:@"testFont.fnt"];
    pauseLabel.position = ccp(winSize.width/2, 2*winSize.height/3);
    pauseLabel.scale = 0.50;
    
    CCLabelBMFont* retryLabel = [CCLabelBMFont labelWithString:@"Retry" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *retryButton = [CCMenuItemLabel itemWithLabel:retryLabel target:self selector:@selector(restartGame)];
    retryLabel.scale = 0.5;
    
    CCLabelBMFont* mainMenuLabel = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *mainMenuButton = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(returnToMainMenu)];
    mainMenuLabel.scale = 0.5;
    
    pauseLayerMenu = [CCMenu menuWithItems:retryButton, mainMenuButton, nil];
    [pauseLayerMenu alignItemsVertically];
    pauseLayerMenu.position = ccp(winSize.width/2, winSize.height/2);
    [pauseLayer addChild:pauseLayerMenu];
}

-(void) setupGameOverLayer {
    gameOverLayer = [[[CCLayer alloc] init] autorelease];
    gameOverLayer.visible = NO;
    [self addChild:gameOverLayer z:1];
    
    CCLabelBMFont* gameOverLabel = [CCLabelBMFont labelWithString:@"Game Over Bitch!" fntFile:@"testFont.fnt"];
    gameOverLabel.position = ccp(winSize.width/2, 2*winSize.height/3);
    gameOverLabel.scale = 0.50;
    
    CCLabelBMFont* retryLabel = [CCLabelBMFont labelWithString:@"Retry" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *retryButton = [CCMenuItemLabel itemWithLabel:retryLabel target:self selector:@selector(restartGame)];
    retryLabel.scale = 0.5;
    
    CCLabelBMFont* mainMenuLabel = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *mainMenuButton = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(returnToMainMenu)];
    mainMenuLabel.scale = 0.5;
    
    gameOverMenu = [CCMenu menuWithItems:retryButton, mainMenuButton, nil];
    [gameOverMenu alignItemsVertically];
    gameOverMenu.position = ccp(winSize.width/2, winSize.height/2);
    
    [gameOverLayer addChild:gameOverLabel];
    [gameOverLayer addChild:gameOverMenu];
}

#pragma mark UILayer Actions

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
    //Some reason when the game is over, GameCenter is lagging the game. I've commented the line below out to prevent this.
    //[[GCHelper sharedInstance] reportScore:kHighScoreLeaderboardID score:(int) [actionLayer gameScore]];
    
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

-(void) returnToMainMenu {
    CCLOG(@"GameUILayer: Returning to Main Menu");
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

#pragma mark Initialize GameUILayer

-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;
        gamePaused = NO;
        [self setupPauseButton];
        [self setupScoreLabel];
        [self setupHighScoreLabel];
        [self setupComboLabel];
        [self setupMultiplierLabel];
        [self setupSpeedLabel];
        [self setupTimeLabel];
        
        [self setupPauseLayer];
        [self setupGameOverLayer];
        
        [self scheduleUpdate];
    }
    return self;
}

#pragma mark Update States

-(void) updateText {
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %0.1f", [actionLayer gameScore]]];
    [highScoreLabel setString:[NSString stringWithFormat:@"High Score: %0.1f", [actionLayer highScore]]];
    
    [comboLabel setString:[NSString stringWithFormat:@"%i/%i", [actionLayer platformCounter], [actionLayer numPlatformsNeedToHit]]];
    
    [multiplierLabel setString:[NSString stringWithFormat:@"%0.1fx", [actionLayer multiplier]]];
    
    //Test Logs
    [speedLabel setString:[NSString stringWithFormat:@"Speed: %0.1f", [actionLayer PIXELS_PER_SECOND]]];
    [timeLabel setString:[NSString stringWithFormat:@"Time: %0.1f", [actionLayer levelTimePassed]]];
    
    
    /*if (actionLayer.comboCount > 2) {
        comboLabel.visible = YES;
    } else {
        comboLabel.visible = NO;
    }*/
}

-(void) update:(ccTime)dt {    
    [self updateText];
    
    if ([actionLayer player].died) {
        [self gameOver];
    }
}

#pragma mark Dealloc

-(void) dealloc {
    [super dealloc];
}

@end
