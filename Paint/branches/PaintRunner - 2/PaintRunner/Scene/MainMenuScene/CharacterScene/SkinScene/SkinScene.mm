//
//  SkinScene.mm
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SkinScene.h"

@implementation SkinScene

-(id)init {
    self = [super init];
    if (self != nil) {
        skinLayer = [SkinLayer node];
        [self addChild:skinLayer];
    }
    return self;
}
@end
