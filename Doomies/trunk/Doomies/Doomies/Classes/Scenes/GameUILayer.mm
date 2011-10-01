//
//  GameUILayer.mm
//  mushroom
//
//  Created by Kelvin on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUILayer.h"


@implementation GameUILayer
@synthesize jumpButton;
@synthesize changeButton;

-(void) initButtons {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect changeButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    
    CGPoint jumpButtonPosition;
    CGPoint changeButtonPosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iPhone 3.2 or later.
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        
        jumpButtonPosition = ccp(winSize.width*0.946f, winSize.height*0.052f);
        changeButtonPosition = ccp(winSize.width*0.054f, winSize.height*0.052f);
    } else {
        // The device is an iPhone or iPod touch.
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        
        //jumpButtonPosition = ccp(winSize.width*0.93f, winSize.height*0.11f);
        //changeButtonPosition = ccp(winSize.width*0.07f, winSize.height*0.11f);
        jumpButtonPosition = ccp(winSize.width*0.93f, winSize.height*0.89f);
        changeButtonPosition = ccp(winSize.width*0.07f, winSize.height*0.89f);
    }
    
    SneakyButtonSkinnedBase *jumpButtonBase =
    [[[SneakyButtonSkinnedBase alloc] init] autorelease];         
    jumpButtonBase.position = jumpButtonPosition;                 
    jumpButtonBase.defaultSprite = 
    [CCSprite spriteWithFile:@"jumpUp.png"];                      
    jumpButtonBase.activatedSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                    
    jumpButtonBase.pressSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                    
    jumpButtonBase.button = [[SneakyButton alloc] 
                             initWithRect:jumpButtonDimensions];
    jumpButtonBase.visible = NO;
    jumpButton = [jumpButtonBase.button retain];                  
    jumpButton.isToggleable = NO;
    [self addChild:jumpButtonBase];                               
    
    SneakyButtonSkinnedBase *changeButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];             
    changeButtonBase.position = changeButtonPosition;             
    changeButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];                                    
    changeButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];                                  
    changeButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];                                  
    changeButtonBase.button = [[SneakyButton alloc] initWithRect:changeButtonDimensions];  
    changeButtonBase.visible = NO;
    changeButton = [changeButtonBase.button retain];              
    changeButton.isToggleable = NO;                               
    [self addChild:changeButtonBase];
    
    
    //////////////////////////////////////////////
    
    totalDistance = 0;
    
    distanceLabel = [[CCLabelTTF alloc] initWithString:@"Distance:" fontName:@"Helvetica" fontSize:20.0];
    distanceLabel.position = ccp(winSize.width/2, winSize.height - distanceLabel.contentSize.height/2);
    [self addChild:distanceLabel z:2];
    
    eatSprite = [[CCSprite alloc] initWithFile:@"handUp.png"];
    eatSprite.position = ccp(3*winSize.width/4 + eatSprite.contentSize.width, eatSprite.contentSize.height/2);
    [self addChild:eatSprite z:2];
    changeSprite = [[CCSprite alloc] initWithFile:@"handUp.png"];
    changeSprite.position = ccp(winSize.width/2 + changeSprite.contentSize.width, changeSprite.contentSize.height/2);
    [self addChild:changeSprite z:2];
}

-(void) updateStats:(float)offset {
    totalDistance = (int) (offset/PTM_RATIO*2) - 9.0;
    [distanceLabel setString:[NSString stringWithFormat:@"distance:%i", totalDistance]];
}

-(id) init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        [self initButtons];
    }
    return self;
}

@end
