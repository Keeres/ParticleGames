//
//  CustomUserData.h
//  GeoQuest
//
//  Created by Kelvin on 5/18/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUserData : NSObject

@property BOOL isHost;
@property float countdownTimer;

-(id) initWithDictionary:(NSDictionary*)d;
-(NSDictionary*) dictionary;

@end
