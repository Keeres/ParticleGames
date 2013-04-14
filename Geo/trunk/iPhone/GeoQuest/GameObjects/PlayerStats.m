//
//  PlayerStats.m
//  GeoQuest
//
//  Created by Kelvin on 4/2/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "PlayerStats.h"
#import <Parse/PFObject+Subclass.h>

@implementation PlayerStats

@dynamic objectId;
@dynamic coins;
@dynamic player_id;
@dynamic selected_vehicle;
@dynamic territories;

+(NSString*) parseClassName {
    return @"PlayerStats";
}

@end
