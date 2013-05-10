//
//  MainMenuRealTime.m
//  GeoQuest
//
//  Created by Kelvin on 4/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MainMenuRealTime.h"
#import "MainMenuCreateGame.h"
#import "NotificationListener.h"


@implementation MainMenuRealTime

#pragma mark - Setup layer

-(void) setupRealTimeLayer {
    //Allocate and initialize buttons
    [self setupRealTimeMenu];
    
    [WarpClient initWarp:@"47f841662b281a58b5dc14bac93adbf9d0b4cf16e5e914cc4b98a4504c71d582" secretKey:@"22cb303a5aca990eff63c7a01a7464c9e604311a435859f86d77a1a1e4fc9275"];
    
    [[WarpClient getInstance] addConnectionRequestListener: self];
    [[WarpClient getInstance] addZoneRequestListener: self];
    [[WarpClient getInstance] connect];
    RoomListener *roomListener = [[[RoomListener alloc] init] autorelease];
    [[WarpClient getInstance] addRoomRequestListener:roomListener];
    NotificationListener *notificationListener = [[[NotificationListener alloc] initWithGame:self] autorelease];
    [[WarpClient getInstance] addNotificationListener:notificationListener];
    
    NSLog(@"AppWarp Client Init");
    
}

-(void) setupRealTimeMenu {
    // Button 1 for real time menu
    CCMenuItemSprite *button1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] target:self selector:@selector(button1Pressed)];
    
    // Button 1's label
    CCLabelTTF *button1Label = [CCLabelTTF labelWithString:@"Button 1 - AppWarp" fontName:@"Arial" fontSize:14];
    button1Label.position = ccp(button1.contentSize.width/2, button1.contentSize.height/2);
    button1Label.color = ccc3(0, 07, 0);
    [button1 addChild:button1Label];
    
    // Button 2 for real time menu
    CCMenuItemSprite *button2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] target:self selector:@selector(button2Pressed)];
    
    // Button 2's label
    CCLabelTTF *button2Label = [CCLabelTTF labelWithString:@"Button 2 - Hide RealTime" fontName:@"Arial" fontSize:14];
    button2Label.position = ccp(button2.contentSize.width/2, button1.contentSize.height/2);
    button2Label.color = ccc3(0, 0, 0);
    [button2 addChild:button2Label];
    
    // Initializing realTimeMenu, adding button1 and 2, setting align horizontally
    realTimeMenu = [CCMenuAdvancedPlus menuWithItems:button1, button2, nil];
    realTimeMenu.extraTouchPriority = 1;
    [realTimeMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    realTimeMenu.ignoreAnchorPointForPosition = NO;
    
    // Setting the position of the menu
    realTimeMenu.position = ccp(winSize.width/2, winSize.height/2);
    realTimeMenu.boundaryRect = CGRectMake(realTimeMenu.position.x - realTimeMenu.contentSize.width/2, realTimeMenu.position.y - realTimeMenu.contentSize.height/2, realTimeMenu.contentSize.width, realTimeMenu.contentSize.height);
    [realTimeMenu fixPosition];
    
    // Start invisible and disabled, add to self layer
    realTimeMenu.visible = NO;
    realTimeMenu.isDisabled = YES;
    [self addChild:realTimeMenu];
}

#pragma mark - App Warp Connections
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

-(void)onDisconnectDone:(ConnectEvent *)event {
    NSLog(@"AppWarp Connection Failed");
}

#pragma mark - Init Layer

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;
        
        // Setup layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuRealTimeLayer:self];
        
        [self setupRealTimeLayer];
    }
    return self;
}

#pragma  mark - Methods for layer

-(void) button1Pressed {
    // Build and Send a json packet to everyone in the room
    int time = (int)[[NSDate date] timeIntervalSince1970];
    NSMutableDictionary* jsonPacket = [NSMutableDictionary dictionary];
    [jsonPacket setObject:[PFUser currentUser].username forKey:@"sender"];
    [jsonPacket setObject:[NSNumber numberWithInt:time] forKey:@"time"];
    [jsonPacket setObject:[NSNumber numberWithInt:counter] forKey:@"counter"];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonPacket options:0 error:&error];
    NSLog(@"Sent %d - %d", counter, time);
    [[WarpClient getInstance]sendUpdatePeers:data];
    
    counter++;
}

-(void) button2Pressed {
    // Return to Main Menu
    [mainMenuUI showObjects];
    [self hideLayerAndObjects];
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    realTimeMenu.visible = NO;
    realTimeMenu.isDisabled = YES;
}

-(void) showLayerAndObjects {
    self.visible = YES;
    realTimeMenu.visible = YES;
    realTimeMenu.isDisabled = NO;
}

#pragma mark - dealloc

-(void) dealloc {
    [super dealloc];
}

@end
