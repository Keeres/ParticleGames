//
//  RealTimeRoom.m
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeRoom.h"

@implementation RealTimeRoom

-(void) setupRoom {
    // Button 1 for real time menu
    CCMenuItemSprite *button1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] target:self selector:@selector(button1Pressed)];
    
    // Button 1's label
    CCLabelTTF *button1Label = [CCLabelTTF labelWithString:@"Button 1 - Quick Game" fontName:@"Arial" fontSize:14];
    button1Label.position = ccp(button1.contentSize.width/2, button1.contentSize.height/2);
    button1Label.color = ccc3(0, 07, 0);
    [button1 addChild:button1Label];
    
    // Initializing realTimeMenu, adding buttons, setting align vertically
    realTimeMenu = [CCMenuAdvancedPlus menuWithItems:button1, nil];
    realTimeMenu.extraTouchPriority = 1;
    [realTimeMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    realTimeMenu.ignoreAnchorPointForPosition = NO;
    
    // Setting the position of the menu
    realTimeMenu.position = ccp(winSize.width/2, winSize.height/2);
    realTimeMenu.boundaryRect = CGRectMake(realTimeMenu.position.x - realTimeMenu.contentSize.width/2, realTimeMenu.position.y - realTimeMenu.contentSize.height/2, realTimeMenu.contentSize.width, realTimeMenu.contentSize.height);
    [realTimeMenu fixPosition];
    
    // Start invisible and disabled, add to self layer
    //realTimeMenu.visible = NO;
    //realTimeMenu.isDisabled = YES;
    [self addChild:realTimeMenu];

}



-(id) initWithRealTimeUILayer:(RealTimeUI *)realUI {
    if ((self = [super init])) {
        CCLOG(@"RealTimeRoom: Initialized");
        winSize = [[CCDirector sharedDirector] winSize];
        
        _realTimeUI = realUI;
        [self setupRoom];
    }
    return self;
}

-(void) button1Pressed {
    int time = (int)[[NSDate date] timeIntervalSince1970];
    NSMutableDictionary* jsonPacket = [NSMutableDictionary dictionary];
    [jsonPacket setObject:[PFUser currentUser].username forKey:@"sender"];
    [jsonPacket setObject:[NSNumber numberWithInt:time] forKey:@"time"];
    [jsonPacket setObject:[NSNumber numberWithInt:counter] forKey:@"counter"];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonPacket options:0 error:&error];
    NSLog(@"Sent %d - %d", counter, time);
    [[WarpClient getInstance]sendUpdatePeers:data];
}

-(void) dealloc {
    [super dealloc];
}

@end
