//
//  NetworkPacket.h
//  GeoQuest
//
//  Created by Kelvin on 1/21/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkPacket : NSObject {
    NSString *_particle;
    uint32_t _crc;
    uint64_t _timeStamp;
    uint8_t  _gameState;
    uint8_t  _packetCounter;
    uint16_t _dataSize;
    NSString *_data;
}

@property (nonatomic, retain) NSString *particle;
@property (assign) uint32_t crc;
@property (assign) uint64_t timeStamp;
@property (assign) uint8_t gameState;
@property (assign) uint8_t packetCounter;
@property (assign) uint16_t dataSize;
@property (nonatomic, retain) NSString *data;

-(void) hostToBig;
-(void) bigToHost;

@end
