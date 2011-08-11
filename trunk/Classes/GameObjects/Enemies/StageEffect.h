//
//  StageEffect.h
//  mushroom
//
//  Created by Steven Chen on 8/11/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2DSprite.h"
#import "CommonProtocols.h"

@interface StageEffect : Box2DSprite {
    StageEffectType type;
}

@property StageEffectType type;

@end
