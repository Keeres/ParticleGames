//  GameCharacter.h
//  SpaceViking

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
    int characterHealth;
    CharacterStates characterState;
}

-(void)checkAndClampSpritePosition; 

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState; 
@end
