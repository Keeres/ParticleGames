//
//  ServerTerritories.h
//  GeoQuest
//
//  Created by Kelvin on 4/1/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface ServerTerritories : PFObject <PFSubclassing>

+(NSString*) parseClassName;

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *continent_of_category;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *uuid;
@property BOOL *weekly_usable;

@end
