//
//  ABCommentsCell5.h
//  APIDZ-46
//
//  Created by Александр on 25.09.15.
//  Copyright © 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCommentsCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *delCommentButton;

@end
