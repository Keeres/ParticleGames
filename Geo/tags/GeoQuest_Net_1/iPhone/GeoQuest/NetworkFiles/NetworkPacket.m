//
//  NetworkPacket.m
//  GeoQuest
//
//  Created by Kelvin on 1/21/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "NetworkPacket.h"


@implementation NetworkPacket
@synthesize particle = _particle;
@synthesize crc = _crc;
@synthesize timeStamp = _timeStamp;
@synthesize gameState = _gameState;
@synthesize packetCounter = _packetCounter;
@synthesize dataSize = _dataSize;
@synthesize data = _data;

-(id) init {
    if ((self = [super init])) {
        /*self.data = [NSString stringWithFormat:@"Hello Test message"];
        self.crc = 12345678;
        self.timeStamp = 6789;
        self.gameState = 5;
        self.packetCounter = 1;
        self.dataSize = self.data.length;*/
    }
    return self;
}

-(void) hostToBig {
    self.crc = NSSwapHostIntToBig(self.crc);
    self.timeStamp = NSSwapHostLongLongToBig(self.timeStamp);
    self.dataSize = NSSwapHostShortToBig(self.dataSize);
}

-(void) bigToHost {
    self.crc = NSSwapBigIntToHost(self.crc);
    self.timeStamp = NSSwapBigLongLongToHost(self.timeStamp);
    self.dataSize = NSSwapBigShortToHost(self.dataSize);
}

-(void) dealloc {
    self.data = nil;
    [super dealloc];
}

@end

/*
Generic Packet Definition
32 bit packet CRC (created by all enclosed data plus 64 bit secret unique passphrase) = 4
64 bit tzinfo timestamp (used by server for sanity check and prevent race conditions) = 8
8 bit game state (0 to 255) = 1
8 bit packet counter (0 to 255) = 1
16 bit data size (0 to 65535) = 2
data (max data 65535 bytes, or 64 kilobytes)
 */
