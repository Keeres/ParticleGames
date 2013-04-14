//
//  Territory.m
//  GeoQuest
//
//  Created by Kelvin on 2/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//


#import "Territory.h"

@implementation Territory
@synthesize objectId = _objectId;
@synthesize answer = _answer;
@synthesize continentOfCategory = _continentOfCategory;
@synthesize name = _name;
@synthesize question = _question;
@synthesize usable = _usable;
@synthesize level = _level;
@synthesize experience = _experience;

-(id) initTerritoryWithObjectId:(NSString *)objectId
                         answer:(NSString *)answer
            continentOfCategory:(NSString *)continentOfCategory
                           name:(NSString *)name
                       question:(NSString *)question
                         usable:(BOOL)usable
                          level:(int)level
                     experience:(int)experience {
    if ((self = [super init])) {
        self.objectId = objectId;
        self.answer = answer;
        self.continentOfCategory = continentOfCategory;
        self.name = name;
        self.question = question;
        self.usable = usable;
        self.level = level;
        self.experience = experience;
    }
    return self;
}

-(id) initWithServerTerritory:(ServerTerritories *)s {
    if ((self = [super init])) {
        self.objectId = s.objectId;
        self.answer = s.answer;
        self.continentOfCategory = s.continentOfCategory;
        self.name = s.name;
        self.question = s.question;
        self.usable = s.usable;
        self.level = 1;
        self.experience = 0;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary *)d {
    if ((self = [super init])) {
        self.objectId = [d objectForKey:@"objectId"];
        self.answer = [d objectForKey:@"answer"];
        self.continentOfCategory = [d objectForKey:@"continentOfCategory"];
        self.name = [d objectForKey:@"name"];
        self.question = [d objectForKey:@"question"];
        self.usable = [[d objectForKey:@"usable"] boolValue];
        self.level = [[d objectForKey:@"level"] integerValue];
        self.experience = [[d objectForKey:@"experience"] integerValue];
    }
    return self;
}

-(NSDictionary*) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.objectId, @"objectId", self.answer, @"answer", self.continentOfCategory, @"continentOfCategory", self.name, @"name", self.question, @"question", [NSNumber numberWithBool:self.usable], @"usable", [NSNumber numberWithInt:self.level], @"level", [NSNumber numberWithInt:self.experience], @"experience", nil];
}

-(void) dealloc {
    self.objectId = nil;
    self.answer = nil;
    self.continentOfCategory = nil;
    self.name = nil;
    self.question = nil;
    
    [_objectId release];
    [_answer release];
    [_continentOfCategory release];
    [_name release];
    [_question release];
    [super dealloc];
}

@end
