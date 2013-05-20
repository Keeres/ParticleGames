//
//  CustomRoomData.m
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CustomRoomData.h"

@implementation CustomRoomData

@synthesize isLocked;
@synthesize password;
@synthesize countdownTimer;
@synthesize numPlayers;

-(id) initWithDictionary:(NSDictionary*)d {
    if ((self = [super init])) {
        self.isLocked = [[d objectForKey:@"isLocked"] boolValue];
        self.password = [d objectForKey:@"password"];
        self.countdownTimer = [[d objectForKey:@"countdownTimer"] floatValue];
        self.numPlayers = [[d objectForKey:@"numPlayers"] intValue];
    }
    return self;
}

-(NSDictionary*) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.isLocked], @"isLocked", self.password, @"password", [NSNumber numberWithFloat:self.countdownTimer], @"countdownTime", [NSNumber numberWithInt:self.numPlayers], @"numPlayers", nil];
}

-(void) dealloc {
    [self.password release];
    [super dealloc];
}


@end
