//
//  RealTimeUI.h
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RealTimeRoom.h"
#import "RealTimeBG.h"
#import "GeoQuestDB.h"
#import "Question.h"
#import "GeoQuestAnswer.h"
#import "CCMenuAdvancedPlus.h"
#import "CCMenu+Layout.h"
#import <Parse/Parse.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "CustomRoomData.h"
#import "Constants.h"
#import "NotificationListener.h"

#define Z_ORDER_TOP 100
#define Z_ORDER_MIDDLE 50
#define Z_ORDER_BACK 10

@class RealTimeRoom;
@class RealTimeBG;
@class NotificationListener;

@interface RealTimeUI : CCLayer { //<ConnectionRequestListener, ZoneRequestListener> {
    CGSize                  winSize;
    
    // Layers
    RealTimeRoom            *_realTimeRoom;
    RealTimeBG              *_realTimeBG;
    
    int                     _gameState;
    
    NotificationListener    *_notificationListener;
    
    NSDictionary            *_updateReceivedDictionary;
    
    int                     _gameLayerState;
    CCLayer                 *_gameLayer;

}

@property (nonatomic, retain) RealTimeRoom *realTimeRoom;
@property (assign) int gameState;
@property (assign) int gameLayerState;
@property (nonatomic, retain) NSDictionary *updateReceiveDictionary;

-(void) setRealTimeBGLayer:(RealTimeBG*)realBG;
-(void) setRealTimeRoomLayer:(RealTimeRoom*)realRoom;


@end
