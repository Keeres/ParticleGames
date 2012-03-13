//
//  MainMenuLayer.m
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "Achievements.h"

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

-(void) showMiniGame {
    CCLOG(@"MainMenu: Mini Game");
    [[GameManager sharedGameManager] runSceneWithID:kMiniGameScene];
}

-(void) showLeaderboard {
    CCLOG(@"MainMenu: Show Leaderboard");
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = kHighScoreLeaderboardID;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.viewController presentModalViewController:leaderboardController animated:YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)
viewController
{
    AppDelegate *delegate = 
    [UIApplication sharedApplication].delegate;
    [delegate.viewController dismissModalViewControllerAnimated: YES];
    [viewController release];
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void) playChorus {
    //play sound stuff
}

-(void) displayMainMenu {
    //Main Menu
    CCLOG(@"MainMenu: Display Main Menu");
    
    CCLabelBMFont *playGameLabel = [CCLabelBMFont labelWithString:@"Play Game" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *playGameButton = [CCMenuItemLabel itemWithLabel:playGameLabel target:self selector:@selector(startGame)];
    playGameButton.anchorPoint = ccp(0.0, 0.5);
    
    CCLabelBMFont *miniGameLabel = [CCLabelBMFont labelWithString:@"Mini Game" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *miniGameButton = [CCMenuItemLabel itemWithLabel:miniGameLabel target:self selector:@selector(showMiniGame)];
    miniGameButton.anchorPoint = ccp(0.0, 0.5);
    
    CCLabelBMFont *companySiteLabel = [CCLabelBMFont labelWithString:@"Website" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *visitCompanySiteButton = [CCMenuItemLabel itemWithLabel:companySiteLabel target:self selector:@selector(visitCompanySite)];
    visitCompanySiteButton.anchorPoint = ccp(0.0, 0.5);
    
    CCLabelBMFont *leaderboardLabel = [CCLabelBMFont labelWithString:@"Leaderboard" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *leaderboardButton = [CCMenuItemLabel itemWithLabel:leaderboardLabel target:self selector:@selector(showLeaderboard)];
    leaderboardButton.anchorPoint = ccp(0.0, 0.5);
    
    mainMenu = [CCMenu menuWithItems:playGameButton, miniGameButton, visitCompanySiteButton, leaderboardButton, nil];
    [mainMenu alignItemsVerticallyWithPadding:25.0];
    mainMenu.position = ccp(winSize.width*0.05, winSize.height/2);
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
