//
//  DefaultPlayer.m
//  CatRun
//
//  Created by Kelvin on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultPlayer.h"

@implementation DefaultPlayer

#pragma mark Init

-(id) init{
    self = [super init];
    if (self != nil){
        activateJump = NO;
    }
    return self;
}

#pragma mark LH Method
+(bool) isSpritePlayer:(id)object{
    if(nil == object)
        return false;
    return [object isKindOfClass:[DefaultPlayer class]];
}

#pragma mark Update States
-(void) jumpCheck:(ccTime)dt {
    b2Vec2 velocity = self.body->GetLinearVelocity();
    
    if (touchActivated && isTouchingGround) {
        activateJump = YES;
    }
    
    if (!touchActivated) {
        activateJump = NO;
    }
    
    if (activateJump) {
        self.isTouchingGround = NO;
        touchTime += dt;
        
        self.body->ApplyForce(b2Vec2(0.0, jumpVelocity), self.body->GetPosition());
        if (velocity.y > jumpVelocity) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, jumpVelocity));
        }
        
        if (touchTime > maximumTouchTime) {
            activateJump = NO;
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


/*for (b2JointEdge* jointEdge = self.body->GetJointList(); jointEdge != NULL; jointEdge = jointEdge->next)
 {
 b2RevoluteJoint *targetJoint = (b2RevoluteJoint*) jointEdge->joint;
 targetJoint->EnableMotor(true);
 targetJoint->SetMotorSpeed(cosf(0.5f * deltaTime)*50.0);
 
 }*/
