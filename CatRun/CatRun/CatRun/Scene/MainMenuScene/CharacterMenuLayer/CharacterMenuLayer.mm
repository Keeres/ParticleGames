//
//  CharacterMenuLayer.mm
//  CatRun
//
//  Created by Steven Chen on 3/14/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import "CharacterMenuLayer.h"

@implementation CharacterMenuLayer

#pragma mark Menu Transition

-(void) switchToMainMenu {
    CCLOG(@"CharacterMenu: Returning to Main Menu");
    [mainMenuLayer switchFromMenu:kCharacterMenuType ToNextMenu:kMainMenuType];
}

-(void) switchToSkinsMenu {
    CCLOG(@"CharacterMenu: Switch to Skin Menu");
    [mainMenuLayer switchFromMenu:kCharacterMenuType ToNextMenu:kCustomizeMenuType];
}

-(void) switchToPerksMenu {
    CCLOG(@"CharacterMenu: switch to Perk Menu");
    [mainMenuLayer switchFromMenu:kCharacterMenuType ToNextMenu:kPerkMenuType];
    
}

#pragma mark Setup Resources
-(void) alignButtonsInMenu:(CCMenu *)menu WithStyle:(AlignStyle)alignStyle withItemsLimit:(int)itemLimit XPadding:(float)xPadding andYPadding:(float)yPadding{
    int row = 0;
    int col = 0;
    int itemCount = 0;
    
    for (CCMenuItem *item in menu.children) {
        CGPoint newPosition = CGPointMake(col*xPadding, -row*yPadding);
        item.position = newPosition;
        itemCount++;
   
        if(alignStyle == kAlignColFirst){
            row++;
            if (itemCount == itemLimit) {
                itemCount = 0;
                row = 0;
                col++;
            }
        }else {
            col++;
            if (itemCount == itemLimit) {
                itemCount = 0;
                col = 0;
                row++;
            }
        }
    }
}

-(void) setupButtons {
    ///////////////////////////////////
    //QUICK ACCESS BUTTONS?:BACK, HOME
    ///////////////////////////////////
    CCSprite *backButtonNormal;
    CCSprite *backButtonSelected;

    backButtonNormal = [sHelper spriteWithUniqueName:@"backButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    backButtonSelected = [sHelper spriteWithUniqueName:@"backButton" atPosition:ccp(2.0, 3.5) inLayer:nil];
    backButtonNormal.scale = 1.1;
    backButtonSelected.scale = 0.75;
    CCMenuItem *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonNormal selectedSprite:backButtonSelected target:self selector:@selector(switchToMainMenu)];
    
    CCLabelBMFont *lairLabel = [CCLabelBMFont labelWithString:@" -----LAIR-----" fntFile:@"testFont.fnt"];
      CCMenuItemLabel *lairButton = [CCMenuItemLabel itemWithLabel:lairLabel];
    
    CCLabelBMFont *homeLabel = [CCLabelBMFont labelWithString:@"HOME" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *homeButton = [CCMenuItemLabel itemWithLabel:homeLabel target:self selector:@selector(switchToMainMenu)];
    homeButton.scale = 0.5;
    
    titleBarMenu = [CCMenu menuWithItems:backButton, lairButton, homeButton, nil];
    [titleBarMenu alignItemsHorizontallyWithPadding:100];
    titleBarMenu.position = ccp(winSize.width*(1.0/2.0), winSize.height - 17.0);
    [self addChild:titleBarMenu];
    
    //////////////////////////////////////////////////////////////////
    //CHARACTER MENU BUTTONS: SKINS, PERKS, STATS, ACHIEVEMENT, COINS
    //////////////////////////////////////////////////////////////////
    CCSprite *skinsButtonNormal;
    CCSprite *skinsButtonSelected;
    CCSprite *perksButtonNormal;
    CCSprite *perksButtonSelected;
    CCSprite *itemsButtonNormal;
    CCSprite *itemsButtonSelected;
    CCSprite *abilitiesButtonNormal;
    CCSprite *abilitiesButtonSelected;
    CCSprite *statsButtonNormal;
    CCSprite *statsButtonSelected;
    CCSprite *achievementButtonNormal;
    CCSprite *achievementButtonSelected;
    CCSprite *coinsButtonNormal;
    CCSprite *coinsButtonSelected;

    skinsButtonNormal = [sHelper spriteWithUniqueName:@"CustomizeButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    skinsButtonSelected = [sHelper spriteWithUniqueName:@"CustomizeButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    skinsButtonSelected.scale = 0.90;
    perksButtonNormal = [sHelper spriteWithUniqueName:@"PerksButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    perksButtonSelected = [sHelper spriteWithUniqueName:@"PerksButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    perksButtonSelected.scale = 0.90;
    itemsButtonNormal = [sHelper spriteWithUniqueName:@"ItemsButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    itemsButtonSelected =[sHelper spriteWithUniqueName:@"ItemsButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    itemsButtonSelected.scale = 0.90;
    abilitiesButtonNormal = [sHelper spriteWithUniqueName:@"AbilitiesButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    abilitiesButtonSelected = [sHelper spriteWithUniqueName:@"AbilitiesButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    abilitiesButtonSelected.scale = 0.90;
    statsButtonNormal= [sHelper spriteWithUniqueName:@"StatsButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    statsButtonSelected = [sHelper spriteWithUniqueName:@"StatsButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    statsButtonSelected.scale = 0.90;
    coinsButtonNormal= [sHelper spriteWithUniqueName:@"CoinsButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    coinsButtonSelected = [sHelper spriteWithUniqueName:@"CoinsButton" atPosition:ccp(5.0, 2.5) inLayer:nil]; 
    coinsButtonSelected.scale = 0.90;
    achievementButtonNormal= [sHelper spriteWithUniqueName:@"AchievementsButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    achievementButtonSelected = [sHelper spriteWithUniqueName:@"AchievementsButton" atPosition:ccp(5.0, 2.5) inLayer:nil];
    achievementButtonSelected.scale = 0.90;

    CCMenuItem *skinsButton = [CCMenuItemSprite itemFromNormalSprite:skinsButtonNormal selectedSprite:skinsButtonSelected target:self selector:@selector(switchToSkinsMenu)];
    CCMenuItem *perksButton = [CCMenuItemSprite itemFromNormalSprite:perksButtonNormal selectedSprite:perksButtonSelected target:self selector:@selector(switchToPerksMenu)];
    CCMenuItem *itemsButton = [CCMenuItemSprite itemFromNormalSprite:itemsButtonNormal selectedSprite:itemsButtonSelected];
    CCMenuItem *abilitiesButton = [CCMenuItemSprite itemFromNormalSprite:abilitiesButtonNormal selectedSprite:abilitiesButtonSelected];
    CCMenuItem *statsButton = [CCMenuItemSprite itemFromNormalSprite:statsButtonNormal selectedSprite:statsButtonSelected];
    CCMenuItem *achievementButton = [CCMenuItemSprite itemFromNormalSprite:achievementButtonNormal selectedSprite:achievementButtonSelected];
    CCMenuItem *coinsButton = [CCMenuItemSprite itemFromNormalSprite:coinsButtonNormal selectedSprite:coinsButtonSelected];
    
    characterMenu = [CCMenu menuWithItems:skinsButton, itemsButton, perksButton, abilitiesButton, statsButton, coinsButton, achievementButton, nil];
    characterMenu.position = ccp(winSize.width*(1.0/3.0), winSize.height*(3.0/4.0)-17.0);
    [self alignButtonsInMenu:characterMenu WithStyle:kAlignRowFirst withItemsLimit:2 XPadding:150 andYPadding:50];
    achievementButton.position = ccp(75, -150.0);
    [self addChild:characterMenu];
}

-(void) setMainMenuLayer:(MainMenuLayer*) mainLayer{
    mainMenuLayer = mainLayer;
}
    
#pragma mark Initialize

-(id) initWithpriteHelper:(SpriteHelperLoader*)sHelperLoader{
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"CharacterMenu"];
        [lHelper addSpritesToLayer:self];
        sHelper = sHelperLoader;
        
        [self setupButtons];
    }
    return self;
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
    }
    return self;
}

#pragma mark Dealloc
- (void) dealloc
{
    [super dealloc];
}

@end
