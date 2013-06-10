//
//  RealTimeRoom.m
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeRoom.h"

@implementation RealTimeRoom

@synthesize countdownTimer = _countdownTimer;




#pragma mark - Setup

-(void) setupRoom {
    [self setupTerritoryMenu];
    [self setupCountDown];
}

-(void) setupTerritoryMenu {
    _realTimeTerritoryMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    
    for (int i = 0; i < 2; i++) {
        CCMenuItemSprite *territoryButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton1.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] target:self selector:@selector(territoryButtonPressed:)];
        territoryButton.tag = i;
        [_realTimeTerritoryMenu addChild:territoryButton];
    }
    
    [_realTimeTerritoryMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    _realTimeTerritoryMenu.ignoreAnchorPointForPosition = NO;
    
    _realTimeTerritoryMenu.position = ccp(winSize.width/2, winSize.height/2);
    _realTimeTerritoryMenu.boundaryRect = CGRectMake(_realTimeTerritoryMenu.position.x - _realTimeTerritoryMenu.contentSize.width/2, _realTimeTerritoryMenu.position.y - _realTimeTerritoryMenu.contentSize.height/2, _realTimeTerritoryMenu.contentSize.width, _realTimeTerritoryMenu.contentSize.height);
    [_realTimeTerritoryMenu fixPosition];
    
    [self addChild:_realTimeTerritoryMenu];
    
}

-(void) setupCountDown {
    self.countdownTimer = COUNTDOWN_TIMER;
    _countdownTimerLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:30];
                                       
    _countdownTimerLabel.position = ccp(winSize.width/2, winSize.height*.8);
    _countdownTimerLabel.color = ccc3(255, 0, 0);
    [self addChild:_countdownTimerLabel];
    
}





#pragma mark - Init

-(id) initWithRealTimeUILayer:(RealTimeUI *)realUI {
    if ((self = [super init])) {
        
        CCLOG(@"RealTimeRoom: Initialized");
        winSize = [[CCDirector sharedDirector] winSize];
        
        _realTimeUI = realUI;
        [_realTimeUI setRealTimeRoom:self];
        
        [self setupRoom];
        [self scheduleUpdate];
    }
    return self;
}






#pragma mark - Update

-(void) update:(ccTime)delta {
    [_countdownTimerLabel setString:[NSString stringWithFormat:@"%0.0f", self.countdownTimer]];
    
    if (self.countdownTimer > 0.0) {
        if ((self.countdownTimer - delta) < 0.0) {
            self.countdownTimer = 0.0;
            [self hideLayerAndObjects];
            [self unscheduleUpdate];
        } else {
            self.countdownTimer -= delta;
        }
    }

}





#pragma mark - Methods

-(void) territoryButtonPressed:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: {
            int time = (int)[[NSDate date] timeIntervalSince1970];
            NSMutableDictionary* jsonPacket = [NSMutableDictionary dictionary];
            [jsonPacket setObject:[PFUser currentUser].username forKey:@"sender"];
            [jsonPacket setObject:[NSNumber numberWithInt:time] forKey:@"time"];
            [jsonPacket setObject:[NSNumber numberWithInt:counter] forKey:@"counter"];
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:jsonPacket options:0 error:&error];
            NSLog(@"Sent %d - %d", counter, time);
            [[WarpClient getInstance]sendUpdatePeers:data];
            break;
        }
        case 1: {
            break;
        }
            
        default:
            break;
    }
}

-(void) hideLayerAndObjects {
    _realTimeTerritoryMenu.visible = NO;
    self.visible = NO;
}




#pragma mark - dealloc

-(void) dealloc {
    [super dealloc];
}

@end
