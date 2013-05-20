//
//  RealTimeQuestion.m
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RealTimeQuestion.h"

@implementation RealTimeQuestion

-(id) initWithDictionary:(NSDictionary*)d {
    if ((self = [super init])) {
        NSError *jsonError = nil;

        NSString *territoryArrayString = [d objectForKey:@"territoryArray"];
        NSString *questionArrayString = [d objectForKey:@"questionArray"];
        
        self.territoryArray = [NSJSONSerialization JSONObjectWithData:[territoryArrayString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];

        self.questionArray = [NSJSONSerialization JSONObjectWithData:[questionArrayString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    }
    return self;
}

-(NSDictionary*) dictionary {
    NSError *jsonError = nil;
    
    NSData *territoryArrayJSON = [NSJSONSerialization dataWithJSONObject:self.territoryArray options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *territoryArrayString = [[[NSString alloc] initWithData:territoryArrayJSON encoding:NSUTF8StringEncoding] autorelease];
    
    NSData *questionArrayJSON = [NSJSONSerialization dataWithJSONObject:self.territoryArray options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *questionArrayString = [[[NSString alloc] initWithData:questionArrayJSON encoding:NSUTF8StringEncoding] autorelease];

    return [NSDictionary dictionaryWithObjectsAndKeys:territoryArrayString, @"territoryArray", questionArrayString, @"questionArray", nil];
}

-(void) dealloc {
    [self.territoryArray release];
    [self.questionArray release];
    [super dealloc];
}


@end
