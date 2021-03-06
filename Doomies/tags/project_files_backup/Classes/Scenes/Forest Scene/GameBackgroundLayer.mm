//
//  GameBackgroundLayer.m
//  mushroom
//
//  Created by Kelvin on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBackgroundLayer.h"

@implementation GameBackgroundLayer
@synthesize backgroundState;
@synthesize stageEffectType;

-(void) updateOffset:(float)offset {
    self.position = ccp(-offset,self.position.y);
}

//Change volcano state based on distance traveled
-(void) volcanoChangeState:(float)offset{

    //change logic statement later to:
    //if(offset/PTM_RATIO == 25 + numberOfPreviousStages*statgeDistance
    CCSprite *volcanoSmoke;
    if(floor(offset/PTM_RATIO) == 25 && backgroundState == kVolcanoDormant){
        backgroundState = kVolcanoSmoke;
        CCLOG(@"volcano state = smoke");
        volcanoSmoke = [CCSprite spriteWithFile:@"volcanoSmoke.png"];
        
        //need to modify to play animation and location of the animation
        [parallax addChild:volcanoSmoke z:-9 parallaxRatio:ccp(0.03f, 0.05f)positionOffset:ccp(230,285)]; 
    } else if(floor(offset/PTM_RATIO) == 40 && backgroundState == kVolcanoSmoke){
        backgroundState = kVolcanoLava;
        CCLOG(@"volcano state = lava");
        CCSprite *volcanoLava = [CCSprite spriteWithFile:@"volcanoLava.png"];
        
        //need to modify to play animation and location of the animation
        [parallax addChild:volcanoLava z:-9 parallaxRatio:ccp(0.03f, 0.05f)positionOffset:ccp(200,190)]; 
    } else if(floor(offset/PTM_RATIO) == 50 && backgroundState == kVolcanoLava){
        backgroundState = kVolcanoErupt;
        CCLOG(@"volcano state = erupt");
        CCSprite *volcanoLava = [CCSprite spriteWithFile:@"volcanoErupt.png"];
        //CCNode *tempNode = [parallax 
        //need to modify to play animation and location of the animation
        //looking into how to remove smoke sp
        [parallax removeChild:volcanoSmoke cleanup:YES];
        [parallax addChild:volcanoLava z:-9 parallaxRatio:ccp(0.03f, 0.05f)positionOffset:ccp(220,260)]; 
    }
}

-(id) init {
    if((self=[super init])) {
        parallax = [CCParallaxNode node];
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
        
        //if(initial stage == volcano)
        backgroundState = kVolcanoDormant;
        stageEffectType = kVolcanoType;
        
        CCSprite *volcano = [CCSprite spriteWithFile:@"Volcano.png"];
        [parallax addChild:volcano z:-9 parallaxRatio:ccp(0.03f, 0.05f)positionOffset:ccp(200,170)]; 
        
        [self addChild:parallax z:-10];
    }
    return self;
}

@end
