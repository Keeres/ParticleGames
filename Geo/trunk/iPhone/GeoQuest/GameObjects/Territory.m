//
//  Territory.m
//  GeoQuest
//
//  Created by Kelvin on 2/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//


#import "Territory.h"

@implementation Territory

@synthesize ID = _ID;
@synthesize name = _name;
@synthesize question = _question;
@synthesize answer = _answer;
@synthesize continentOfCategory = _continentOfCategory;
@synthesize weeklyUsable = _weeklyUsable;
@synthesize ownerUsable = _ownerUsable;

-(id) init {
    if ((self = [super init])) {
        self.ID = nil;
        self.name = nil;
        self.question = nil;
        self.answer = nil;
        self.continentOfCategory = nil;
        self.weeklyUsable = NO;
        self.ownerUsable = NO;

    }
    return self;
}

-(id) initTerritory:(NSArray*)array {
    if ((self = [super init])) {
        self.ID = [array objectAtIndex:1];
        self.name = [array objectAtIndex:2];
        self.question = [array objectAtIndex:3];
        self.answer = [array objectAtIndex:4];
        self.continentOfCategory = [array objectAtIndex:5];
        self.weeklyUsable = [[array objectAtIndex:6] boolValue];
        self.ownerUsable = [[array objectAtIndex:7] boolValue];
    }
    return self;
}

-(id) initTerritoryWithID:(NSString *)ID
                     name:(NSString *)name
                 question:(NSString *)question
                   answer:(NSString *)answer
      continentOfCategory:(NSString *)continentOfCategory
             weeklyUsable:(BOOL)weelyUsable
              ownerUsable:(BOOL)ownerUsable {
    
    if ((self = [super init])) {
        self.ID = ID;
        self.name = name;
        self.question = question;
        self.answer = answer;
        self.continentOfCategory = continentOfCategory;
        self.weeklyUsable = weelyUsable;
        self.ownerUsable = ownerUsable;
    }
    
    return self;
}

-(void) dealloc {
    self.ID = nil;
    self.name = nil;
    self.question = nil;
    self.answer = nil;
    self.continentOfCategory = nil;
    
    [_ID release];
    [_name release];
    [_question release];
    [_answer release];
    [_continentOfCategory release];
    [super dealloc];
}

@end
