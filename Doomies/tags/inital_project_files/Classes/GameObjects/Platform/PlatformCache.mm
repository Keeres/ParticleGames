//
//  PlatformCache.mm
//  mushroom
//
//  Created by Kelvin on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlatformCache.h"


@implementation PlatformCache
@synthesize platforms;
@synthesize platformsVisible;
@synthesize platformsFront;
@synthesize platformsMiddle;
@synthesize platformsEnd;
@synthesize platformBody;
@synthesize platformSideBody;
@synthesize fromKeyPointI;
@synthesize toKeyPointI;
@synthesize previousXLocation;

-(void) initPlatforms {
    platforms = [[CCArray alloc] initWithCapacity:PlatformType_MAX];
    platformsVisible = [[NSMutableArray alloc] init];
    platformsFront = [[CCArray alloc] init];
    platformsMiddle = [[CCArray alloc] init];
    platformsEnd = [[CCArray alloc] init];
    
    for (int i = 0; i < PlatformType_MAX; i++) {
        int capacity;
        switch (i) {
            case LargePlatformA:
                capacity = 20;
                break;
            case LargePlatformB:
                capacity = 100;
                break;
            case LargePlatformC:
                capacity = 100;
                break;
            case LargePlatformD:
                capacity = 20;
                break;
            case SmallPlatformA:
                capacity = 20;
                break;
            case SmallPlatformB:
                capacity = 100;
                break;
            case SmallPlatformC:
                capacity = 100;
                break;
            case SmallPlatformD:
                capacity = 20;
                break;
                
            default:
                [NSException exceptionWithName:@"PlatformCache Exception" reason:@"unhandled platform type" userInfo:nil];
                break;
                
        }
        CCArray *platformOfType = [CCArray arrayWithCapacity:capacity];
        [platforms addObject:platformOfType];
    }
    
    for (int i = 0; i < PlatformType_MAX; i++) {
        CCArray *platformOfType = [platforms objectAtIndex:i];
        int numberPlatformOfType = [platformOfType capacity];
        for (int j = 0; j < numberPlatformOfType; j++) {
            Platform *platform = [Platform platformWithType:(PlatformTypes)i];
            [batch addChild:platform z:0 tag:i];
            [platformOfType addObject:platform];
        }
    }
}



-(void) resetBox2DBody {    
    if (platformBody) {
        world->DestroyBody(platformBody);
    }
    
    b2BodyDef platformBodyDef;
    platformBodyDef.type = b2_staticBody;
    platformBodyDef.position.Set(0, 0);
    platformBody = world->CreateBody(&platformBodyDef);
    
    b2PolygonShape platformShape;    
    b2FixtureDef platformFixtureDef;
    platformFixtureDef.shape = &platformShape;
    platformFixtureDef.density = 0.0;
    platformFixtureDef.filter.categoryBits = kCategoryGround;
    platformFixtureDef.filter.maskBits = kMaskGround;
    platformFixtureDef.filter.groupIndex = kGroupGround;
    
    for(int i = MAX(fromKeyPointI, 0); i <= toKeyPointI; i++) {
        b2Vec2 p0 = b2Vec2(platformKeyPoints[i].x/PTM_RATIO*self.scale,
                           platformKeyPoints[i].y/PTM_RATIO*self.scale);
        b2Vec2 p1 = b2Vec2(platformKeyPoints[i+1].x/PTM_RATIO*self.scale,
                           platformKeyPoints[i+1].y/PTM_RATIO*self.scale);
        platformShape.SetAsEdge(p0, p1);
        platformBody->CreateFixture(&platformFixtureDef);
        i++;
    }
    
    if (platformSideBody) {
        world->DestroyBody(platformSideBody);
    }
    
    b2BodyDef platformSideBodyDef;
    platformSideBodyDef.type = b2_staticBody;
    platformSideBodyDef.position.Set(0, 0);
    platformSideBody = world->CreateBody(&platformSideBodyDef);
    
    b2PolygonShape platformSideShape;    
    b2FixtureDef platformSideFixtureDef;
    platformSideFixtureDef.shape = &platformSideShape;
    platformSideFixtureDef.density = 1.0;
    platformSideFixtureDef.restitution = 0.0;
    platformSideFixtureDef.filter.categoryBits = kCategoryGround;
    platformSideFixtureDef.filter.maskBits = kMaskGround;
    platformSideFixtureDef.filter.groupIndex = kGroupGround;

    for(int i = MAX(fromKeyPointI, 0); i <= toKeyPointI; i++) {
        b2Vec2 p0 = b2Vec2((platformKeyPoints[i].x-40.0)/PTM_RATIO*self.scale,
                           (platformKeyPoints[i].y)/PTM_RATIO*self.scale);
        b2Vec2 p1 = b2Vec2((platformKeyPoints[i].x-40.0)/PTM_RATIO*self.scale,
                           -winSize.height/PTM_RATIO*self.scale);
        platformShape.SetAsEdge(p0, p1);
        platformSideBody->CreateFixture(&platformFixtureDef);
        i++;
    }
}

-(void) resetSpritePlatform {
    
    for (int i = MAX(fromKeyPointI, 0); i <= toKeyPointI; i++) {
        
        if (platformKeyPoints[i].x >= previousXLocation) {
            //BOOL LargePlatform = arc4random() % 2;
            BOOL LargePlatform = YES;
            
            if (LargePlatform) {
                
                CCArray *platformOfLargeTypeA = [platforms objectAtIndex:0];
                CCArray *platformOfLargeTypeB = [platforms objectAtIndex:1];
                CCArray *platformOfLargeTypeC = [platforms objectAtIndex:2];
                CCArray *platformOfLargeTypeD = [platforms objectAtIndex:3];
                
                CCSprite *frontPlatform = [platformOfLargeTypeA objectAtIndex:0];
                CCSprite *middlePlatform = [platformOfLargeTypeB objectAtIndex:0];
                CCSprite *backPlatform = [platformOfLargeTypeD objectAtIndex:0];
                
                float distanceOfPlatform = platformKeyPoints[i+1].x - platformKeyPoints[i].x;
                                
                int numberOfSprites = (int) 
                (distanceOfPlatform - frontPlatform.textureRect.size.width/2 - backPlatform.textureRect.size.width/2)/
                (middlePlatform.textureRect.size.width - 10);
                
                for (int a = 0; a < [platformOfLargeTypeA count]; a++) {
                    CCSprite *frontPlatform = [platformOfLargeTypeA objectAtIndex:a];
                    
                    if (frontPlatform.visible == NO) {
                        frontPlatform.position = ccp(platformKeyPoints[i].x, 
                                                     platformKeyPoints[i].y - frontPlatform.textureRect.size.height/2 + 40.0);
                        frontPlatform.visible = YES;
                        [platformsVisible addObject:frontPlatform];
                        previousXLocation = frontPlatform.position.x;
                        break;
                    }
                }
                
                for (int d = 0; d < [platformOfLargeTypeD count]; d++) {
                    CCSprite *middlePlatform = [platformOfLargeTypeB objectAtIndex:0];
                    CCSprite *backPlatform = [platformOfLargeTypeD objectAtIndex:d];
                    
                    if (backPlatform.visible == NO) {
                        backPlatform.position = ccp(platformKeyPoints[i].x 
                                                    + numberOfSprites * (middlePlatform.textureRect.size.width - 10) 
                                                    + backPlatform.textureRect.size.width, 
                                                    platformKeyPoints[i].y - backPlatform.textureRect.size.height/2 + 40.0);
                        backPlatform.visible = YES;                        
                        [platformsVisible addObject:backPlatform];
                        previousXLocation = backPlatform.position.x;
                        break;
                    }
                }
                
                for (int j = 0; j < numberOfSprites; j++) {
                    
                    for (int b = 0; b < [platformOfLargeTypeB count]; b++) {
                        CCSprite *middlePlatform = [platformOfLargeTypeB objectAtIndex:b];
                        
                        if (middlePlatform.visible == NO) {
                            middlePlatform.position = ccp(platformKeyPoints[i].x 
                                                          //+ frontPlatform.textureRect.size.width/2
                                                          + (j+1)*(middlePlatform.textureRect.size.width - 10), 
                                                          platformKeyPoints[i].y - middlePlatform.textureRect.size.height/2 + 40.0);
                            middlePlatform.visible = YES;
                            [platformsVisible addObject:middlePlatform];
                            previousXLocation = middlePlatform.position.x;
                            break;
                        }
                    }
                }
            } else {
                CCArray *platformOfSmallTypeA = [platforms objectAtIndex:4];
                CCArray *platformOfSmallTypeB = [platforms objectAtIndex:5];
                CCArray *platformOfSmallTypeC = [platforms objectAtIndex:6];
                CCArray *platformOfSmallTypeD = [platforms objectAtIndex:7];
                
                CCSprite *frontPlatform = [platformOfSmallTypeA objectAtIndex:0];
                CCSprite *middlePlatform = [platformOfSmallTypeB objectAtIndex:0];
                CCSprite *backPlatform = [platformOfSmallTypeD objectAtIndex:0];
                
                float distanceOfPlatform = platformKeyPoints[i+1].x - platformKeyPoints[i].x;
                
                
                int numberOfSprites = (int) 
                (distanceOfPlatform - frontPlatform.textureRect.size.width/2 - backPlatform.textureRect.size.width/2)/
                (middlePlatform.textureRect.size.width - 10);
                
                for (int a = 0; a < [platformOfSmallTypeA count]; a++) {
                    CCSprite *frontPlatform = [platformOfSmallTypeA objectAtIndex:a];
                    
                    if (frontPlatform.visible == NO) {
                        frontPlatform.position = ccp(platformKeyPoints[i].x, 
                                                     platformKeyPoints[i].y - frontPlatform.textureRect.size.height/2 + 10.0);
                        frontPlatform.visible = YES;
                        [platformsVisible addObject:frontPlatform];
                        previousXLocation = frontPlatform.position.x;
                        break;
                    }
                }
                
                for (int d = 0; d < [platformOfSmallTypeD count]; d++) {
                    CCSprite *middlePlatform = [platformOfSmallTypeB objectAtIndex:0];
                    CCSprite *backPlatform = [platformOfSmallTypeD objectAtIndex:d];
                    
                    if (backPlatform.visible == NO) {
                        backPlatform.position = ccp(platformKeyPoints[i].x 
                                                    + numberOfSprites * (middlePlatform.textureRect.size.width - 10) 
                                                    + backPlatform.textureRect.size.width, 
                                                    platformKeyPoints[i].y - backPlatform.textureRect.size.height/2 + 10.0);
                        backPlatform.visible = YES;
                        
                        [platformsVisible addObject:backPlatform];
                        previousXLocation = backPlatform.position.x;
                        break;
                    }
                }
                
                for (int j = 0; j < numberOfSprites; j++) {
                    
                    for (int b = 0; b < [platformOfSmallTypeB count]; b++) {
                        CCSprite *middlePlatform = [platformOfSmallTypeB objectAtIndex:b];
                        
                        if (middlePlatform.visible == NO) {
                            middlePlatform.position = ccp(platformKeyPoints[i].x 
                                                          + (j+1)*(middlePlatform.textureRect.size.width - 10), 
                                                          platformKeyPoints[i].y - middlePlatform.textureRect.size.height/2 + 10.0);
                            middlePlatform.visible = YES;
                            [platformsVisible addObject:middlePlatform];
                            previousXLocation = middlePlatform.position.x;
                            break;
                        }
                    }
                }
            }
        }
        i++;
    }
    
}

-(void) resetPlatform {
    float fromDistance = (offset - winSize.width)/self.scale;
    float toDistance = (offset + winSize.width*3/4)/self.scale;
    while (platformKeyPoints[fromKeyPointI+1].x < fromDistance) {
        fromKeyPointI += 2;
    }
    while (platformKeyPoints[toKeyPointI].x < toDistance) {
        toKeyPointI += 2;    
    }
    
    [self resetBox2DBody];
    [self resetSpritePlatform];
}

-(void) generatePlatforms {
    CCArray *platformOfType = [platforms objectAtIndex:0];
    CCSprite *frontPlatform = [platformOfType objectAtIndex:0];
    platformOfType = [platforms objectAtIndex:1];
    CCSprite *middlePlatform = [platformOfType objectAtIndex:0];
    platformOfType = [platforms objectAtIndex:2];
    CCSprite *backPlatform = [platformOfType objectAtIndex:0];
    CGPoint p0, p1;
    int startingPoint;
    
    if (toKeyPointI > 0) {
        startingPoint = toKeyPointI+2;
        if (startingPoint > kMaxPlatformPoints) {
            startingPoint = kMaxPlatformPoints;
        }
    } else {
        startingPoint = 0;
    }
    
    for (int i = startingPoint; i < kMaxPlatformPoints; i++) {
        int lengthOfPlatform = arc4random() % 10;
        
        if (lengthOfPlatform < 3) {
            lengthOfPlatform = 4;
        }
        
        lengthOfPlatform *= 4;
        
        //float randomDistance = arc4random()%100;
        //float distBetweenPlatforms = randomDistance + (randomDistance * (1-self.scale)) + 100.0 + (100.0 * (1-self.scale));
        float distBetweenPlatforms = 300;
        
        if (i == 0) {
            p0 = CGPointMake(0, winSize.height/8);
            p1 = CGPointMake(p0.x 
                             + frontPlatform.textureRect.size.width/2
                             + (middlePlatform.textureRect.size.width - 10) * lengthOfPlatform 
                             + backPlatform.textureRect.size.width/2, 
                             winSize.height/8);
            platformKeyPoints[i] = p0;
            platformKeyPoints[i+1] = p1;
        } else {
            float randomHeight = winSize.height/8 + (arc4random() % 3)*winSize.height/6;
            
            p0 = CGPointMake(platformKeyPoints[i-1].x + distBetweenPlatforms, randomHeight);
            p1 = CGPointMake(p0.x 
                             + frontPlatform.textureRect.size.width/2 
                             + (middlePlatform.textureRect.size.width - 10) * lengthOfPlatform 
                             + backPlatform.textureRect.size.width/2, 
                             randomHeight);
            platformKeyPoints[i] = p0;
            platformKeyPoints[i+1] = p1;
        }
        i++;
    }    
}


-(id) initWithWorld:(b2World*)theWorld andScale:(float)scale {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
        self.scale = scale;
        CCSpriteFrame *textureFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"platform.png"];
        batch = [CCSpriteBatchNode batchNodeWithTexture:textureFrame.texture];
        fromKeyPointI = 0;
        toKeyPointI = 0;
        
        [self addChild:batch];
        [self initPlatforms];
        
        [self generatePlatforms];
        [self resetPlatform];
    }
    return self;
}


-(void) updatePlatforms:(float)newOffset withScale:(float)newScale {    
    offset = newOffset;
    self.scale = newScale;
    
    [self resetPlatform];
    
    //self.position = ccp(-offset*self.scale, self.position.y);    
    //b2Vec2 platformPosition = platformBody->GetPosition();
    //platformBody->SetTransform(b2Vec2(-offset/PTM_RATIO*self.scale, platformPosition.y), 0);
    //b2Vec2 platformSidePosition = platformSideBody->GetPosition();
    //platformSideBody->SetTransform(b2Vec2(-offset/PTM_RATIO*self.scale, platformSidePosition.y), 0);
    
    for (int i = 0; i < [platformsVisible count]; i++) {
        CCSprite *sprite = [platformsVisible objectAtIndex:i];
        //if (sprite.position.x < offset - winSize.width/5/self.scale - sprite.contentSize.width/2) {
        if (sprite.position.x < platformKeyPoints[fromKeyPointI].x) {
            sprite.visible = NO;
            [platformsVisible removeObjectAtIndex:i];
        }
    }
}

-(void) dealloc {
    [platforms release];
    [platformsVisible release];
    [platformsFront release];
    [platformsMiddle release];
    [platformsEnd release];
    [super dealloc];
}

@end
