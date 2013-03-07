//
//  Territory.h
//  GeoQuest
//
//  Created by Kelvin on 2/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Territory : NSObject {
    NSString    *_ID;
    NSString    *_name;
    NSString    *_question;
    NSString    *_answer;
    NSString    *_continentOfCategory;
    BOOL        _weeklyUsable;
    BOOL        _ownerUsable;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *continentOfCategory;
@property (assign) BOOL weeklyUsable;
@property (assign) BOOL ownerUsable;

-(id) initTerritory:(NSArray*)array;
-(id) initTerritoryWithID:(NSString*)ID
                     name:(NSString*)name
                 question:(NSString*)question
                   answer:(NSString*)answer
      continentOfCategory:(NSString*)continentOfCategory
             weeklyUsable:(BOOL)weelyUsable
              ownerUsable:(BOOL)ownerUsable;

@end
