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


@implementation MainMenuUI

#pragma mark - Setup Layers

-(void) setMainMenuBGLayer:(MainMenuBG *)menuBG {
    mainMenuBG = menuBG;
}

-(void) setMainMenuLoginLayer:(MainMenuLogin*) menuLogin {
    mainMenuLogin = menuLogin;
}

-(void) setMainMenuCreateGameLayer:(MainMenuCreateGame*) menuCreateGame {
    mainMenuCreateGame = menuCreateGame;
}

#pragma mark - Setup Player Database

-(void) setupPlayerDatabase {
    //Need to check username from online account
    
    [mainMenuLogin hideLayerAndObjects];

    [[PlayerDB database] createNewPlayerStatsTable:[PlayerDB database].username];
    [self setupChallengeMenu];
    
    NSMutableArray *t = [[GeoQuestDB database] retrieveTerritories];
    [[PlayerDB database] updatePlayerTerritoriesTable:t];
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

-(void) setupTitle {
    // Game title on the main menu

    title = [CCSprite spriteWithSpriteFrameName:@"MainMenuTitle.png"];
    title.position = ccp(winSize.width/2, winSize.height - title.textureRect.size.height/2);
    
    title.scale = 0.8;
    [self addChild:title z:20];
}

-(void) setupChallengeMenu {
    // Scrollable menu that includes all buttons for main menu.
    // Create game. All the challengers player is playing with. Options button.
    //
    
    // Update challengers from server DB to client DB
    // Retrieve challengers from client DB
    // Place challengers in to array
    // Create blank buttons for each challenger
    // Add create game button in gameChallengeMenu;
    // Add the rest of the challengers
    
    if (gameChallengeMenu == nil) {
        gameChallengeMenu = [CCMenuAdvancedPlus menuWithItems:nil];
        CCLOG(@"MainMenuUI: gameChallengeMenu init with nil");
    } else {
        gameChallengeMenu.visible = YES;
        [gameChallengeMenu removeAllChildrenWithCleanup:YES];
        CCLOG(@"MainMenuUI: gameChallengerMenu already created.");
    }
    
    [self addButtonsToChallengerMenu];
    
    gameChallengeMenu.position = ccp(winSize.width/2, title.position.y - title.contentSize.height/2 - gameChallengeMenu.contentSize.height/2 - UI_MENU_SPACING);

    gameChallengeMenu.originalPos = gameChallengeMenu.position;
    
    float yPos = 0.0;
    float gHeight = gameChallengeMenu.originalPos.y + gameChallengeMenu.contentSize.height/2;
    
    if (gameChallengeMenu.originalPos.y - gameChallengeMenu.contentSize.height/2 > 0.0) {
        yPos = gameChallengeMenu.originalPos.y - gameChallengeMenu.contentSize.height/2;
        gHeight = gameChallengeMenu.contentSize.height;
    }
    
    gameChallengeMenu.boundaryRect = CGRectMake(gameChallengeMenu.originalPos.x - gameChallengeMenu.contentSize.width/2, yPos, gameChallengeMenu.contentSize.width, gHeight);
    
    [gameChallengeMenu fixPosition];
    
    BOOL childAdded = NO;
    for (int i = 0 ; i < [[self children] count]; i++) {
        if ([[self children] objectAtIndex:i] == gameChallengeMenu) {
            childAdded = YES;
        }
    }
    if (childAdded == NO) {
        [self addChild:gameChallengeMenu z:10];
    }
    
    gameChallengeMenu.debugDraw = YES;

}

#pragma mark - Initialize


-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;

        //[NetworkController sharedInstance].delegate = self;
        
        [self loadSpriteSheets];
        [self setupTitle];
        
        //[self setupPlayerDatabase];
        //[self setupMenus];
        
        [self scheduleUpdate];
        
        //[[GameManager sharedGameManager] playBackgroundTrack:@"BGMusic.mp3"];
        
        //[self stateChanged:[NetworkController sharedInstance].state];
        
    }
    return self;
}

-(void) refreshChallengerMenu {
    [gameChallengeMenu stopAllActions];
    CGPoint currentPos = ccp(0, 0);
    
    if (gameChallengeMenu == nil) {
        //gameChallengeMenu = [CCMenuAdvancedPlus menuWithItems:nil];
        return;
        CCLOG(@"MainMenuUI: gameChallengerMenu is nil");
    } else {
        currentPos = gameChallengeMenu.position;
        gameChallengeMenu.visible = YES;
        [gameChallengeMenu removeAllChildrenWithCleanup:YES];
        
        CCLOG(@"MainMenuUI: gameChallengeMenu removed all children.");
    }
    
    [self addButtonsToChallengerMenu];
    
    gameChallengeMenu.position = currentPos;
    gameChallengeMenu.originalPos = ccp(winSize.width/2, title.position.y - title.contentSize.height/2 - gameChallengeMenu.contentSize.height/2 - UI_MENU_SPACING);
    
    float yPos = 0.0;
    float gHeight = gameChallengeMenu.originalPos.y + gameChallengeMenu.contentSize.height/2;
    
    if (gameChallengeMenu.originalPos.y - gameChallengeMenu.contentSize.height/2 > 0.0) {
        yPos = gameChallengeMenu.originalPos.y - gameChallengeMenu.contentSize.height/2;
        gHeight = gameChallengeMenu.contentSize.height;
    }
    
    gameChallengeMenu.boundaryRect = CGRectMake(gameChallengeMenu.originalPos.x - gameChallengeMenu.contentSize.width/2, yPos, gameChallengeMenu.contentSize.width, gHeight);
    
    [gameChallengeMenu fixPosition];
    
    BOOL childAdded = NO;
    for (int i = 0 ; i < [[self children] count]; i++) {
        if ([[self children] objectAtIndex:i] == gameChallengeMenu) {
            childAdded = YES;
        }
    }
    if (childAdded == NO) {
        [self addChild:gameChallengeMenu z:10];
    }
    
    gameChallengeMenu.debugDraw = YES;
    
    id action = [CCMoveTo actionWithDuration:0.75 position:gameChallengeMenu.originalPos];
    id ease = [CCEaseBackOut actionWithAction:action];
    
    [gameChallengeMenu runAction:ease];
}

-(void) addButtonsToChallengerMenu {
    NSMutableArray *challengerArray = [[PlayerDB database] retrievePlayerChallengersTable];

    // Add Create Game Button
    CCMenuItemSprite *createGameItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(createGame)];
    
    CCLabelTTF *createGameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@, Create Game", [PlayerDB database].username] fontName:@"Arial" fontSize:10];
    createGameLabel.position = ccp(createGameLabel.contentSize.width/2 + UI_MENU_SPACING, createGameItemSprite.contentSize.height/2);
    createGameLabel.color = ccc3(255, 0, 0);
    
    [createGameItemSprite addChild:createGameLabel];
    [gameChallengeMenu addChild:createGameItemSprite];
    
    // Add Player vs. Challenger Buttons
    for (int i = 0; i < [challengerArray count]; i++) {
        ChallengerMenuItemSprite *challengerItemSprite = [ChallengerMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(startChallenge:)];
        challengerItemSprite.tag = i;
        challengerItemSprite.disabledImage = [CCSprite spriteWithSpriteFrameName:@"MainMenuSoloButton.png"];
        
        Challenger *c = [challengerArray objectAtIndex:i];
        challengerItemSprite.ID = c.ID;
        challengerItemSprite.challenger = c.name;
        [challengerItemSprite setupDeleteSprite];
        
        if (c.myTurn) {
            challengerItemSprite.color = ccc3(0, 255, 0);
        } else {
            challengerItemSprite.color = ccc3(255, 0, 0);
            challengerItemSprite.isEnabled = NO;
        }
        
        CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:c.name fontName:@"Arial" fontSize:10];
        nameLabel.position = ccp(nameLabel.contentSize.width/2 + UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        nameLabel.color = ccc3(0, 0, 0);
        [challengerItemSprite addChild:nameLabel];
        
        NSString *pScore = [[PlayerDB database] retrieveDataFromColumn:@"WIN" forUsername:[PlayerDB database].username andID:c.ID];
        NSString *cScore = [[PlayerDB database] retrieveDataFromColumn:@"LOSS" forUsername:[PlayerDB database].username andID:c.ID];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ - %@", pScore, cScore] fontName:@"Arial" fontSize:10];
        scoreLabel.position = ccp(challengerItemSprite.contentSize.width - scoreLabel.contentSize.width/2 - UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        scoreLabel.color = ccc3(0, 0, 0);
        [challengerItemSprite addChild:scoreLabel];
        
        [gameChallengeMenu addChild:challengerItemSprite];
    }
    
    // Add Options Button
    
    CCMenuItemSprite *optionItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(openOptions)];
    
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
}

-(void) update:(ccTime)delta {
    if (gameChallengeMenu.isRefreshed) {
        [self refreshChallengerMenu];
        gameChallengeMenu.isRefreshed = NO;
    }
}

#pragma mark - Methods for Buttons

/*-(void) disableButtonsWhenNoNetwork {
    CCArray *gameChallengeMenuArray = [gameChallengeMenu children];
    for (int i = 0; i < [gameChallengeMenuArray count] - 1; i++) {
        CCMenuItemSprite *s = [gameChallengeMenuArray objectAtIndex:i];
        if (s.isEnabled) {
            s.isEnabled = NO;
        } else {
            s.isEnabled = YES;
        }
    }
    
}*/

-(void) createGame {
    CCLOG(@"MainMenuUI: Create new game!");
    [mainMenuCreateGame showLayerAndObjects];
    [self hideObjects];
}

-(void) startChallenge:(ChallengerMenuItemSprite *)sender {
    int i = sender.tag;
    CCLOG(@"MainMenuUI: Challenger %i!", i);
    if (sender.deleteActive) {
        CCLOG(@"delete this srptie");
    } else {
        [PlayerDB database].gameGUID = sender.ID;
        [PlayerDB database].challenger = sender.challenger;
        [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
    }

    
}

-(void) openOptions {
    CCLOG(@"MainMenuUI: Open options menu! - TEST: Logged out. Username cleared.");
    [[PlayerDB database] logOut];
    //[self disableButtonsWhenNoNetwork];
    mainMenuLogin.visible = YES;
    [mainMenuLogin checkIfLoggedIn];
    gameChallengeMenu.visible = NO;
}

-(void) openStore {
    CCLOG(@"MainMenuUI: Store open!");
    if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume == 1) {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
    } else {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
    }
}

-(void) showObjects {
    gameChallengeMenu.visible = YES;
}

-(void) hideObjects {
    gameChallengeMenu.visible = NO;
}

-(void) refreshObjects {
    gameChallengeMenu.isRefreshed = YES;
}

#pragma mark - Methods for Touches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    previousPoint = currentPoint;
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
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


