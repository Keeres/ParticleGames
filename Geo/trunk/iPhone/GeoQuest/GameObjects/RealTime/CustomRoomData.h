//
//  CustomRoomData.h
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomRoomData : NSObject

@property BOOL isLocked;
@property (nonatomic, retain) NSString *password;
@property float countdownTimer;
@property int numPlayers;

-(id) initWithDictionary:(NSDictionary*)d;
-(NSDictionary*) dictionary;

@end
