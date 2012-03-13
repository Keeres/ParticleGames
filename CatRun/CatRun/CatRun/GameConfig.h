//
//  GameConfig.h
//  CatRun
//
//  Created by Kelvin on 3/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController


#endif // __GAME_CONFIG_H