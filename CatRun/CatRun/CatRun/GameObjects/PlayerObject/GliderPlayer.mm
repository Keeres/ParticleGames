//
//  GliderPlayer.mm
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GliderPlayer.h"

@implementation GliderPlayer

#pragma mark Init
-(id) init{
    self = [super init];
    if (self != nil){
        activateJump = NO;
        activateGlider = NO;
    }
    return self;
}

#pragma mark LH Method
+(bool) isSpritePlayer:(id)object{
    if(nil == object)
        return false;
    return [object isKindOfClass:[GliderPlayer class]];
}

#pragma mark Update States
-(void) jumpAndGliderCheck:(ccTime)dt {
    b2Vec2 velocity = self.body->GetLinearVelocity();
    
    if (!touchActivated) {
        activateJump = NO;
        activateGlider = NO;
    }
    
    if (touchActivated && isTouchingGround) {
        activateJump = YES;
    }
    
    if (touchActivated && !isTouchingGround) {
        activateGlider = YES;
    }
    
    if (activateJump) {
        self.isTouchingGround = NO;
        touchTime += dt;
        
        self.body->ApplyForce(b2Vec2(0.0, jumpVelocity), self.body->GetPosition());
        if (velocity.y > jumpVelocity) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, jumpVelocity));
        }
        
        if (touchTime > maximumTouchTime) {
            touchActivated = NO;
        }
    }
    
    if (activateGlider) {
        if (velocity.y < -1.0) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, -1.0));
        }
    }
}

-(void)updateStateWithDeltaTime:(ccTime)dt {
    //Keep player from moving on the X-Axis
    b2Vec2 currentPosition = self.body->GetPosition();
    float PTM_RATIO = [[LHSettings sharedInstance] lhPtmRatio];
    self.body->SetTransform(b2Vec2(100.0/PTM_RATIO, currentPosition.y), 0.0);
    
    [self jumpAndGliderCheck:dt];
}

#pragma mark Dealloc
-(void) dealloc{		
	[super dealloc];
}


@end
