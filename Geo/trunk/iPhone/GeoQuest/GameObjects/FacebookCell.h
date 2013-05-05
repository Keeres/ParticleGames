//
//  FacebookCell.h
//  GeoQuest
//
//  Created by Kelvin on 5/5/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookCell : UITableViewCell {
    NSString *text;
    
    UILabel *textLabel;
}

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) UILabel *textLabel;

@end
