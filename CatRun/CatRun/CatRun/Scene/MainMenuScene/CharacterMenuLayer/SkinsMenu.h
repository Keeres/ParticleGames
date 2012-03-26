//
//  SkinsMenu.h
//  CatRun
//
//  Created by Steven Chen on 3/20/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMenu.h"
#import "InputController.h"

@interface SkinsMenu : CCMenu {
    CCMenuItem *currentHighlighted;
    CCMenuItem *currentSelection;

    bool moving;
    bool isDragging;
    bool scrollUp;
    bool scrollDown;
    bool scrollLeft;
    bool scrollRight;
	bool touchDown;
    bool touchCanceled;
    CGPoint distance;
    double yVelocity;
    double yLastPosition;
    int contentHeight;
}
@property (nonatomic, readwrite) int contentHeight;

- (void)setSelectedItem:(CCMenuItem *)item;
- (void) moveTick: (ccTime)dt;

@end
