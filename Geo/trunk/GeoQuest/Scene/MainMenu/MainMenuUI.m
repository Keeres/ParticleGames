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

@interface NSMutableDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSMutableDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;    
}
@end

#pragma mark - MainMenuUI

@implementation MainMenuUI

-(void) setMainMenuBGLayer:(MainMenuBG *)menuBG {
    mainMenuBG = menuBG;
}

#pragma mark - Fetch data from web

-(void) retrieveChallengeData {
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kChallengesURL [NSURL URLWithString:@"www.google.com"]

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];


    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
#undef kBgQueue
#undef kChallengesURL
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    challengesData = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error]]; //1
    [challengesData retain];
    
    if (error != nil) {
        CCLOG(@"error:%@", error);
    }
    
    [self setupMenus];
}

#pragma mark - Setup Player Database

-(void) setupPlayerDatabase {
    //Need to check username from online account
    
    [[PlayerDB database] createNewPlayerTable:@"Keith"];
}

#pragma mark - Setup Menus

-(void) setupMenus {
    [self setupSidePanel];
    [self setupTitle];
    [self setupPlayMenu];
    //[self setupChallengeMenu];
    //[self setupExitMenu];
    [self setupOptionMenu];
}

-(void) setupTitle {
    //Game title on the main menu
    //
    //
    
    title = [CCSprite spriteWithSpriteFrameName:@"MainMenuTitle.png"];
    title.position = ccp((sidePanel.position.x - sidePanel.contentSize.width/2)/2, winSize.height - title.contentSize.height/2);
    [self addChild:title z:1];
}

-(void) setupSidePanel {
    //Side panel that contains the playMenu and challengeMenu
    //Also the spinning compass is attached to this panel
    //The panel will slide left and right
    
    sidePanel = [CCSprite spriteWithSpriteFrameName:@"MainMenuSidePanel.png"];
    sidePanel.position = ccp(winSize.width - sidePanel.contentSize.width/2, winSize.height/2);
    [self addChild:sidePanel z:1];
    
    compass = [CCSprite spriteWithSpriteFrameName:@"MainMenuCompass.png"];
    compass.position = ccp(compass.contentSize.width*.25, sidePanel.contentSize.height/2);
    [sidePanel addChild:compass z:20];
    
    id action = [CCRotateBy actionWithDuration:6 angle:360];
    compassAction = [CCRepeatForever actionWithAction:action];
    [compassAction retain];
    
    [compass runAction:compassAction];
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
    gamePlayMenu.bounceEffect = NO;
    gamePlayMenu.extraTouchPriority = 1;
    
    [gamePlayMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    gamePlayMenu.ignoreAnchorPointForPosition = NO;
    
    gamePlayMenu.position = ccp(sidePanel.contentSize.width - gamePlayMenu.contentSize.width/2 - UI_MENU_SPACING, sidePanel.contentSize.height - gamePlayMenu.contentSize.height/2 - UI_MENU_SPACING);
    gamePlayMenu.boundaryRect = CGRectMake(sidePanel.contentSize.width - gamePlayMenu.contentSize.width - UI_MENU_SPACING, sidePanel.contentSize.height - gamePlayMenu.contentSize.height - UI_MENU_SPACING, gamePlayMenu.contentSize.width, gamePlayMenu.contentSize.height);
    
    [gamePlayMenu fixPosition];
    
    [sidePanel addChild:gamePlayMenu z:20];
}

-(void) setupChallengeMenu {
    //Scrollable menu that shows current challenger games.
    //
    //
    
    CGPoint currentPos = ccp(0, 0);
    
    NSMutableArray *currentChallenges = [challengesData objectForKey:@"Current"];
    NSMutableArray *oldChallenges = [challengesData objectForKey:@"Old"];
    
    if (gameChallengeMenu == nil) {
        gameChallengeMenu = [CCMenuAdvancedPlus menuWithItems:nil];
        CCLOG(@"MainMenuUI: gameChallengeMenu init with nil");
    } else {
        currentPos = gameChallengeMenu.position;
        [gameChallengeMenu removeAllChildrenWithCleanup:YES];
        CCLOG(@"MainMenuUI: gameChallengeMenu removed all children.");
    }
    
    for (int i = 0; i < [currentChallenges count]; i++) { //autorelease objects?
        
        CCMenuItemSprite *challengerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(startChallenge:)];
        challengerItemSprite.tag = i;
        
        NSMutableDictionary *challenger = [currentChallenges objectAtIndex:i];
        CCLabelTTF *name = [CCLabelTTF labelWithString:[challenger objectForKey:@"Player"] fontName:@"Arial" fontSize:10];
        name.position = ccp(name.contentSize.width/2 + UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        name.color = ccc3(255, 0, 0);
        
        CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"win: %@ - loss: %@", [challenger objectForKey:@"Win"], [challenger objectForKey:@"Loss"]] fontName:@"Arial" fontSize:10];
        score.position = ccp(challengerItemSprite.contentSize.width - score.contentSize.width/2 - UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        score.color = ccc3(0, 0, 0);
        
        
        [challengerItemSprite addChild:name];
        [challengerItemSprite addChild:score];
        [gameChallengeMenu addChild:challengerItemSprite];
        
    }
    
    for (int i = 0; i < [oldChallenges count]; i++) { //autorelease objects?
        
        CCMenuItemSprite *challengerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(startChallenge:)];
        challengerItemSprite.tag = (i*-1)-1;
        
        NSMutableDictionary *challenger = [oldChallenges objectAtIndex:i];
        CCLabelTTF *name = [CCLabelTTF labelWithString:[challenger objectForKey:@"Player"] fontName:@"Arial" fontSize:10];
        name.position = ccp(name.contentSize.width/2 + UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        name.color = ccc3(255, 0, 0);
        
        CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"win: %@ - loss: %@", [challenger objectForKey:@"Win"], [challenger objectForKey:@"Loss"]] fontName:@"Arial" fontSize:10];
        score.position = ccp(challengerItemSprite.contentSize.width - score.contentSize.width/2 - UI_MENU_SPACING, challengerItemSprite.contentSize.height/2);
        score.color = ccc3(0, 0, 0);
        
        
        [challengerItemSprite addChild:name];
        [challengerItemSprite addChild:score];
        [gameChallengeMenu addChild:challengerItemSprite];
        
    }
    
    gameChallengeMenu.bounceEffect = YES;

    [gameChallengeMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    gameChallengeMenu.ignoreAnchorPointForPosition = NO;

    
    if (currentPos.x != 0 && currentPos.y != 0) {
        gameChallengeMenu.position = currentPos;
    } else {
        gameChallengeMenu.position = ccp(sidePanel.contentSize.width - gameChallengeMenu.contentSize.width/2 - UI_MENU_SPACING,
                                         gamePlayMenu.position.y - gamePlayMenu.contentSize.height/2 - gameChallengeMenu.contentSize.height/2 - UI_MENU_SPACING);
        gameChallengeMenu.originalPos = ccp(gameChallengeMenu.position.x, gameChallengeMenu.position.y);
        
    }
    
    gameChallengeMenu.boundaryRect = CGRectMake(sidePanel.contentSize.width - gameChallengeMenu.contentSize.width - UI_MENU_SPACING, //x coordinate
                                                0.0, //y coordinate
                                                gameChallengeMenu.boundingBox.size.width, //width
                                                gamePlayMenu.position.y - gamePlayMenu.contentSize.height/2 - UI_MENU_SPACING); //height
    
    [gameChallengeMenu fixPosition];
    
    BOOL childAdded = NO;
    for (int i = 0; i < [[sidePanel children] count]; i++) {
        if ([[sidePanel children] objectAtIndex:i] == gameChallengeMenu) {
            childAdded = YES;
        }
    }
    if (childAdded == NO) {
        [sidePanel addChild:gameChallengeMenu z:10];
    }
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
    
    
    CCMenuItemSprite *achievementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"AchievementButton.png"]
                                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"AchievementButton.png"]
                                                                           block:^(id sender){
                                                                               GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
                                                                               achivementViewController.achievementDelegate = self;
                                                                               
                                                                               AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                                                                               
                                                                               [[app navController] presentModalViewController:achivementViewController animated:YES];
                                                                               
                                                                               [achivementViewController release];
                                                                           }
                                           ];
    [achievementButton setPosition:ccp(5*achievementButton.contentSize.width/2 + UI_MENU_SPACING*3, achievementButton.contentSize.height/2 + UI_MENU_SPACING)];
    
    
    
    optionMenu = [CCMenuAdvanced menuWithItems:storeButton, embargoButton, achievementButton, nil];
    
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
        self.isTouchEnabled = YES;
        
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

        
        challengesData = [[NSMutableDictionary alloc] init];
        
        [self setupPlayerDatabase];

        //[self retrieveChallengeData];
        [self setupMenus];
        
        [self scheduleUpdate];
        

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
        [self setupChallengeMenu];
        gameChallengeMenu.isRefreshed = NO;
    }
}

#pragma mark - Methods for Buttons

-(void) startSolo {
    CCLOG(@"MainMenuUI: Start solo game!");
    [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
}

-(void) startMulti {
    CCLOG(@"MainMenuUI: Start multi game!");
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
    CCLOG(@"%@", [PlayerDB database].name);
    CCLOG(@"%@", [PlayerDB database].territoriesOwned);
    [PlayerDB database].experience = 100;
    [[PlayerDB database] updateInformation];
}

-(void) openEmbargo {
    CCLOG(@"MainMenuUI: Embargo open!");
}

-(void) toggleSidePanel {
    if (optionMenu.enabled == NO) {
        [optionMenu runAction:[CCFadeIn actionWithDuration:UI_FADE_TIME]];
        optionMenu.enabled = YES;
        
        id sidePanelAction = [CCMoveTo actionWithDuration:0.25 position:ccp(winSize.width - sidePanel.contentSize.width/2, winSize.height/2)];
        id sidePanelEase = [CCEaseInOut actionWithAction:sidePanelAction rate:2];
        [sidePanel runAction:sidePanelEase];
        
        id tAction = [CCMoveTo actionWithDuration:0.5 position:ccp(title.position.x, winSize.height - title.contentSize.height/2)];
        id titleEase = [CCEaseInOut actionWithAction:tAction rate:2];
        [title runAction:titleEase];
    }
    
    if (optionMenu.enabled == YES) {
        [optionMenu runAction:[CCFadeOut actionWithDuration:UI_FADE_TIME]];
        optionMenu.enabled = NO;
        
        id sidePanelAction = [CCMoveTo actionWithDuration:0.25 position:ccp(winSize.width + sidePanel.contentSize.width/2 - compass.contentSize.width/2, winSize.height/2)];
        id sidePanelEase = [CCEaseInOut actionWithAction:sidePanelAction rate:2];
        [sidePanel runAction:sidePanelEase];
        
        id tAction = [CCMoveTo actionWithDuration:0.5 position:ccp(title.position.x, winSize.height*2)];
        id titleEase = [CCEaseInOut actionWithAction:tAction rate:2];
        [title runAction:titleEase];
    }
}

-(void) showSidePanel {
    [sidePanel stopAllActions];
    
    if (optionMenu.enabled == NO) {
        [optionMenu runAction:[CCFadeIn actionWithDuration:UI_FADE_TIME]];
        optionMenu.enabled = YES;
    }
    id sidePanelAction = [CCMoveTo actionWithDuration:0.25 position:ccp(winSize.width - sidePanel.contentSize.width/2, winSize.height/2)];
    id sidePanelEase = [CCEaseInOut actionWithAction:sidePanelAction rate:2];
    [sidePanel runAction:sidePanelEase];
    
    id tAction = [CCMoveTo actionWithDuration:0.5 position:ccp(title.position.x, winSize.height - title.contentSize.height/2)];
    id titleEase = [CCEaseInOut actionWithAction:tAction rate:2];
    [title runAction:titleEase];
}

-(void) hideSidePanel {
    [sidePanel stopAllActions];
    [title stopAllActions];
    
    if (optionMenu.enabled == YES) {
        [optionMenu runAction:[CCFadeOut actionWithDuration:UI_FADE_TIME]];
        optionMenu.enabled = NO;
    }
    id sidePanelAction = [CCMoveTo actionWithDuration:0.25 position:ccp(winSize.width + sidePanel.contentSize.width/2 - compass.contentSize.width/2, winSize.height/2)];
    id sidePanelEase = [CCEaseInOut actionWithAction:sidePanelAction rate:2];
    [sidePanel runAction:sidePanelEase];
    
    id tAction = [CCMoveTo actionWithDuration:0.5 position:ccp(title.position.x, winSize.height*2)];
    id titleEase = [CCEaseInOut actionWithAction:tAction rate:2];
    [title runAction:titleEase];
}

#pragma mark - Methods for Touches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        
    if (CGRectContainsPoint(sidePanel.boundingBox, currentPoint)) {
        touchedSidePanel = YES;
    }

    if (CGRectContainsPoint(compass.boundingBox, [sidePanel convertToNodeSpace:currentPoint])) {
        CCLOG(@"yes");
    }
    

}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];

    previousPoint = currentPoint;
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if (CGRectContainsPoint(sidePanel.boundingBox, currentPoint)) {
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
    }
    
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if (sidePanel.position.x < winSize.width) {
        //Show side panel
        [self showSidePanel];
    }
    
    if (sidePanel.position.x >= winSize.width) {
        //Hide side panel
        [self hideSidePanel];
    }
    
    touchedSidePanel = NO;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [challengesData release];
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


