//
//  CCMenuAdvancedPlus.m
//  GeoQuest
//
//  Created by Kelvin on 10/24/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "CCMenuAdvancedPlus.h"

@implementation CCMenuAdvancedPlus

@synthesize originalPos;
@synthesize bounceEffect;
@synthesize isRefreshed;
@synthesize extraTouchPriority;

-(id) initWithItems: (CCMenuItem*) item vaList: (va_list) args
{
	if ((self = [super initWithItems:item vaList:args])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        originalPos = ccp(winSize.width/2, winSize.height/2);
        bounceEffect = NO;
        isRefreshed = NO;
        extraTouchPriority = 0;
    }
	return self;
}

-(void) fixPosition {
    if ( CGRectIsNull( boundaryRect_) || CGRectIsInfinite(boundaryRect_) )
		return;
	
#define CLAMP(x,y,z) MIN(MAX(x,y),z)
	// get right top corner coords
	CGRect rect = [self boundingBox];
	CGPoint rightTopCorner = ccp(rect.origin.x + rect.size.width,
								 rect.origin.y + rect.size.height);
	CGPoint originalRightTopCorner = rightTopCorner;
	CGSize s = rect.size;
	
	// reposition right top corner to stay in boundary
    CGFloat leftBoundary;
    CGFloat rightBoundary;
    CGFloat bottomBoundary;
    CGFloat topBoundary;


    if (bounceEffect && boundaryRect_.size.width < self.contentSize.width) {
        leftBoundary = boundaryRect_.origin.x + boundaryRect_.size.width - 80.0;
    } else {
        leftBoundary = boundaryRect_.origin.x + boundaryRect_.size.width;
    }
    
    if (bounceEffect && boundaryRect_.size.width < self.contentSize.width) {
        rightBoundary = boundaryRect_.origin.x + MAX(s.width + 80.0, boundaryRect_.size.width + 80.0);
    } else {
        rightBoundary = boundaryRect_.origin.x + MAX(s.width, boundaryRect_.size.width);
    }
    
    if (bounceEffect && boundaryRect_.size.height < self.contentSize.height) {
        bottomBoundary = boundaryRect_.origin.y + boundaryRect_.size.height - 80.0;
    } else {
        bottomBoundary = boundaryRect_.origin.y + boundaryRect_.size.height;
    }
    
    if (bounceEffect && boundaryRect_.size.height < self.contentSize.height) {
        topBoundary = boundaryRect_.origin.y + MAX(s.height + 80.0,boundaryRect_.size.height + 80.0);
    } else {
        topBoundary = boundaryRect_.origin.y + MAX(s.height,boundaryRect_.size.height);
    }
    
	rightTopCorner = ccp( CLAMP(rightTopCorner.x,leftBoundary,rightBoundary),
						 CLAMP(rightTopCorner.y,bottomBoundary,topBoundary));
	
	// calculate and add position delta
	CGPoint delta = ccpSub(rightTopCorner, originalRightTopCorner);
	self.position = ccpAdd(self.position, delta);
	
#undef CLAMP
    
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority - extraTouchPriority swallowsTouches:YES];
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] && [self isTouchForMe:touch]) {
            
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
            
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

-(BOOL) isTouchForMe:(UITouch *) touch
{
	CGPoint point = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]]];
	CGPoint prevPoint = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch previousLocationInView: [touch view]]]];
    	
	CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
      
    if ( CGRectContainsPoint(rect, point) || CGRectContainsPoint(rect, prevPoint) ) {
        [self stopAllActions];
		return YES;
    }
	
	return NO;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( state_ != kCCMenuStateWaiting || !visible_ || self.isDisabled )
		return NO;
	
	curTouchLength_ = 0; //< every new touch should reset previous touch length
	
	selectedItem_ = [self itemForTouch:touch];
	[selectedItem_ selected];
	
	if( selectedItem_ ) {
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	
	// start slide even if touch began outside of menuitems, but inside menu rect
	if ( !CGRectIsNull(boundaryRect_) && [self isTouchForMe: touch] ){
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
	[selectedItem_ unselected];
	[selectedItem_ activate];
	
	state_ = kCCMenuStateWaiting;
    
    float contentTopBorder = self.position.y + self.contentSize.height/2;
    float boundaryTopBorder = boundaryRect_.origin.y + boundaryRect_.size.height;
    
    float contentBotBorder = self.position.y - self.contentSize.height/2;
    float boundaryBotBorder = boundaryRect_.origin.y;
    
    float bottomPositionY = boundaryRect_.origin.y + self.contentSize.height/2;

    if (contentTopBorder < (boundaryTopBorder - 30.0)) {
        CCLOG(@"CCMenuAdvancedPlus: Refresh Menu");
        isRefreshed = YES;
    }
    
    if (contentTopBorder < boundaryTopBorder) {
        id action = [CCMoveTo actionWithDuration:0.75 position:originalPos];
        id ease = [CCEaseBackOut actionWithAction:action];
        
        [self runAction:ease];
    }
    
    if (contentBotBorder > boundaryBotBorder) {
        
        id action = [CCMoveTo actionWithDuration:0.75 position:ccp(self.position.x, bottomPositionY)];
        id ease = [CCEaseBackOut actionWithAction:action];
        
        [self runAction:ease];
    }
}

@end
