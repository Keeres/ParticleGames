//
//  PlayerStats.h
//  GeoQuest
//
//  Created by Kelvin on 4/2/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface PlayerStats : PFObject <PFSubclassing>

+(NSString*) parseClassName;

@property (nonatomic, retain) NSString *objectId;
@property int coins;
@property (nonatomic, retain) NSString *player_id;
@property (nonatomic, retain) NSString *selected_vehicle;
@property (nonatomic, retain) NSString *territories;
//@property (nonatomic, retain) NSArray *vehicles;

@end
