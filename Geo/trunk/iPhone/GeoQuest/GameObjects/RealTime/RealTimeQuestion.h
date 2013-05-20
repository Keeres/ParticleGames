//
//  RealTimeQuestion.h
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealTimeQuestion : NSObject

@property (nonatomic, retain) NSArray *territoryArray;
@property (nonatomic, retain) NSArray *questionArray;

-(id) initWithDictionary:(NSDictionary*)d;
-(NSDictionary*) dictionary;

@end