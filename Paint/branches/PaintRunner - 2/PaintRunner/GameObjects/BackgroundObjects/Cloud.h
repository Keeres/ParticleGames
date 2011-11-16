//
//  Cloud.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

typedef enum {
    cloud = 0,
    cloud_Max,
} CloudTypes;

@interface Cloud : GameObject {
    CloudTypes cloudType;
    float speedPercentage;
}

@property (readwrite) float speedPercentage;

-(id) initWithCloudType:(CloudTypes)cloudWithType;
-(void) despawn;

@end
