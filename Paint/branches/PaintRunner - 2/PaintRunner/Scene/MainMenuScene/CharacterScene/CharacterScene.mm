//
//  CharacterScene.mm
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CharacterScene.h"

@implementation CharacterScene
-(id)init {
    self = [super init];
    if (self != nil) {
        characterLayer = [CharacterLayer node];
        [self addChild:characterLayer];
    }
    return self;
}
@end
