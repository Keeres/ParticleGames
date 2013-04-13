//
//  MainMenuBG.m
//  GeoQuest
//
//  Created by Kelvin on 10/6/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "MainMenuBG.h"


@implementation MainMenuBG

@synthesize BGTouched;

-(void) setupBG {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    BGMap = [CCSprite spriteWithSpriteFrameName:@"SoloGameBGSky.png"];
    BGMap.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:BGMap z:1];
}

/*-(id) init {
    //CCLOG(@"MainMenuBG: Do not use init. Use initWithMainMenuUiLayer:(MainMenuUI *)menuUI");
    //return [self initWithMainMenuUILayer:NULL];
    if ((self = [super init])) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuBGSprites.plist"];
        mainMenuBGSheet = [CCSpriteBatchNode batchNodeWithFile:@"MainMenuBGSprites.png"];
        [self addChild:mainMenuBGSheet z:0];
        
        [self setupBG];
        
        self.isTouchEnabled = YES;
        BGTouched = NO;
        
    }
    return self;
}*/

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuBGSprites.plist"];
        mainMenuBGSheet = [CCSpriteBatchNode batchNodeWithFile:@"MainMenuBGSprites.png"];
        [self addChild:mainMenuBGSheet z:0];
        
        //Setup Layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuBGLayer:self];
        
        [self setupBG];
        
        self.isTouchEnabled = YES;
        BGTouched = NO;
        
    }
    return self;
}

/*-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (BGTouched == NO) {
        BGTouched = YES;
        //[mainMenuUI fadeInOutMainMenuUI];
        [mainMenuUI slideSideMenuPane];
    }
}*/


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
