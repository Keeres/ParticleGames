//
//  PaintChip.mm
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintChip.h"

@implementation PaintChip

@synthesize isHit;

-(void) createBody {
    b2BodyDef bodyDef;
    //bodyDef.type = b2_dynamicBody;
    bodyDef.type = b2_staticBody;
    bodyDef.position = b2Vec2(0.0, 0.0);
    bodyDef.allowSleep = false;
    bodyDef.fixedRotation = true;
    //bodyDef.isGravitated = false;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2CircleShape shape;        
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.01;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    
    paintChipFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}


-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        world = theWorld;
        
        NSString *paintChipFrameName = @"brush.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:paintChipFrameName]];
        
        self.tag = kPaintChipType;
        self.visible = NO;
        self.isHit = NO;
        
        [self createBody];
    }
    return self;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {    
    if (self.isHit) {
        self.visible = NO;
        self.body->SetActive(NO);
    }
}

-(void) dealloc {
    [super dealloc];
}

@end
