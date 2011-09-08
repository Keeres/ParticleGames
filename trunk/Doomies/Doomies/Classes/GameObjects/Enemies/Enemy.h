//
//  Enemy.h
//  mushroom
//
//  Created by Kelvin on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "CommonProtocols.h"
#import "Box2DHelpers.h"

@interface Enemy : Box2DSprite {
    EnemyType type;
    float speed;
}

@property EnemyType type;
@property float speed;

@end
