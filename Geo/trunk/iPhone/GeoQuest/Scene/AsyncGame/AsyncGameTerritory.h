//
//  AsyncGameTerritory.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "AsyncGameUI.h"
#import "CCMenuAdvancedPlus.h"
#import "TerritoryMenuItemSprite.h"


@class AsyncGameUI;

@interface AsyncGameTerritory : CCLayer {
    CGSize              winSize;
    
    // Layers
    AsyncGameUI          *asyncGameUI;
    
    // CCSprites
    //CCSprite            *difficultyBackground;
    //CCSprite            *difficultyDisplay;
    //CCSprite            *selectDifficulty;
    
    // CCMenus
    //CCMenuAdvanced      *difficultyChoiceMenu;
    CCMenuAdvancedPlus      *territoryChoiceMenu;
    
    // Arrays
    NSMutableArray      *territoriesChosen; //array of all the territories usable by player


    // Variables
    int                 difficultyChoice;

    
}

-(id) initWithAsyncGameUILayer:(AsyncGameUI*)asyncUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;




@end
