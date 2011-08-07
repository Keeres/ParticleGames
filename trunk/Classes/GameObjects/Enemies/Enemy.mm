//
//  Enemy.mm
//  mushroom
//
//  Created by Kelvin on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

@synthesize type;
@synthesize speed;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) despawn {
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    body->SetActive(NO);
    self.visible = NO;
}

@end
