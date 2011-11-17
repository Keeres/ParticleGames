//
//  Tree.m
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tree.h"

@implementation Tree

@synthesize speedPercentage;

-(id) initWithTreeType:(TreeTypes)treeWithType {
    treeType = treeWithType;
    
    NSString *treeName;
    
    switch (treeType) {
        case tree:
            treeName = @"tree.png";
            break;
            
        default:
            [NSException exceptionWithName:@"Tree Exception" reason:@"unhandled tree type" userInfo:nil];
            break;
    }
    
    if ((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:treeName]];
        
        self.visible = NO;
        self.tag = kTreeType;
        speedPercentage = 1.0;
    }
    return self;
}

-(void) despawn {
    self.visible = NO;
    self.scale = 1;
    speedPercentage = 1.0;
}

-(void) dealloc {
    [super dealloc];
}


@end
