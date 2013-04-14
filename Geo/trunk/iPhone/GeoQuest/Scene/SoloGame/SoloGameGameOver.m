//
//  SoloGameGameOver.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "SoloGameGameOver.h"
#import "ChallengesInProgress.h"

@implementation SoloGameGameOver

@synthesize gameOverMenu;

-(void) setupGameOverLayer {
    [self setupGameOverMenu];
}

-(void) setupGameOverMenu {
    
    gameOverMenu = [CCMenuAdvanced menuWithItems:nil];
    
    CCMenuItemSprite *gameOverItemSprite;
    for (int i = 0; i < 3; i++) {
        gameOverItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] target:self selector:@selector(gameOverSelected:)];
        gameOverItemSprite.tag = i;
        
        switch (i) {
            case 0: {
                CCLabelTTF *nextButtonLabel = [CCLabelTTF labelWithString:@"Next Round" fontName:@"Arial" fontSize:14];
                nextButtonLabel.position = ccp(gameOverItemSprite.contentSize.width/2, gameOverItemSprite.contentSize.height/2);
                nextButtonLabel.color = ccc3(0, 0, 0);
                [gameOverItemSprite addChild:nextButtonLabel];
                break;
            }
            case 1: {
                CCLabelTTF *replayButtonLabel = [CCLabelTTF labelWithString:@"Show Replay" fontName:@"Arial" fontSize:14];
                replayButtonLabel.position = ccp(gameOverItemSprite.contentSize.width/2, gameOverItemSprite.contentSize.height/2);
                replayButtonLabel.color = ccc3(0, 0, 0);
                [gameOverItemSprite addChild:replayButtonLabel];
                gameOverItemSprite.isEnabled = NO;
                gameOverItemSprite.visible = NO;
                break;
            }
            case 2: {
                CCLabelTTF *mainMenuButtonLabel = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Arial" fontSize:14];
                mainMenuButtonLabel.position = ccp(gameOverItemSprite.contentSize.width/2, gameOverItemSprite.contentSize.height/2);
                mainMenuButtonLabel.color = ccc3(0, 0, 0);
                [gameOverItemSprite addChild:mainMenuButtonLabel];
                break;
            }
            default:
                break;
        }
        
        [gameOverMenu addChild:gameOverItemSprite];
    }
    
    [gameOverMenu alignItemsHorizontallyWithPadding:0 leftToRight:YES];
    
    gameOverMenu.ignoreAnchorPointForPosition = NO;
    gameOverMenu.position = ccp(winSize.width/2, winSize.height/2);
    gameOverMenu.boundaryRect = CGRectMake(gameOverMenu.position.x - gameOverMenu.contentSize.width/2, gameOverMenu.position.y - gameOverMenu.contentSize.height/2, gameOverMenu.contentSize.width, gameOverMenu.contentSize.height);
    [gameOverMenu fixPosition];
    
    [gameOverMenu retain];
    
    [self addChild:gameOverMenu];
    
    gameOverMenu.visible = NO;
    gameOverMenu.enabled = NO;
    
}


-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup Layers
        soloGameUI = soloUI;
        [soloGameUI setSoloGameGameOverLayer:self];
        
        soloGameReplay = [soloUI getSoloGameReplay];
        
        self.isTouchEnabled = YES;
        [self setupGameOverLayer];
    }
    return self;
}

-(void) gameOverSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0:
            CCLOG(@"SoloGameUI: Reset game");
            [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
            break;
        case 1:
            CCLOG(@"SoloGameUI: Show answers to questions");
            //[self showReplay];
            [soloGameReplay showLayerAndObjects];
            [self moveGameOverMenu];
            break;
        case 2:
            CCLOG(@"SoloGameUI: go back to main menu");
            [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
            break;
            
        default:
            break;
    }
}

-(void) moveGameOverMenu {
    gameOverMenu.position = ccp(gameOverMenu.position.x, winSize.height - gameOverMenu.contentSize.height);
    gameOverMenu.boundaryRect = CGRectMake(gameOverMenu.position.x - gameOverMenu.contentSize.width/2, gameOverMenu.position.y - gameOverMenu.contentSize.height/2, gameOverMenu.contentSize.width, gameOverMenu.contentSize.height);
}

-(void) showLayerAndObjects {
    self.visible = YES;
    
    gameOverMenu.position = ccp(winSize.width/2, winSize.height + gameOverMenu.contentSize.height);
    gameOverMenu.visible = YES;
    gameOverMenu.enabled = NO;
    
    id action = [CCMoveTo actionWithDuration:0.75 position:ccp(winSize.width/2, winSize.height/2)];
    id ease = [CCEaseBackInOut actionWithAction:action];
    [gameOverMenu runAction:ease];
}

-(void) hideLayerAndObjects {
    gameOverMenu.visible = NO;
    gameOverMenu.enabled = NO;
    self.visible = NO;
}

-(void) checkGameOverMenu {
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    /*NSError *error = nil;
    NSArray *challengeObjectArray = [challengeQuery findObjects:&error];
    
    if (error) {
        CCLOG(@"SoloGameReplay: Unable to show replay");
        return;
    }*/
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        //NSString *currentPlayerName = [PFUser currentUser].username;
        //BOOL playerInPlayer1Column = [challenge.player1_id isEqualToString:currentPlayerName];
        
        NSString *PNRD = @"";
        if ([PlayerDB database].playerInPlayer1Column) {
            PNRD = challenge.player1_next_race;
        } else {
            PNRD = challenge.player2_next_race;
        }
        
        CCArray *gArray = [gameOverMenu children];
        
        CCMenuItemSprite *nextRoundSprite = [gArray objectAtIndex:0];
        
        if ([PNRD isEqualToString:@""]) {
            nextRoundSprite.isEnabled = YES;
            nextRoundSprite.visible = YES;
        } else {
            nextRoundSprite.isEnabled = NO;
            nextRoundSprite.visible = NO;
        }
        
        [self showLayerAndObjects];
    }];
}

-(void) dealloc {
    [gameOverMenu release];
    [super dealloc];
}

@end
