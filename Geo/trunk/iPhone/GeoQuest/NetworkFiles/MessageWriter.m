//
//  MessageWriter.m
//  GeoQuest
//
//  Created by Kelvin on 1/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MessageWriter.h"

@implementation MessageWriter
@synthesize data = _data;

- (id)init {
    if ((self = [super init])) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)writeBytes:(void *)bytes length:(int)length {
    [_data appendBytes:bytes length:length];
}

- (void)writeByte:(unsigned char)value {
    [self writeBytes:&value length:sizeof(value)];
}

- (void)writeInt:(int)intValue {
    int value = htonl(intValue);
    [self writeBytes:&value length:sizeof(value)];
    //[self writeBytes:&intValue length:sizeof(intValue)];
}

- (void)writeString:(NSString *)value {
    const char * utf8Value = [value UTF8String];
    int length = strlen(utf8Value) + 1; // for null terminator
    [self writeInt:length];
    [self writeBytes:(void *)utf8Value length:length];
}

- (void)writePacketWithKeyword:(NSString *)keyword CRC:(int32_t)crc timeStamp:(int64_t)timeStamp gameState:(int8_t)gameState packetCounter:(int8_t)packetCounter dataSize:(int16_t)dataSize data:(NSString *)data {
    
    const char * keywordParticle = [keyword UTF8String];
    int keywordLength = strlen(keywordParticle);
    [self writeBytes:(void*)keywordParticle length:keywordLength];
    
    [self writeBytes:&crc length:sizeof(crc)];
    [self writeBytes:&timeStamp length:sizeof(timeStamp)];
    [self writeBytes:&gameState length:sizeof(gameState)];
    [self writeBytes:&packetCounter length:sizeof(packetCounter)];
    [self writeBytes:&dataSize length:sizeof(dataSize)];
    
    const char * utf8Value = [data UTF8String];
    int length = strlen(utf8Value);
    [self writeBytes:(void*)utf8Value length:length];
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

@end
