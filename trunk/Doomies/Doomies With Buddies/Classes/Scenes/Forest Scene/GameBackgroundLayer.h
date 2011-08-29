//
//  GameBackgroundLayer.h
//  mushroom
//
//  Created by Kelvin on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CommonProtocols.h"
#import "Constants.h"

@interface GameBackgroundLayer : CCLayer {
    CCSprite *background;
    CCParallaxNode *parallax;
   
    BackgroundState backgroundState;
    StageEffectType stageEffectType;
    
    CCParticleSystem *snowEmitter;
    float snowEmitterSpeed;
    BOOL gameStarted;
}

@property BackgroundState backgroundState;
@property StageEffectType stageEffectType;
@property StageEffectType initialStageType;
@property (retain) CCParticleSystem *snowEmitter;
@property float snowEmitterSpeed;
@property BOOL gameStarted;

-(void) updateOffset:(float)offset;
-(void) volcanoChangeState:(float)offset;
- (id) initWithInitialStageType: (int) initialStage;

@end
