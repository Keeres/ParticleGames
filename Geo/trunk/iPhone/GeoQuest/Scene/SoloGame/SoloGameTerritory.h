//
//  SoloGameTerritory.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "SoloGameUI.h"
#import "CCMenuAdvancedPlus.h"
#import "TerritoryMenuItemSprite.h"


@class SoloGameUI;

@interface SoloGameTerritory : CCLayer {
    CGSize              winSize;
    
    // Layers
    SoloGameUI          *soloGameUI;
    
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

-(id) initWithSoloGameUILayer:(SoloGameUI*)soloUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;




@end
