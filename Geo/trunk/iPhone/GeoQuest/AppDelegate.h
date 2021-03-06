//
//  AppDelegate.h
//  GeoQuest
//
//  Created by Kelvin on 10/3/12.
//  Copyright Particle Games LLC 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "PlayerDB.h"
#import <FacebookSDK/FacebookSDK.h>


@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
