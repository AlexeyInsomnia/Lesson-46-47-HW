//
//  APDeatailsVideoCell.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 16.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APDeatailsVideoCell.h"

@implementation APDeatailsVideoCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    _youTubeView = nil;
}

@end
