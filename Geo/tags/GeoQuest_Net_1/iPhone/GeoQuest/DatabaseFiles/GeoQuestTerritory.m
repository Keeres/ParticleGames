//
//  GeoQuestTerritory.m
//  GeoQuest
//
//  Created by Kelvin on 1/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "GeoQuestTerritory.h"

@implementation GeoQuestTerritory


@synthesize territoryID = _territoryID;
@synthesize name = _name;
@synthesize questionTable = _questionTable;
@synthesize answerTable = _answerTable;

-(id) initWithTerritoryID:(NSString *)territoryID name:(NSString *)name questionTable:(NSString *)questionTable answerTable:(NSString *)answerTable {
    if ((self = [super init])) {
        self.territoryID = territoryID;
        self.name = name;
        self.questionTable = questionTable;
        self.answerTable = answerTable;
        
    }
    return self;
}

-(void) dealloc {
    self.territoryID = nil;
    self.name = nil;
    self.questionTable = nil;
    self.answerTable = nil;
    [super dealloc];
}


@end
