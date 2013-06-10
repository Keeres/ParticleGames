//
//  RealTimeRoom.h
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RealTimeUI.h"
#import "CCMenuAdvancedPlus.h"
#import "CustomRoomData.h"


#define COUNTDOWN_TIMER 30

@class RealTimeUI;

@interface RealTimeRoom : CCLayer {
    CGSize              winSize;
    
    RealTimeUI          *_realTimeUI;
    int counter;
    
    //Button Menu
    CCMenuAdvancedPlus  *_realTimeMenu;
    CCMenuAdvancedPlus  *_realTimeTerritoryMenu;
    
    //Label
    CCLabelTTF          *_countdownTimerLabel;
    
    float               _countdownTimer;
}

@property float countdownTimer;

-(id) initWithRealTimeUILayer:(RealTimeUI*)realUI;

@end
