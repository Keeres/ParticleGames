#import "GameCharacter.h"
#import "Box2D.h"

@interface Box2DSprite : GameCharacter {
    b2Body *body;
    BOOL isTouchingGround;
}

@property (assign) b2Body *body;
@property BOOL isTouchingGround;

// Return TRUE to accept the mouse joint
// Return FALSE to reject the mouse joint
-(void) spawn:(CGPoint)location;
-(void) despawn;

@end
