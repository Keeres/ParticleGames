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
    
    //volcano variables
    VolcanoState volcanoState;
}

-(void) updateOffset:(float)offset;
-(void) volcanoChangeState:(float)offset;

@end
