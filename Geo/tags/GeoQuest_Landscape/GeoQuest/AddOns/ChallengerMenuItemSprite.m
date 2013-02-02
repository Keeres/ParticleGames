//
//  ChallengerMenuItemSprite.m
//  GeoQuest
//
//  Created by Kelvin on 10/17/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "ChallengerMenuItemSprite.h"


@implementation ChallengerMenuItemSprite

//-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(NSNumber *)wins withLosses:(NSNumber *)losses {
-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(int)wins withLosses:(int)losses {
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"BlankButton.png"];
        background.anchorPoint = ccp(0.5, 1);
        [self addChild:background z:0];
        
        /*CCSprite *picture = [CCSprite spriteWithFile:@"Icon.png"];
        picture.scale = 0.8;
        picture.position = ccp(picture.contentSize.width/2, background.contentSize.height/2);
        [background addChild:picture z:1];*/
        
        /*CCLabelTTF *challengerName = [[CCLabelTTF alloc] initWithString:name fontName:@"Arial" fontSize:24];
        challengerName.color = ccc3(255, 0, 255);
        challengerName.position = ccp(background.contentSize.width/2, background.contentSize.height/2);
        [background addChild:challengerName z:2];*/
        
    }
    return self;
    
}

@end
