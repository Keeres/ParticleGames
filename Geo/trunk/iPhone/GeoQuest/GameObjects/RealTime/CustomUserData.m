//
//  CustomUserData.m
//  GeoQuest
//
//  Created by Kelvin on 5/18/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CustomUserData.h"

@implementation CustomUserData

@synthesize isHost;
@synthesize countdownTimer;

-(id) init {
    if ((self = [super init])) {
        self.isHost = NO;
        self.countdownTimer = 5;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary*)d {
    if ((self = [super init])) {
        self.isHost = [[d objectForKey:@"isHost"] boolValue];
        self.countdownTimer = [[d objectForKey:@"countdownTimer"] floatValue];
    }
    return self;
}

-(NSDictionary*) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.isHost], @"isHost", [NSNumber numberWithFloat:self.countdownTimer], @"countdownTimer", nil];
}

-(void) dealloc {
    [super dealloc];
}

@end
