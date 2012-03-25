//
//  MainMenuScene.m
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

-(id)init {
    self = [super init];
    if (self != nil) {
        sHelper = [[SpriteHelperLoader alloc] initWithContentOfFile:@"menuButtons"];
        characterMenuLayer = [[CharacterMenuLayer alloc] initWithpriteHelper:sHelper];
        perksMenuLayer = [[PerksMenuLayer alloc] initWithpriteHelper:sHelper];
       customizeMenuLayer = [[CustomizeMenuLayer alloc] initWithSpriteHelper:sHelper];
        
        [self addChild:characterMenuLayer];
        [self addChild:customizeMenuLayer];
        [self addChild:perksMenuLayer];
        
        characterMenuLayer.position = ccp(500.0, 0.0);
        customizeMenuLayer.position = ccp(500.0, 0.0);
        perksMenuLayer.position = ccp(500.0, 0.0);
        
        mainMenuLayer = [[MainMenuLayer alloc] initWithCharacterLayer:characterMenuLayer andSkinLayer:customizeMenuLayer andPerkLayer:perksMenuLayer andSpriteHelper:sHelper];
        [self addChild:mainMenuLayer];
    }
    return self;
}

#pragma mark Dealloc
- (void) dealloc
{
    [super dealloc];
}

@end

