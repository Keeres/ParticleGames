//
//  PlaformCache.h
//  PaintRunner
//
//  Created by Kelvin on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"
#import "Platform.h"

@interface PlatformCache : CCNode {
    //Box2D
    b2World *world;
    
    //Variables
    CGSize winSize;
    CCArray *platforms;
    CCSpriteBatchNode *batch;
}

-(id) initWithWorld:(b2World*)theWorld;


@end
