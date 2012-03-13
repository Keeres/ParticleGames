//
//  DoubleJumpPlayer.mm
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoubleJumpPlayer.h"

@implementation DoubleJumpPlayer

#pragma mark Init
-(id) init{
    self = [super init];
    if (self != nil){
        activateJump = NO;
        activateDoubleJump = NO;
        doubleJumpAvailable = NO;

    }
    return self;
}

#pragma mark LH Method
+(bool) isSpritePlayer:(id)object{
    if(nil == object)
        return false;
    return [object isKindOfClass:[DoubleJumpPlayer class]];
}

#pragma mark Update States
-(void) jumpCheck:(ccTime)dt {
    b2Vec2 velocity = self.body->GetLinearVelocity();

    if (!touchActivated) {
        activateJump = NO;
        activateDoubleJump = NO;
        if (isTouchingGround) {
            doubleJumpAvailable = YES;
        }
    }
    
    if (touchActivated && isTouchingGround) {
        activateJump = YES;
    }
    
    if (touchActivated && !activateJump && doubleJumpAvailable) {
        doubleJumpAvailable = NO;
        activateDoubleJump = YES;
        self.body->SetLinearVelocity(b2Vec2(velocity.x, 0.0));
    }
    
    if (activateJump || activateDoubleJump) {        
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
}

-(void)updateStateWithDeltaTime:(ccTime)dt {
    //Keep player from moving on the X-Axis
    b2Vec2 currentPosition = self.body->GetPosition();
    float PTM_RATIO = [[LHSettings sharedInstance] lhPtmRatio];
    self.body->SetTransform(b2Vec2(100.0/PTM_RATIO, currentPosition.y), 0.0);
    
    [self jumpCheck:dt];
}

#pragma mark Dealloc
-(void) dealloc{		
	[super dealloc];
}

@end
