//
//  MainMenuLayer.m
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"

@interface MainMenuLayer() 
-(void)displayMainMenu;
@end

@implementation MainMenuLayer

-(void) visitCompanySite {
    CCLOG(@"MainMenu: Visit Website");
    [[GameManager sharedGameManager] openSiteWithLinkType:kLinkTypeCompanySite];
}

-(void) showOptions {
    CCLOG(@"MainMenu: Show Options");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

-(void) startGame {
    CCLOG(@"MainMenu: Start Game");
    [[GameManager sharedGameManager] runSceneWithID:kGameScene];
}

-(void) showLeaderboard {
    
}

-(void) playChorus {
    //play sound stuff
}

-(void) displayMainMenu {
    //Main Menu
    CCLOG(@"MainMenu: Display Main Menu");
    
    CCLabelBMFont *playGameLabel = [CCLabelBMFont labelWithString:@"Play Game" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *playGameButton = [CCMenuItemLabel itemWithLabel:playGameLabel target:self selector:@selector(startGame)]; 
    
    CCLabelBMFont *companySiteLabel = [CCLabelBMFont labelWithString:@"Website" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *visitCompanySiteButton = [CCMenuItemLabel itemWithLabel:companySiteLabel target:self selector:@selector(visitCompanySite)]; 
    
    CCLabelBMFont *leaderboardLabel = [CCLabelBMFont labelWithString:@"Leaderboard" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *leaderboardButton = [CCMenuItemLabel itemWithLabel:leaderboardLabel target:self selector:@selector(showLeaderboard)]; 
    
    mainMenu = [CCMenu menuWithItems:playGameButton,visitCompanySiteButton, leaderboardButton, nil];
    [mainMenu alignItemsVerticallyWithPadding:100.0];
    mainMenu.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mainMenu];
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        [self displayMainMenu];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

@end
