//
//  TerritoryMenuItemSprite.h
//  GeoQuest
//
//  Created by Kelvin on 3/4/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CCMenuItem.h"

@interface TerritoryMenuItemSprite : CCMenuItemSprite {
    NSMutableArray *_territories;
}

-(void) setTerritories:(NSMutableArray*)t;
-(NSMutableArray*) getTerritories;

@end
