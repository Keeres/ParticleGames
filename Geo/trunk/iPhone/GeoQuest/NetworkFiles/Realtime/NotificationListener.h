//
// NotificationListener.h
// Cocos2DSimpleGame
//
// Created by Dhruv Chopra on 8/22/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "MainMenuRealTime.h"
#import "RealTimeUI.h"
#import "CustomRoomData.h"

#define COUNTDOWN_TIMER 30

@class MainMenuRealTime;
@class RealTimeUI;

/////////////////////////////////////
//NOTIFICATION LISTENER
/////////////////////////////////////

@interface NotificationListener : NSObject<NotifyListener>

@property (nonatomic, retain) MainMenuRealTime *mainMenuRealTime;

@property (nonatomic, retain) RealTimeUI *realTimeUI;

@end



/////////////////////////////////////
//ROOM LISTENER
/////////////////////////////////////

@interface RoomListener : NSObject<RoomRequestListener>

@property (nonatomic, retain) MainMenuRealTime *mainMenuRealTime;

@property (nonatomic, retain) RealTimeUI *realTimeUI;


@end