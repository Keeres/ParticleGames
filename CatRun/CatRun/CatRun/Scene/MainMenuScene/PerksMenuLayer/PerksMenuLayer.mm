//
//  PerksMenuLayer.mm
//  CatRun
//
//  Created by Steven Chen on 3/14/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import "PerksMenuLayer.h"

@implementation PerksMenuLayer

#pragma mark Menu Transition

-(void) switchToCharacterMenu {
    CCLOG(@"CharacterMenu: Switch to Character Menu ");
    [mainMenuLayer switchFromMenu:kPerkMenuType ToNextMenu:kCharacterMenuType];
}

#pragma mark Setup Resources

-(void) setupButtons {
    ///////////////////////////////////
    //QUICK ACCESS BUTTONS?:BACK, HOME
    ///////////////////////////////////
    CCSprite *backButtonNormal;
    CCSprite *backButtonSelected;
    
    backButtonNormal = [sHelper spriteWithUniqueName:@"backButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    backButtonSelected = [sHelper spriteWithUniqueName:@"backButton" atPosition:ccp(2.0, 2.0) inLayer:nil];
    backButtonSelected.scale = 0.75;
    CCMenuItem *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonNormal selectedSprite:backButtonSelected target:self selector:@selector(switchToCharacterMenu)];
    
    backButtonMenu = [CCMenu menuWithItems:backButton, nil];
    backButtonMenu.position = ccp(20.0, winSize.height - 40.0);
    [self addChild:backButtonMenu];
}
    
-(void) setMainMenuLayer:(MainMenuLayer*) mainLayer{
    mainMenuLayer = mainLayer;
}

#pragma mark Initialize

-(id) initWithpriteHelper:(SpriteHelperLoader*)sHelperLoader{
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"PerksMenu"];
        [lHelper addSpritesToLayer:self];
        sHelper = sHelperLoader;
        
        [self setupButtons];
    }
    return self;
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
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
