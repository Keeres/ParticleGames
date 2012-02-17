//
//  StoreScene.m
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreScene.h"

@implementation StoreScene
-(id)init {
    self = [super init];
    if (self != nil) {
        storeLayer = [StoreLayer node];
        [self addChild:storeLayer];
    }
    return self;
}
@end
