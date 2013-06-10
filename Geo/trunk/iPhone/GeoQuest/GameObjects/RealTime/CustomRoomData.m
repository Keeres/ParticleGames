//
//  CustomRoomData.m
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CustomRoomData.h"

@implementation CustomRoomData

@synthesize isLocked = _isLocked;
@synthesize password = _password;
@synthesize countdownTimer = _countdownTimer;
@synthesize numPlayers = _numPlayers;

-(id) init {
    if ((self = [super init])) {
        self.isLocked = NO;
        self.password = @"";
        self.countdownTimer = 5;
        self.numPlayers = 1;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary*)d {
    if ((self = [super init])) {
        self.isLocked = [[d objectForKey:@"isLocked"] boolValue];
        self.password = [d objectForKey:@"password"];
        self.countdownTimer = (float)[[d objectForKey:@"countdownTimer"] floatValue];
        self.numPlayers = [[d objectForKey:@"numPlayers"] intValue];
    }
    return self;
}

-(NSDictionary*) dictionary {    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.isLocked], @"isLocked", self.password, @"password", [NSNumber numberWithFloat:self.countdownTimer], @"countdownTimer", [NSNumber numberWithInt:self.numPlayers], @"numPlayers", nil];
}

-(NSString*) jsonString {
    NSError *jsonError = nil;
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *string = [[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] autorelease];
    
    return string;
}


-(void) dealloc {
    self.password = nil;
    [_password release];
    [super dealloc];
}


@end
