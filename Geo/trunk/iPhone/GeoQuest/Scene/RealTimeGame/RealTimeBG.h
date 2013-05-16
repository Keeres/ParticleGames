//
//  RealTimeBG.h
//  GeoQuest
//
//  Created by Kelvin on 5/16/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RealTimeBG.h"

@class RealTimeUI;

@interface RealTimeBG : CCLayer {
    CGSize              winSize;
    
    RealTimeUI          *_realTimeUI;
}

-(id) initWithRealTimeUILayer:(RealTimeUI*)realUI;

@end
