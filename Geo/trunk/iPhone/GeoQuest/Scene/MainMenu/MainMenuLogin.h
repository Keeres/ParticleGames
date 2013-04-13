//
//  MainMenuLogin.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuUI.h"
#import "CCMenuAdvancedPlus.h"
#import "CCUIViewWrapper.h"
#import <Parse/Parse.h>

@class MainMenuUI;

@interface MainMenuLogin : CCLayer {
    CGSize              winSize;
    
    CCMenuAdvancedPlus  *registerLoginUserMenu;
    CCMenuAdvancedPlus  *registerButtonMenu;
    CCMenuAdvancedPlus  *loginButtonMenu;
    
    //Layers
    MainMenuUI          *mainMenuUI;
    
    // UIView
    CCUIViewWrapper     *wrapper;
    UIView              *registerView;
    UITextField         *userField;
    UITextField         *emailField;
    UITextField         *pwField;
    
}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI;
-(void) checkIfLoggedIn;
-(void) hideLayerAndObjects;

@end
