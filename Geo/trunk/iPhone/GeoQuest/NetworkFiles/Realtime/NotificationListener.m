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


-(void)onRoomCreated:(RoomData*)roomEvent{

}

-(void)onRoomDestroyed:(RoomData*)roomEvent{
    
}

-(void)onUserLeftRoom:(RoomData*)roomData username:(NSString*)username{
    CCLOG(@"NotificationListner: User left the room.");
    self.realTimeUI.realTimeRoom.countdownTimer = COUNTDOWN_TIMER;
}

-(void)onUserJoinedRoom:(RoomData*)roomData username:(NSString*)username{
    CCLOG(@"NotificationListner: User joined the room.");
    self.realTimeUI.realTimeRoom.countdownTimer = COUNTDOWN_TIMER;
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
    
    self.realTimeUI.gameState = kUpdateReceived;
    
    NSLog(@"onUpdate peers received");
    NSError* error = nil;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:updateEvent.update
                          options:kNilOptions
                          error:&error];
    
    self.realTimeUI.updateReceiveDictionary = json;
    
    
    /*int time = [[json objectForKey:@"time"]intValue];
    int counter = [[json objectForKey:@"counter"]intValue];
    NSString* sender = [json objectForKey:@"sender"];
    
    
    if(![sender isEqualToString:[PFUser currentUser].username]) {
        
        nil;
    }
    NSLog(@"Received @ %d = %@,%i,%i",(int)[[NSDate date] timeIntervalSince1970], sender,time,counter);
    */
    
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
    CCLOG(@"Attemping to join roomId: %@", roomEvent.roomData.roomId);
    
    if (roomEvent.result == SUCCESS) {
        NSLog(@"Room Joined");
        [[WarpClient getInstance] subscribeRoom:roomEvent.roomData.roomId];
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
        switch (self.realTimeUI.gameState) {
            case kJoinRandomGame: {
                if([event.joinedUsers count] < 4) {
                    self.mainMenuRealTime.gameState = kJoinGame;
                    self.mainMenuRealTime.roomIdToJoin = event.roomData.roomId;
                } else {
                    self.mainMenuRealTime.gameState = kJoinRandomGame;
                }
                break;
            }
                
            case kGetLiveRoomInfo: {
                
                break;
            }
                
            default:
                break;
        }
        

    } else {
        CCLOG(@"Room Live Info failed");
    }
}

-(void)onSetCustomRoomDataDone:(LiveRoomInfoEvent*)event{
    //NSLog(@"event joined users = %@",event.joinedUsers);
    //NSLog(@"event custom data = %@",event.customData);
}

@end