//
//  AsyncGameTerritory.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "AsyncGameTerritory.h"
#import "ServerTerritories.h"

@implementation AsyncGameTerritory

-(void) setupTerritoryLayer {
    //[self setupDifficultyDisplay];
    [self setupTerritoryMenu];
}

/*-(void) setupDifficultyDisplay {
    difficultyBackground = [CCSprite spriteWithSpriteFrameName:@"MainMenuUIWoodBG.png"];
    difficultyBackground.position = ccp(winSize.width/2, winSize.height/2);
    
    difficultyDisplay = [CCSprite spriteWithSpriteFrameName:@"DifficultyDisplay.png"];
    difficultyDisplay.position = ccp(winSize.width/2, winSize.height*.75);
    [self addChild:difficultyDisplay];
    
    selectDifficulty = [CCSprite spriteWithSpriteFrameName:@"SelectDifficulty01.png"];
    selectDifficulty.position = ccp(difficultyDisplay.contentSize.width/2, difficultyDisplay.contentSize.height/2);
    [difficultyDisplay addChild:selectDifficulty];
    
    NSMutableArray *selectDifficultyAnimFrames = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"SelectDifficulty%02d.png",i]];
        [selectDifficultyAnimFrames addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:selectDifficultyAnimFrames delay:0.30];
    [selectDifficulty runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    //[self addChild:difficultyBackground];
}*/

/*-(void) setupTerritoryMenu {
    difficultyChoiceMenu = [CCMenuAdvanced menuWithItems:nil];
    
    CCMenuItemSprite *easyButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"EasyButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"EasyButton.png"] target:self selector:@selector(difficultySelected:)];
    easyButtonSprite.tag = kEasyDifficulty;
    [difficultyChoiceMenu addChild:easyButtonSprite];
    
    CCMenuItemSprite *normButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"NormButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"NormButton.png"] target:self selector:@selector(difficultySelected:)];
    normButtonSprite.tag = kNormalDifficulty;
    [difficultyChoiceMenu addChild:normButtonSprite];
    
    CCMenuItemSprite *hardButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"HardButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"HardButton.png"] target:self selector:@selector(difficultySelected:)];
    hardButtonSprite.tag = kExtremeDifficuly;
    [difficultyChoiceMenu addChild:hardButtonSprite];
    
    //[difficultyChoiceMenu alignItemsHorizontallyWithPadding:ASYNC_GRID_SPACING/2 leftToRight:YES];
    [difficultyChoiceMenu alignItemsVerticallyWithPadding:ASYNC_GRID_SPACING/2 bottomToTop:NO];
    
    difficultyChoiceMenu.ignoreAnchorPointForPosition = NO;
    difficultyChoiceMenu.position = ccp(winSize.width/2, winSize.height*.42);
    difficultyChoiceMenu.boundaryRect = CGRectMake(difficultyChoiceMenu.position.x - difficultyChoiceMenu.contentSize.width/2, difficultyChoiceMenu.position.y - difficultyChoiceMenu.contentSize.height/2, difficultyChoiceMenu.contentSize.width, difficultyChoiceMenu.contentSize.height);
    [difficultyChoiceMenu fixPosition];
    
    [self addChild:difficultyChoiceMenu z:100];
    [difficultyChoiceMenu retain];
    
}*/

-(void) setupTerritoryMenu {    
    //NSMutableArray *territoryArray = [[PlayerDB database] availableTerritories];
    
    NSError *error = nil;
    NSString *jsonString = [PlayerDB database].player1Stats.territories;
    NSArray *playerTerritoryArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if ([[PFUser currentUser].username isEqualToString:[PlayerDB database].player2Stats.player_id]) {
        jsonString = [PlayerDB database].player2Stats.territories;
        playerTerritoryArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    }

    
    PFQuery *sTerritory = [ServerTerritories query];
    [sTerritory whereKey:@"usable" equalTo:[NSNumber numberWithBool:YES]];
    sTerritory.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [sTerritory findObjectsInBackgroundWithBlock:^(NSArray *serverTerritoryArray, NSError *error) {
        if (!error) {
            
            territoryChoiceMenu = [CCMenuAdvancedPlus menuWithItems:nil];
            
            NSMutableArray *serverAndPlayerTerritoryArray = [NSMutableArray arrayWithObjects:nil];
            for (int i = 0; i < [serverTerritoryArray count]; i++) {
                ServerTerritories *sTerritory = [serverTerritoryArray objectAtIndex:i];
                Territory *territory = [[Territory alloc] initWithServerTerritory:sTerritory];

                [serverAndPlayerTerritoryArray addObject:territory];
                [territory release];
            }
            
            for (int i = 0; i < [playerTerritoryArray count]; i++) {
                Territory *territory = [[Territory alloc] initWithDictionary:[playerTerritoryArray objectAtIndex:i]];
                if (territory.usable == YES) {
                    [serverAndPlayerTerritoryArray addObject:territory];
                }
                [territory release];
            }
            
            //Remove duplicate territories
            NSArray *territoryArray = [[NSSet setWithArray:serverAndPlayerTerritoryArray] allObjects];
            
            
            TerritoryMenuItemSprite *territoryItemSprite;
            for (int i = 0; i < 3; i++) {
                territoryItemSprite = [TerritoryMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] target:self selector:@selector(territorySelected:)];
                territoryItemSprite.tag = i;
                NSArray *tempArray = [NSArray arrayWithObject:[territoryArray objectAtIndex:i]];
                //[territoryItemSprite setTerritories:territoryArray];
                [territoryItemSprite setTerritories:tempArray];
                
                switch (i) {
                    case 0: {
                        CCLabelTTF *t1Label = [CCLabelTTF labelWithString:@"Territory" fontName:@"Arial" fontSize:14];
                        t1Label.position = ccp(territoryItemSprite.contentSize.width/2, territoryItemSprite.contentSize.height/2);
                        t1Label.color = ccc3(0, 0, 0);
                        [territoryItemSprite addChild:t1Label];
                        break;
                    }
                    case 1: {
                        CCLabelTTF *t2Label = [CCLabelTTF labelWithString:@"Territory" fontName:@"Arial" fontSize:14];
                        t2Label.position = ccp(territoryItemSprite.contentSize.width/2, territoryItemSprite.contentSize.height/2);
                        t2Label.color = ccc3(0, 0, 0);
                        [territoryItemSprite addChild:t2Label];
                        break;
                    }
                    case 2: {
                        CCLabelTTF *t3Label = [CCLabelTTF labelWithString:@"Territory" fontName:@"Arial" fontSize:14];
                        t3Label.position = ccp(territoryItemSprite.contentSize.width/2, territoryItemSprite.contentSize.height/2);
                        t3Label.color = ccc3(0, 0, 0);
                        [territoryItemSprite addChild:t3Label];
                        break;
                    }
                        
                    default:
                        break;
                }
                
                [territoryChoiceMenu addChild:territoryItemSprite];
            }
            
            //[territoryChoiceMenu alignItemsHorizontallyWithPadding:0.0 leftToRight:YES];
            [territoryChoiceMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
            
            territoryChoiceMenu.ignoreAnchorPointForPosition = NO;
            territoryChoiceMenu.position = ccp(winSize.width/2, winSize.height/2);
            territoryChoiceMenu.boundaryRect = CGRectMake(territoryChoiceMenu.position.x - territoryChoiceMenu.contentSize.width/2, territoryChoiceMenu.position.y - territoryChoiceMenu.contentSize.height/2, territoryChoiceMenu.contentSize.width, territoryChoiceMenu.contentSize.height);
            [territoryChoiceMenu fixPosition];
            
            [self addChild:territoryChoiceMenu];
            territoryChoiceMenu.visible = NO;
            territoryChoiceMenu.enabled = NO;
            territoryChoiceMenu.disableScroll = YES;
        }
    }];
}

-(void) territorySelected:(TerritoryMenuItemSprite*)sender {
    int i = sender.tag;
    territoryChoiceMenu.isDisabled = YES;
    switch (i) {
        case 0: {
            TerritoryMenuItemSprite *t = [[territoryChoiceMenu children] objectAtIndex:i];
            territoriesChosen = [t getTerritories];
            break;
        }
        case 1: {
            TerritoryMenuItemSprite *t = [[territoryChoiceMenu children] objectAtIndex:i];
            territoriesChosen = [t getTerritories];
            break;
        }
        case 2: {
            TerritoryMenuItemSprite *t = [[territoryChoiceMenu children] objectAtIndex:i];
            territoriesChosen = [t getTerritories];
            break;
        }
            
        default:
            break;
    }
    
    [self hideLayerAndObjects];
    [asyncGameUI setTerritoriesChosen:territoriesChosen];
    [asyncGameUI setupGame];
}

/*-(void) difficultySelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0:
            difficultyChoice = kEasyDifficulty;
            break;
        case 1:
            difficultyChoice = kNormalDifficulty;
            break;
        case 2:
            difficulty Choice = kExtremeDifficuly;
            break;
            
        default:
            break;
    }
    
    //territoriesChosen = [[GeoQuestDB database] displayTerritories];
    territoriesChosen = [[PlayerDB database] availableTerritories];

    [self hideLayerAndObjects];
    //[selectDifficulty stopAllActions];
    [asyncGameUI setTerritoriesChosen:territoriesChosen];

    [asyncGameUI setupGame];
}*/

-(id) initWithAsyncGameUILayer:(AsyncGameUI *)asyncUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup layers
        asyncGameUI = asyncUI;
        [asyncGameUI setAsyncGameTerritoryLayer:self];
        
        self.isTouchEnabled = YES;
        difficultyChoice = -1;

        [self setupTerritoryLayer];
        [self hideLayerAndObjects];
    }
    return self;
}

-(void) showLayerAndObjects {
    self.visible = YES;
    //difficultyChoiceMenu.visible = YES;
    //difficultyChoiceMenu.enabled = YES;
    territoryChoiceMenu.visible = YES;
    territoryChoiceMenu.isDisabled = NO;
}

-(void) hideLayerAndObjects {
    //difficultyChoiceMenu.visible = NO;
    //difficultyChoiceMenu.enabled = NO;
    territoryChoiceMenu.visible = NO;
    territoryChoiceMenu.isDisabled = YES;
    self.visible = NO;
}

-(void) dealloc {
    //[difficultyChoiceMenu release];
    //[territoryChoiceMenu release];
    [super dealloc];
}

@end
