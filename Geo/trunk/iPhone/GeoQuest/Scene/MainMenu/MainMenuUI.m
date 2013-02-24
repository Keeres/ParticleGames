//
//  MainMenuUI.m
//  GeoQuest
//
//  Created by Kelvin on 10/3/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "MainMenuUI.h"
#import "ChallengerMenuItemSprite.h"
#import "AppDelegate.h"
#import "GameManager.h"
#import "SoloGameScene.h"
#import "NetworkPacket.h"
#import "Challenger.h"

#pragma mark - MainMenuUI

@implementation MainMenuUI

-(void) setMainMenuBGLayer:(MainMenuBG *)menuBG {
    mainMenuBG = menuBG;
}

#pragma mark - Setup Player Database

-(void) setupPlayerDatabase {
    //Need to check username from online account
    
    //[writer writeString:[GKLocalPlayer localPlayer].playerID];
    //[writer writeString:[GKLocalPlayer localPlayer].alias];
    
    //[[PlayerDB database] createNewPlayerStatsTable:[GKLocalPlayer localPlayer].alias];
    [[PlayerDB database] createNewPlayerStatsTable:@"kelvin"];
}

#pragma mark - Setup Menus

-(void) loadSpriteSheets {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuUISprites.plist"];
    mainMenuUISheet = [CCSpriteBatchNode batchNodeWithFile:@"MainMenuUISprites.png"];
    [self addChild:mainMenuUISheet z:20];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USAStatesSprites.plist"];
    usaStatesSheet = [CCSpriteBatchNode batchNodeWithFile:@"USAStatesSprites.png"];
    [self addChild:usaStatesSheet z:20];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USACapitalsSprites.plist"];
    usaCapitalsSheet = [CCSpriteBatchNode batchNodeWithFile:@"USACapitalsSprites.png"];
    [self addChild:usaCapitalsSheet z:20];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"QuestionThemes.plist"];
    questionThemesSheet = [CCSpriteBatchNode batchNodeWithFile:@"QuestionThemes.png"];
    [self addChild:questionThemesSheet z:20];
}


-(void) setupMenus {
    [self setupTitle];
    //[self setupPlayMenu];
    [self setupChallengeMenu];
    //[self setupExitMenu];
    //[self setupOptionMenu];
}

-(void) setupTitle {
    //Game title on the main menu
    //
    //
    
    title = [CCSprite spriteWithSpriteFrameName:@"MainMenuTitle.png"];
    title.position = ccp(winSize.width/2, winSize.height - title.textureRect.size.height/2);
    
    title.scale = 0.8;
    [self addChild:title z:1];
}

-(void) setupPlayMenu {
    //Menu with solo and multiplayer button.
    //
    //
    
    CCMenuItemSprite *soloButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuSoloButton.png"]
                                                           selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuSoloButton.png"]
                                                                   target:self
                                                                 selector:@selector(startSolo)];
    CCMenuItemSprite *multiButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"]
                                                                    target:self
                                                                  selector:@selector(startMulti)];
    
    gamePlayMenu = [CCMenuAdvancedPlus menuWithItems:soloButton, multiButton, nil];
    gamePlayMenu.extraTouchPriority = 1;
    
    [gamePlayMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    gamePlayMenu.ignoreAnchorPointForPosition = NO;
    gamePlayMenu.position = ccp(winSize.width/2, title.position.y - gamePlayMenu.contentSize.height - UI_MENU_SPACING);
    //gamePlayMenu.position = [sidePanel convertToNodeSpace:gamePlayMenu.position];
    gamePlayMenu.boundaryRect = CGRectMake(gamePlayMenu.position.x - gamePlayMenu.contentSize.width/2, gamePlayMenu.position.y - gamePlayMenu.contentSize.height/2, gamePlayMenu.contentSize.width, gamePlayMenu.contentSize.height);
    
    
    [gamePlayMenu fixPosition];
    
    [self addChild:gamePlayMenu z:20];
}

-(void) setupChallengeMenu {
    //Scrollable menu that shows current challenger games.
    //
    //
    
    // Update challengers from server DB to client DB
    // Retrieve challengers from client DB
    // Place challengers in to array
    // Create blank buttons for each challenger
    // Add create game button in gameChallengeMenu;
    // Add the rest of the challengers
    // f[[NetworkController sharedInstance] requestServerTerritories];
    NSMutableArray *challengerArray = [[PlayerDB database] retrievePlayerChallengersTable];
    
    CGPoint currentPos = ccp(0, 0);
    
    //NSMutableArray *currentChallenges = [challengesData objectForKey:@"Current"];
    //NSMutableArray *oldChallenges = [challengesData objectForKey:@"Old"];
    
    if (gameChallengeMenu == nil) {
        gameChallengeMenu = [CCMenuAdvancedPlus menuWithItems:nil];
        CCLOG(@"MainMenuUI: gameChallengeMenu init with nil");
    } else {
        currentPos = gameChallengeMenu.position;
        [gameChallengeMenu removeAllChildrenWithCleanup:YES];
        CCLOG(@"MainMenuUI: gameChallengeMenu removed all children.");
    }
    
    // Add Create Game Button
    CCMenuItemSprite *createGameItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(createGame)];
    //createGameItemSprite.tag = 0;
    
    CCLabelTTF *createGameLabel = [CCLabelTTF labelWithString:@"Create Game" fontName:@"Arial" fontSize:10];
    createGameLabel.position = ccp(createGameLabel.contentSize.width/2 + UI_MENU_SPACING, createGameItemSprite.contentSize.height/2);
    createGameLabel.color = ccc3(255, 0, 0);
    
    [createGameItemSprite addChild:createGameLabel];
    [gameChallengeMenu addChild:createGameItemSprite];
    
    // Add Player vs. Challenger Buttons
    for (int i = 0; i < [challengerArray count]; i++) {
        CCMenuItemSprite *challengerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(startChallenge:)];
        challengerItemSprite.tag = i;
        challengerItemSprite.disabledImage = [CCSprite spriteWithSpriteFrameName:@"MainMenuSoloButton.png"];
        
        Challenger *c = [challengerArray objectAtIndex:i];
        
        CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:c.name fontName:@"Arial" fontSize:10];
        nameLabel.position = ccp(nameLabel.contentSize.width/2 + UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        nameLabel.color = ccc3(255, 0, 0);
        
        [challengerItemSprite addChild:nameLabel];
        [gameChallengeMenu addChild:challengerItemSprite];
    }
    
    // Add Options Button
    
    CCMenuItemSprite *optionItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(openOptions)];
    //createGameItemSprite.tag = [challengerArray count] + 1;
    
    CCLabelTTF *optionLabel = [CCLabelTTF labelWithString:@"Options" fontName:@"Arial" fontSize:10];
    optionLabel.position = ccp(optionLabel.contentSize.width/2 + UI_MENU_SPACING, optionItemSprite.contentSize.height/2);
    optionLabel.color = ccc3(255, 0, 0);
    
    [optionItemSprite addChild:optionLabel];
    [gameChallengeMenu addChild:optionItemSprite];
    
    gameChallengeMenu.bounceEffectUp = YES;
    gameChallengeMenu.bounceEffectDown = YES;
    gameChallengeMenu.bounceDistance = 40.0;
    
    [gameChallengeMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    gameChallengeMenu.ignoreAnchorPointForPosition = NO;
    
    
    if (currentPos.x != 0 && currentPos.y != 0) {
        gameChallengeMenu.position = currentPos;
    } else {
        //gameChallengeMenu.position = ccp(winSize.width/2, winSize.height/2 - gameChallengeMenu.contentSize.height/2 - UI_MENU_SPACING);
        gameChallengeMenu.position = ccp(winSize.width/2, title.position.y - title.contentSize.height/2 - gameChallengeMenu.contentSize.height/2 - UI_MENU_SPACING);

        gameChallengeMenu.originalPos = gameChallengeMenu.position;
        
    }
    
    float yPos = MAX(0.0, gameChallengeMenu.position.y - gameChallengeMenu.contentSize.height/2);
    float gHeight = MIN(winSize.height/2 ,gameChallengeMenu.contentSize.height);
    gameChallengeMenu.boundaryRect = CGRectMake(winSize.width/2 - gameChallengeMenu.contentSize.width/2, //x coordinate
                                                yPos, //y coordinate
                                                gameChallengeMenu.boundingBox.size.width, //width
                                                gHeight); //height
    
    [gameChallengeMenu fixPosition];
    [self addChild:gameChallengeMenu];
    
    /*BOOL childAdded = NO;
    for (int i = 0; i < [[sidePanel children] count]; i++) {
        if ([[sidePanel children] objectAtIndex:i] == gameChallengeMenu) {
            childAdded = YES;
        }
    }
    if (childAdded == NO) {
        [sidePanel addChild:gameChallengeMenu z:10];
    }*/
}

-(void) setupExitMenu {
    //Menu to exit button in map view
    //
    //
    CCMenuItemSprite *exitButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"OptionButton.png"]
                                                           selectedSprite:[CCSprite spriteWithSpriteFrameName:@"OptionButton.png"]
                                                                   target:self
                                                                 selector:@selector(exitMap)];
    exitMenu = [CCMenuAdvanced menuWithItems:exitButton, nil];
    [exitMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    exitMenu.ignoreAnchorPointForPosition = NO;
    
    exitMenu.position = ccp(exitMenu.contentSize.width/2 + UI_MENU_SPACING, winSize.height - exitMenu.contentSize.height/2 - UI_MENU_SPACING);
    exitMenu.boundaryRect = CGRectMake(UI_MENU_SPACING, winSize.height - exitMenu.contentSize.height - UI_MENU_SPACING, exitMenu.contentSize.width, exitMenu.contentSize.height);
    
    [exitMenu fixPosition];
    [self addChild:exitMenu z:20];
    exitMenu.enabled = NO;
    [exitMenu runAction:[CCFadeOut actionWithDuration:0]];
}

-(void) setupOptionMenu {
    //Menu with Store, Embargo, and Game Center buttons
    //
    //
    
    CCMenuItemSprite *storeButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"StoreButton.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"StoreButton.png"]
                                                                    target:self
                                                                  selector:@selector(openStore)];
    [storeButton setPosition:ccp(storeButton.contentSize.width/2 + UI_MENU_SPACING, storeButton.contentSize.height/2 + UI_MENU_SPACING)];
    
    
    CCMenuItemSprite *embargoButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"EmbargoButton.png"]
                                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"EmbargoButton.png"]
                                                                      target:self
                                                                    selector:@selector(openEmbargo)];
    [embargoButton setPosition:ccp(3*embargoButton.contentSize.width/2 + UI_MENU_SPACING*2, embargoButton.contentSize.height/2 + UI_MENU_SPACING)];
    
    
    /*CCMenuItemSprite *achievementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"AchievementButton.png"]
                                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"AchievementButton.png"]
                                                                           block:^(id sender){
                                                                               GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
                                                                               achivementViewController.achievementDelegate = self;
                                                                               
                                                                               AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                                                                               
                                                                               [[app navController] presentModalViewController:achivementViewController animated:YES];
                                                                               
                                                                               [achivementViewController release];
                                                                           }
                                           ];
    [achievementButton setPosition:ccp(5*achievementButton.contentSize.width/2 + UI_MENU_SPACING*3, achievementButton.contentSize.height/2 + UI_MENU_SPACING)];*/
    
    
    
    optionMenu = [CCMenuAdvanced menuWithItems:storeButton, embargoButton, nil];
    
    [optionMenu alignItemsHorizontallyWithPadding:5.0 leftToRight:YES];
    optionMenu.ignoreAnchorPointForPosition = NO;
    
    optionMenu.position = ccp(optionMenu.contentSize.width/2 + UI_MENU_SPACING, optionMenu.contentSize.height - UI_MENU_SPACING);
    optionMenu.boundaryRect = CGRectMake(UI_MENU_SPACING, UI_MENU_SPACING, optionMenu.contentSize.width, optionMenu.contentSize.height);
    
    [optionMenu fixPosition];
    [self addChild:optionMenu z:20];
    
}

#pragma mark - Initialize


-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        [NetworkController sharedInstance].delegate = self;
        [self loadSpriteSheets];
        
        self.isTouchEnabled = YES;
        
        [self setupPlayerDatabase];
        
        [self setupMenus];
        [self scheduleUpdate];
        
        //[[GameManager sharedGameManager] playBackgroundTrack:@"BGMusic.mp3"];
        
        //[self stateChanged:[NetworkController sharedInstance].state];
        
        
        
        /*CCLabelTTF *label = [CCLabelTTF labelWithString:@"GEOQUEST" fontName:@"Marker Felt" fontSize:48];
         
         CGSize winSize = [[CCDirector sharedDirector] winSize];
         
         CCLOG(@"w:%f h:%f", label.contentSize.width, label.contentSize.height);
         
         label.position = ccp(label.contentSize.width/2 + 40, winSize.height - label.contentSize.width/2);
         
         [self addChild:label z:20];*/
        
        
        
        /*
         //
         //Leaderboards and Achievements
         //
         
         // Default font size will be 28 points.
         [CCMenuItemFont setFontSize:28];
         
         // Achievement Menu Item using blocks
         CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
         
         
         GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
         achivementViewController.achievementDelegate = self;
         
         AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
         
         [[app navController] presentModalViewController:achivementViewController animated:YES];
         
         [achivementViewController release];
         }
         
         ];
         
         // Leaderboard Menu Item using blocks
         CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
         
         
         GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
         leaderboardViewController.leaderboardDelegate = self;
         
         AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
         
         [[app navController] presentModalViewController:leaderboardViewController animated:YES];
         
         [leaderboardViewController release];
         }
         ];
         
         CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
         
         [menu alignItemsHorizontallyWithPadding:20];
         [menu setPosition:ccp( winSize.width/2, winSize.height/2 - 50)];
         
         // Add the menu to the layer
         [self addChild:menu];*/
        
    }
    return self;
}

-(void) update:(ccTime)delta {
    if (gameChallengeMenu.isRefreshed) {
        //[self setupChallengeMenu];
        gameChallengeMenu.isRefreshed = NO;
    }
}

#pragma mark - Methods for Buttons

-(void) disableButtonsWhenNoNetwork {
    CCArray *gameChallengeMenuArray = [gameChallengeMenu children];
    for (int i = 0; i < [gameChallengeMenuArray count] - 1; i++) {
        CCMenuItemSprite *s = [gameChallengeMenuArray objectAtIndex:i];
        if (s.isEnabled) {
            s.isEnabled = NO;
        } else {
            s.isEnabled = YES;
        }
    }
    
}

-(void) startSolo {
    CCLOG(@"MainMenuUI: Start solo game!");
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
}

-(void) startMulti {
    CCLOG(@"MainMenuUI: Start multi game!");
    [[NetworkController sharedInstance] requestServerTerritories];
}

-(void) createGame {
    CCLOG(@"MainMenuUI: Create new game!");
    [self startSolo];
}

-(void) openOptions {
    CCLOG(@"MainMenuUI: Open options menu!");
    [self disableButtonsWhenNoNetwork];
}

-(void) startChallenge:(CCMenuItemSprite *)sender {
    int i = sender.tag;
    CCLOG(@"MainMenuUI: Challenger %i!", i);
}

-(void) exitMap {
    CCLOG(@"MainMenuUI: Option open!");
}

-(void) openStore {
    CCLOG(@"MainMenuUI: Store open!");
    if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume == 1) {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
    } else {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
    }
}

-(void) openEmbargo {
    CCLOG(@"MainMenuUI: Embargo open!");
}

#pragma mark - Methods for Touches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    /*if (CGRectContainsPoint(sidePanel.boundingBox, currentPoint)) {
     touchedSidePanel = YES;
     }
     
     if (CGRectContainsPoint(compass.boundingBox, [sidePanel convertToNodeSpace:currentPoint])) {
     CCLOG(@"yes");
     }*/
    
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    previousPoint = currentPoint;
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    /*if (CGRectContainsPoint(sidePanel.boundingBox, currentPoint)) {
     touchedSidePanel = YES;
     }
     
     if (touchedSidePanel) {
     
     if (sidePanel.position.x >= (winSize.width - sidePanel.contentSize.width/2) && sidePanel.position.x <= (winSize.width + sidePanel.contentSize.width/2 - compass.contentSize.width/2)) {
     float xDifference = previousPoint.x - currentPoint.x;
     sidePanel.position = ccp(sidePanel.position.x - xDifference, sidePanel.position.y);
     
     if (sidePanel.position.x < (winSize.width - sidePanel.contentSize.width/2)) {
     sidePanel.position = ccp(winSize.width - sidePanel.contentSize.width/2, sidePanel.position.y);
     }
     
     if (sidePanel.position.x > (winSize.width + sidePanel.contentSize.width/2 - compass.contentSize.width/2)) {
     sidePanel.position = ccp(winSize.width + sidePanel.contentSize.width/2 - compass.contentSize.width/2, sidePanel.position.y);
     }
     }
     }*/
    
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    /*if (sidePanel.position.x < winSize.width) {
     //Show side panel
     [self showSidePanel];
     }
     
     if (sidePanel.position.x >= winSize.width) {
     //Hide side panel
     [self hideSidePanel];
     }
     
     touchedSidePanel = NO;*/
}

// GameState Changes
-(void) stateChanged:(uint8_t)state {
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	//[titleAction release];
    //[compassAction release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end


