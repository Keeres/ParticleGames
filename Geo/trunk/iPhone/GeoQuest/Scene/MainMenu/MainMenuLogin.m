//
//  MainMenuLogin.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MainMenuLogin.h"

@implementation MainMenuLogin


-(void) setupLoginLayer {
    
    //[self setupTitle];
    [self setupRegisterLoginUserMenu];
    [self setupRegisterMenu];
    [self setupLoginMenu];
    
    [self checkIfLoggedIn];
}


-(void) setupRegisterLoginUserMenu {
    // Two button menu asking user to either register a new username or login with a previous username
    
    CCMenuItemSprite *registerButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                       target:self
                                                                     selector:@selector(registerUserFields)];
    
    CCLabelTTF *registerButtonLabel = [CCLabelTTF labelWithString:@"Create User" fontName:@"Arial" fontSize:14];
    registerButtonLabel.position = ccp(registerButton.contentSize.width/2, registerButton.contentSize.height/2);
    registerButtonLabel.color = ccc3(0, 0, 0);
    [registerButton addChild:registerButtonLabel];
    
    CCMenuItemSprite *loginButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                    target:self
                                                                  selector:@selector(loginUserFields)];
    CCLabelTTF *loginButtonLabel = [CCLabelTTF labelWithString:@"Login" fontName:@"Arial" fontSize:14];
    loginButtonLabel.position = ccp(loginButton.contentSize.width/2, loginButton.contentSize.height/2);
    loginButtonLabel.color = ccc3(0, 0, 0);
    [loginButton addChild:loginButtonLabel];
    
    registerLoginUserMenu = [CCMenuAdvancedPlus menuWithItems:registerButton, loginButton, nil];
    registerLoginUserMenu.extraTouchPriority = 1;
    
    [registerLoginUserMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    registerLoginUserMenu.ignoreAnchorPointForPosition = NO;
    registerLoginUserMenu.position = ccp(winSize.width/2, winSize.height/2);
    registerLoginUserMenu.boundaryRect = CGRectMake(registerLoginUserMenu.position.x - registerLoginUserMenu.contentSize.width/2, registerLoginUserMenu.position.y - registerLoginUserMenu.contentSize.height/2, registerLoginUserMenu.contentSize.width, registerLoginUserMenu.contentSize.height);
    
    [registerLoginUserMenu fixPosition];
    
    registerLoginUserMenu.isDisabled = YES;
    registerLoginUserMenu.visible = NO;
    [self addChild:registerLoginUserMenu];
}


-(void) setupRegisterMenu {
    // User selected to register a new username. This button is the "OK" button once user has entered the username/email/password
    
    CCMenuItemSprite *registerButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                       target:self
                                                                     selector:@selector(registerUser)];
    CCLabelTTF *registerButtonLabel = [CCLabelTTF labelWithString:@"Create" fontName:@"Arial" fontSize:14];
    registerButtonLabel.position = ccp(registerButton.contentSize.width/2, registerButton.contentSize.height/2);
    registerButtonLabel.color = ccc3(0, 0, 0);
    [registerButton addChild:registerButtonLabel];
    
    CCMenuItemSprite *cancelButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                       target:self
                                                                     selector:@selector(cancelRegisterAndLogin)];
    CCLabelTTF *cancelButtonLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
    cancelButtonLabel.position = ccp(cancelButton.contentSize.width/2, cancelButton.contentSize.height/2);
    cancelButtonLabel.color = ccc3(0, 0, 0);
    [cancelButton addChild:cancelButtonLabel];
    
    registerButtonMenu = [CCMenuAdvancedPlus menuWithItems:registerButton, cancelButton, nil];
    
    registerButtonMenu.extraTouchPriority = 1;
    
    [registerButtonMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    registerButtonMenu.ignoreAnchorPointForPosition = NO;
    registerButtonMenu.position = ccp(winSize.width/2, winSize.height/8);
    registerButtonMenu.boundaryRect = CGRectMake(registerButtonMenu.position.x - registerButtonMenu.contentSize.width/2, registerButtonMenu.position.y - registerButtonMenu.contentSize.height/2, registerButtonMenu.contentSize.width, registerButtonMenu.contentSize.height);
    
    [registerButtonMenu fixPosition];
    
    registerButtonMenu.isDisabled = YES;
    registerButtonMenu.visible = NO;
    [self addChild:registerButtonMenu];
}

-(void) setupLoginMenu {
    // User selected to login with a existing username. This button is the "OK" button once user has entered the username/password to login
    CCMenuItemSprite *loginButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                    target:self
                                                                  selector:@selector(loginUser)];
    
    CCLabelTTF *loginButtonLabel = [CCLabelTTF labelWithString:@"Login" fontName:@"Arial" fontSize:14];
    loginButtonLabel.position = ccp(loginButton.contentSize.width/2, loginButton.contentSize.height/2);
    loginButtonLabel.color = ccc3(0, 0, 0);
    [loginButton addChild:loginButtonLabel];
    
    CCMenuItemSprite *cancelButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"]
                                                                     target:self
                                                                   selector:@selector(cancelRegisterAndLogin)];
    CCLabelTTF *cancelButtonLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
    cancelButtonLabel.position = ccp(cancelButton.contentSize.width/2, cancelButton.contentSize.height/2);
    cancelButtonLabel.color = ccc3(0, 0, 0);
    [cancelButton addChild:cancelButtonLabel];
    
    loginButtonMenu = [CCMenuAdvancedPlus menuWithItems:loginButton, cancelButton, nil];
    
    loginButtonMenu.extraTouchPriority = 1;
    
    [loginButtonMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    loginButtonMenu.ignoreAnchorPointForPosition = NO;
    loginButtonMenu.position = ccp(winSize.width/2, winSize.height/8);
    loginButtonMenu.boundaryRect = CGRectMake(loginButtonMenu.position.x - loginButtonMenu.contentSize.width/2, loginButtonMenu.position.y - loginButtonMenu.contentSize.height/2, loginButtonMenu.contentSize.width, loginButtonMenu.contentSize.height);
    
    [loginButtonMenu fixPosition];
    
    loginButtonMenu.isDisabled = YES;
    loginButtonMenu.visible = NO;
    [self addChild:loginButtonMenu];
}

-(void) checkIfLoggedIn {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        CCLOG(@"MainMenuLogin: Currently logged in as %@", currentUser.username);
        self.visible = NO;
        [mainMenuUI setupPlayerDatabase];
    } else {
        registerLoginUserMenu.visible = YES;
        registerLoginUserMenu.isDisabled = NO;
    }
}


-(void) registerUserFields {
    CCLOG(@"LoadScreenUI: Register User");
    registerLoginUserMenu.visible = NO;
    registerLoginUserMenu.isDisabled = YES;
    registerButtonMenu.visible = YES;
    registerButtonMenu.isDisabled = NO;
    
    registerView = [[[UIView alloc] init] autorelease];
    registerView.frame = CGRectMake(0, 0, 320, 160);
    registerView.backgroundColor = [UIColor blackColor];
    
    //CGRect userFieldRect = CGRectMake(registerView.bounds.size.width/2, registerView.bounds.size.height/2, 150, 30);
    CGRect userFieldRect = CGRectMake(registerView.bounds.size.width/4, registerView.bounds.size.height/4, 150, 30);
    userField = [[[UITextField alloc] initWithFrame:userFieldRect] autorelease];
    userField.layer.anchorPoint = ccp(0.5, 0.5);
    userField.placeholder = @"Enter Username";
    userField.backgroundColor = [UIColor whiteColor];
    userField.font = [UIFont systemFontOfSize:14.0f];
    userField.borderStyle = UITextBorderStyleRoundedRect;
    userField.returnKeyType = UIReturnKeyNext;
    userField.textAlignment = UITextAlignmentCenter;
    userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [registerView addSubview:userField];
    
    CGRect emailFieldRect = CGRectMake(registerView.bounds.size.width/4, registerView.bounds.size.height/4 + 30, 150, 30);
    emailField = [[[UITextField alloc] initWithFrame:emailFieldRect] autorelease];
    emailField.placeholder = @"Enter E-mail";
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.font = [UIFont systemFontOfSize:14.0f];
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.returnKeyType = UIReturnKeyDefault;
    emailField.textAlignment = UITextAlignmentCenter;
    emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [registerView addSubview:emailField];
    
    CGRect pwFieldRect = CGRectMake(registerView.bounds.size.width/4, registerView.bounds.size.height/4 + 60, 150, 30);
    pwField = [[[UITextField alloc] initWithFrame:pwFieldRect] autorelease];
    pwField.placeholder = @"Enter Password";
    pwField.backgroundColor = [UIColor whiteColor];
    pwField.font = [UIFont systemFontOfSize:14.0f];
    pwField.borderStyle = UITextBorderStyleRoundedRect;
    pwField.returnKeyType = UIReturnKeyDefault;
    pwField.textAlignment = UITextAlignmentCenter;
    pwField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwField.secureTextEntry = YES;
    [registerView addSubview:pwField];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:registerView];
    wrapper.contentSize = CGSizeMake(320, 160);
    wrapper.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:wrapper];
}

-(void) loginUserFields {
    CCLOG(@"LoadScreenUI: Register User");
    registerLoginUserMenu.visible = NO;
    registerLoginUserMenu.isDisabled = YES;
    loginButtonMenu.visible = YES;
    loginButtonMenu.isDisabled = NO;
    
    registerView = [[[UIView alloc] init] autorelease];
    registerView.frame = CGRectMake(0, 0, 320, 160);
    registerView.backgroundColor = [UIColor blackColor];
    
    //CGRect userFieldRect = CGRectMake(registerView.bounds.size.width/2, registerView.bounds.size.height/2, 150, 30);
    CGRect userFieldRect = CGRectMake(registerView.bounds.size.width/4, registerView.bounds.size.height/4, 150, 30);
    userField = [[[UITextField alloc] initWithFrame:userFieldRect] autorelease];
    userField.layer.anchorPoint = ccp(0.5, 0.5);
    userField.placeholder = @"Enter Username";
    userField.backgroundColor = [UIColor whiteColor];
    userField.font = [UIFont systemFontOfSize:14.0f];
    userField.borderStyle = UITextBorderStyleRoundedRect;
    userField.returnKeyType = UIReturnKeyNext;
    userField.textAlignment = UITextAlignmentCenter;
    userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [registerView addSubview:userField];
    
    CGRect pwFieldRect = CGRectMake(registerView.bounds.size.width/4, registerView.bounds.size.height/4 + 30, 150, 30);
    pwField = [[[UITextField alloc] initWithFrame:pwFieldRect] autorelease];
    pwField.placeholder = @"Enter Password";
    pwField.backgroundColor = [UIColor whiteColor];
    pwField.font = [UIFont systemFontOfSize:14.0f];
    pwField.borderStyle = UITextBorderStyleRoundedRect;
    pwField.returnKeyType = UIReturnKeyDefault;
    pwField.textAlignment = UITextAlignmentCenter;
    pwField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwField.secureTextEntry = YES;
    [registerView addSubview:pwField];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:registerView];
    wrapper.contentSize = CGSizeMake(320, 160);
    wrapper.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:wrapper];
}

-(void) registerUser { // Need to check for duplicate user or email
    PFUser *user = [PFUser user];
    user.username = userField.text;
    user.password = pwField.text;
    user.email = emailField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Signed in
            //Load server territories, create player territories
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:user.username forKey:@"channels"];
            [currentInstallation saveInBackground];
            
            [mainMenuUI setupPlayerDatabase];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            CCLOG(@"MainMenuLogin: %@", errorString);
        }
    }];
}

-(void) loginUser{
    [PFUser logInWithUsernameInBackground:userField.text password:pwField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Logged in
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:user.username forKey:@"channels"];
            [currentInstallation saveInBackground];
            
            [mainMenuUI setupPlayerDatabase];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            CCLOG(@"MainMenuLogin: %@", errorString);
        }
    }];
}

-(void) cancelRegisterAndLogin {
    registerButtonMenu.visible = NO;
    loginButtonMenu.visible = NO;
    wrapper.visible = NO;
    registerLoginUserMenu.visible = YES;
    registerLoginUserMenu.isDisabled = NO;
}

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;

        // Setup layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuLoginLayer:self];

        [self setupLoginLayer];
    }
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [registerView endEditing:YES];
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    registerLoginUserMenu.visible = NO;
    registerButtonMenu.visible = NO;
    loginButtonMenu.visible = NO;
    wrapper.visible = NO;
    [mainMenuUI refreshObjects];
}

-(void) dealloc {
    [super dealloc];
}

@end
