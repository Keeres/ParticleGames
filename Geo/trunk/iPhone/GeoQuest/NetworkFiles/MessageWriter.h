//
//  MessageWriter.h
//  GeoQuest
//
//  Created by Kelvin on 1/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MessageWriter : NSObject {
    NSMutableData * _data;
}

@property (retain, readonly) NSMutableData * data;

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeString:(NSString *)value;
- (void)writePacketWithKeyword:(NSString*)keyword CRC:(int32_t)crc timeStamp:(int64_t)timeStamp gameState:(int8_t)gameState packetCounter:(int8_t)packetCounter dataSize:(int16_t)dataSize data:(NSString*)data;

@end