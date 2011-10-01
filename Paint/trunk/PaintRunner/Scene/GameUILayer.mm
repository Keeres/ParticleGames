//
//  GameUILayer.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUILayer.h"

@implementation GameUILayer

-(id) init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}

@end
