//
//  MainMenuCreateGame.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MainMenuCreateGame.h"

@implementation MainMenuCreateGame


-(void) setMainMenuUI:(MainMenuUI*)menuUI {
    mainMenuUI = menuUI;
}

-(void) setupCreateGameLayer {
    [self setupCreateGameMenu];
    [self setupFindUserMenu];
    [self setupFindUserField];
}

#pragma mark - Setup Menus and Buttons

-(void) setupCreateGameMenu {
    /*CCMenuItemSprite *quickGame = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(quickGame)];
    
    CCMenuItemSprite *findUser = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(findUser)];
    
    CCMenuItemSprite *findFriend = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(findFriend)];
    
    CCMenuItemSprite *cancel = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(cancelGame)];*/
    
    createGameMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    for (int i = 0; i < 4; i++) {
        CCMenuItemSprite *createGameSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(createGameMenuSelected:)];
        createGameSprite.tag = i;
        
        switch (i) {
            case 0: {
                CCLabelTTF *quickGameLabel = [CCLabelTTF labelWithString:@"Quick Game" fontName:@"Arial" fontSize:14];
                quickGameLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                quickGameLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:quickGameLabel];
                break;
            }
            case 1: {
                CCLabelTTF *findUserLabel = [CCLabelTTF labelWithString:@"Find User" fontName:@"Arial" fontSize:14];
                findUserLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                findUserLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:findUserLabel];
                break;
            }
            case 2: {
                CCLabelTTF *findFriendLabel = [CCLabelTTF labelWithString:@"Find Friend" fontName:@"Arial" fontSize:14];
                findFriendLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                findFriendLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:findFriendLabel];
                break;
            }
            case 3: {
                CCLabelTTF *cancelLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
                cancelLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                cancelLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:cancelLabel];
                break;
            }
                
                
            default:
                break;
        }
        
        [createGameMenu addChild:createGameSprite];
    }
    

    
    //createGameMenu = [CCMenuAdvancedPlus menuWithItems:quickGame, findUser, findFriend, cancel, nil];
    
    createGameMenu.extraTouchPriority = 1;
    
    [createGameMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    createGameMenu.ignoreAnchorPointForPosition = NO;
    createGameMenu.position = ccp(winSize.width/2, winSize.height/2);
    createGameMenu.boundaryRect = CGRectMake(createGameMenu.position.x - createGameMenu.contentSize.width/2, createGameMenu.position.y - createGameMenu.contentSize.height/2, createGameMenu.contentSize.width, createGameMenu.contentSize.height);
    
    [createGameMenu fixPosition];
    
    createGameMenu.enabled = NO;
    createGameMenu.visible = NO;
    [self addChild:createGameMenu];
    
}

-(void) setupFindUserMenu {
    findUserMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    
    for (int i = 0; i < 2; i++) {
        CCMenuItemSprite *findUserSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(findUserMenuSelected:)];
        findUserSprite.tag = i;
        
        switch (i) {
            case 0: {
                CCLabelTTF *findUserLabel = [CCLabelTTF labelWithString:@"Find User" fontName:@"Arial" fontSize:14];
                findUserLabel.position = ccp(findUserSprite.contentSize.width/2, findUserSprite.contentSize.height/2);
                findUserLabel.color = ccc3(0, 0, 0);
                [findUserSprite addChild:findUserLabel];
                break;
            }
            case 1: {
                CCLabelTTF *cancelLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
                cancelLabel.position = ccp(findUserSprite.contentSize.width/2, findUserSprite.contentSize.height/2);
                cancelLabel.color = ccc3(0, 0, 0);
                [findUserSprite addChild:cancelLabel];
                break;
            }
                
                
            default:
                break;
        }
        
        [findUserMenu addChild:findUserSprite];
    }
    
    findUserMenu.extraTouchPriority = 1;
    [findUserMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    findUserMenu.ignoreAnchorPointForPosition = NO;
    findUserMenu.position = ccp(winSize.width/2, winSize.height*.25);
    findUserMenu.boundaryRect = CGRectMake(findUserMenu.position.x - findUserMenu.contentSize.width/2, findUserMenu.position.y - findUserMenu.contentSize.height/2, findUserMenu.contentSize.width, findUserMenu.contentSize.height);
    
    [findUserMenu fixPosition];
    
    findUserMenu.enabled = NO;
    findUserMenu.visible = NO;
    [self addChild:findUserMenu];

}

-(void) setupFindUserField {
    findUserView = [[[UIView alloc] init] autorelease];
    findUserView.frame = CGRectMake(0, 0, 320, 160);
    findUserView.backgroundColor = [UIColor blackColor];
    
    CGRect userFieldRect = CGRectMake(findUserView.bounds.size.width/4, findUserView.bounds.size.height/4, 150, 30);
    userField = [[[UITextField alloc] initWithFrame:userFieldRect] autorelease];
    userField.layer.anchorPoint = ccp(0.5, 0.5);
    userField.placeholder = @"Enter Username";
    userField.backgroundColor = [UIColor whiteColor];
    userField.font = [UIFont systemFontOfSize:14.0f];
    userField.borderStyle = UITextBorderStyleRoundedRect;
    userField.returnKeyType = UIReturnKeyNext;
    userField.textAlignment = UITextAlignmentCenter;
    userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [findUserView addSubview:userField];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:findUserView];
    wrapper.contentSize = CGSizeMake(320, 160);
    wrapper.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:wrapper];
    
    wrapper.visible = NO;
}

#pragma mark - Init

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;
        
        // Setup Layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuCreateGameLayer:self];
        
        [self setupCreateGameLayer];
    }
    
    return self;
}

#pragma mark - Create Game Menu Buttons

-(void) createGameMenuSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: { // Quick Game
            CCLOG(@"MainMenuCreateGame: Selected Quick Game. Looking for challenger.");
            [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
            break;
        }
        case 1: { // Find User
            CCLOG(@"MainMenuCreateGame: Selected Find User. Enter challenger's username.");
            [self showFindUserField];
            break;
        }
        case 2: { // Find Friend
            CCLOG(@"MainMenuCreateGame: Selected Find Friend. Select your friend.");
            break;
        }
        case 3: { // Cancel Menu
            CCLOG(@"MainMenuCreateGame: Create game menu canceled.");
            [self hideLayerAndObjects];
            [mainMenuUI showObjects];
            break;
        }
        default:
            break;
    }
}

-(void) showFindUserField {
    CCLOG(@"MainMenuCreateGame: Show find user field");
    createGameMenu.visible = NO;
    wrapper.visible = YES;
    findUserMenu.visible = YES;
    findUserMenu.enabled = YES;
}

#pragma mark - Find User Menu Buttons

-(void) findUserMenuSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: {
            CCLOG(@"MainMenuCreateGame: Find User");
            [self findUser];
            break;
        }
        case 1: {
            [self showLayerAndObjects];
            wrapper.visible = NO;
            findUserMenu.visible = NO;
            findUserMenu.enabled = NO;
            break;
        }
            
        default:
            break;
    }
}

-(void) findUser {
    wrapper.visible = NO;
    int userFieldLength = userField.text.length;
    
    for (int i = 0; i < userFieldLength; i++) {
        unichar ch = [userField.text characterAtIndex:i];
        if (i == 0) {
            BOOL isLetter = (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
            if (!isLetter) {
                CCLOG(@"LoadScreenUI: First character needs to be a letter");
                return;
            }
        }
        BOOL isLetterAndNumber = (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9');
        if (!isLetterAndNumber) { // If a letter in username is not a-z or A-Z then get out of method
            CCLOG(@"LoadScreenUI: Only letters and numbers are allowed.");
            return;
        }
    }
    CCLOG(@"LoadScreenUI: username ok");
        
    Guid *randomGuid = [Guid randomGuid];
    NSString *guidString = [randomGuid stringValue];
    [randomGuid release];
    CCLOG(@"guidString: %@", guidString);
    
    // Search for user in server database. Retrieve challenger information.
    Challenger *challenger = [[Challenger alloc] initWithUserID:guidString name:userField.text email:@"" profilePic:@"VehicleVolvo.png" win:0 loss:0 matchStarted:@"" lastPlayed:@"" myTurn:YES playerPrevRaceData:@"" playerNextRaceData:@"" challengerPrevRaceData:@"" challengerNextRaceData:@"" questionData:@""];
    [[PlayerDB database] updatePlayerChallenger:challenger inPlayerChallengerDatabase:[PlayerDB database].username];
    
    Challenger *player = [[Challenger alloc] initWithUserID:guidString name:[PlayerDB database].username email:@"" profilePic:@"VehicleWhiteOwl.png" win:0 loss:0 matchStarted:@"" lastPlayed:@"" myTurn:NO playerPrevRaceData:@"" playerNextRaceData:@"" challengerPrevRaceData:@"" challengerNextRaceData:@"" questionData:@""];
    [[PlayerDB database] updatePlayerChallenger:player inPlayerChallengerDatabase:userField.text];
    
    [PlayerDB database].gameGUID = guidString;
    [PlayerDB database].challenger = userField.text;
    [challenger release];
    [player release];
    [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
}

/*-(void) quickGame {
    CCLOG(@"MainMenuUI: Selected Quick Game. Looking for challenger.");
    [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
}

-(void) findUser {
    CCLOG(@"MainMenuUI: Selected Find User. Enter challenger's username.");
}

-(void) findFriend {
    CCLOG(@"MainMenuUI: Selected Find Friend. Select your friend.");
}

-(void) cancelGame {
    [self hideLayerAndObjects];
    [mainMenuUI showObjects];
}*/


-(void) showLayerAndObjects {
    self.visible = YES;
    createGameMenu.visible = YES;
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    createGameMenu.visible = NO;
    [mainMenuUI refreshObjects];	
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [findUserView endEditing:YES];
}

-(void) dealloc {
    [super dealloc];
}


@end
