//
//  TreeCache.m
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TreeCache.h"

@implementation TreeCache

@synthesize totalTrees;
@synthesize visibleTrees;

-(void) initTrees {
    totalTrees = [[CCArray alloc] initWithCapacity:tree_Max];
    
    for (int i = 0; i < tree_Max; i++) {
        int capacity;
        switch (i) {
                /*case platformA:
                 capacity = 10;
                 break;
                 case platformB:
                 capacity = 10;
                 break;
                 case platformC:
                 capacity = 10;
                 break;*/
                
            case tree:
                capacity = 4;
                
            default:
                [NSException exceptionWithName:@"TreeCache Exception" reason:@"unhandled tree type" userInfo:nil];
                break;
        }
        CCArray *treeOfType = [CCArray arrayWithCapacity:capacity];
        [totalTrees addObject:treeOfType];
    }
    
    for (int i = 0; i < tree_Max; i++) {
        CCArray *treeOfType = [totalTrees objectAtIndex:i];
        
        int numberTreeOfType = [treeOfType capacity];
        
        for (int j = 0; j < numberTreeOfType; j++) {
            
            Tree *tree = [[[Tree alloc] initWithTreeType:(TreeTypes)i] autorelease];
            [treeOfType addObject:tree];
        }
    }
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        visibleTrees = [[NSMutableArray alloc] init];
        [self initTrees];
    }
    return self;
}

-(void) updateTreesWithTime:(ccTime)dt andSpeed:(float)speed {
    for (int i = 0; i < [visibleTrees count]; i++) {
        Tree *tempTree = [visibleTrees objectAtIndex:i];
        tempTree.position = ccp(tempTree.position.x - speed*dt*tempTree.speedPercentage, tempTree.position.y);
    }
    [self cleanTree];
}

-(void) addTree {
    int randomNumOfTrees = arc4random() % 2 + 1;
    int randomTree = 0; //Picks cloud type
    
    CCArray *treeOfType = [totalTrees objectAtIndex:randomTree];
    
    int speedSetter = arc4random()%2;
    float speedPercentage;
    
    switch (speedSetter) {
        case 0:
            speedPercentage = 2.0;
            break;
        case 1:
            speedPercentage = 2.5;
            break;
        default:
            break;
    }
    
    for (int i = 0; i < randomNumOfTrees; i++) {
        for (int j = 0; j < [treeOfType count]; j++) {
            Tree *tempTree = [treeOfType objectAtIndex:j];
            
            if (tempTree.visible == NO) {
                float differentX = 0;
                float differentY = 0;
                if (arc4random()%2) {
                    differentX = 40;
                    differentY = 20;
                    tempTree.scale = 1.5;
                }
                CGPoint location = ccp(winSize.width + tempTree.contentSize.width + differentX, winSize.height/8 + differentY);
                tempTree.position = location;
                tempTree.visible = YES;
                tempTree.speedPercentage = speedPercentage;
                [visibleTrees addObject:tempTree];
                break;
            }
        }
    }
}

-(void) cleanTree {
    for (int i = 0; i < [visibleTrees count]; i++) {
        Tree *tempTree = [visibleTrees objectAtIndex:i];
        
        if (tempTree.visible == NO || tempTree.position.x < -winSize.width/4) {
            [tempTree despawn];
            [visibleTrees removeObject:tempTree];
        }
    }
    
}

-(void) resetTrees {
    for (int i = 0; i < [visibleTrees count]; i++) {
        Tree *tempTree = [visibleTrees objectAtIndex:i];
        [tempTree despawn];
    }
    [visibleTrees removeAllObjects];
}

-(void) dealloc {
    [super dealloc];
}


@end
