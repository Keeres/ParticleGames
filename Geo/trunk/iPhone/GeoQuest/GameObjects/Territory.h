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
    NSString *_territoryID;
    NSString *_name;
    NSString *_question;
    NSString *_answer;
    NSString *_continentOfCategory;
    NSString *_ownerUsable;
    NSString *_weeklyUsable;
}

@property (nonatomic, retain) NSString *territoryID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *continentOfCategory;
@property (nonatomic, retain) NSString *ownerUsable;
@property (nonatomic, retain) NSString *weeklyUsable;

-(id) initTerritory:(NSArray*)array;

@end
