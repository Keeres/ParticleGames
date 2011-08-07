//
//  GameBackgroundLayer.h
//  mushroom
//
//  Created by Kelvin on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameBackgroundLayer : CCLayer {
    CCSprite *background;
}

-(void) updateOffset:(float)offset;

@end
