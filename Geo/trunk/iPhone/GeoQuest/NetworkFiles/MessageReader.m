//
//  MessageReader.m
//  GeoQuest
//
//  Created by Kelvin on 1/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MessageReader.h"

@implementation MessageReader

- (id)initWithData:(NSData *)data {
    if ((self = [super init])) {
        _data = [data retain];
        _offset = 0;
    }
    return self;
}

- (unsigned char)readByte {
    unsigned char retval = *((unsigned char *) (_data.bytes + _offset));
    _offset += sizeof(unsigned char);
    return retval;
}

- (int)readInt {
    int retval = *((unsigned int *) (_data.bytes + _offset));
    retval = ntohl(retval);
    _offset += sizeof(unsigned int);
    return retval;
}

- (NSString *)readString {
    int strLen = [self readInt];
    NSString *retval = [NSString stringWithCString:_data.bytes+_offset encoding:NSUTF8StringEncoding];
    _offset += strLen;
    return retval;
    
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

@end
