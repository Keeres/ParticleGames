//
//  GameUILayer.h
//  mushroom
//
//  Created by Kelvin on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "Constants.h"

@interface GameUILayer : CCLayer {
    SneakyButton *jumpButton;
    SneakyButton *changeButton;
    
    CCLabelTTF *distanceLabel;
    int totalDistance;
}

@property (nonatomic, readonly) SneakyButton *jumpButton;
@property (nonatomic, readonly) SneakyButton *changeButton;

-(void) updateStats:(float)offset;

@end
