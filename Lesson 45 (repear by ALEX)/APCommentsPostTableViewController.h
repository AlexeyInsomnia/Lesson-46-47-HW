//
//  APCommentsPostTableViewController.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 11.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol APCommentsPostDelegate;


@class APPost;

@interface APCommentsPostTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>


@property (weak, nonatomic) id <APCommentsPostDelegate> delegate;

@property (strong, nonatomic) APPost *post;


@property (weak, nonatomic) IBOutlet UIView *fakeFooterView;


- (IBAction)delCommentAction:(UIButton *)sender;


- (IBAction)likeAction:(UIButton *)sender;



@end

@protocol APCommentsPostDelegate <NSObject>

- (void)refreshPost;

@end
