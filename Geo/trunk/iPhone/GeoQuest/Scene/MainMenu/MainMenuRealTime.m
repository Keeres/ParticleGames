//
//  MainMenuRealTime.m
//  GeoQuest
//
//  Created by Kelvin on 4/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MainMenuRealTime.h"

@implementation MainMenuRealTime


#pragma mark - Setup layer

-(void) setupRealTimeLayer {
    //Allocate and initialize buttons
    [self setupRealTimeMenu];
    
    //Setup AppWarp stuff?
    
}

-(void) setupRealTimeMenu {
    // Button 1 for real time menu
    CCMenuItemSprite *button1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] target:self selector:@selector(button1Pressed)];
    
    // Button 1's label
    CCLabelTTF *button1Label = [CCLabelTTF labelWithString:@"Button 1 - AppWarp" fontName:@"Arial" fontSize:14];
    button1Label.position = ccp(button1.contentSize.width/2, button1.contentSize.height/2);
    button1Label.color = ccc3(0, 0, 0);
    [button1 addChild:button1Label];
    
    // Button 2 for real time menu
    CCMenuItemSprite *button2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] target:self selector:@selector(button2Pressed)];
    
    // Button 2's label
    CCLabelTTF *button2Label = [CCLabelTTF labelWithString:@"Button 2 - Hide RealTime" fontName:@"Arial" fontSize:14];
    button2Label.position = ccp(button2.contentSize.width/2, button1.contentSize.height/2);
    button2Label.color = ccc3(0, 0, 0);
    [button2 addChild:button2Label];
    
    // Initializing realTimeMenu, adding button1 and 2, setting align horizontally
    realTimeMenu = [CCMenuAdvancedPlus menuWithItems:button1, button2, nil];
    realTimeMenu.extraTouchPriority = 1;
    [realTimeMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    realTimeMenu.ignoreAnchorPointForPosition = NO;
    
    // Setting the position of the menu
    realTimeMenu.position = ccp(winSize.width/2, winSize.height/2);
    realTimeMenu.boundaryRect = CGRectMake(realTimeMenu.position.x - realTimeMenu.contentSize.width/2, realTimeMenu.position.y - realTimeMenu.contentSize.height/2, realTimeMenu.contentSize.width, realTimeMenu.contentSize.height);
    [realTimeMenu fixPosition];
    
    // Start invisible and disabled, add to self layer
    realTimeMenu.visible = NO;
    realTimeMenu.isDisabled = YES;
    [self addChild:realTimeMenu];
}

#pragma mark - Init Layer

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;
        
        // Setup layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuRealTimeLayer:self];
        
        [self setupRealTimeLayer];
    }
    return self;
}

#pragma  mark - Methods for layer

-(void) button1Pressed {
    // Do some AppWarp stuff
    CCLOG(@"Button1 pressed");
}

-(void) button2Pressed {
    // Return to Main Menu
    [mainMenuUI showObjects];
    [self hideLayerAndObjects];
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    realTimeMenu.visible = NO;
    realTimeMenu.isDisabled = YES;
}

-(void) showLayerAndObjects {
    self.visible = YES;
    realTimeMenu.visible = YES;
    realTimeMenu.isDisabled = NO;
}

#pragma mark - dealloc

-(void) dealloc {
    [super dealloc];
}

@end
