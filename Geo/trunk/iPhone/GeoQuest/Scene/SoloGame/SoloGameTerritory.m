//
//  SoloGameTerritory.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "SoloGameTerritory.h"
#import "ServerTerritories.h"

@implementation SoloGameTerritory

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
    
    //[difficultyChoiceMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING/2 leftToRight:YES];
    [difficultyChoiceMenu alignItemsVerticallyWithPadding:SOLO_GRID_SPACING/2 bottomToTop:NO];
    
    difficultyChoiceMenu.ignoreAnchorPointForPosition = NO;
    difficultyChoiceMenu.position = ccp(winSize.width/2, winSize.height*.42);
    difficultyChoiceMenu.boundaryRect = CGRectMake(difficultyChoiceMenu.position.x - difficultyChoiceMenu.contentSize.width/2, difficultyChoiceMenu.position.y - difficultyChoiceMenu.contentSize.height/2, difficultyChoiceMenu.contentSize.width, difficultyChoiceMenu.contentSize.height);
    [difficultyChoiceMenu fixPosition];
    
    [self addChild:difficultyChoiceMenu z:100];
    [difficultyChoiceMenu retain];
    
}*/

-(void) setupTerritoryMenu {    
    //NSMutableArray *territoryArray = [[PlayerDB database] availableTerritories];
    
    PFQuery *sTerritory = [ServerTerritories query];
    [sTerritory whereKey:@"weekly_usable" equalTo:[NSNumber numberWithBool:YES]];
    sTerritory.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [sTerritory findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            territoryChoiceMenu = [CCMenuAdvanced menuWithItems:nil];
            
            NSMutableArray *territoryArray = [NSMutableArray arrayWithObjects:nil];
            for (int i = 0; i < [objects count]; i++) {
                ServerTerritories *territories = [objects objectAtIndex:i];
                GeoQuestTerritory *geoQuestTerritory = [[[GeoQuestTerritory alloc] initWithTerritoryID:territories.objectId name:territories.name questionTable:territories.question answerTable:territories.answer] autorelease];
                [territoryArray addObject:geoQuestTerritory];
            }
            
            TerritoryMenuItemSprite *territoryItemSprite;
            for (int i = 0; i < 3; i++) {
                territoryItemSprite = [TerritoryMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(territorySelected:)];
                territoryItemSprite.tag = i;
                [territoryItemSprite setTerritories:territoryArray];
                
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
        }
    }];
}

-(void) territorySelected:(TerritoryMenuItemSprite*)sender {
    int i = sender.tag;
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
    [soloGameUI setTerritoriesChosen:territoriesChosen];
    [soloGameUI setupGame];
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
    [soloGameUI setTerritoriesChosen:territoriesChosen];

    [soloGameUI setupGame];
}*/

-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup layers
        soloGameUI = soloUI;
        [soloGameUI setSoloGameTerritoryLayer:self];
        
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
    territoryChoiceMenu.enabled = YES;
}

-(void) hideLayerAndObjects {
    //difficultyChoiceMenu.visible = NO;
    //difficultyChoiceMenu.enabled = NO;
    territoryChoiceMenu.visible = NO;
    territoryChoiceMenu.enabled = NO;
    self.visible = NO;
}

-(void) dealloc {
    //[difficultyChoiceMenu release];
    //[territoryChoiceMenu release];
    [super dealloc];
}

@end
