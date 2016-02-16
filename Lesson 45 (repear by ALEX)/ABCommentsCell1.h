//
//  ABCommentsCell1.h
//  APIDZ-46
//
//  Created by Александр on 20.09.15.
//  Copyright © 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCommentsCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textWallLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *comments;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end
