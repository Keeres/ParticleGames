//
//  Territory.h
//  GeoQuest
//
//  Created by Kelvin on 2/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ServerTerritories.h"

@interface Territory : NSObject {
    NSString    *_objectId;
    NSString    *_answer;
    NSString    *_continentOfCategory;
    NSString    *_name;
    NSString    *_question;
    BOOL        _usable;
    int         _level;
    int         _experience;
}

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *continentOfCategory;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *question;
@property BOOL usable;
@property int level;
@property int experience;

-(id) initTerritoryWithObjectId:(NSString*)objectId
                         answer:(NSString*)answer
            continentOfCategory:(NSString*)continentOfCategory
                           name:(NSString*)name
                       question:(NSString*)question
                         usable:(BOOL)usable
                          level:(int)level
                     experience:(int)experience;

-(id) initWithServerTerritory:(ServerTerritories*)s;

-(id) initWithDictionary:(NSDictionary*)d;

-(NSDictionary*) dictionary;

@end
