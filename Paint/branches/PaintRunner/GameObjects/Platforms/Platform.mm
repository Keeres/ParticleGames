//
//  Platform.mm
//  PaintRunner
//
//  Created by Kelvin on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"

@implementation Platform

@synthesize readyToMove;
@synthesize isHit;
@synthesize finalHeight;
@synthesize platformNumber;

-(void) createBody {
    b2Vec2 p0 = b2Vec2(-self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    b2Vec2 p1 = b2Vec2(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position = b2Vec2(0.0, 0.0);    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2PolygonShape platformTopShape;
    b2FixtureDef platformTopFixtureDef;
    platformTopFixtureDef.shape = &platformTopShape;
    platformTopShape.SetAsEdge(p0, p1);

    platformTopFixtureDef.density = 0.01;
    platformTopFixtureDef.friction = 0.0;
    platformTopFixtureDef.restitution = 0.0;
    
    platformFixture = body->CreateFixture(&platformTopFixtureDef);
    body->SetActive(NO);
}

-(void) createInitialGroundBody {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    b2Vec2 p0 = b2Vec2(-winSize.width/4/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    b2Vec2 p1 = b2Vec2(winSize.width/4/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position = b2Vec2(0.0, 0.0);    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2PolygonShape platformTopShape;
    b2FixtureDef platformTopFixtureDef;
    platformTopFixtureDef.shape = &platformTopShape;
    platformTopShape.SetAsEdge(p0, p1);
    
    platformTopFixtureDef.density = 0.01;
    platformTopFixtureDef.friction = 0.0;
    platformTopFixtureDef.restitution = 0.0;
    
    platformFixture = body->CreateFixture(&platformTopFixtureDef);
    body->SetActive(NO);
}



-(id) initWithWorld:(b2World*)theWorld andPlatformType:(PlatformTypes)platformWithType {
    platformType = platformWithType;
    
    NSString *platformName;
    
    switch (platformType) {
        case platformA:
            platformName = @"platformA.png";
            break;
        case platformB:
            platformName = @"platformB.png";
            break;
        case platformC:
            platformName = @"platformA.png";
            break;
            
        default:
            [NSException exceptionWithName:@"Platform Exception" reason:@"unhandled platform type" userInfo:nil];
            break;
    }
    
    if ((self = [super init])) {
        world = theWorld;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:platformName]];
        
        self.visible = NO;
        self.tag = kPlatformType;
        readyToMove = NO;
        isHit = NO;
        finalHeight = 0.0;
        platformNumber = 0;
        [self createBody];
    }
    
    return self;
}

-(id) initInitialGroundPlatformWithWorld:(b2World *)theWorld {
    if ((self = [super init])) {
        world = theWorld;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"platformA"]];
        
        self.visible = NO;
        self.tag = kPlatformType;
        readyToMove = NO;
        isHit = NO;
        finalHeight = 0.0;
        [self createInitialGroundBody];
    }
    
    return self;
}


-(void) updateStateWithDeltaTime:(ccTime)deltaTime {
    
}

-(void) despawn {
    self.visible = NO;
    self.body->SetActive(NO);
    readyToMove = NO;
    isHit = NO;
}

-(void) dealloc {
    [super dealloc];
}

@end
