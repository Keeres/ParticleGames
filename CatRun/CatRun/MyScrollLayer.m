//
//  MyScrollLayer.m
//  CatRun
//
//  Created by Steven Chen on 3/22/12.
//  Copyright 2012 UIUC. All rights reserved.
//
//  Edited based on exocyze from cocos2d Forum

#import "MyScrollLayer.h"

@implementation MyScrollLayer

#pragma mark Initialize

+(id)makeScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY{
    return [[[self alloc] initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY] autorelease]; 
}

+(id) makeScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY viewWindow:(CGRect)viewWindow touchWindow:(CGRect)touchWindow{
    return [[[self alloc] initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY viewWindow:(CGRect)viewWindow touchWindow:(CGRect)touchWindow] autorelease];
}



-(id) initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)yStart{
    if ((self = [super init])) {
        
        //Temp background for debugging
    //   CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(150, 0, 255, 255)];
     //   [self addChild:layerColor];
        
        [self addChild:menu];
        
        //Scrolling layer initial parameters
        self.isTouchEnabled = YES;
        yPreviousPosition = 0.0;
        yVelocity = 0.0;
        contentHeight = height;
        
        //Bool statements
        isDragging = false;
        snapBack = false;
        boundaryBounce = false;
        draggingOutOfBound = false;
        lowerBoundaryBounce = false;
        upperBoundaryBounce = false;
        upperBoundarySnapBack = false;
        lowerBoundarySnapBack = false;
        setViewTouchArea = false;
        
        //user set values
        defaultFriction = 0.95;               //Defualt friction used for resetting at beginning of touch
        friction = defaultFriction;           //Initial friction when scrolling
        draggingFriction = 0.85;              //Defulat friction when menu dragged out of bound
        minVelocity = 30.0;                   //Min velocity for boundary bounce effect
        maxVelocity = 50.0;                   //Max velocity for boundary snap effect
        boundaryBuffer = 50.0;                //Buffer zone when menu can no longer be moved
        maxScrollingVelocity = 50.0;          //Prevent scrolling too fast when scrolling with multiple swipte motion     
        touchArea = CGRectMake(0.0, 0.0, 480.0, 320.0);         
        viewArea = CGRectMake(0.0, 0.0, 960.0, 640.0);

        //Main scrolling layer
        yStartPostion = yStart;
        self.anchorPoint = ccp(0.0, 320.0);   //Anchors to top left corner
        self.position = ccp(0.0, 0.0);
        [self schedule:@selector(moveTick:) interval:0.02f];
    }
    return self;
}

-(id) initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY viewWindow:(CGRect)viewWindow touchWindow:(CGRect)touchWindow{
    if ((self = [super init])) {
        
        //Temp background for debugging
   //     CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(150, 0, 255, 255)];
    //    [self addChild:layerColor];
        
        [self addChild:menu];
        
        //Scrolling layer initial parameters
        self.isTouchEnabled = YES;
        yPreviousPosition = 0.0;
        yVelocity = 0.0;
        contentHeight = height;
        
        //Bool statements
        isDragging = false;
        snapBack = false;
        boundaryBounce = false;
        draggingOutOfBound = false;
        lowerBoundaryBounce = false;
        upperBoundaryBounce = false;
        upperBoundarySnapBack = false;
        lowerBoundarySnapBack = false;
        setViewTouchArea = false;
        
        //user set values
        defaultFriction = 0.95;               //Defualt friction used for resetting at beginning of touch
        friction = defaultFriction;           //Initial friction when scrolling
        draggingFriction = 0.85;              //Defulat friction when menu dragged out of bound
        minVelocity = 30.0;                   //Min velocity for boundary bounce effect
        maxVelocity = 50.0;                   //Max velocity for boundary snap effect
        boundaryBuffer = 50.0;                //Buffer zone when menu can no longer be moved
        maxScrollingVelocity = 50.0;          //Prevent scrolling too fast when scrolling with multiple swipte motion     
        viewArea= viewWindow;
        touchArea = touchWindow;
        
        //Main scrolling layer
        self.anchorPoint = ccp(0.0, 320.0);   //Anchors to top left corner
        self.position = ccp(0.0, 0.0);
        [self schedule:@selector(moveTick:) interval:0.02f];
    }
    return self;
}

-(void)moveTick:(ccTime) delta{

    if(isDragging == false){

        yVelocity *= friction;
        
        //Sets a max scrolling velocity to prevent overshooting when scrolling with multiple finger swipes
        if (yVelocity > maxScrollingVelocity) {
            yVelocity = maxScrollingVelocity;

        }else if (yVelocity < -maxScrollingVelocity){
            yVelocity = -maxScrollingVelocity;
        }
        
        CGPoint position = self.position;
        position.y += yVelocity;
        //////////////////
        //Inertia Behavior
        //////////////////
        
        //Bounces menu back to boundary position when swiped pass it
        if (boundaryBounce == true) {

            if ((position.y < 0.0 - boundaryBuffer && upperBoundaryBounce == false) || (position.y > contentHeight + boundaryBuffer && lowerBoundaryBounce == false)) {
                friction = draggingFriction*0.10;
            }
            
            if(position.y < 0.0 && yVelocity > -20.0 && yVelocity <= 0.01){
                yVelocity = 50.0;
                friction = 0.50;
                upperBoundaryBounce = true;
            }else if(position.y > contentHeight && yVelocity < 20.0 && yVelocity >= -0.01){
                yVelocity = -50.0;
                friction = 0.50;
                lowerBoundaryBounce = true;
            }

            if (upperBoundaryBounce == true) {
                if (yVelocity > maxVelocity) {
                    yVelocity = maxVelocity;
                } else {
                    friction = friction*1.20;
                }
            }else if (lowerBoundaryBounce == true){
                if (yVelocity < -maxVelocity) {
                    yVelocity = -maxVelocity;
                } else {
                    friction = friction*1.20;
                }      
            }
        } else if(snapBack == true) {
            if ((position.y < 0.0 - boundaryBuffer && upperBoundarySnapBack == false) || (position.y > contentHeight + boundaryBuffer && lowerBoundarySnapBack == false)) {
                friction = draggingFriction*0.10;
            }else if (position.y < 0.0 - boundaryBuffer*1.5 && upperBoundarySnapBack == false){
                position.y = -boundaryBuffer*1.5;
            }else if (position.y > contentHeight + boundaryBuffer*1.5 && lowerBoundarySnapBack == false) {
                position.y = boundaryBuffer*1.5;
            }
            //Snapsback the menu to boundary when scrolling out of bound with finger on the screen
            if(position.y < 0.0 && yVelocity >= -20.0 && yVelocity < 0.01){
                yVelocity = 60.0;
                upperBoundarySnapBack = true;
            }else if(position.y > contentHeight && yVelocity <= 20.0 && yVelocity > -0.01){
                yVelocity = -60.0;
                lowerBoundarySnapBack = true;
            }
           if (upperBoundarySnapBack == true) {
               friction = defaultFriction;
                if (yVelocity < minVelocity) {
                    yVelocity = minVelocity;
                }else {
                    friction = friction*0.60;
                }
            }else if(lowerBoundarySnapBack == true) {
                friction = defaultFriction;
                if (yVelocity > -minVelocity) {
                    yVelocity = -minVelocity;
                }else{
                    friction =friction*0.60;
                }
            }
        } else if (draggingOutOfBound == true) {
            //Continue to
            friction = draggingFriction*0.45;
        } else if (friction > 0.75) {
                friction = friction*0.9;
            
        }
        
        //Stop bounce/snap action at the boundary
        if (position.y > 0.0 && (upperBoundaryBounce == true || upperBoundarySnapBack == true)) {
            yVelocity = 0.0;
            position.y = 0.0;
            friction = defaultFriction;
            upperBoundaryBounce = false;
            draggingOutOfBound = false;
            upperBoundarySnapBack = false;
            snapBack = false;
            boundaryBounce = false;
        }else if (position.y < contentHeight && (lowerBoundaryBounce == true || lowerBoundarySnapBack == true)) {
            yVelocity = 0.0;
            position.y = contentHeight;
            friction = defaultFriction;
            lowerBoundaryBounce = false;
            draggingOutOfBound = false;
            lowerBoundarySnapBack = false;
            snapBack = false;
            boundaryBounce = false;
        } 
       
        //Updates position
        self.position = position;
        
        //If swipe motion occured within bound but scrolling velocity pulls menu out of bound, bounces menu back to boundary
        if (snapBack == false && (self.position.y < 0.0 || self.position.y > contentHeight)) {
            boundaryBounce = true;
        }
    }else {
        
        //Introduce dragging friction if draggin motion is out of bound to restrict menu movement
        if (draggingOutOfBound == true) {
            if (self.position.y < -boundaryBuffer || self.position.y > contentHeight + boundaryBuffer) {
                draggingFriction = draggingFriction*0.05;
            }else{
            draggingFriction = draggingFriction*0.35;
            }
         }
        
        yVelocity = (self.position.y - yPreviousPosition)/2.0;
        yPreviousPosition = self.position.y;
    }
}

#pragma mark Clip Screen
- (void) visit {
    if (!self.visible)
        return;
    
    glPushMatrix();
    
    glEnable(GL_SCISSOR_TEST);
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    //In pixels not points
    //(start x, start y, width, heith)
    //(start x, start y) at bottom left corner
    CGRect scissorRect = viewArea;
    
    // transform the clipping rectangle to adjust to the current screen
    // orientation: the rectangle that has to be passed into glScissor is
    // always based on the coordinate system as if the device was held with the
    // home button at the bottom. the transformations account for different
    // device orientations and adjust the clipping rectangle to what the user
    // expects to happen.
    ccDeviceOrientation orientation = [[CCDirector sharedDirector] deviceOrientation];
    switch (orientation) {
        case kCCDeviceOrientationPortrait:
            break;
        case kCCDeviceOrientationPortraitUpsideDown:
            scissorRect.origin.x = size.width-scissorRect.size.width-scissorRect.origin.x;
            scissorRect.origin.y = size.height-scissorRect.size.height-scissorRect.origin.y;
            break;
        case kCCDeviceOrientationLandscapeLeft:
        {
            float tmp = scissorRect.origin.x;
            scissorRect.origin.x = scissorRect.origin.y;
            scissorRect.origin.y = size.width-scissorRect.size.width-tmp;
            tmp = scissorRect.size.width;
            scissorRect.size.width = scissorRect.size.height;
            scissorRect.size.height = tmp;
        }
            break;
        case kCCDeviceOrientationLandscapeRight:
        {
            float tmp = scissorRect.origin.y;
            scissorRect.origin.y = scissorRect.origin.x;
            scissorRect.origin.x = size.height-scissorRect.size.height-tmp;
            tmp = scissorRect.size.width;
            scissorRect.size.width = scissorRect.size.height;
            scissorRect.size.height = tmp;
        }
            break;
    }
    
    glScissor(scissorRect.origin.x, scissorRect.origin.y,
              scissorRect.size.width, scissorRect.size.height);
    
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);
    glPopMatrix();
}

#pragma mark Touch

-(void)registerWithTouchDispatcher{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint currentTouch = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    if (CGRectContainsPoint(touchArea, currentTouch)) {
        if (snapBack == true || boundaryBounce == true) {
            isDragging = false; 
        }else {
            isDragging = true;
            friction = defaultFriction;
        }
        //Resets dragging friction
        if (draggingOutOfBound == false) {
            draggingFriction = 0.85;
        }
        return YES;
    }
    return NO;
}

-(void)ccTouchEnded:(UITouch *)touches withEvent:(UIEvent *)event{
    isDragging = false;
    return;
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    isDragging = false;
    return;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    
    CGPoint currentPosition = self.position;
   
    if (currentPosition.y < 0.0 || currentPosition.y > contentHeight) {
        currentPosition.y += ((b.y - a.y)*draggingFriction);
        draggingOutOfBound = true;
    
        if (abs(b.y - a.y) < 0.01 || draggingFriction < 0.1) {
            snapBack = true;
            boundaryBounce = false;
        }else {
            boundaryBounce = true;
            snapBack = false;
        }
    }else {
        currentPosition.y += (b.y - a.y);
        draggingOutOfBound = false;
    }
    self.position = currentPosition;
  
    return;
}

-(void) dealloc{
    [super dealloc];
}

@end
