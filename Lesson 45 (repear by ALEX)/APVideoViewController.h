//
//  APVideoViewController.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 15.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APVideo.h"

@interface APVideoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APVideo *video;

@end

