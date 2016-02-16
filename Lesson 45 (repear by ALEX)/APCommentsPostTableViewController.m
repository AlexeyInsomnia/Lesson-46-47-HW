//
//  APCommentsPostTableViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 11.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APCommentsPostTableViewController.h"
#import "ABCommentsCell1.h"
#import "ABCommentsCell2.h"
#import "ABCommentsCell3.h"
#import "ABCommentsCell4.h"
#import "ABCommentsCell5.h"
#import "APPost.h"
#import "APPhoto.h"
#import "APUser.h"
#import "APGroup.h"
#import "APCommentsPost.h"
#import "APServerManager.h"
#import "UIImageView+AFNetworking.h"
//#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "UIScrollView+BottomRefreshControl.h"
#import "SLKTextViewController.h"
#import "SLKTextInputbar.h"
#import "SLKTextView.h"
#import "APGroupWallViewControllerTableViewController.h"
#import "APImages.h"

static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface APCommentsPostTableViewController ()

@property (strong, nonatomic) NSString *ownerId;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) UITextView *textViewComment;
@property (strong, nonatomic) UIBarButtonItem *senderButton;
@property (strong, nonatomic) UIButton *senderButtonCell;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIView *viewBar;
@property (nonatomic, readonly) SLKTextInputbar *textInputbar;
@property (nonatomic, strong) SLKTextView *textView;
@property (assign, nonatomic) CGFloat heightIfNoAttachment;

@property (assign, nonatomic) NSString *commentId;

@property (strong, nonatomic) UIButton *dellCommentButton;

@end

@implementation APCommentsPostTableViewController

static NSInteger countComments = 20;


#pragma mark - UITableViewDataSource

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textViewComment.delegate = self;
    
    [self refreshController];
    
    self.ownerId = @"-58860049";
    
    self.commentsArray = [NSMutableArray array];
    
    //[self initToolbarEndTextView];
    
    [self getCommentsFromServer];
    
    
}

- (void)refreshController {
    UIRefreshControl *refreshControlBottom = [[UIRefreshControl alloc] init];
    refreshControlBottom.triggerVerticalOffset = 100.;
    [refreshControlBottom addTarget:self action:@selector(refreshBottom:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControlBottom];
    self.tableView.bottomRefreshControl = refreshControlBottom;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.toolbar removeFromSuperview];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.tableView.contentInset = contentInsets;
    
    
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    //[self.tableView scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    CGRect rect = self.fakeFooterView.frame;
    rect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(rect, self.fakeFooterView.frame.origin)) {
        
        CGPoint scrollPoint = CGPointMake(0.0, self.fakeFooterView.frame.origin.y -(keyboardSize.height + self.fakeFooterView.frame.size.height));
        NSLog(@"scrollPoint = %f, %f", scrollPoint.x, scrollPoint.y);
        
        [self.tableView setContentOffset:scrollPoint animated:NO];
        //[self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    CGRect frame = self.toolbar.frame;
    
    frame.origin.y = self.parentViewController.view.frame.size.height - keyboardSize.height - self.toolbar.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    /*
     self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 190);
     NSIndexPath *indexPath =[NSIndexPath indexPathForRow:nIndex inSection:nSectionIndex];
     [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
     */
    
    //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    self.toolbar.frame = frame;
    
    //self.tableView.frame = rect;
    /*
     // Cette portion de code permet de remonter le scroll (à cause de la toolbar)
     if (![[AppKit sharedInstance] isIPad]) {
     CGRect tableFrame = self.tableView.frame;
     tableFrame.origin.y = tableFrame.origin.y - 50;
     self.tableView.frame = tableFrame;
     }
     */
    
    [UIView commitAnimations];
    
    // Action pour les keyboards
    //self.toolbarDoneButton.tag = 1;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect frame = self.toolbar.frame;
    frame.origin.y = self.parentViewController.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    
    self.toolbar.frame = frame;
    /*
     // Cette portion de code permet de rebaisser le scroll (à cause de la toolbar)
     if (![[AppKit sharedInstance] isIPad]) {
     CGRect tableFrame = self.tableView.frame;
     tableFrame.origin.y = tableFrame.origin.y + 50;
     self.tableView.frame = tableFrame;
     }
     */
    [UIView commitAnimations];
}

- (void)initToolBar {
    
    self.toolbar = [[UIToolbar alloc] init];
    
    self.toolbar.barStyle = UIBarStyleDefault;
    
    
    
    //Set the toolbar to fit the width of the app.
    [self.toolbar sizeToFit];
    
    
    
    //Caclulate the height of the toolbar
    
    CGFloat toolbarHeight = [self.toolbar frame].size.height;
    
    //Get the bounds of the parent view
    
    CGRect viewBounds = self.parentViewController.view.bounds;
    
    //Get the height of the parent view.
    
    CGFloat rootViewHeight = CGRectGetHeight(viewBounds);
    
    //Get the width of the parent view,
    
    CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
    
    //Create a rectangle for the toolbar
    
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
    
    //Reposition and resize the receiver
    
    [self.toolbar setFrame:rectArea];
    
    [self.navigationController.view addSubview:self.toolbar];
    
    self.textViewComment = [[UITextView alloc] init];
    
    self.textViewComment.frame = CGRectMake(20, 10, self.toolbar.frame.size.width - 80, 25);
    self.textViewComment.backgroundColor = [UIColor colorWithRed:235 green:215 blue:210 alpha:1];
    [self.toolbar addSubview:self.textViewComment];
    
    self.senderButton = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(senderAction)];
    self.senderButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:flex, self.senderButton, nil];
    [self.toolbar setItems: buttons animated:NO];
    
    
}


- (void)initToolbarEndTextView {
    
    //Initialize the toolbar
    // self.toolbar = [[UIToolbar alloc] init];
    
    //self.toolbar.frame = CGRectMake(0, 0, self.viewBar.frame.size.width, 44);
    
    
    //self.toolbar.frame = CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 44);
    
    // [self.viewBar addSubview:self.toolbar];
    /*
     self.textViewComment = [[UITextView alloc] init];
     
     self.textViewComment.frame = CGRectMake(20, 10, self.toolbar.frame.size.width - 80, 25);
     self.textViewComment.backgroundColor = [UIColor colorWithRed:235 green:215 blue:210 alpha:1];
     [self.toolbar addSubview:self.textViewComment];
     
     self.senderButton = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(senderAction)];
     self.senderButton.tintColor = [UIColor blackColor];
     
     UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     
     NSArray *buttons = [NSArray arrayWithObjects:flex, self.senderButton, nil];
     [self.toolbar setItems: buttons animated:NO];
     */
}

- (void)refreshBottom:(UIRefreshControl *)refreshControl {
    
    [self updateComments];
    
    [refreshControl endRefreshing];
}

- (void)updateComments {
    
    
   
    
    [[APServerManager sharedManager] getCommentsFromPostId:self.post.post_id ownerId:self.ownerId count:MAX(10, [self.commentsArray count]) offset:0 onSuccess:^(NSArray *array) {
        
        [self.commentsArray removeAllObjects];
        
        [self.commentsArray addObjectsFromArray:array];
        
        NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        [self.commentsArray sortUsingDescriptors:[NSArray arrayWithObject:date]];
        
        [self.tableView reloadData];
        
        //[self initToolbarEndTextView];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
}

#pragma mark - Actions

- (IBAction)delCommentAction:(UIButton *)sender {
    
    [[APServerManager sharedManager]deleteCommentFromPostId:self.commentId ownerId:self.ownerId onSuccess:^(NSArray *array) {
        
        if (array) {
            [self updateComments];
        }
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
}

- (void)tapGestureForButton:(UIButton *)sender {
    
    sender.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)];
    [sender addGestureRecognizer:recognizer];
    
}

- (void)onTapImageView:(UITapGestureRecognizer *)recognizer {
    
    UIImageView *imageView = (UIImageView *)[recognizer view];
    
    UITableViewCell *cell = (UITableViewCell *)[[imageView superview]superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        
        NSString *type = @"post";
        
        [[APServerManager sharedManager] addLikeFromObjectType:type ownerId:self.ownerId itemId:self.post.post_id  onSuccess:^(NSArray *array) {
            NSLog(@"like post");
            if (array) {
                
                [self.delegate refreshPost];
                
                [self requestPost];
            }
            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
        }];
        
    } else {
        
        NSString *type = @"comment";
        
        APCommentsPost *commentPost = [self.commentsArray objectAtIndex:indexPath.row];
        
        NSLog(@"commentId - %@", [NSString stringWithFormat:@"%@", commentPost.commentId]);
        
        
        [[APServerManager sharedManager] addLikeFromObjectType:type ownerId:self.ownerId itemId:commentPost.commentId onSuccess:^(NSArray *array) {
            
            if (array) {
                
                [self updateLikeCommentsForPaths:indexPath];
            }
            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
        }];
         
    }
}

- (void)updateLikeCommentsForPaths:(NSIndexPath *)indexPath {
    
    [[APServerManager sharedManager] getCommentsFromPostId:self.post.post_id ownerId:self.ownerId count:MAX(10, [self.commentsArray count]) offset:0 onSuccess:^(NSArray *array) {
        
        [self.commentsArray removeAllObjects];
        
        [self.commentsArray addObjectsFromArray:array];
        
        NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        [self.commentsArray sortUsingDescriptors:[NSArray arrayWithObject:date]];
        
        [self.tableView beginUpdates];
        
        NSArray* rowsTobeReloaded = [NSArray arrayWithObjects:indexPath, nil];
        
        [self.tableView reloadRowsAtIndexPaths:rowsTobeReloaded withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
}

- (IBAction)likeAction:(UIButton *)sender {
    
    [self tapGestureForButton:sender];
    
}

- (void)senderAction {
    
    [[APServerManager sharedManager] addCommentFromPostId:self.post.post_id ownerId:self.ownerId text:self.textViewComment.text onSuccess:^(NSArray *array) {
        
        [self updateComments];
        self.textViewComment.text = nil;
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
    
}


- (void)getCommentsFromServer {
    
    NSLog(@"post is, %@", self.post.text);
    NSLog(@"post id is %@", self.post.post_id);
    NSLog(@"self owner id is %@", self.ownerId);
    
    [[APServerManager sharedManager]
                    getCommentsFromPostId:self.post.post_id
                                  ownerId:self.ownerId
                                    count:countComments
                                   offset:[self.commentsArray count]
                                onSuccess:^(NSArray *array) {
                                    
                                    //NSLog(@"array comed to getCommentsFromServer - %@", array);
        
        [self.commentsArray addObjectsFromArray:array];
        
        NSMutableArray *newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.commentsArray count] - (int)[array count]; i < [self.commentsArray count]; i++) {
            
            [newPaths addObject:[NSIndexPath indexPathForItem:i inSection:1]];
        }
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.commentsArray count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier1 = @"ABCommentsCell1";
    
    static NSString *identifier2 = @"ABCommentsCell2";
    
    static NSString *identifier3 = @"ABCommentsCell3";
    
    static NSString *identifier4 = @"ABCommentsCell4";
    
    static NSString *identifier5 = @"ABCommentsCell5";
    
   // NSLog(@"*******************************************post is %@",self.post.text);
   // NSLog(@"*******************************************post PHOTO is %@",self.post.postImageURL);
   // NSLog(@"*******************************************post comments is %@",self.post.commentsCount);
   // NSLog(@"*******************************************post likes is %@",self.post.likesCount);
    
    if (indexPath.section == 0) {
        //if (self.post.postImageURL) {
            
            
            if( [self.post.attachment count] > 0) {
            ABCommentsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            
            if (self.post.from_user.firstName|| self.post.from_user.lastName) {
                cell.nameLabel.text = [NSString stringWithFormat:@"1st cell%@ %@", self.post.from_user.firstName, self.post.from_user.lastName];
            } else {
                cell.nameLabel.text = self.post.from_group.name ;
            }
                // make size of text rect
                
                CGRect rect = cell.textWallLabel.frame;
                rect.size.height = [self heightLabelOfTextForString:self.post.text fontSize:9.f widthLabel:CGRectGetWidth(rect)];
                cell.textWallLabel.frame = rect;

            cell.textWallLabel.text = self.post.text;
            
            cell.dateLabel.text = self.post.date;
            cell.likeLabel.text = self.post.likesCount;
            cell.comments.text = self.post.commentsCount;
            
            NSURLRequest *request = [NSURLRequest requestWithURL:self.post.photo];
            
            __weak ABCommentsCell1 *weakCell = cell;
            
            cell.photoView.image = nil;
            
            [cell.photoView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                               weakCell.photoView.image = image;
                                               //[weakCell layoutSubviews];
                                           } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                               
                                           }];
            
            NSURLRequest *requestAvatar = nil;
            
                if (self.post.from_user.photo_100) {
                    requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_user.photo_100]];
                } else {
                    requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_group.photo_200]];
                }
            
            __weak ABCommentsCell1 *weakAvatarCell = cell;
            
            cell.avatar.image = nil;
            
            [cell.avatar setImageWithURLRequest:requestAvatar
                               placeholderImage:nil
                                        success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                            weakAvatarCell.avatar.image = image;
                                            //[weakAvatarCell layoutSubviews];
                                            CALayer *imageLayer = weakAvatarCell.avatar.layer;
                                            [imageLayer setCornerRadius:30];
                                            [imageLayer setMasksToBounds:YES];
                                        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                            
                                        }];
            
            
                
                CGPoint point = CGPointZero;
                
                if (![self.post.text isEqualToString:@""]) {
                    point = CGPointMake(CGRectGetMinX(cell.textWallLabel.frame),CGRectGetMaxY(cell.textWallLabel.frame));
                } else {
                    point = CGPointMake(CGRectGetMinX(cell.avatar.frame),CGRectGetMaxY(cell.avatar.frame));
                }
                
                APImages *galery = [[APImages alloc]initWithImageArray:self.post.attachment startPoint:point];
                //galery.delegate = self;
                //galery.tag = 11;
                
                [cell addSubview:galery];
                
                
                
            
            return cell;
            
        } else {
            
            ABCommentsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            
            if (self.post.from_user.firstName|| self.post.from_user.lastName) {
                cell.nameLabel.text = [NSString stringWithFormat:@"2nd CELL %@ %@", self.post.from_user.firstName, self.post.from_user.lastName];
            } else {
                cell.nameLabel.text = self.post.from_group.name ;
            }
            // make size of text rect
            
            CGRect rect = cell.textWallLabel.frame;
            rect.size.height = [self heightLabelOfTextForString:self.post.text fontSize:9.f widthLabel:CGRectGetWidth(rect)];
            cell.textWallLabel.frame = rect;
            self.heightIfNoAttachment = rect.size.height;
            
            cell.textWallLabel.text = self.post.text;
            
            cell.dateLabel.text = self.post.date;
            cell.likeLabel.text = self.post.likesCount;
            
            
            cell.comments.text = self.post.commentsCount;
            

 
            NSURLRequest *requestAvatar = nil;
            
            
 
            if (self.post.from_user.photo_100) {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_user.photo_100]];
            } else {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_group.photo_200]];
            }
 
            __weak ABCommentsCell2 *weakAvatarCell = cell;
 
            cell.avatar.image = nil;
 
            [cell.avatar setImageWithURLRequest:requestAvatar
                               placeholderImage:nil
                                        success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                            weakAvatarCell.avatar.image = image;
                                            //[weakAvatarCell layoutSubviews];
                                            CALayer *imageLayer = weakAvatarCell.avatar.layer;
                                            [imageLayer setCornerRadius:30];
                                            [imageLayer setMasksToBounds:YES];
                                        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                            
                                        }];
            
            return cell;
        }
        
        
    } else {
        
        APCommentsPost *comments = [self.commentsArray objectAtIndex:indexPath.row];
        
        if ([comments.type isEqualToString:@"link"]) {
            ABCommentsCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
            
            
            if (comments.user.firstName || comments.user.lastName) {
                cell.nameLabel.text = [NSString stringWithFormat:@"4d cell %@ %@", comments.user.firstName, comments.user.lastName];
            } else {
                cell.nameLabel.text = self.post.from_group.name;
            }
            cell.textCommentsLabel.text = comments.text;
            cell.titleLabel.text = comments.titleLink;
            cell.urlLabel.text = comments.urlLink;
            cell.descriptionLabel.text = comments.descriptionLink;
            cell.dateLabel.text = comments.date;
            cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)comments.likesCount];
            
    
            
            
   
            
            NSURLRequest *requestAvatar = nil;
            
   
            
            if (comments.user.photo_100) {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:comments.user.photo_100]];
            } else {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_group.photo_200]];
            }
            
            __weak ABCommentsCell4 *weakAvatarCell = cell;
            
            cell.avatar.image = nil;
            
            [cell.avatar setImageWithURLRequest:requestAvatar
                               placeholderImage:nil
                                        success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                            weakAvatarCell.avatar.image = image;
                                            //[weakAvatarCell layoutSubviews];
                                            CALayer *imageLayer = weakAvatarCell.avatar.layer;
                                            [imageLayer setCornerRadius:30];
                                            [imageLayer setMasksToBounds:YES];
                                        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                            
                                        }];
            
            NSURLRequest *requestPhotoLink = [NSURLRequest requestWithURL:comments.photoLink];
            
            __weak ABCommentsCell4 *weakPhotoCell = cell;
            
            cell.photoImage.image = nil;
            
            [cell.photoImage setImageWithURLRequest:requestPhotoLink
                                   placeholderImage:nil
                                            success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                                weakPhotoCell.photoImage.image = image;
                                                [weakPhotoCell layoutSubviews];
                                            } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                                
                                            }];
            
            cell.delCommentButton.hidden = YES;
            
            return cell;
            
        } else if ([comments.type isEqualToString:@"photo"]) {
            ABCommentsCell5 *cell = [tableView dequeueReusableCellWithIdentifier:identifier5];
            
            if (comments.user.firstName || comments.user.lastName) {
                cell.nameLabel.text = [NSString stringWithFormat:@"5d cell %@ %@", comments.user.firstName, comments.user.lastName];
            } else {
                cell.nameLabel.text = self.post.from_group.name;
            }
            cell.textCommentsLabel.text = comments.text;
            cell.dateLabel.text = comments.date;
            cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)comments.likesCount];
            
            NSURLRequest *requestAvatar = nil;
            
            
            if (comments.user.photo_100) {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:comments.user.photo_100]];
            } else {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_group.photo_200]];
            }

            
            __weak ABCommentsCell5 *weakAvatarCell = cell;
            
            cell.avatar.image = nil;
            
            [cell.avatar setImageWithURLRequest:requestAvatar
                               placeholderImage:nil
                                        success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                            weakAvatarCell.avatar.image = image;
                                            //[weakAvatarCell layoutSubviews];
                                            CALayer *imageLayer = weakAvatarCell.avatar.layer;
                                            [imageLayer setCornerRadius:30];
                                            [imageLayer setMasksToBounds:YES];
                                        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                            
                                        }];
            
            NSURLRequest *requestPhotoLink = [NSURLRequest requestWithURL:comments.photoLink];
            
            __weak ABCommentsCell5 *weakPhotoCell = cell;
            
            cell.photoImage.image = nil;
            
            [cell.photoImage setImageWithURLRequest:requestPhotoLink
                                   placeholderImage:nil
                                            success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                                weakPhotoCell.photoImage.image = image;
                                                //[weakPhotoCell layoutSubviews];
                                            } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                                
                                            }];
            
            cell.delCommentButton.hidden = YES;
            
            return cell;
            
        } else {
 
            ABCommentsCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            
            
            if (comments.user.firstName || comments.user.lastName) {
                cell.nameLabel.text = [NSString stringWithFormat:@"3d cell %@ %@", comments.user.firstName, comments.user.lastName];
            } else {
                cell.nameLabel.text = self.post.from_group.name;
            }
            
            // make size of text rect
            
            CGRect rect = cell.textCommentsLabel.frame;
            rect.size.height = [self heightLabelOfTextForString:self.post.text fontSize:9.f widthLabel:CGRectGetWidth(rect)];
            cell.textCommentsLabel.frame = rect;
            self.heightIfNoAttachment = rect.size.height;

            
            cell.textCommentsLabel.text = comments.text;
            cell.dateLabel.text = comments.date;
            cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)comments.likesCount];
            
            NSURLRequest *requestAvatar = nil;
            
            if (comments.user.photo_100) {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:comments.user.photo_100]];
            } else {
                requestAvatar = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.post.from_group.photo_200]];
            }
            
            __weak ABCommentsCell3 *weakAvatarCell = cell;
            
            cell.avatar.image = nil;
            
            [cell.avatar setImageWithURLRequest:requestAvatar
                               placeholderImage:nil
                                        success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                            weakAvatarCell.avatar.image = image;
                                            [weakAvatarCell layoutSubviews];
                                            CALayer *imageLayer = weakAvatarCell.avatar.layer;
                                            [imageLayer setCornerRadius:30];
                                            [imageLayer setMasksToBounds:YES];
                                        } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                            
                                        }];
            
            cell.delCommentButton.hidden = YES;
            
            return cell;
        }
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return 60.0f;
    }
    else {
        
        return 10.0f;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return self.fakeFooterView;
    }
    
    else {
        
        return nil;
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1300;
    
    //return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        APPost *post = self.post;
        
        float height = 0;
        
        if (![post.text isEqualToString:@""]) {
            height = height + (int)[self heightLabelOfTextForString:post.text fontSize:9.f widthLabel:300];
        }
        
        if ([post.attachment count] > 0) {
            
            height = height + 250;
        }
        
        return 46 + 10 + height+10+20;
    }
    
    else  if (indexPath.section  == 1){
        
        
        
        return self.heightIfNoAttachment+30;
        
    }
 
    return self.heightIfNoAttachment+30;
    
    //return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        
        APCommentsPost *commentPost = [self.commentsArray objectAtIndex:indexPath.row];
        
        self.commentId = commentPost.commentId;
        
        ABCommentsCell3 *cellSelected3 = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected3.delCommentButton.hidden = NO;
        
        ABCommentsCell4 *cellSelected4 = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected4.delCommentButton.hidden = NO;
        
        ABCommentsCell5 *cellSelected5 = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected5.delCommentButton.hidden = NO;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        ABCommentsCell3 *cellSelected = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected.delCommentButton.hidden = YES;
        
        ABCommentsCell4 *cellSelected4 = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected4.delCommentButton.hidden = YES;
        
        ABCommentsCell5 *cellSelected5 = [tableView cellForRowAtIndexPath: indexPath];
        
        cellSelected5.delCommentButton.hidden = YES;
    }
}

//request of object from a wall
- (void)requestPost {
    NSString *posts = [NSString stringWithFormat:@"-58860049_%@", self.post.post_id];
    
    
    [[APServerManager sharedManager] getWallById:posts onSuccess:^(id result) {
        self.post = result;
        
        NSLog(@"TEST!!!");
        
        if (result) {
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
    

}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
    
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [self textViewShouldEndEditing:self.textViewComment];
}

#pragma mark - TextImageConfigure

- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageFrames.count;
    CGRect newFrames[N];
    
    float ideal_height = MAX(frameSize.height, frameSize.width) / N;
    float seq[N];
    float total_width = 0;
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[APPhoto class]]) {
            APPhoto *image = [imageFrames objectAtIndex:i];
            CGSize size = CGSizeMake(image.width, image.height);
            
            CGSize newSize = CGSizeResizeToHeight(size, ideal_height);
            
            newFrames[i] = (CGRect) {{0, 0}, newSize};
            seq[i] = newSize.width;
            total_width += seq[i];
            
        } else if ([[imageFrames objectAtIndex:i] isKindOfClass:[APVideo class]]) {
            
            CGSize size = CGSizeMake(320, 240);
            CGSize newSize = CGSizeResizeToHeight(size, ideal_height);
            newFrames[i] = (CGRect) {{0, 0}, newSize};
            seq[i] = newSize.width;
            total_width += seq[i];
        }
        
        
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}

- (CGRect)heightTextView:(UITextView *)view {
    
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    if (newSize.height > 200) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth),150);
    } else {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    }
    
    return newFrame;
}

- (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width {
    
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, paragraph, NSParagraphStyleAttributeName,shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes
                                        context:nil];
    
    return rect.size.height+24;
}


@end
