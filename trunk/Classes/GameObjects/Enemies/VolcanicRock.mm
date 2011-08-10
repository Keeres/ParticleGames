//
//  VolcanicRockAir.m
//  mushroom
//
//  Created by Steven Chen on 8/9/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "VolcanicRock.h"


@implementation VolcanicRock

@synthesize hasLanded;
@synthesize isHitAir;
@synthesize isHitLand;
//@synthesize rockOffset;
@synthesize rockSpeed;

-(void) createSensorWithWorld:(b2World *)world{
    b2BodyDef bodydef;
    bodydef.type = b2_staticBody;
    bodydef.position = b2Vec2(0,0);
   //  bodydef.allowSleep = false;
    // bodydef.fixedRotation = true;
    body = world->CreateBody(&bodydef);
    body->SetUserData(self);

    b2CircleShape shape;
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = 0.25;
    fixtureDef.shape = &shape;
    fixtureDef.isSensor = true;
    
    RockSensorAir = body->CreateFixture(&fixtureDef);
    body->SetActive(YES);
}

-(void) spawn:(CGPoint)location{
    CCLOG(@"rock spawned");

    body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
    self.position = location;
    self.visible = YES;
    self.hasLanded = NO;
    self.isHitLand = NO;
    self.characterState = kStateSpawning;
    body->SetActive(YES);
}



-(void) changeState:(CharacterStates) newState {
    if (self.characterState == newState) {
        return;
    }
    
    [self stopAllActions];
    id action = nil;
    self.characterState = newState;
    
    switch (newState) {
        case kStateSpawning:
            break;
        case kStateFlying:{
            //insert animation here
            break;
        case kStateLanding:
            CCLOG(@"state landing");
            //insert animation here
            break;
            //initiate with landing image with new sensor size
        case kStateDead:
            [self despawn];
            
        default:
            break;
        }
    }
    if (action != nil) {
        [self runAction:action];
    }
}


-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {
    if(self.characterState == kStateSpawning)
        [self changeState:kStateFlying];
    else if(self.characterState == kStateFlying){
       // CCLOG(@"time update");
       // [self changeState:kStateFlying];
        b2Vec2 rockPosition = self.body->GetPosition();
        self.body->SetTransform(b2Vec2(rockPosition.x + rockSpeed*deltaTime/PTM_RATIO, rockPosition.y - 10/PTM_RATIO), 0.0);
    }else if(hasLanded == TRUE){
        [self changeState:kStateLanding];
     //   b2Vec2 rockPosition = self.body->GetPosition();
   //     self.body->SetTransform(b2Vec2(rockPosition.x, rockPosition.y - self.contentSize.height/2/PTM_RATIO), 0.0);
    }
        
}

-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
       //type = ?
      //  NSString *rockFrameName = @"RockAirTemp.png";
     // [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"RockAirTemp.png"]];
        
        //place holder
         [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:  @"red_mushroom_jump_1.png"]];
        
        [self createSensorWithWorld:world];
        isHitLand = NO;
        isHitAir = NO;
        hasLanded = NO;
        self.visible = NO;
    }
    return self;
}
        
-(void) dealloc{
    [super dealloc];
}
@end
