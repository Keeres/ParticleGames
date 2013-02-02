//
//  NetworkController.h
//  GeoQuest
//
//  Created by Kelvin on 1/18/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
    NetworkStateNotAvailable,
    NetworkStatePendingAuthentication,
    NetworkStateAuthenticated,
    NetworkStateConnectingToServer,
    NetworkStateConnected,
    NetworkStatePendingMatchStatus,
    NetworkStateReceivedMatchStatus,
} NetworkState;

@protocol NetworkControllerDelegate
- (void)stateChanged:(NetworkState)state;
@end

@interface NetworkController : NSObject <NSStreamDelegate> {
    //GameCenter
    BOOL _gameCenterAvailable;
    BOOL _userAuthenticated;
    id <NetworkControllerDelegate> _delegate;
    NetworkState _state;
    
    //Connecting to server
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    BOOL _inputOpened;
    BOOL _outputOpened;
    
    //Writing to server
    NSMutableData *_outputBuffer;
    BOOL _okToWrite;
    
    //Reading from server
    NSMutableData *_inputBuffer;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (assign) id <NetworkControllerDelegate> delegate;
@property (assign, readonly) NetworkState state;
@property (retain) NSInputStream *inputStream;
@property (retain) NSOutputStream *outputStream;
@property (assign) BOOL inputOpened;
@property (assign) BOOL outputOpened;
@property (retain) NSMutableData *outputBuffer;
@property (assign) BOOL okToWrite;
@property (retain) NSMutableData *inputBuffer;


+ (NetworkController *)sharedInstance;
- (void)authenticateLocalUser;

@end
