//
//  PlayerAction.m
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "PlayerAction.h"

@implementation PlayerAction


-(id) initWithDictionary:(NSDictionary*)d {
    if ((self = [super init])) {
        self.username = [d objectForKey:@"username"];
        self.isCorrect = [[d objectForKey:@"isCorrect"] boolValue];
        self.moveDistance = [[d objectForKey:@"moveDistance"] floatValue];
        self.powerUp = [d objectForKey:@"powerUp"];
        self.attackUsername = [d objectForKey:@"attackUsername"];
        self.isWinner = [[d objectForKey:@"isWinner"] boolValue];
    }
    return self;
}

-(NSDictionary*) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"username", [NSNumber numberWithBool:self.isCorrect], @"isCorrect", [NSNumber numberWithFloat:self.moveDistance], @"moveDistance", self.powerUp, @"powerUp", self.attackUsername, @"attackUsername", [NSNumber numberWithBool:self.isWinner], @"isWinner", nil];
}

-(void) dealloc {
    [self.username release];
    [self.powerUp release];
    [self.attackUsername release];
    [super dealloc];
}

@end
