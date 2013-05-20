//
// NotificationListener.m
// Cocos2DSimpleGame
//
// Created by Dhruv Chopra on 8/22/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuCreateGame.h"
#import "NotificationListener.h"

@implementation NotificationListener

@synthesize gameView;

/*-(id)initWithGame:(MainMenuRealTime *) game {
    self.gameView = game;
    return self;
}*/

-(id) initWithGame:(RealTimeUI*)game {
    self.gameView = game;
    return self;
}

-(void)onRoomCreated:(RoomData*)roomEvent{
    
}
-(void)onRoomDestroyed:(RoomData*)roomEvent{
    
}
-(void)onUserLeftRoom:(RoomData*)roomData username:(NSString*)username{
    
}
-(void)onUserJoinedRoom:(RoomData*)roomData username:(NSString*)username{
    
}
-(void)onUserLeftLobby:(LobbyData*)lobbyData username:(NSString*)username{
    
}
-(void)onUserJoinedLobby:(LobbyData*)lobbyData username:(NSString*)username{
    
}
-(void)onChatReceived:(ChatEvent*)chatEvent{
    
}


//
// decode the NSData into JSON to get
// sender, xPos and yPos and invoke the callback
// on the gameView reference
//
//

-(void)onUpdatePeersReceived:(UpdateEvent*)updateEvent {
    
    NSLog(@"onUpdate peers received");
    NSError* error = nil;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:updateEvent.update
                          options:kNilOptions
                          error:&error];
    
    
    int time = [[json objectForKey:@"time"]intValue];
    int counter = [[json objectForKey:@"counter"]intValue];
    NSString* sender = [json objectForKey:@"sender"];
    
    
    if(![sender isEqualToString:[PFUser currentUser].username]) {
        
        nil;
    }
    NSLog(@"Received @ %d = %@,%i,%i",(int)[[NSDate date] timeIntervalSince1970], sender,time,counter);
    
    
}

@end

@implementation RoomListener

-(void)onSubscribeRoomDone:(RoomEvent*)roomEvent{
    
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Subscribed");
    }
    else {
        NSLog(@"subscribed failed");
    }
}
-(void)onUnSubscribeRoomDone:(RoomEvent*)roomEvent{
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Room Unsubscribed");
    }
    else {
        NSLog(@"Room Unsubscribed failed");
    }
}
-(void)onJoinRoomDone:(RoomEvent*)roomEvent{
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Room Joined");
        [[WarpClient getInstance] getLiveRoomInfo:@"1852889716"];
    }
    else {
        NSLog(@"Room Join failed");
    }
    
}
-(void)onLeaveRoomDone:(RoomEvent*)roomEvent{
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Room Left");
    }
    else {
        NSLog(@"Room Left failed");
    }
}
-(void)onGetLiveRoomInfoDone:(LiveRoomInfoEvent*)event{
    if (event.result == SUCCESS) {
        CCLOG(@"Room Live Info retrieved");
        for (int i = 0; i < [event.joinedUsers count]; i++) {
            CCLOG(@"%@", [event.joinedUsers objectAtIndex:i]);
        }
    } else {
        CCLOG(@"Room Live Info failed");
    }
}
-(void)onSetCustomRoomDataDone:(LiveRoomInfoEvent*)event{
    NSLog(@"event joined users = %@",event.joinedUsers);
    NSLog(@"event custom data = %@",event.customData);
}

@end