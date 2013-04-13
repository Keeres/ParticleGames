//
//  CCUIViewWrapper.h
//  GeoQuest
//
//  Created by Kelvin on 2/13/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
	UIView *uiItem;
	float rotation;
}
@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;

- (id) initForUIView:(UIView*)ui;
- (void) updateUIViewTransform;
@end