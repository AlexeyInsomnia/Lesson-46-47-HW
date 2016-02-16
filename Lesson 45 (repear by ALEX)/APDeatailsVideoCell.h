//
//  APDeatailsVideoCell.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 16.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface APDeatailsVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateUploadLabel;
@property (weak, nonatomic) IBOutlet YTPlayerView *youTubeView;
@property (weak, nonatomic) IBOutlet UILabel *nameVideoLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end


