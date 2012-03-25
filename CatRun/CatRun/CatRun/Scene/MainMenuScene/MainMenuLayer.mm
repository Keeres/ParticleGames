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

#pragma mark Menu Transitions

-(void) startGame {
    CCLOG(@"MainMenu: Start Game");
    [[GameManager sharedGameManager] runSceneWithID:kGameScene];
}

-(void) showMiniGame {
    CCLOG(@"MainMenu: Mini Game");
    [[GameManager sharedGameManager] runSceneWithID:kMiniGameScene];
}

-(void) switchToCharacterMenu {
    CCLOG(@"MainMenu: Character");    
    [self switchFromMenu:kMainMenuType ToNextMenu:kCharacterMenuType];
}

-(void) visitCompanySite {
    CCLOG(@"MainMenu: Visit Website");
    [[GameManager sharedGameManager] openSiteWithLinkType:kLinkTypeCompanySite];
}

-(void) showOptions {
    CCLOG(@"MainMenu: Show Options");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
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

//Switches between different menu layers
-(void) switchFromMenu:(MenuType)currentLayer ToNextMenu:(MenuType)nextLayer {
    switch (currentLayer) {
        case kMainMenuType:
            currentMenuLayer = self;
            break;
            
        case kCharacterMenuType:
            currentMenuLayer = characterMenuLayer;
            break;
            
        case kCustomizeMenuType:
            currentMenuLayer = customizeMenuLayer;
            break;
            
        case kPerkMenuType:
            currentMenuLayer = perksMenuLayer;
            break;
            
        default:
            break;
    }
    
    switch (nextLayer) {
        case kMainMenuType:
            nextMenuLayer= self;
            break;
            
        case kCharacterMenuType:
            nextMenuLayer = characterMenuLayer;
            break;
            
        case kCustomizeMenuType:
            nextMenuLayer = customizeMenuLayer;
            break;
            
        case kPerkMenuType:
            nextMenuLayer = perksMenuLayer;
            break;
            
        default:
            break;
    }
    
    //If next menu is to the right of the current menu, reposition next menu and move everything from right to left
    //Else move move everything from right to left
    if (currentLayer < nextLayer) {
        nextMenuLayer.position = ccp(winSize.width, 0.0);
        
        [nextMenuLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0.0, 0.0)] rate:1.0], nil]];
        
        [currentMenuLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-winSize.width, 0.0)] rate:1.0], nil]];
    }else{
        nextMenuLayer.position = ccp(-winSize.width, 0.0);
        
        [nextMenuLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0.0, 0.0)] rate:1.0], nil]];
        
        [currentMenuLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(winSize.width, 0.0)] rate:1.0], nil]];
    }
}

#pragma mark Setup Resources

-(void) playChorus {
    //play sound stuff
}

-(void) displayMainMenu {
    //Main Menu
    CCLOG(@"MainMenu: Display Main Menu");
    
    CCSprite *playButtonNormal;
    CCSprite *playButtonSelected;
    CCSprite *lairButtonNormal;
    CCSprite *lairButtonSelected;
    CCSprite *miniGamesButtonNormal;
    CCSprite *miniGamesButtonSelected;
    CCSprite *gameCenterButtonNormal;
    CCSprite *gameCenterButtonSelected;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //NOTE:
    //1)CCMenuItem defines its position relation to CCMenu by first centering itself at the anchor point of CCMenu 
    //  but it defines the sprite for the button by adding in the position of the sprite. 
    //
    //  (i.e) for a CCMenuItem defined by a sprite *Button at position (5.0, 5.0) and CCMenu anchorpoint at (0.5, 0.5),
    //  CCMenu will be placed defualt at the center of the creen (240, 160), meaning the CCMenuItem *Button will 
    //  be position at (240, 160) with its position inside CCMenu being (0, 0), but the button will appear to be at (245, 165)
    //  since that is the position of the button plus the sprite. However, the button will continue to be activate as if the button 
    //  is at (240, 160) even if no button sprite is at that position. 
    //
    //  The position of the sprite must be defined when using SpriteHelper to assign sprites using a spriteHelpr plist.
    //  It may be easiest to place the sprites at (0.0, 0.0) and reposition the buttons after adding 
    //  CCMenuItem to CCmenu to avoid confusion especially when manually moving the button is necessary
    //  An alternative is to write our own function to call for the sprite from spriteHelper plist without having to 
    //  define a location for the sprite (REQUIRE FURTHER TESTING).
    //
    //2)When the sprites are added as CCMenuItem, the anchor point seems to be at the bottom left corner. Thus, when
    //  changing scales between normal and selected sprite, the button would appear to shrink/expand towards bottom 
    //  left/upper right corner instead of the center. To resolve this issue, current solution is to modify sprite
    //  position such that when added as MenuItem, the sprite is place at the origin of the MenuItem plus the sprite
    //  positon as state in (1). This will occur regardless of using spriteHelper
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    playButtonNormal = [sHelper spriteWithUniqueName:@"PlayButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    playButtonSelected = [sHelper spriteWithUniqueName:@"PlayButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    playButtonSelected.scale = 0.90;
    lairButtonNormal=[sHelper spriteWithUniqueName:@"LairButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    lairButtonSelected = [sHelper spriteWithUniqueName:@"LairButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    lairButtonSelected.scale = 0.90;
    miniGamesButtonNormal = [sHelper spriteWithUniqueName:@"MiniGameButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    miniGamesButtonSelected = [sHelper spriteWithUniqueName:@"MiniGameButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    miniGamesButtonSelected.scale = 0.90;
    gameCenterButtonNormal=[sHelper spriteWithUniqueName:@"GameCenterButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    gameCenterButtonSelected=[sHelper spriteWithUniqueName:@"GameCenterButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    gameCenterButtonSelected.scale = 0.90;
    
    CCMenuItem *playButton = [CCMenuItemSprite itemFromNormalSprite:playButtonNormal selectedSprite:playButtonSelected target:self selector:@selector(startGame)];
    CCMenuItem *miniGamesButton = [CCMenuItemSprite itemFromNormalSprite:miniGamesButtonNormal selectedSprite:miniGamesButtonSelected target:self selector:@selector(showMiniGame)];
    CCMenuItem *lairButton = [CCMenuItemSprite itemFromNormalSprite:lairButtonNormal selectedSprite:lairButtonSelected target:self selector:@selector(switchToCharacterMenu)];
     CCMenuItem *gameCenterButton = [CCMenuItemSprite itemFromNormalSprite:gameCenterButtonNormal selectedSprite:gameCenterButtonSelected target:self selector:@selector(showLeaderboard)];
    
 //   CCLabelBMFont *companySiteLabel = [CCLabelBMFont labelWithString:@"Website" fntFile:@"testFont.fnt"];
 //   CCMenuItemLabel *visitCompanySiteButton = [CCMenuItemLabel itemWithLabel:companySiteLabel target:self selector:@selector(visitCompanySite)];
  //  visitCompanySiteButton.anchorPoint = ccp(0.5, 0.5);

   
    mainMenu = [CCMenu menuWithItems:playButton, miniGamesButton, lairButton, gameCenterButton, nil];
    [mainMenu alignItemsVerticallyWithPadding:20.0];
    mainMenu.position = ccp(winSize.width*2.0/3.0, winSize.height/2.0);

    [self addChild:mainMenu];
}

-(void) displayTitle {  
    CGSize size = CGSizeMake(400.0, 100.0);
    CCLabelBMFont *title = [CCLabelBMFontMultiline labelWithString:@"YaRG" fntFile:@"testFont.fnt" dimensions:size alignment:CenterAlignment];
     CCLabelBMFont *subTitle = [CCLabelBMFontMultiline labelWithString:@"Yet another \nRunning Game" fntFile:@"testFont.fnt" dimensions:size alignment:CenterAlignment];
    
    title.scale = 1.5;
    subTitle.scale = 0.50;
    
    title.position = ccp(winSize.width*(1.0/4.0), 220.0);
    subTitle.position = ccp(winSize.width*(1.0/4.0), 180.0);
    
    [self addChild:subTitle];
    [self addChild:title];
}                          

#pragma mark Initialize

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        b2Vec2 gravity;
		gravity.Set(0.0f, -20.0f);
        world = new b2World(gravity);
        
        lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"MainMenu"];
        [lHelper addObjectsToWorld:world cocos2dLayer:self];
        
        [self displayMainMenu];
        
        self.isTouchEnabled = YES;
    }
    return self;
}   

-(id) initWithCharacterLayer:(CharacterMenuLayer *)characterLayer andSkinLayer:(CustomizeMenuLayer *)customizeLayer andPerkLayer:(PerksMenuLayer *)perkLayer andSpriteHelper:(SpriteHelperLoader*)sHelperLoader{ 

    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;

       lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"MainMenu"];
        [lHelper addSpritesToLayer:self];
        sHelper = sHelperLoader;
     
        characterMenuLayer = characterLayer;
        customizeMenuLayer = customizeLayer;
        perksMenuLayer = perkLayer;
        [characterMenuLayer setMainMenuLayer:self];
        [customizeMenuLayer setMainMenuLayer:self];
        [perksMenuLayer setMainMenuLayer:self];
        
        [self displayMainMenu];
        [self displayTitle];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

#pragma mark Dealloc
- (void) dealloc
{
    [super dealloc];
}

@end
