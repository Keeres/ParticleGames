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
    
    pauseMenu = [CCMenu menuWithItems:pauseButton, nil];
    [pauseMenu alignItemsVertically];
    pauseMenu.position = ccp(winSize.width - 20.0, winSize.height - 20.0);
    [self addChild:pauseMenu];
}

-(void) setupScoreLabel {
    scoreLabel = [CCLabelBMFont labelWithString:@"Score:" fntFile:@"testFont.fnt"];
    
    scoreLabel.position = ccp(winSize.width/2, winSize.height - scoreLabel.contentSize.height/2);
    
    scoreLabel.scale = 0.5;
    
    [self addChild:scoreLabel];
}

-(void) pauseGame {
    if (gamePaused == NO) {
        [actionLayer unscheduleUpdate];
        gamePaused = YES;
    } else {
        [actionLayer scheduleUpdate];
        gamePaused = NO;
    }
}

-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;
        
        [self setupPauseButton];
        [self setupScoreLabel];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)dt {    
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %f", [actionLayer gameScore]]];
}

-(void) dealloc {
    [super dealloc];
}

@end
