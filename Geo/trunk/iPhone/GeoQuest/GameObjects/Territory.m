//
//  Territory.m
//  GeoQuest
//
//  Created by Kelvin on 2/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//


#import "Territory.h"

@implementation Territory

@synthesize territoryID = _territoryID;
@synthesize name = _name;
@synthesize question = _question;
@synthesize answer = _answer;
@synthesize continentOfCategory = _continentOfCategory;
@synthesize ownerUsable = _ownerUsable;
@synthesize weeklyUsable = _weeklyUsable;

-(id) init {
    if ((self = [super init])) {
        self.territoryID = nil;
        self.name = nil;
        self.question = nil;
        self.answer = nil;
        self.continentOfCategory = nil;
        self.ownerUsable = nil;
        self.weeklyUsable = nil;
    }
    return self;
}

-(id) initTerritory:(NSArray*)array {
    if ((self = [super init])) {
        self.territoryID = [array objectAtIndex:1];
        self.name = [array objectAtIndex:2];
        self.question = [array objectAtIndex:3];
        self.answer = [array objectAtIndex:4];
        self.continentOfCategory = [array objectAtIndex:5];
        self.weeklyUsable = [array objectAtIndex:6];
    }
    return self;
}

-(void) dealloc {
    self.territoryID = nil;
    self.name = nil;
    self.question = nil;
    self.answer = nil;
    self.continentOfCategory = nil;
    self.ownerUsable = nil;
    self.weeklyUsable = nil;
    [super dealloc];
}

@end
