//
//  Player.m
//  CatRun
//
//  Created by Kelvin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize isTouchingGround;
@synthesize touchActivated;
@synthesize touchTime;


//------------------------------------------------------------------------------
#pragma mark Init
-(id) init{
    self = [super init];
    if (self != nil){
        isTouchingGround = YES;
        touchActivated = NO;
        touchTime = 0.0;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark LH Methods

+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect{
    return [[[self alloc] initWithFile:filename rect:rect] autorelease];
}

+(id) spriteWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect{
    return [[[self alloc] initWithBatchNode:batchNode rect:rect] autorelease];
}

-(id) initWithFile:(NSString*)filename rect:(CGRect)rect{
    self = [super initWithFile:filename rect:rect];
    if (self != nil){
    }
    return self;
}

-(id) initWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect{
    self = [super initWithBatchNode:batchNode rect:rect];
    if (self != nil){
    }
    return self;
}

+(bool) isSpritePlayer:(id)object{
    if(nil == object)
        return false;
    return [object isKindOfClass:[Player class]];
}
////////////////////////////////////////////////////////////////////////////////

#pragma mark Update State
-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    //Overload
}

#pragma mark Dealloc
-(void) dealloc{		
	[super dealloc];
}

@end
