//
//  FlyingPlayer.mm
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlyingPlayer.h"

@implementation FlyingPlayer

#pragma mark Init
-(id) init{
    self = [super init];
    if (self != nil){
        activateFlight = NO;
    }
    return self;
}

#pragma mark LH Method
+(bool) isSpritePlayer:(id)object{
    if(nil == object)
        return false;
    return [object isKindOfClass:[FlyingPlayer class]];
}

#pragma mark Update States
-(void) flightCheck:(ccTime)dt {
    b2Vec2 velocity = self.body->GetLinearVelocity();
    
    if (!touchActivated) {
        activateFlight = NO;
        if (velocity.y < fallingVelocity) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, fallingVelocity));
        }
    }
    
    if (touchActivated) {
        activateFlight = YES;
    }
    
    if (activateFlight) {
        self.isTouchingGround = NO;
        
        self.body->ApplyForce(b2Vec2(0.0, flightVelocity), self.body->GetPosition());
        if (velocity.y > flightVelocity) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, flightVelocity));
        }
    }
}

-(void)updateStateWithDeltaTime:(ccTime)dt {
    //Keep player from moving on the X-Axis
    b2Vec2 currentPosition = self.body->GetPosition();
    float PTM_RATIO = [[LHSettings sharedInstance] lhPtmRatio];
    self.body->SetTransform(b2Vec2(100.0/PTM_RATIO, currentPosition.y), 0.0);
    
    [self flightCheck:dt];
}

#pragma mark Dealloc
-(void) dealloc{		
	[super dealloc];
}


@end
