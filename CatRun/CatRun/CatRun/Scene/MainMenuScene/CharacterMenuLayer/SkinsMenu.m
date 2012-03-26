//
//  SkinsMenu.m
//  CatRun
//
//  Created by Steven Chen on 3/20/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import "SkinsMenu.h"

@interface SkinsMenu (Animation)

//-(void) updateAnimation;
-(void) moveItemsDownBy:(float) offset;
-(void) moveItemsUpBy:(float) offset;

@end

@implementation SkinsMenu

@synthesize contentHeight;

-(void) registerWithTouchDispatcher{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}

- (void)setSelectedItem:(CCMenuItem *)item {
    selectedItem_ = item;    
    [selectedItem_ selected];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if([[event allTouches] count] != 1){
		return false;
    }
    CCMenuItem *itemTouched= [super itemForTouch:touch];
    if (itemTouched) {
        currentHighlighted = selectedItem_;
        
        isDragging = true;
        moving = false;
        touchCanceled = false;
        state_ = kCCMenuStateTrackingTouch;
        
        return true;
    }
    return false;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if([[event allTouches] count] != 1) {
		[self ccTouchCancelled:touch withEvent:event];
		return;
	}
    currentSelection = [super itemForTouch:touch];

 //   if(!moving && state_ == kCCMenuStateTrackingTouch){
      

        if (currentSelection != currentHighlighted && currentSelection != nil && touchCanceled != true) {
            [selectedItem_ unselected];
            selectedItem_ = currentSelection;
            [selectedItem_ selected];
            [selectedItem_ activate];

            currentHighlighted = nil;
            state_ = kCCMenuStateWaiting;
            return ;
        } 
 //   }
//	else if(state_ == kCCMenuStateTrackingTouch)
//		[self ccTouchCancelled:touch withEvent:event];
  /*  if(scrollUp == true){
        double buffer;
        double offset;
        for (int i=0; i<20; i++) {
            CCLOG(@"ASDF");
            buffer = 1.0/(i+10);
            offset = distance.y*buffer;
            [self moveItemsUpBy:offset];
        }
    }*/
    isDragging = false;

   // selectedItem_ = currentHighlighted;
  //  currentHighlighted = nil;
    
  //  moving = false;
//	touchDown = true;
    state_ = kCCMenuStateWaiting;

}

- (void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    touchCanceled = true;
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if([[event allTouches] count] != 1) {
		[self ccTouchCancelled:touch withEvent:event];
		return;
	}
    NSMutableSet* touches = [[[NSMutableSet alloc] initWithObjects:touch, nil] autorelease];
    distance = icDistance(1, touches, event);

    //Moves buttons by distance in x or y direction
    if(icWasSwipeLeft(touches, event) && distance.y < distance.x) {
		moving = true;
        scrollLeft = true;
        [self ccTouchCancelled:touch withEvent:event];
	} else if(icWasSwipeRight(touches, event) && distance.y < distance.x){
		moving = true;
        scrollRight = true;
        [self ccTouchCancelled:touch withEvent:event];
    } else if(icWasSwipeUp(touches, event)){
        moving = true;
        scrollUp = true;
        [self ccTouchCancelled:touch withEvent:event];
        [self moveItemsUpBy:distance.y];
    } else if(icWasSwipeDown(touches, event)){
        moving = true;
        scrollDown = true;
        [self ccTouchCancelled:touch withEvent:event];
        [self moveItemsDownBy:-distance.y];
    }
    else if(!moving && state_ == kCCMenuStateTrackingTouch) {
		[super ccTouchMoved:touch withEvent:event];
	}
    
}

- (void) moveTick: (ccTime)dt {
	float friction = 0.95f;
    
	if ( !isDragging )
	{   CCLOG(@"INERTIA");
		// inertia
		yVelocity *= friction;
		CGPoint pos = self.position;
		pos.y += yVelocity;
        
		// *** CHANGE BEHAVIOR HERE *** //
		// to stop at bounds
		//pos.y = MAX( 320, pos.y );
		//pos.y = MIN( contentHeight + 320, pos.y );
		// to bounce at bounds
		if ( pos.y < 320 ) {
            yVelocity *= -1; pos.y = 320;
        }
		if ( pos.y > contentHeight + 320 ) { yVelocity *= -1; pos.y = contentHeight + 320; }
		self.position = pos;
        CCLOG(@"POSITION %f ", self.position.x);
	}
	else
	{
		yVelocity = ( self.position.y - yLastPosition ) / 2;
		yLastPosition = self.position.y;
	}
}

@end

#pragma mark Setup Movements

@implementation SkinsMenu (Animation)

-(void) moveItemsDownBy:(float) offset
{
	//[selectedItem_ unselected];  
	
	for(CCMenuItem<CCRGBAProtocol>* item in children_) {
		[item setPosition:ccpAdd([item position], ccp(0, offset))];
	}
}

-(void) moveItemsUpBy:(float) offset
{
	//[selectedItem_ unselected];  
	
	for(CCMenuItem<CCRGBAProtocol>* item in children_) {
		[item setPosition:ccpAdd([item position], ccp(0, offset))];
	}
}

@end
