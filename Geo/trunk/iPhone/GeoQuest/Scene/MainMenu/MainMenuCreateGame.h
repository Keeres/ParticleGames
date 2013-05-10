//
//  MainMenuCreateGame.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuUI.h"
#import "GameManager.h"
#import "CCUIViewWrapper.h"
#import "PlayerDB.h"
#import "Challenger.h"
#import "Guid.h"
#import "ChallengesInProgress.h"
#import "FacebookCell.h"

@class MainMenuUI;

@interface MainMenuCreateGame : CCLayer <UITabBarControllerDelegate, UITabBarDelegate, FBFriendPickerDelegate, UIAlertViewDelegate> {
    CGSize              winSize;
    
    CCMenuAdvancedPlus  *createGameMenu;
    CCMenuAdvancedPlus  *findUserMenu;

    // Layers
    MainMenuUI          *mainMenuUI;
    
    // UIView
    CCUIViewWrapper     *wrapper;
    CCUIViewWrapper     *fbWrapper;
    UIView              *findUserView;
    UIViewController    *fbViewController;
    //UITabBarController  *fbViewController;
    UITabBarController  *testController;
    UITextField         *userField;
    
    NSArray *viewControllers;
    FBFriendPickerViewController *_friendPickerController;
    
    //Sprite
    CCSprite            *loadingImage;
    
    //Label
    CCLabelTTF          *errorMessage;
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) FBFriendPickerViewController *friendPickerController;


-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;


@end
