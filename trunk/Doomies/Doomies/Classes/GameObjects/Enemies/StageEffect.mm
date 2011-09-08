//
//  StageEffect.m
//  mushroom
//
//  Created by Steven Chen on 8/11/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "StageEffect.h"


@implementation StageEffect
@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) despawn {
    
  //  body->SetLinearVelocity(b2Vec2(0.0, 0.0));
  //  body->SetActive(NO);
 //   self.visible = NO;
}

@end
