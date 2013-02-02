//
//  CCMenu+Layout.h
//  GeoQuest
//
//  Created by Kelvin on 11/9/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"

@interface CCMenu (Layout)

- (void)alignItemsInGridWithPadding:(CGPoint)padding columns:(NSInteger)columns;

@end