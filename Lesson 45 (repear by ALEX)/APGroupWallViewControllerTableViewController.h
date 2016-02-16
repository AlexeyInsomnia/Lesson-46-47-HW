//
//  APGroupWallViewControllerTableViewController.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 05.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APUser.h"
#import "APPost.h"

@interface APGroupWallViewControllerTableViewController : UITableViewController

@property (strong, nonatomic) APUser* user;
@property (strong, nonatomic) APPost* wall;

- (IBAction)readMyMessagesAction:(UIButton *)sender;

@end
