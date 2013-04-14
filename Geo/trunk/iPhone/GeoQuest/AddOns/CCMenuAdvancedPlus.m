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
@synthesize bounceEffectLeft;
@synthesize bounceEffectRight;
@synthesize bounceEffectUp;
@synthesize bounceEffectDown;
@synthesize isRefreshed;
@synthesize disableScroll;
@synthesize extraTouchPriority;
@synthesize bounceDistance;

-(id) initWithItems: (CCMenuItem*) item vaList: (va_list) args
{
	if ((self = [super initWithItems:item vaList:args])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        originalPos = ccp(winSize.width/2, winSize.height/2);
        bounceEffectLeft = NO;
        bounceEffectRight = NO;
        bounceEffectUp = NO;
        bounceEffectDown = NO;
        isRefreshed = NO;
        disableScroll = NO;
        extraTouchPriority = 0;
        bounceDistance = 0.0;
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


    if (bounceEffectLeft && boundaryRect_.size.width <= self.contentSize.width) {
        leftBoundary = boundaryRect_.origin.x + boundaryRect_.size.width - bounceDistance;
    } else {
        leftBoundary = boundaryRect_.origin.x + boundaryRect_.size.width;
    }
    
    if (bounceEffectRight && boundaryRect_.size.width <= self.contentSize.width) {
        rightBoundary = boundaryRect_.origin.x + MAX(s.width + bounceDistance, boundaryRect_.size.width + bounceDistance);
    } else {
        rightBoundary = boundaryRect_.origin.x + MAX(s.width, boundaryRect_.size.width);
    }
    
    if (bounceEffectDown && boundaryRect_.size.height <= self.contentSize.height) {
        bottomBoundary = boundaryRect_.origin.y + boundaryRect_.size.height - bounceDistance;
    } else {
        bottomBoundary = boundaryRect_.origin.y + boundaryRect_.size.height;
    }
    
    if (bounceEffectUp && boundaryRect_.size.height <= self.contentSize.height) {
        topBoundary = boundaryRect_.origin.y + MAX(s.height + bounceDistance, boundaryRect_.size.height + bounceDistance);
    } else {
        topBoundary = boundaryRect_.origin.y + MAX(s.height, boundaryRect_.size.height);
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
    
    //challenger = (ChallengerMenuItemSprite*)[self itemForTouch:touch];
    //[challenger selected];
	
	if( selectedItem_ ) {
		state_ = kCCMenuStateTrackingTouch;
        
        startTouchPos = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]]];
        touchedItem = YES;
		return YES;
	}
	
	// start slide even if touch began outside of menuitems, but inside menu rect
	if ( !CGRectIsNull(boundaryRect_) && [self isTouchForMe: touch] ){
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [self itemForTouch:touch];
	
	if (currentItem != selectedItem_) {
		[selectedItem_ unselected];
		selectedItem_ = currentItem;
		[selectedItem_ selected];
	}
	
	// scrolling is allowed only with non-zero boundaryRect
	if (!CGRectIsNull(boundaryRect_) && !disableScroll)
	{
		// get touch move delta
		CGPoint point = [touch locationInView: [touch view]];
		CGPoint prevPoint = [ touch previousLocationInView: [touch view] ];
		point =  [ [CCDirector sharedDirector] convertToGL: point ];
		prevPoint =  [ [CCDirector sharedDirector] convertToGL: prevPoint ];
		CGPoint delta = ccpSub(point, prevPoint);
		
		curTouchLength_ += ccpLength( delta );
		
		if (curTouchLength_ >= self.minimumTouchLengthToSlide)
		{
			[selectedItem_ unselected];
			selectedItem_ = nil;
			
			// add delta
			CGPoint newPosition = ccpAdd(self.position, delta );
			self.position = newPosition;
			
			// stay in externalBorders
			[self fixPosition];
		}
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
    //CGPoint point = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]]];

    
    /*if (challenger) {
        
        if ((point.x - startTouchPos.x) > 20) {
            [challenger showDeleteSprite];
        } else if ((point.x - startTouchPos.x) < -20) {
            [challenger hideDeleteSprite];
        } else {
            [selectedItem_ unselected];
        }
        
    }
	
    if (challenger.deleteActive) {
        CGPoint deletePoint = [challenger convertTouchToNodeSpace:touch];
        
        if (CGRectContainsPoint(challenger.deleteBoundaryRect, deletePoint)) {
            [challenger unselected];
            [challenger activate];
        } else {
            challenger.deleteActive = NO;
            [challenger hideDeleteSprite];
            //[challenger unselected];
        }
    } else {
        [selectedItem_ unselected];
        [selectedItem_ activate];
    }*/

    [selectedItem_ unselected];
    [selectedItem_ activate];
	state_ = kCCMenuStateWaiting;
    
    float contentTopBorder = self.position.y + self.contentSize.height/2;
    float boundaryTopBorder = self.originalPos.y + self.contentSize.height/2;
    
    float contentBotBorder = self.position.y - self.contentSize.height/2;
    float boundaryBotBorder = boundaryRect_.origin.y;
    float bottomPositionY;
    if (originalPos.y - self.contentSize.height/2 < 0.0){
        bottomPositionY = boundaryRect_.origin.y + self.contentSize.height/2;
    } else {
        bottomPositionY = originalPos.y;
    }
    
    if (contentTopBorder < (boundaryTopBorder - bounceDistance/2)) {
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
