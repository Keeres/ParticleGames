//
//  RealTimeUI.m
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeUI.h"
#import "NotificationListener.h"

@implementation RealTimeUI


#pragma mark - Setup Layers

-(void) setRealTimeBGLayer:(RealTimeBG *)realBG {
    _realTimeBG = realBG;
}

-(void) setRealTimeRoomLayer:(RealTimeRoom *)realRoom {
    _realTimeRoom = realRoom;
}

#pragma mark - Setup 

-(void) setupGame {
    [self setupAppWarpClient];
}

-(void) setupAppWarpClient {
    [WarpClient initWarp:@"47f841662b281a58b5dc14bac93adbf9d0b4cf16e5e914cc4b98a4504c71d582" secretKey:@"22cb303a5aca990eff63c7a01a7464c9e604311a435859f86d77a1a1e4fc9275"];
    
    [[WarpClient getInstance] addConnectionRequestListener: self];
    [[WarpClient getInstance] addZoneRequestListener: self];
    [[WarpClient getInstance] connect];
    RoomListener *roomListener = [[[RoomListener alloc] init] autorelease];
    [[WarpClient getInstance] addRoomRequestListener:roomListener];
    NotificationListener *notificationListener = [[[NotificationListener alloc] initWithGame:self] autorelease];
    [[WarpClient getInstance] addNotificationListener:notificationListener];

    
    CCLOG(@"RealTimeUI: AppWarp Init");
}

#pragma mark - App Warp Connections
#pragma mark -
#pragma mark ConnectionRequestListener Methods

-(void)onConnectDone:(ConnectEvent*) event{
    
    if (event.result==0) {
        NSLog(@"AppWarp Connection established");
        [[WarpClient getInstance]joinZone:[PFUser currentUser].username];
    }
    else {
        NSLog(@"AppWarp Connection Failed");
    }
}

-(void)onJoinZoneDone:(ConnectEvent*) event{
    if (event.result==0) {
        NSLog(@"AppWarp Join Zone done");
        [[WarpClient getInstance] joinRoom:@"1852889716"];
        [[WarpClient getInstance] subscribeRoom:@"1852889716"];
        [[WarpClient getInstance] getOnlineUsers];
        
    }
    else {
        NSLog(@"AppWarp Join Zone Failed!");
    }
}

-(void)onDisconnectDone:(ConnectEvent *)event {
    NSLog(@"AppWarp Connection Failed");
}

#pragma mark ZoneRequestListener Methods

-(void) onGetAllRoomsDone:(AllRoomsEvent *)event {
    for (int i = 0; i < [event.roomIds count]; i++) {
        //RoomData *room = [event.roomIds objectAtIndex:i];
        CCLOG(@"Room id: %@", [event.roomIds objectAtIndex:i]);
        //[[WarpClient getInstance] deleteRoom:[event.roomIds objectAtIndex:i]];
    }
}


-(void)onCreateRoomDone:(RoomEvent*)roomEvent{
    RoomData *roomData = roomEvent.roomData;
    NSLog(@"roomEvent result = %i",roomEvent.result);
    NSLog(@"room id = %@",roomData.roomId);
    
    [[WarpClient getInstance] getAllRooms];
}

-(void)onDeleteRoomDone:(RoomEvent*)roomEvent{
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Room Deleted");
    }
    else {
        NSLog(@"Room Deleted failed");
    }
}

-(void)onGetOnlineUsersDone:(AllUsersEvent*)event{
    if (event.result == SUCCESS) {
        NSLog(@"usernames = %@",event.userNames);
    }
    else {
        NSLog(@"All Online Users Get Operation failed");
    }
}

-(void) onGetLiveUserInfoDone:(LiveUserInfoEvent *)event {
    
}

-(void) onSetCustomUserDataDone:(LiveUserInfoEvent *)event {
    
}

#pragma mark - Get Question/Answer

-(id) getQuestion {
    return 0;
}

-(CCMenuAdvancedPlus*) getAnswerChoice {
    return 0;
}

#pragma mark - Init

-(id) init {
    if ((self = [super init])) {
        CCLOG(@"RealTimeUI: Initialized");
        winSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        [self setupGame];
    }
    return self;
}

#pragma mark - Update

-(void) update:(ccTime)delta {
    
}

-(void) dealloc {
    [super dealloc];
}

@end
