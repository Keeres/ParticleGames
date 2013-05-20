//
//  MainMenuCreateGame.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MainMenuCreateGame.h"

@implementation MainMenuCreateGame
@synthesize friendPickerController = _friendPickerController;
@synthesize viewControllers;

-(void) setMainMenuUI:(MainMenuUI*)menuUI {
    mainMenuUI = menuUI;
}

-(void) setupCreateGameLayer {
    [self setupCreateGameMenu];
    [self setupFindUserMenu];
    [self setupFindUserField];
    [self setupFacebookView];
}

#pragma mark - Setup Menus and Buttons

-(void) setupCreateGameMenu {
    /*CCMenuItemSprite *quickGame = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(quickGame)];
    
    CCMenuItemSprite *findUser = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(findUser)];
    
    CCMenuItemSprite *findFriend = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(findFriend)];
    
    CCMenuItemSprite *cancel = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuMultiButton.png"] target:self selector:@selector(cancelGame)];*/
    
    errorMessage = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
    errorMessage.position = ccp(winSize.width/2, winSize.height * .75);
    errorMessage.visible = NO;
    [self addChild:errorMessage];
    
    createGameMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    for (int i = 0; i < 4; i++) {
        CCMenuItemSprite *createGameSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuButton2.png"] target:self selector:@selector(createGameMenuSelected:)];
        createGameSprite.tag = i;
        
        switch (i) {
            case 0: {
                CCLabelTTF *quickGameLabel = [CCLabelTTF labelWithString:@"Quick Game" fontName:@"Arial" fontSize:14];
                quickGameLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                quickGameLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:quickGameLabel];
                break;
            }
            case 1: {
                CCLabelTTF *findUserLabel = [CCLabelTTF labelWithString:@"Find User" fontName:@"Arial" fontSize:14];
                findUserLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                findUserLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:findUserLabel];
                break;
            }
            case 2: {
                CCLabelTTF *findFriendLabel = [CCLabelTTF labelWithString:@"Find Friend" fontName:@"Arial" fontSize:14];
                findFriendLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                findFriendLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:findFriendLabel];
                break;
            }
            case 3: {
                CCLabelTTF *cancelLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
                cancelLabel.position = ccp(createGameSprite.contentSize.width/2, createGameSprite.contentSize.height/2);
                cancelLabel.color = ccc3(0, 0, 0);
                [createGameSprite addChild:cancelLabel];
                break;
            }
                
                
            default:
                break;
        }
        
        [createGameMenu addChild:createGameSprite];
    }
    

    
    //createGameMenu = [CCMenuAdvancedPlus menuWithItems:quickGame, findUser, findFriend, cancel, nil];
    
    createGameMenu.extraTouchPriority = 1;
    
    [createGameMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    createGameMenu.ignoreAnchorPointForPosition = NO;
    createGameMenu.position = ccp(winSize.width/2, winSize.height/2);
    createGameMenu.boundaryRect = CGRectMake(createGameMenu.position.x - createGameMenu.contentSize.width/2, createGameMenu.position.y - createGameMenu.contentSize.height/2, createGameMenu.contentSize.width, createGameMenu.contentSize.height);
    
    [createGameMenu fixPosition];
    
    createGameMenu.isDisabled = YES;
    createGameMenu.visible = NO;
    [self addChild:createGameMenu];
    
}

-(void) setupFindUserMenu {
    findUserMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    
    for (int i = 0; i < 2; i++) {
        CCMenuItemSprite *findUserSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] target:self selector:@selector(findUserMenuSelected:)];
        findUserSprite.tag = i;
        
        switch (i) {
            case 0: {
                CCLabelTTF *findUserLabel = [CCLabelTTF labelWithString:@"Find User" fontName:@"Arial" fontSize:14];
                findUserLabel.position = ccp(findUserSprite.contentSize.width/2, findUserSprite.contentSize.height/2);
                findUserLabel.color = ccc3(0, 0, 0);
                [findUserSprite addChild:findUserLabel];
                break;
            }
            case 1: {
                CCLabelTTF *cancelLabel = [CCLabelTTF labelWithString:@"Cancel" fontName:@"Arial" fontSize:14];
                cancelLabel.position = ccp(findUserSprite.contentSize.width/2, findUserSprite.contentSize.height/2);
                cancelLabel.color = ccc3(0, 0, 0);
                [findUserSprite addChild:cancelLabel];
                break;
            }
                
                
            default:
                break;
        }
        
        [findUserMenu addChild:findUserSprite];
    }
    
    findUserMenu.extraTouchPriority = 1;
    [findUserMenu alignItemsVerticallyWithPadding:0.0 bottomToTop:NO];
    findUserMenu.ignoreAnchorPointForPosition = NO;
    findUserMenu.position = ccp(winSize.width/2, winSize.height*.25);
    findUserMenu.boundaryRect = CGRectMake(findUserMenu.position.x - findUserMenu.contentSize.width/2, findUserMenu.position.y - findUserMenu.contentSize.height/2, findUserMenu.contentSize.width, findUserMenu.contentSize.height);
    
    [findUserMenu fixPosition];
    
    findUserMenu.isDisabled = YES;
    findUserMenu.visible = NO;
    [self addChild:findUserMenu];

}

-(void) setupFindUserField {
    findUserView = [[[UIView alloc] init] autorelease];
    findUserView.frame = CGRectMake(0, 0, 320, 160);
    findUserView.backgroundColor = [UIColor blackColor];
    
    CGRect userFieldRect = CGRectMake(findUserView.bounds.size.width/4, findUserView.bounds.size.height/4, 150, 30);
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
    [findUserView addSubview:userField];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:findUserView];
    wrapper.contentSize = CGSizeMake(320, 160);
    wrapper.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:wrapper];
    
    wrapper.visible = NO;
}

-(void) setupFacebookView {
    self.friendPickerController = nil;
    
    fbViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    //fbViewController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    //fbViewController.delegate = self;
    fbWrapper = [CCUIViewWrapper wrapperForUIView:fbViewController.view];
    fbWrapper.contentSize = CGSizeMake(winSize.width, winSize.height);
    fbWrapper.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:fbWrapper];
    fbWrapper.visible = NO;
}

#pragma mark - Facebook Friend Picker

/*
 * Event: Error during data fetch
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}

/*
 * Event: Data loaded
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Friend data loaded.");
}

/*
 * Event: Decide if a given user should be displayed
 */
-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user{
    /*if ([friendPicker.title isEqualToString:@"Challenge Friends"]) {
        BOOL installed = [user objectForKey:@"installed"] != nil;
        return installed;
    } else {
        return 1;
    }*/
    return 1;
}


/*
 * Event: Selection changed
 */
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Current friend selections: %@", friendPicker.selection);
}

/*
 * Event: Done button clicked
 */
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerController = (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friends: %@", friendPickerController.selection);

    FBGraphObject *fbFriendSelection = [friendPickerController.selection objectAtIndex:0];
    
    PFQuery *fbFriendQuery = [PFUser query];
    [fbFriendQuery whereKey:@"facebookId" containsString:[fbFriendSelection objectForKey:@"id"]];
    [fbFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] > 0) {
                // Found Facebook friend in Parse database
                // Create Challenge and start playing game.
                PFUser *challenger = [objects objectAtIndex:0];
                [self createChallengeAgainstPlayer:challenger.username];
                
            } else {
                UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"Invite friend to Play!"
                                                                  message:@"Seems like your friend doesn't have a GeoCup account. Would you like to invite him to download GeoCup to play?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Okay"
                                                        otherButtonTitles:@"No",nil] autorelease];
                [message show];
                //[self sendFacebookInvite];
                
            }
        }
    }];
    
    // Dismiss the friend picker
    //[[sender presentingViewController] dismissModalViewControllerAnimated:YES];
    
    //[self cancelFacebookTable];
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    // Dismiss the friend picker
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
    
    [self cancelFacebookTable];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Okay"])
    {
        CCLOG(@"OK");
        //[self sendFacebookInvite];
    }
    else if([title isEqualToString:@"No"])
    {
        
    }
}

-(void) sendFacebookInvite {
    // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
    // It will first attempt to do this natively through iOS 6
    // If that's not supported we'll fall back to the web based dialog.
    
    /*UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"www.google.com"]];
    
    
    //bool bDisplayedDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:nil initialText:@"Check out my Test!" image:image url:url handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {}];
    //[FBNativeDialogs presentShareDialogModallyFrom:nil initialText:@"Checkout my TEST!" image:image url:url handler:^(FBNativeDialogResult result, NSError *error) {}];
    
    //if (!bDisplayedDialog)
    //{
        FBGraphObject *fbFriend = [self.friendPickerController.selection objectAtIndex:0];
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [fbFriend objectForKey:@"id"], @"to",
                                       @"Testing game feed!", @"name",
                                       @"This is a test message!", @"caption",
                                       [NSString stringWithFormat:@"I'm testing this feed!"], @"description",
                                       @"http://www.friendsmash.com/images/logo_large.jpg", @"picture",
                                       // Add the link param for Deep Linking
                                       [NSString stringWithFormat:@"www.google.com"], @"link",
                                       nil];
        
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     NSLog(@"User canceled story publishing.");
                 } else {
                     NSLog(@"Posted story");
                 }
             }}];
    //}*/
    
    FBGraphObject *fbFriend = [self.friendPickerController.selection objectAtIndex:0];
    CCLOG(@"%@", [fbFriend objectForKey:@"id"]);
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[fbFriend objectForKey:@"id"], @"to", nil];
    //NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100005824262665", @"to", nil];

    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:@"Testing the facebook message for App. Let me know what happens."]
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}];
}





#pragma mark - Init

-(id) initWithMainMenuUILayer:(MainMenuUI *)menuUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;
        
        // Setup Layers
        mainMenuUI = menuUI;
        [mainMenuUI setMainMenuCreateGameLayer:self];
        
        [self setupCreateGameLayer];
    }
    
    return self;
}

#pragma mark - Create Game Menu Buttons

-(void) createGameMenuSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: { // Quick Game
            CCLOG(@"MainMenuCreateGame: Selected Quick Game. Looking for challenger.");
            //[[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];
            [self sendFacebookInvite];
            break;
        }
        case 1: { // Find User
            CCLOG(@"MainMenuCreateGame: Selected Find User. Enter challenger's username.");
            [self showFindUserField];
            break;
        }
        case 2: { // Find Friend
            CCLOG(@"MainMenuCreateGame: Selected Find Friend. Select your friend.");
            //[self testFacebook];
            [self loadFacebookTable];
            break;
        }
        case 3: { // Cancel Menu
            CCLOG(@"MainMenuCreateGame: Create game menu canceled.");
            [self hideLayerAndObjects];
            [mainMenuUI showObjects];
            break;
        }
        default:
            break;
    }
}

-(void) showFindUserField {
    CCLOG(@"MainMenuCreateGame: Show find user field");
    createGameMenu.visible = NO;
    wrapper.visible = YES;
    findUserMenu.visible = YES;
    findUserMenu.isDisabled = NO;
}

-(void) loadFacebookTable {
    fbWrapper.visible = YES;
    
    /*if (fbFriendsArray != nil) {
        [fbFriendsArray release];
    }
    
    fbFriendsArray = [[NSMutableArray alloc] init];
    [fbTableView reloadData];
    
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSMutableArray *friendList = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
            NSArray *sortedFriendList = [self sortFacebookArray:friendList];
            [fbFriendsArray addObjectsFromArray:sortedFriendList];
            
            [fbTableView reloadData];
        }
    }];*/
    
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        
        // Set the friend picker delegate
        self.friendPickerController.delegate = self;
        
        self.friendPickerController.title = @"Select friends";
        self.friendPickerController.allowsMultipleSelection = NO;
    }
    
    //NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    //self.friendPickerController.fieldsForRequest = fields;
    
    [self.friendPickerController loadData];
    [self.friendPickerController presentModallyFromViewController:fbViewController animated:YES handler:nil];

}

/*-(NSArray*) sortFacebookArray:(NSMutableArray*)array {
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"first_name" ascending:YES] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    //return [NSMutableArray arrayWithArray:sortedArray];
    return sortedArray;
    
}*/

-(void) testFacebook {

    /*NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:@"Testing the facebook message for App. Let me know what happens."]
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}];
    */
    

    
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendList = [result objectForKey:@"data"];
            NSMutableArray *friendIdList = [NSMutableArray arrayWithObjects:nil];
            for (int i = 0; i < [friendList count]; i++) {
                NSDictionary *friend = [friendList objectAtIndex:i];
                //CCLOG(@"facebook username: %@ , %i", [friend objectForKey:@"id"], i);
                [friendIdList addObject:[friend objectForKey:@"id"]];
            }
            
            PFQuery *query = [PFUser query];
            [query whereKey:@"facebookId" containedIn:friendIdList];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if ([objects count] > 0) {
                        PFUser* foundUser = [objects objectAtIndex:0];
                        CCLOG(@"User found: %@", foundUser.username);
                        
                        // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
                        // It will first attempt to do this natively through iOS 6
                        // If that's not supported we'll fall back to the web based dialog.
                        
                        UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
                        
                        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"www.google.com"]];
                        
                        
                        bool bDisplayedDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:nil initialText:@"Check out my Test!" image:image url:url handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {}];
                        //[FBNativeDialogs presentShareDialogModallyFrom:nil initialText:@"Checkout my TEST!" image:image url:url handler:^(FBNativeDialogResult result, NSError *error) {}];
                        
                        if (!bDisplayedDialog)
                        {
                            // Put together the dialog parameters
                            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                           [foundUser objectForKey:@"facebookId"], @"to",
                                                           @"Testing game feed!", @"name",
                                                           @"This is a test message!", @"caption",
                                                           [NSString stringWithFormat:@"I'm testing this feed!"], @"description",
                                                           @"http://www.friendsmash.com/images/logo_large.jpg", @"picture",
                                                           // Add the link param for Deep Linking
                                                           [NSString stringWithFormat:@"www.google.com"], @"link",
                                                           nil];
                            
                            
                            // Invoke the dialog
                            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                                   parameters:params
                                                                      handler:
                             ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                 if (error) {
                                     NSLog(@"Error publishing story.");
                                 } else {
                                     if (result == FBWebDialogResultDialogNotCompleted) {
                                         NSLog(@"User canceled story publishing.");
                                     } else {
                                         NSLog(@"Posted story");
                                     }
                                 }}];
                        }
                    }
                }
            }];

        }
    }];
}

#pragma mark - Find User Menu Buttons

-(void) findUserMenuSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0: { //Find User selected
            CCLOG(@"MainMenuCreateGame: Find User");
            [self findUser];
            break;
        }
        case 1: { //Cancel Find User Menu
            [self showLayerAndObjects];
            wrapper.visible = NO;
            errorMessage.visible = NO;
            findUserMenu.visible = NO;
            findUserMenu.isDisabled = YES;
            break;
        }
            
        default:
            break;
    }
}

-(void) findUser {
    if ([userField.text isEqualToString:[PFUser currentUser].username]) {
        [errorMessage setString:@"Stop playing with yourself."];
        errorMessage.visible = YES;
        CCLOG(@"LoadScreenUI: Stop playing with yourself.");
        return;
    }
    
    int userFieldLength = userField.text.length;
    
    for (int i = 0; i < userFieldLength; i++) {
        unichar ch = [userField.text characterAtIndex:i];
        if (i == 0) {
            BOOL isLetter = (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
            if (!isLetter) {
                [errorMessage setString:@"First character needs to be a letter."];
                errorMessage.visible = YES;
                CCLOG(@"LoadScreenUI: First character needs to be a letter");
                return;
            }
        }
        BOOL isLetterAndNumber = (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9');
        if (!isLetterAndNumber) { // If a letter in username is not a-z or A-Z then get out of method
            [errorMessage setString:@"Only letters and numbers are allowed."];
            errorMessage.visible = YES;
            CCLOG(@"LoadScreenUI: Only letters and numbers are allowed.");
            return;
        }
    }
    
    [self createChallengeAgainstPlayer:userField.text];
    
    /*PFUser *currentUser = [PFUser currentUser];
    NSString *playerName = currentUser.username;
    ChallengesInProgress *challenge = [ChallengesInProgress object];
    challenge.player1_id = playerName;
    challenge.player1_last_played = @"";
    challenge.player1_next_race = @"";
    challenge.player1_prev_race = @"";
    challenge.player1_wins = 0;
    challenge.player2_id = userField.text;
    challenge.player2_last_played = @"";
    challenge.player2_next_race = @"";
    challenge.player2_prev_race = @"";
    challenge.player2_wins = 0;
    challenge.question = @"";
    challenge.turn = playerName;
    
    [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFQuery *player1StatQuery = [PlayerStats query];
        [player1StatQuery whereKey:@"player_id" equalTo:challenge.player1_id];
        player1StatQuery.cachePolicy = kPFCachePolicyNetworkOnly;
        
        PFQuery *player2StatQuery = [PlayerStats query];
        [player2StatQuery whereKey:@"player_id" equalTo:challenge.player2_id];
        player2StatQuery.cachePolicy = kPFCachePolicyNetworkOnly;
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:player1StatQuery, player2StatQuery, nil]];
        //PFQuery *query = [PFQuery queryWithClassName:@"PlayerStats"];
        //[query whereKey:@"player_id" containsAllObjectsInArray:@[challenge.player1_id, challenge.player2_id]];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *playerStatArray, NSError *error) {
            CCLOG(@"count:%i", [playerStatArray count]);
            PlayerStats *p1Stat = [playerStatArray objectAtIndex:0];
            PlayerStats *p2Stat = [playerStatArray objectAtIndex:1];
            
            if (![challenge.player1_id isEqualToString:p1Stat.player_id]) {
                PlayerStats *tempStat = p1Stat;
                p1Stat = p2Stat;
                p2Stat = tempStat;
            }
            
            [PlayerDB database].player1Stats = p1Stat;
            [PlayerDB database].player2Stats = p2Stat;
            [PlayerDB database].currentChallenge = challenge;
            [PlayerDB database].playerInPlayer1Column = [challenge.player1_id isEqualToString:[PFUser currentUser].username];
            [[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];
        }];
    }];*/

    
    /*PFQuery *player2StatQuery = [PlayerStats query];
    [player2StatQuery whereKey:@"player_id" equalTo:userField.text];
    [player2StatQuery findObjectsInBackgroundWithBlock:^(NSArray *player2StatArray, NSError *error) {
        
        PFQuery *player1StatQuery = [PlayerStats query];
        [player1StatQuery whereKey:@"player_id" equalTo:[PFUser currentUser].username];
        [player1StatQuery findObjectsInBackgroundWithBlock:^(NSArray *player1StatArray, NSError *error) {
            if ([player1StatArray count] > 0) {
                PlayerStats *p1Stat = [player1StatArray objectAtIndex:0];
                
                if ([player2StatArray count] > 0) {
                    PlayerStats *p2Stat = [player2StatArray objectAtIndex:0];
                    CCLOG(@"LoadScreenUI: username ok");
                    PFUser *currentUser = [PFUser currentUser];
                    NSString *playerName = currentUser.username;
                    ChallengesInProgress *challenge = [ChallengesInProgress object];
                    challenge.player1_id = playerName;
                    challenge.player1_last_played = @"";
                    challenge.player1_next_race = @"";
                    challenge.player1_prev_race = @"";
                    challenge.player1_wins = 0;
                    challenge.player2_id = userField.text;
                    challenge.player2_last_played = @"";
                    challenge.player2_next_race = @"";
                    challenge.player2_prev_race = @"";
                    challenge.player2_wins = 0;
                    challenge.question = @"";
                    challenge.turn = playerName;
                    
                    [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [PlayerDB database].player1Stats = p1Stat;
                        [PlayerDB database].player2Stats = p2Stat;
                        [PlayerDB database].currentChallenge = challenge;
                        //[PlayerDB database].gameGUID = challenge.objectId;
                        [PlayerDB database].playerInPlayer1Column = YES;
                        [[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];
                    }];
                }
            } else {
                CCLOG(@"MainMenuCreateGame: Can't find user");
            }
        }];
    }];*/
    
    /*Guid *randomGuid = [Guid randomGuid];
    NSString *guidString = [randomGuid stringValue];
    [randomGuid release];
    CCLOG(@"guidString: %@", guidString);
    
    // Search for user in server database. Retrieve challenger information.
    Challenger *challenger = [[Challenger alloc] initWithUserID:guidString name:userField.text email:@"" profilePic:@"VehicleVolvo.png" win:0 loss:0 matchStarted:@"" lastPlayed:@"" myTurn:YES playerPrevRaceData:@"" playerNextRaceData:@"" challengerPrevRaceData:@"" challengerNextRaceData:@"" questionData:@""];
    [[PlayerDB database] updatePlayerChallenger:challenger inPlayerChallengerDatabase:[PlayerDB database].username];
    
    Challenger *player = [[Challenger alloc] initWithUserID:guidString name:[PlayerDB database].username email:@"" profilePic:@"VehicleWhiteOwl.png" win:0 loss:0 matchStarted:@"" lastPlayed:@"" myTurn:NO playerPrevRaceData:@"" playerNextRaceData:@"" challengerPrevRaceData:@"" challengerNextRaceData:@"" questionData:@""];
    [[PlayerDB database] updatePlayerChallenger:player inPlayerChallengerDatabase:userField.text];
    
    [PlayerDB database].gameGUID = guidString;
    [PlayerDB database].challenger = userField.text;
    [challenger release];
    [player release];
    [[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];*/

}

-(void) createChallengeAgainstPlayer:(NSString*)challengerName {
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *playerName = currentUser.username;
    ChallengesInProgress *challenge = [ChallengesInProgress object];
    challenge.player1_id = playerName;
    challenge.player1_last_played = @"";
    challenge.player1_next_race = @"";
    challenge.player1_prev_race = @"";
    challenge.player1_wins = 0;
    challenge.player2_id = challengerName;
    challenge.player2_last_played = @"";
    challenge.player2_next_race = @"";
    challenge.player2_prev_race = @"";
    challenge.player2_wins = 0;
    challenge.question = @"";
    challenge.turn = playerName;
    
    PFQuery *player1StatQuery = [PlayerStats query];
    [player1StatQuery whereKey:@"player_id" equalTo:challenge.player1_id];
    player1StatQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    PFQuery *player2StatQuery = [PlayerStats query];
    [player2StatQuery whereKey:@"player_id" equalTo:challenge.player2_id];
    player2StatQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:player1StatQuery, player2StatQuery, nil]];
    
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *playerStatArray, NSError *error) {
        if ([playerStatArray count] == 2) {
            wrapper.visible = NO;
            [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                CCLOG(@"count:%i", [playerStatArray count]);
                
                PlayerStats *p1Stat = [playerStatArray objectAtIndex:0];
                PlayerStats *p2Stat = [playerStatArray objectAtIndex:1];
                
                if (![challenge.player1_id isEqualToString:p1Stat.player_id]) {
                    PlayerStats *tempStat = p1Stat;
                    p1Stat = p2Stat;
                    p2Stat = tempStat;
                }
                
                [PlayerDB database].player1Stats = p1Stat;
                [PlayerDB database].player2Stats = p2Stat;
                [PlayerDB database].currentChallenge = challenge;
                [PlayerDB database].playerInPlayer1Column = [challenge.player1_id isEqualToString:[PFUser currentUser].username];
                [[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];
            }];
        } else {
            [errorMessage setString:[NSString stringWithFormat:@"Player %@ not found.", challengerName]];
            errorMessage.visible = YES;
        }
    }];
}

/*-(void) quickGame {
    CCLOG(@"MainMenuUI: Selected Quick Game. Looking for challenger.");
    [[GameManager sharedGameManager] runSceneWithID:kAsyncGameScene];
}

-(void) findUser {
    CCLOG(@"MainMenuUI: Selected Find User. Enter challenger's username.");
}

-(void) findFriend {
    CCLOG(@"MainMenuUI: Selected Find Friend. Select your friend.");
}

-(void) cancelGame {
    [self hideLayerAndObjects];
    [mainMenuUI showObjects];
}*/

-(void) cancelFacebookTable {
    CCLOG(@"MainMenuCreateGame: Facebook Table canceled.");
    fbWrapper.visible = NO;
}

-(void) showLayerAndObjects {
    self.visible = YES;
    createGameMenu.visible = YES;
    createGameMenu.isDisabled = NO;
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    createGameMenu.visible = NO;
    errorMessage.visible = NO;
    //[mainMenuUI refreshObjects];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [findUserView endEditing:YES];
}

-(void) dealloc {

    _friendPickerController = nil;

    
    [fbViewController release];
    [viewControllers release];
    
    [self.friendPickerController release];

    
    [super dealloc];
}


@end
