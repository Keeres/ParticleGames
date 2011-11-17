//
//  Tree.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

typedef enum {
    tree = 0,
    tree_Max,
} TreeTypes;

@interface Tree : GameObject {
    TreeTypes treeType;
    float speedPercentage;
}

@property (readwrite) float speedPercentage;

-(id) initWithTreeType:(TreeTypes)treeWithType;
-(void) despawn;

@end
