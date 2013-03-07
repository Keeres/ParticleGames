//
//  ChallengerMenuItemSprite.h
//  GeoQuest
//
//  Created by Kelvin on 10/17/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChallengerMenuItemSprite : CCMenuItemSprite {
    NSString        *_ID;
    NSString        *_challenger;
    
    CCSprite        *_deleteSprite;
    CGRect          _deleteBoundaryRect;
    BOOL            _deleteActive;
    
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *challenger;
@property (nonatomic, retain) CCSprite *deleteSprite;
@property (assign) CGRect deleteBoundaryRect;
@property (assign) BOOL deleteActive;

//-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(NSNumber *)wins withLosses:(NSNumber *)losses;
-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(int)wins withLosses:(int)losses;

-(void) setupDeleteSprite;
-(void) showDeleteSprite;
-(void) hideDeleteSprite;

@end
