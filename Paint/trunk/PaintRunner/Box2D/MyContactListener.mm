//
//  MyContactListener.m
//  Box2DPong
//
//  Created by Ray Wenderlich on 2/18/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "MyContactListener.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
    //We need to copy out the data because the b2Contact passed in
    //is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact* contact) {
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    b2Fixture *fixA = contact->GetFixtureA();
	b2Fixture *fixB = contact->GetFixtureB();
    
	b2Body *bodyA = fixA->GetBody();
	b2Body *bodyB = fixB->GetBody();
    
	CCNode *sprA = (CCNode*)bodyA->GetUserData();
	CCNode *sprB = (CCNode*)bodyB->GetUserData();
    
	if((sprA.tag == kPlayerType && sprB.tag == kPaintChipType) || 
       (sprA.tag == kPaintChipType && sprB.tag == kPlayerType)) {
        contact->SetEnabled(false);
	}
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}	

