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
}

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

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup Layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuCreateGameLayer:self];
        [self setupCreateGameLayer];
    }
    
    return self;
}

-(void) createGameMenuSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: { // Quick Game
            CCLOG(@"MainMenuUI: Selected Quick Game. Looking for challenger.");
            [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
            break;
        }
        case 1: { // Find User
            CCLOG(@"MainMenuUI: Selected Find User. Enter challenger's username.");
            break;
        }
        case 2: { // Find Friend
            CCLOG(@"MainMenuUI: Selected Find Friend. Select your friend.");
            break;
        }
        case 3: { // Cancel Menu
            [self hideLayerAndObjects];
            [mainMenuUI showObjects];
            break;
        }
        default:
            break;
    }
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
}

-(void) dealloc {
    [super dealloc];
}


@end
