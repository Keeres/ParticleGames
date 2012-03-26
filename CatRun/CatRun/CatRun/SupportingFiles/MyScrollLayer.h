//
//  MyScrollLayer.h
//  CatRun
//
//  Created by Steven Chen on 3/22/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyScrollLayer : CCLayer {
    bool isDragging;
    bool draggingOutOfBound;
    bool snapBack;
    bool boundaryBounce;
    bool lowerBoundaryBounce;
    bool upperBoundaryBounce;
    bool lowerBoundarySnapBack;
    bool upperBoundarySnapBack;
    bool setViewTouchArea;
    
    float yPreviousPosition;
    float yVelocity;
    float boundaryBuffer;
    float maxScrollingVelocity;
    float maxVelocity;
    float minVelocity;
    float friction;
    float defaultFriction;
    float draggingFriction;
    
    //Sets up scroll layer size
    float yStartPostion;
    int contentHeight;
    
    //Scrolling layer area
    CGRect touchArea;
    CGRect viewArea;
}

+(id) makeScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY;
+(id) makeScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY viewWindow:(CGRect)viewWindow touchWindow:(CGRect)touchWindow;

-(id) initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY;
-(id) initScrollLayerWithMenuLayerWithMenu:(CCMenu *)menu withContentHeight:(int)height startingYPosition:(float)startY viewWindow:(CGRect)viewWindow touchWindow:(CGRect)touchWindow;

@end























