//
// NotificationListener.h
// Cocos2DSimpleGame
//
// Created by Dhruv Chopra on 8/22/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>

@interface NotificationListener : NSObject<NotifyListener>

@property (nonatomic,retain)MainMenuRealTime *gameView;

-(id)initWithGame:(MainMenuRealTime*) game;


@end

@interface RoomListener : NSObject<RoomRequestListener>

@end