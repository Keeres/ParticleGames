//
//  SoloGameTerritory.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "SoloGameTerritory.h"

@implementation SoloGameTerritory

-(void) setupTerritoryLayer {
    [self setupDifficultyDisplay];
    [self setupTerritoryMenu];
}

-(void) setupDifficultyDisplay {
    /*difficultyBackground = [CCSprite spriteWithSpriteFrameName:@"MainMenuUIWoodBG.png"];
    difficultyBackground.position = ccp(winSize.width/2, winSize.height/2);*/
    
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
}

-(void) setupTerritoryMenu {
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
    
}

-(void) difficultySelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0:
            difficultyChoice = kEasyDifficulty;
            break;
        case 1:
            difficultyChoice = kNormalDifficulty;
            break;
        case 2:
            difficultyChoice = kExtremeDifficuly;
            break;
            
        default:
            break;
    }
    
    territoriesChosen = [[GeoQuestDB database] displayTerritories];

    [self hideLayerAndObjects];
    [selectDifficulty stopAllActions];
    [soloGameUI setTerritoriesChosen:territoriesChosen];

    [soloGameUI setupGame];
}

-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup layers
        soloGameUI = soloUI;
        [soloGameUI setSoloGameTerritoryLayer:self];
        
        self.isTouchEnabled = YES;
        difficultyChoice = -1;

        [self setupTerritoryLayer];
    }
    return self;
}

-(void) showLayerAndObjects {
    self.visible = YES;
}

-(void) hideLayerAndObjects {
    difficultyChoiceMenu.visible = NO;
    difficultyChoiceMenu.enabled = NO;
    self.visible = NO;
}

-(void) dealloc {
    [super dealloc];
}

@end
