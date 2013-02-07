//
//  NetworkController.m
//  GeoQuest
//
//  Created by Kelvin on 1/18/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "NetworkController.h"
#import "MessageWriter.h"
#import "NetworkPacket.h"
#import "Challenger.h"

@interface NetworkController (PrivateMethods)
- (BOOL)writeChunk;
@end

typedef enum {
    MessagePlayerConnected = 0,
    MessageNotInMatch,
} MessageType;


@implementation NetworkController
@synthesize gameCenterAvailable = _gameCenterAvailable;
@synthesize userAuthenticated = _userAuthenticated;
@synthesize delegate = _delegate;
@synthesize state = _state;
@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize inputOpened = _inputOpened;
@synthesize outputOpened = _outputOpened;
@synthesize outputBuffer = _outputBuffer;
@synthesize okToWrite = _okToWrite;
@synthesize inputBuffer = _inputBuffer;

#pragma mark - Helpers

static NetworkController *sharedController = nil;
+ (NetworkController *) sharedInstance {
    if (!sharedController) {
        sharedController = [[NetworkController alloc] init];
    }
    return sharedController;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)setState:(NetworkState)state {
    _state = state;
    if (_delegate) {
        [_delegate stateChanged:_state];
    }
}

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self setState:_state];
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (_gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)processMessage:(NSData *)data {
    // TODO: Process message
    NSLog(@"w00t got a message!  Implement me!");
}

#pragma mark - Message sending / receiving

- (void)sendData:(NSData *)data {
    if (_outputBuffer == nil) return;
    
    [_outputBuffer appendData:data];
    
    if (_okToWrite) {
        [self writeChunk];
        NSLog(@"Wrote message");
    } else {
        NSLog(@"Queued message");
    }
}

/*- (void)sendPlayerConnected:(BOOL)continueMatch {
 [self setState:NetworkStatePendingMatchStatus];
 
 MessageWriter * writer = [[[MessageWriter alloc] init] autorelease];
 //[writer writeByte:MessagePlayerConnected];
 //[writer writeString:[GKLocalPlayer localPlayer].playerID];
 //[writer writeString:[GKLocalPlayer localPlayer].alias];
 //[writer writeByte:continueMatch];
 NetworkPacket *packet = [[[NetworkPacket alloc] init] autorelease];
 
 packet.data = [NSString stringWithFormat:@"new test message"];
 packet.crc = 12345678;
 packet.timeStamp = 6789;
 packet.gameState = 254;
 packet.packetCounter = 1;
 packet.dataSize = packet.data.length;
 
 packet.crc = NSSwapHostIntToBig(packet.crc);
 packet.timeStamp = NSSwapHostLongLongToBig(packet.timeStamp);
 packet.dataSize = NSSwapHostShortToBig(packet.dataSize);
 
 [writer writePacketWithCRC:packet.crc timeStamp:packet.timeStamp gameState:packet.gameState packetCounter:packet.packetCounter dataSize:packet.dataSize data:packet.data];
 [self sendData:writer.data];
 }*/

-(void) sendPlayerInit {
    MessageWriter *writer = [[[MessageWriter alloc] init] autorelease];
    NetworkPacket *packet = [[[NetworkPacket alloc] init] autorelease];
    
    packet.particle = @"PARTICLE";
    packet.data = [GKLocalPlayer localPlayer].alias;
    packet.crc = 12345678;
    packet.timeStamp = 2345;
    //packet.crc = 0;
    //packet.timeStamp = 0;
    packet.gameState = PLAYER_INIT;
    packet.packetCounter = 1;
    packet.dataSize = packet.data.length;
    //packet.crc = crc32(0, packet.data, packet.data.length);
    
    [packet hostToBig];
    
    [writer writePacketWithKeyword:packet.particle CRC:packet.crc timeStamp:packet.timeStamp gameState:packet.gameState packetCounter:packet.packetCounter dataSize:packet.dataSize data:packet.data];
    [self sendData:writer.data];
}

-(void) requestPlayerHistory {
    MessageWriter *writer = [[[MessageWriter alloc] init] autorelease];
    NetworkPacket *packet = [[[NetworkPacket alloc] init] autorelease];
    
    packet.particle = @"PARTICLE";
    packet.data = @"Requesting Player History";
    packet.crc = 12345678;
    packet.timeStamp = 2345;
    packet.gameState = PLAYER_HISTORY;
    //packet.gameState = 1;
    packet.packetCounter = 1;
    packet.dataSize = packet.data.length;
    //packet.crc = crc32(0, packet.data, packet.data.length);
    
    [packet hostToBig];
    
    [writer writePacketWithKeyword:packet.particle CRC:packet.crc timeStamp:packet.timeStamp gameState:packet.gameState packetCounter:packet.packetCounter dataSize:packet.dataSize data:packet.data];
    [self sendData:writer.data];
}

#pragma mark - Server communication

- (void)connect {
    self.outputBuffer = [NSMutableData data];
    self.inputBuffer = [NSMutableData data];
    
    [self setState:NetworkStateConnectingToServer];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"finium.homedns.org", 80, &readStream, &writeStream);
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    _inputStream = (NSInputStream *)readStream;
    _outputStream = (NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (void)disconnect {
    
    [self setState:NetworkStateConnectingToServer];
    
    if (_inputStream != nil) {
        self.inputStream.delegate = nil;
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream close];
        self.inputStream = nil;
        self.inputBuffer = nil;
    }
    if (_outputStream != nil) {
        self.outputStream.delegate = nil;
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream close];
        self.outputStream = nil;
        self.outputBuffer = nil;
    }
}

- (void)reconnect {
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

- (void)checkForMessages {
#define PACKET_HEADER_SIZE 16
    NetworkPacket *newPacket = [[[NetworkPacket alloc] init] autorelease];
    
    NSString *packetKeyword = [[[NSString alloc] initWithBytes:self.inputBuffer.bytes length:8 encoding:NSUTF8StringEncoding] autorelease];
    newPacket.particle = packetKeyword;
    int amtRemaining = self.inputBuffer.length - 8;
    self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+8 length:amtRemaining] autorelease];
    CCLOG(@"Packet Keyword: %@", packetKeyword);
    
    
    if ([newPacket.particle isEqualToString:@"PARTICLE"]) {
        while (self.inputBuffer.length >= PACKET_HEADER_SIZE) {
            
            
            newPacket.crc = *(uint32_t*)[[self.inputBuffer subdataWithRange:NSMakeRange(0, 4)] bytes];
            amtRemaining = self.inputBuffer.length - 4;
            self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+4 length:amtRemaining] autorelease];
            
            newPacket.timeStamp = *(uint64_t*)[[self.inputBuffer subdataWithRange:NSMakeRange(0, 8)] bytes];
            amtRemaining = self.inputBuffer.length - 8;
            self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+8 length:amtRemaining] autorelease];
            
            newPacket.gameState = *(uint8_t*)[[self.inputBuffer subdataWithRange:NSMakeRange(0, 1)] bytes];
            amtRemaining = self.inputBuffer.length - 1;
            self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+1 length:amtRemaining] autorelease];
            
            newPacket.packetCounter = *(uint8_t*)[[self.inputBuffer subdataWithRange:NSMakeRange(0, 1)] bytes];
            amtRemaining = self.inputBuffer.length - 1;
            self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+1 length:amtRemaining] autorelease];
            
            newPacket.dataSize = *(uint16_t*)[[self.inputBuffer subdataWithRange:NSMakeRange(0, 2)] bytes];
            amtRemaining = self.inputBuffer.length - 2;
            self.inputBuffer = [[[NSMutableData alloc] initWithBytes:self.inputBuffer.bytes+2 length:amtRemaining] autorelease];
            
            NSString* stringData = [[[NSString alloc] initWithBytes:self.inputBuffer.bytes length:amtRemaining encoding:NSUTF8StringEncoding] autorelease];
            newPacket.data = stringData;
            amtRemaining = self.inputBuffer.length - amtRemaining;
            
            [newPacket bigToHost];
            
            if (amtRemaining == 0) {
                self.inputBuffer = [[[NSMutableData alloc] init] autorelease];
            }
            
            CCLOG(@"NetworkPacket.crc: %i", newPacket.crc);
            CCLOG(@"NetworkPacket.timestamp: %lli", newPacket.timeStamp);
            CCLOG(@"NetworkPacket.gamestate: %i", newPacket.gameState);
            CCLOG(@"NetworkPacket.packetcounter: %i", newPacket.packetCounter);
            CCLOG(@"NetworkPacket.datasize: %i", newPacket.dataSize);
            CCLOG(@"NetworkPacket.data: %@", newPacket.data);
        }
    }
    [self receivedPacket:newPacket];
}

- (void) receivedPacket:(NetworkPacket*)packet {
    uint8_t gameState = packet.gameState;
    
    switch (gameState) {
        case PLAYER_INIT:
            CCLOG(@"GameState: Player Initialized/Logged In Successfully");
            //PLAYER successfully logged in. Request player history.
            [self requestPlayerHistory];
            break;
        case PLAYER_CONNECTED:
            CCLOG(@"GameState: Player Connected Successfully.");
            //Send PLAYER_INIT
            [self sendPlayerInit];
            break;
        case PLAYER_DISCONNECTED:
            break;
        case PLAYER_TIMEOUT:
            break;
        case PLAYER_HISTORY:
            CCLOG(@" GameState: Player Requested History Successfully. Updating game list.");
            //Player successfully requested player history. Update games list.
            
            break;
        case PLAYER_SERVER_SETTINGS:
            break;
        case PLAYER_DATA_UPLOAD:
            break;
        case PLAYER_DATA_DOWNLOAD:
            break;
        case PLAYER_DATA_DELETE:
            break;
        case MATCH_INIT:
            break;
        case MATCH_SYNC:
            break;
        case MATCH_SEARCHING:
            break;
        case MATCH_NOTIFY:
            break;
        case MATCH_WAITING:
            break;
        case MATCH_TIMEOUT:
            break;
        case MATCH_READY:
            break;
        case MATCH_STARTED:
            break;
        case MATCH_END:
            break;
        case MATCH_RESTART:
            break;
        case MATCH_STATE_PLAYER:
            break;
        case MATCH_STATE_OPPOPNENT:
            break;
        case MATCH_RESULTS:
            break;
        case MATCH_FORCE_PEER:
            break;
        case MATCH_FORCE_RESET:
            break;
        case GAME_GENERATION_INIT:
            break;
        case GAME_DOWNLOAD_INIT:
            break;
        case GAME_QUESTION:
            break;
        case GAME_VERIFY:
            break;
        case GAME_TRANSFER_COMPLETE:
            break;
        case GAME_TRANSFER_RESET:
            break;
        case GAME_INFO:
            break;
        case GAME_DELETE:
            break;
        case GAME_HISTORY:
            break;
        case GAME_RESET:
            break;
        case GAME_DUMP:
            break;
        case REQUEST_MATCH_INFO:
            break;
        case REQUEST_PLAYER_SAVE_DATA:
            break;
        case REQUEST_PLAYER_INFO:
            break;
        case REQUEST_SESSION_INFO:
            break;
        case REQUEST_SERVER_STATS:
            break;
        case REQUEST_SERVER_GAME_POOL:
            break;
        case REQUEST_SERVER_INFO:
            break;
        case REQUEST_SERVER_DUMP:
            break;
            
        default:
            break;
    }
}

- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened input stream");
            _inputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                // TODO: Send message to server
                //[self sendPlayerConnected:true];
                //[self sendPlayerInit];
                
            }
        }
        case NSStreamEventHasBytesAvailable: {
            if ([_inputStream hasBytesAvailable]) {
                NSLog(@"Input stream has bytes...");
                // TODO: Read bytes
                NSInteger       bytesRead;
                uint8_t         buffer[32768];
                
                bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    NSLog(@"Network read error");
                } else if (bytesRead == 0) {
                    NSLog(@"No data read, reconnecting");
                    [self reconnect];
                } else {
                    NSLog(@"Read %d bytes", bytesRead);
                    [_inputBuffer appendData:[NSData dataWithBytes:buffer length:bytesRead]];
                    [self checkForMessages];
                }
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO); // should never happen for the input stream
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (BOOL)writeChunk {
    int amtToWrite = MIN(_outputBuffer.length, 65535+16);
    //int amtToWrite = _outputBuffer.length;
    if (amtToWrite == 0) return FALSE;
    
    NSLog(@"Amt to write: %d/%d", amtToWrite, _outputBuffer.length);
    
    int amtWritten = [self.outputStream write:_outputBuffer.bytes maxLength:amtToWrite];
    if (amtWritten < 0) {
        [self reconnect];
    }
    int amtRemaining = _outputBuffer.length - amtWritten;
    if (amtRemaining == 0) {
        self.outputBuffer = [NSMutableData data];
    } else {
        NSLog(@"Creating output buffer of length %d", amtRemaining);
        self.outputBuffer = [NSMutableData dataWithBytes:_outputBuffer.bytes+amtWritten length:amtRemaining];
    }
    NSLog(@"Wrote %d bytes, %d remaining.", amtWritten, amtRemaining);
    _okToWrite = FALSE;
    return TRUE;
}

- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened output stream");
            _outputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                // TODO: Send message to server
                //[self sendPlayerConnected:true];
                //[self sendPlayerInit];
            }
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"Ok to send");
            // TODO: Write bytes
            BOOL wroteChunk = [self writeChunk];
            if (!wroteChunk) {
                _okToWrite = TRUE;
            }
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (aStream == _inputStream) {
            [self inputStreamHandleEvent:eventCode];
        } else if (aStream == _outputStream) {
            [self outputStreamHandleEvent:eventCode];
        }
    });
}

#pragma mark - Authentication

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        [self setState:NetworkStateAuthenticated];
        _userAuthenticated = TRUE;
        [self connect];
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        _userAuthenticated = FALSE;
        [self setState:NetworkStateNotAvailable];
        [self disconnect];
    }
    
}

- (void)authenticateLocalUser {
    
    if (!_gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [self setState:NetworkStatePendingAuthentication];
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

@end