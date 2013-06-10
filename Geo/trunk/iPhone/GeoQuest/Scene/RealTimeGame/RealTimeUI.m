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

@synthesize realTimeRoom = _realTimeRoom;
@synthesize gameState = _gameState;
@synthesize gameLayerState = _gameLayerState;
@synthesize updateReceiveDictionary = _updateReceivedDictionary;




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
    
    _notificationListener = [[[NotificationListener alloc] init] autorelease];
    [[WarpClient getInstance] addNotificationListener:_notificationListener];
    _notificationListener.realTimeUI = self;
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
        [self scheduleUpdate];
    }
    return self;
}




#pragma mark - Update

-(void) update:(ccTime)delta {
    [self checkState];
}

-(void) checkState {
    switch (self.gameState) {
        case kIdle: {
            break;
        }
        case kUpdateReceived: {
            int type = [[self.updateReceiveDictionary objectForKey:@"type"] intValue];
            switch (type) {
                case kCirclePopUp: {
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case kGameStart: {
            break;
        }
        case kLoadGameLayer: {
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - Dealloc
-(void) dealloc {
    self.realTimeRoom = nil;
    self.updateReceiveDictionary = nil;
    
    [_realTimeRoom release];
    [_updateReceivedDictionary release];
    
    [super dealloc];
}

@end
