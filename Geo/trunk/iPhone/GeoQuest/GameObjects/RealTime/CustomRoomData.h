//
//  CustomRoomData.h
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomRoomData : NSObject {
    BOOL        _isLocked;
    NSString    *_password;
    float       _countdownTimer;
    int         _numPlayers;
}

@property (assign) BOOL isLocked;
@property (nonatomic, retain) NSString *password;
@property (assign) float countdownTimer;
@property (assign) int numPlayers;

-(id) initWithDictionary:(NSDictionary*)d;
-(NSDictionary*) dictionary;
-(NSString*) jsonString;

@end
