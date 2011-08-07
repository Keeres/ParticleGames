//
//  GameBackgroundLayer.m
//  mushroom
//
//  Created by Kelvin on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VolcanoBackgroundLayer.h"

@implementation VolcanoBackgroundLayer

-(void) updateOffset:(float)offset {
    self.position = ccp(-offset,self.position.y);
}

-(id) init {
    if((self=[super init])) {
        CCParallaxNode * parallax = [CCParallaxNode node];
        [CCTexture2D setDefaultAlphaPixelFormat:
         kCCTexture2DPixelFormat_RGB565];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            background = [CCSprite spriteWithFile:@"background.png"];
        } else {
            background = [CCSprite spriteWithFile:@"background.png"];
        }
        background.anchorPoint = ccp(0,0);
        [CCTexture2D setDefaultAlphaPixelFormat:
         kCCTexture2DPixelFormat_Default];
        [parallax addChild:background z:-10 parallaxRatio:ccp(0.007f, 0.05f) 
            positionOffset:ccp(0,120)];        
        [self addChild:parallax z:-10];
    }
    return self;
}

@end
