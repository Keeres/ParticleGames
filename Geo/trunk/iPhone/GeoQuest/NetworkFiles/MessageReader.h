//
//  MessageReader.h
//  GeoQuest
//
//  Created by Kelvin on 1/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageReader : NSObject {
    NSData * _data;
    int _offset;
}

- (id)initWithData:(NSData *)data;

- (unsigned char)readByte;
- (int)readInt;
- (NSString *)readString;

@end
