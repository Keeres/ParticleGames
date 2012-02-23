//
//  SkinScene.mm
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PerkScene.h"

@implementation PerkScene

-(id)init {
    self = [super init];
    if (self != nil) {
        perkLayer = [PerkLayer node];
        [self addChild:perkLayer];
    }
    return self;
}
@end
