//
//  APVideoTableViewCell.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 15.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface APVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

