//
//  ChallengerMenuItemSprite.m
//  GeoQuest
//
//  Created by Kelvin on 10/17/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "ChallengerMenuItemSprite.h"


@implementation ChallengerMenuItemSprite

@synthesize objectId = _objectId;
@synthesize player_id = _player_id;
@synthesize challenger_id = _challenger_id;
@synthesize deleteSprite = _deleteSprite;
@synthesize deleteBoundaryRect = _deleteBoundaryRect;
@synthesize deleteActive = _deleteActive;

-(id) init {
    if ((self = [super init])) {
        self.objectId = nil;
        self.player_id = nil;
        self.challenger_id = nil;
    }
    return self;
}

-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(int)wins withLosses:(int)losses {
    if ((self = [super init])) {
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"BlankButton.png"];
        background.anchorPoint = ccp(0.5, 1);
        [self addChild:background z:0];
        
        /*CCSprite *picture = [CCSprite spriteWithFile:@"Icon.png"];
        picture.scale = 0.8;
        picture.position = ccp(picture.contentSize.width/2, background.contentSize.height/2);
        [background addChild:picture z:1];*/
        
        /*CCLabelTTF *challengerName = [[CCLabelTTF alloc] initWithString:name fontName:@"Arial" fontSize:24];
        challengerName.color = ccc3(255, 0, 255);
        challengerName.position = ccp(background.contentSize.width/2, background.contentSize.height/2);
        [background addChild:challengerName z:2];*/
        
    }
    return self;
    
}

-(void) setupDeleteSprite {
    _deleteSprite = [CCSprite spriteWithSpriteFrameName:@"MainMenuCompass.png"];
    _deleteSprite.position = ccp(self.contentSize.width - _deleteSprite.contentSize.width/2, self.contentSize.height/2);
    _deleteSprite.visible = NO;
    _deleteBoundaryRect = CGRectMake(_deleteSprite.position.x - _deleteSprite.contentSize.width/2, _deleteSprite.position.y - _deleteSprite.contentSize.height/2, _deleteSprite.contentSize.width, _deleteSprite.contentSize.height);
    [self addChild:_deleteSprite];
}

-(void) showDeleteSprite {
    CCLOG(@"show delete");
    _deleteSprite.visible = YES;
    self.deleteActive = YES;
}

-(void) hideDeleteSprite {
    CCLOG(@"hide delete");
    _deleteSprite.visible = NO;
    self.deleteActive = NO;
}

- (void)dealloc
{
    self.objectId = nil;
    self.player_id = nil;
    self.challenger_id = nil;
    
    [_objectId release];
    [_player_id release];
    [_challenger_id release];
    [super dealloc];
}

@end
