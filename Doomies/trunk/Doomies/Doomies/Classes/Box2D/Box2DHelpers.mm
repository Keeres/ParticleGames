#import "Box2DHelpers.h"
#import "Box2DSprite.h"

bool isBodyCollidingWithObjectType(b2Body *body, GameObjectType objectType) {
    b2ContactEdge* edge = body->GetContactList();
    while (edge)
    {
        b2Contact* contact = edge->contact;
        if (contact->IsTouching()) {        
            b2Fixture* fixtureA = contact->GetFixtureA();
            b2Fixture* fixtureB = contact->GetFixtureB();
            b2Body *bodyA = fixtureA->GetBody();
            b2Body *bodyB = fixtureB->GetBody();
            Box2DSprite *spriteA = 
            (Box2DSprite *) bodyA->GetUserData();
            Box2DSprite *spriteB = 
            (Box2DSprite *) bodyB->GetUserData();
            if ((spriteA != NULL && 
                 spriteA.gameObjectType == objectType) ||
                (spriteB != NULL && 
                 spriteB.gameObjectType == objectType)) {
                    return true;
                }        
        }
        edge = edge->next;
    }    
    return false;
}

//may need to modify to include category and group
void setBodyMask(b2Body *body, uint16 maskBits){
    b2Filter tempFilter;
    for (b2Fixture *f = body->GetFixtureList(); f; f = f->GetNext()) {
        f->GetFilterData();
     //   tempFilter.categoryBits = kCategoryEnemy;
        tempFilter.maskBits = maskBits;
       // tempFilter.groupIndex = kGroupEnemy;
        f->SetFilterData(tempFilter);
    }
}