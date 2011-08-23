#import "Box2D.h"
#import "CommonProtocols.h"

bool isBodyCollidingWithObjectType(b2Body *body, 
                                   GameObjectType objectType);

void setBodyMask(b2Body *body, uint16 maskBits);