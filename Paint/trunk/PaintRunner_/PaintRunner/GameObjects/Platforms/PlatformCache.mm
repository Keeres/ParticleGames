//
//  PlaformCache.mm
//  PaintRunner
//
//  Created by Kelvin on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlatformCache.h"

@implementation PlatformCache

-(void) initPlatforms {
    platforms = [[CCArray alloc] initWithCapacity:platform_Max];
    
    for (int i = 0; i < platform_Max; i++) {
        int capacity;
        switch (i) {
            case platformA:
                capacity = 20;
                break;
            case platformB:
                capacity = 100;
                break;
            case platformC:
                capacity = 20;
                break;
                
            default:
                [NSException exceptionWithName:@"PlatformCache Exception" reason:@"unhandled platform type" userInfo:nil];
                break;
        }
        CCArray *platformOfType = [CCArray arrayWithCapacity:capacity];
        [platforms addObject:platformOfType];
    }
    
    for (int i = 0; i < platform_Max; i++) {
        CCArray *platformOfType = [platforms objectAtIndex:i];
        int numberPlatformOfType = [platformOfType capacity];
        for (int j = 0; j < numberPlatformOfType; j++) {
            Platform *platform = [Platform platformWithType:(PlatformTypes)i];        
            [batch addChild:platform z:0 tag:i];
            [platformOfType addObject:platform];
        }
    }
}

-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
        
        CCSpriteFrame *textureFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"platformA.png"];
        batch = [CCSpriteBatchNode batchNodeWithTexture:textureFrame.texture];
        
        [self addChild:batch];
        [self initPlatforms];
        
    }
    return self;
}

@end
