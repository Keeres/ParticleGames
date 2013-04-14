//
//  ServerTerritories.m
//  GeoQuest
//
//  Created by Kelvin on 4/1/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "ServerTerritories.h"
#import <Parse/PFObject+Subclass.h>

@implementation ServerTerritories

@dynamic objectId;
@dynamic answer;
@dynamic continentOfCategory;
@dynamic name;
@dynamic question;
@dynamic usable;

+(NSString*) parseClassName {
    return @"ServerTerritories";
}

@end
    