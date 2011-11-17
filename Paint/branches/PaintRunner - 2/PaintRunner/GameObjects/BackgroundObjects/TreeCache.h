//
//  TreeCache.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Tree.h"
#import "Constants.h"

@interface TreeCache : CCNode {
    //Variables
    CGSize winSize;
    CCArray *totalTrees;
    NSMutableArray *visibleTrees;
}

@property (nonatomic, retain) CCArray *totalTrees;
@property (nonatomic, retain) NSMutableArray *visibleTrees;

-(void) updateTreesWithTime:(ccTime)dt andSpeed:(float)speed;
-(void) addTree;
-(void) cleanTree;
-(void) resetTrees;

@end
