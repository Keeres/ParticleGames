//
//  FacebookCell.m
//  GeoQuest
//
//  Created by Kelvin on 5/5/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "FacebookCell.h"

@implementation FacebookCell
@synthesize text;
@synthesize textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setText:(NSString*)t {
    if (![t isEqualToString:text]) {
        //text = [t copy];
        textLabel.text = t;
    }
}

-(void) dealloc {
    [text release];
    [textLabel release];
    [super dealloc];
}

@end
