//
//  TerritoryMenuItemSprite.m
//  GeoQuest
//
//  Created by Kelvin on 3/4/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "TerritoryMenuItemSprite.h"

@implementation TerritoryMenuItemSprite

-(void) setTerritories:(NSArray *)t {
    _territories = t;
    [_territories retain];
}

-(NSArray*) getTerritories {
    return _territories;
}

- (void)dealloc
{
    [_territories release];
    [super dealloc];
}

@end
