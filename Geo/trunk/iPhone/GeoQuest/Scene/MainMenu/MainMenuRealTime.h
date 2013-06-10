//
//  MainMenuRealTime.h
//  GeoQuest
//
//  Created by Kelvin on 4/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "MainMenuUI.h"
#import "CCMenuAdvancedPlus.h"
#import <Parse/Parse.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "NotificationListener.h"


@class MainMenuUI;
@class RoomListener;
@class NotificationListener;

@interface MainMenuRealTime : CCLayer <ConnectionRequestListener,ZoneRequestListener> {
    CGSize              winSize;
    
    //Layers
    MainMenuUI          *mainMenuUI;
    
    //Button Menu
    CCMenuAdvancedPlus  *realTimeMenu;
    
    NSMutableArray      *_roomIds;
    int                 _gameState;
    NSString            *_roomIdToJoin;
    
    //AppWarp
    RoomListener        *_roomListener;
    NotificationListener *_notificationListener;
    
    //Test variable. Remove later
    int counter;

}

@property (nonatomic, retain) NSMutableArray *roomIds;
@property (assign) int gameState;
@property (nonatomic, retain) NSString *roomIdToJoin;

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) hideLayerAndObjects;
-(void) showLayerAndObjects;

@end
