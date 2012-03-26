//
//  CustomizeMenuLayer.mm
//  CatRun
//
//  Created by Steven Chen on 3/14/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import "CustomizeMenuLayer.h"

@implementation CustomizeMenuLayer

#pragma mark Menu Transition

-(void) switchToMainMenu {
    CCLOG(@"CharacterMenu: Returning to Main Menu");
    [mainMenuLayer switchFromMenu:kCustomizeMenuType ToNextMenu:kMainMenuType];
}

-(void) switchToCharacterMenu {
    CCLOG(@"CharacterMenu: Switch to Character Menu");
    [mainMenuLayer switchFromMenu:kCustomizeMenuType ToNextMenu:kCharacterMenuType];
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
    backButtonNormal.scale = 1.1;
    backButtonSelected.scale = 0.75;
    CCMenuItem *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonNormal selectedSprite:backButtonSelected target:self selector:@selector(switchToCharacterMenu)];
    
    CCLabelBMFont *customizeLabel = [CCLabelBMFont labelWithString:@" ----Customize----" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *customizeButton = [CCMenuItemLabel itemWithLabel:customizeLabel];
    
    CCLabelBMFont *homeLabel = [CCLabelBMFont labelWithString:@"HOME" fntFile:@"testFont.fnt"];
    CCMenuItemLabel *homeButton = [CCMenuItemLabel itemWithLabel:homeLabel target:self selector:@selector(switchToMainMenu)];
    homeButton.scale = 0.5;
    
    titleBarMenu = [CCMenu menuWithItems:backButton, customizeButton, homeButton, nil];
    [titleBarMenu alignItemsHorizontallyWithPadding:70];
    titleBarMenu.position = ccp(winSize.width*(1.0/2.0), winSize.height - 17.0);
    [self addChild:titleBarMenu z:2];
}

-(void) setupSkinsButton{

    CCSprite *defaultSkinIconNormal;
    CCSprite *defaultSkinIconSelected;
    CCSprite *defaultSkinSelectionButtonNromal;
    CCSprite *defaultSkinSelectionButtonSelected;
    CCSprite *redSkinIconNormal;
    CCSprite *redSkinIconSelected;
    CCSprite *redSkinSelectionButtonNromal;
    CCSprite *redSkinSelectionButtonSelected;
    CCSprite *blueSkinIconNormal;
    CCSprite *blueSkinIconSelected;
    CCSprite *blueSkinSelectionButtonNromal;
    CCSprite *blueSkinSelectionButtonSelected;
    CCSprite *greenSkinIconNormal;
    CCSprite *greenSkinIconSelected;
    CCSprite *greenSkinSelectionButtonNromal;
    CCSprite *greenSkinSelectionButtonSelected;
    CCSprite *pinkSkinIconNormal;
    CCSprite *pinkSkinIconSelected;
    CCSprite *pinkSkinSelectionButtonNromal;
    CCSprite *pinkSkinSelectionButtonSelected;
    CCSprite *purpleSkinIconNormal;
    CCSprite *purpleSkinIconSelected;
    CCSprite *purpleSkinSelectionButtonNromal;
    CCSprite *purpleSkinSelectionButtonSelected;
    CCSprite *rainbowSkinIconNormal;
    CCSprite *rainbowSkinIconSelected;
    CCSprite *rainbowSkinSelectionButtonNromal;
    CCSprite *rainbowSkinSelectionButtonSelected;
    
    defaultSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatImageIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    defaultSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatImageIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    defaultSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    defaultSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    redSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatRedIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    redSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatRedIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    redSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    redSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    blueSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatBlueIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    blueSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatBlueIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    blueSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    blueSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    greenSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatGreenIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    greenSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatGreenIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    greenSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    greenSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    pinkSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatPinkIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    pinkSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatPinkIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    pinkSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    pinkSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    purpleSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatPurpleIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    purpleSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatPurpleIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    purpleSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    purpleSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    
    rainbowSkinIconNormal = [sHelper spriteWithUniqueName:@"MenuCatRainbowIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    rainbowSkinIconSelected = [sHelper spriteWithUniqueName:@"MenuCatRainbowIcon" atPosition:ccp(0.0, 0.0) inLayer:nil];
    rainbowSkinSelectionButtonNromal = [sHelper spriteWithUniqueName:@"UnselectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];
    rainbowSkinSelectionButtonSelected = [sHelper spriteWithUniqueName:@"SelectedButton" atPosition:ccp(0.0, 0.0) inLayer:nil];

    CCMenuItem *defaultSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:defaultSkinIconNormal selectedSprite:defaultSkinIconSelected target:self selector:@selector(defaultSkinSelected)];
    CCMenuItem *defaultSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:defaultSkinSelectionButtonNromal selectedSprite:defaultSkinSelectionButtonSelected target:self selector:@selector(defaultSkinSelected)];
    
    CCMenuItem *redSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:redSkinIconNormal selectedSprite:redSkinIconSelected target:self selector:@selector(redSkinSelected)];
    CCMenuItem *redSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:redSkinSelectionButtonNromal selectedSprite:redSkinSelectionButtonSelected target:self selector:@selector(redSkinSelected)];

    CCMenuItem *blueSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:blueSkinIconNormal selectedSprite:blueSkinIconSelected target:self selector:@selector(blueSkinSelected)];
    CCMenuItem *blueSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:blueSkinSelectionButtonNromal selectedSprite:blueSkinSelectionButtonSelected target:self selector:@selector(blueSkinSelected)];

    CCMenuItem *greenSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:greenSkinIconNormal selectedSprite:greenSkinIconSelected target:self selector:@selector(greenSkinSelected)];
    CCMenuItem *greenSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:greenSkinSelectionButtonNromal selectedSprite:greenSkinSelectionButtonSelected target:self selector:@selector(greenSkinSelected)];

    CCMenuItem *pinkSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:pinkSkinIconNormal selectedSprite:pinkSkinIconSelected target:self selector:@selector(pinkSkinSelected)];
    CCMenuItem *pinkSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:pinkSkinSelectionButtonNromal selectedSprite:pinkSkinSelectionButtonSelected target:self selector:@selector(pinkSkinSelected)];

    CCMenuItem *purpleSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:purpleSkinIconNormal selectedSprite:purpleSkinIconSelected target:self selector:@selector(purpleSkinSelected)];
    CCMenuItem *purpleSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:purpleSkinSelectionButtonNromal selectedSprite:purpleSkinSelectionButtonSelected target:self selector:@selector(purpleSkinSelected)];
    
    CCMenuItem *rainbowSkinIconButton = [CCMenuItemSprite itemFromNormalSprite:rainbowSkinIconNormal selectedSprite:rainbowSkinIconSelected target:self selector:@selector(rainbowSkinSelected)];
    CCMenuItem *rainbowSkinSelectionButton = [CCMenuItemSprite itemFromNormalSprite:rainbowSkinSelectionButtonNromal selectedSprite:rainbowSkinSelectionButtonSelected target:self selector:@selector(rainbowSkinSelected)];
    
    defaultSkinSelectionButton.scale = 2.0;
    redSkinSelectionButton.scale = 2.0;
    blueSkinSelectionButton.scale = 2.0;
    greenSkinSelectionButton.scale = 2.0;
    pinkSkinSelectionButton.scale = 2.0;
    purpleSkinSelectionButton.scale = 2.0;
    rainbowSkinSelectionButton.scale = 2.0;

 //   skinsMenu = [SkinsMenu menuWithItems:defaultSkinIconButton, defaultSkinSelectionButton, redSkinIconButton, redSkinSelectionButton, blueSkinIconButton, blueSkinSelectionButton, greenSkinIconButton, greenSkinSelectionButton, pinkSkinIconButton, pinkSkinSelectionButton, purpleSkinIconButton, purpleSkinSelectionButton, rainbowSkinIconButton, rainbowSkinSelectionButton, nil];
    
    skinsPurchaseMenu = [CCMenu menuWithItems:defaultSkinIconButton, defaultSkinSelectionButton, redSkinIconButton, redSkinSelectionButton, blueSkinIconButton, blueSkinSelectionButton, greenSkinIconButton, greenSkinSelectionButton, pinkSkinIconButton, pinkSkinSelectionButton, purpleSkinIconButton, purpleSkinSelectionButton, rainbowSkinIconButton, rainbowSkinSelectionButton, nil];
    skinsPurchaseMenu.position = ccp(winSize.width*(2.0/3.0), winSize.height/2.0-720);
    //////////////////////////////
    //Create Tags for the buttons
    //////////////////////////////
    int count = 0;
  /*  for (CCMenuItem *item in skinsMenu.children) {
        if (count >= 0 && count < 2) {
            item.tag = kDefaultSkin;
            count++;
        } else if (count >= 2 && count < 4) {
            item.tag = kRedSkin;
            count++;
        } else if (count >= 4 && count < 6) {
            item.tag = kBlueSkin;
            count++;
        } else if (count >= 6 && count < 8) {
            item.tag = kGreenSkin;
            count++;
        } else if (count >= 8 && count < 10) {
            item.tag = kPinkSkin;
            count++;
        } else if (count >= 10 && count < 12) {
            item.tag = kPurpleSkin;
            count++;
        } else if(count >= 12 && count < 14) {
            item.tag = kRainbowSkin;
            count++;
        }
    }*/
    //[skinsMenu alignItemsVerticallyWithPadding:3];
    
    
    [skinsPurchaseMenu alignItemsVerticallyWithPadding:100];
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Reposition Buttons Manually for Alignment (Could write own alignment code in skinsMenu subclass later)
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
  /*  count = 0;
    for (CCMenuItem *item in skinsMenu.children) {
        if (count%2 != 0) {
            item.position = ccp(item.position.x + 100.0, item.position.y + 23.0);
        }
        count++;
    }
    skinsMenu.position = ccp(winSize.width*(2.0/3.0), winSize.height/2.0);
    skinsMenu.contentHeight = 800;
    //PLACEHOLDER, get initial selected button from game center
    [skinsMenu setSelectedItem:redSkinSelectionButton];
    
    [self addChild:skinsMenu];
    [skinsMenu schedule:@selector(moveTick:) interval:0.02f];*/
}

-(void) setMainMenuLayer:(MainMenuLayer*) mainLayer{
    mainMenuLayer = mainLayer;
}


#pragma mark Item Selection
-(void) defaultSkinSelected{
    CCLOG(@"Default Skin Selected");
}

-(void) redSkinSelected{
    CCLOG(@"Red Skin Selected");
}
-(void) blueSkinSelected{
    CCLOG(@"Blue Skin Selected");
}

-(void) greenSkinSelected{
    CCLOG(@"Green Skin Selected");
}

-(void) pinkSkinSelected{
    CCLOG(@"Pink Skin Selected");
}

-(void) purpleSkinSelected{
    CCLOG(@"Purple Skin Selected");
}

-(void) rainbowSkinSelected{
    CCLOG(@"Rainbow Skin Selected");
}


#pragma mark Initialize

-(id) initWithSpriteHelper:(SpriteHelperLoader *)sHelperLoader{
    if((self = [super init])){
        winSize = [CCDirector sharedDirector].winSize;
        
        lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"SkinsMenu"];
        [lHelper addSpritesToLayer:self];
        sHelper = sHelperLoader;
        
        [self setupButtons];
        [self setupSkinsButton];
        
   //     skinsPurchaseMenuLayer = [[CCScrollLayer alloc] initCCScrollLayerWithMenu:skinsPurchaseMenu withContentHeight:200 startingYPosition:100.0];
        
   //     skinsPurchaseMenuLayer = [MyScrollLayer makeScrollLayerWithMenuLayerWithMenu:skinsPurchaseMenu withContentHeight:1400 startingYPosition:0.0];
        
        CGRect viewArea = CGRectMake(480.0, 0.0, 480.0, 640.0);           //View are in pixels since it's opengl function
        CGRect touchArea = CGRectMake(240.0, 0.0, 240.0, 300.0);          //Touch area in points 
        skinsPurchaseMenuLayer = [MyScrollLayer makeScrollLayerWithMenuLayerWithMenu:skinsPurchaseMenu withContentHeight:1400 startingYPosition:0.0 viewWindow:viewArea touchWindow:touchArea];

        [self addChild:skinsPurchaseMenuLayer z:1];
        self.isTouchEnabled = NO;

    return self;
    }
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        lHelper = [[LevelHelperLoader alloc] initWithContentOfFile:@"SkinsMenu"];
        [lHelper addSpritesToLayer:self];

        self.isTouchEnabled = NO;
        }
    return self;
}

#pragma mark Dealloc
- (void) dealloc
{
    [super dealloc];
}

@end
