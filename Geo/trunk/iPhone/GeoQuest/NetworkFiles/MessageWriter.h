//
//  MessageWriter.h
//  GeoQuest
//
//  Created by Kelvin on 1/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageWriter : NSObject {
    NSMutableData * _data;
}

@property (retain, readonly) NSMutableData * data;

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeString:(NSString *)value;

@end