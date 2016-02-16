//
//  APGroupWallViewControllerTableViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 05.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//


#import "APGroupWallViewControllerTableViewController.h"
#import "APServerManager.h"
#import "APPostCell.h"
#import "APAddPostTableViewCell.h"
#import "APAddPostViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APVideo.h"
#import "APPhoto.h"
#import "APImages.h"
#import "APPostTextToUserViewController.h"
#import "APMyMessages.h"
#import "APMyMessagesTableViewController.h"
#import "APVideosViewController.h"
#import "APCommentsPostTableViewController.h"
#import "APGroup.h"


static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface APGroupWallViewControllerTableViewController () <APImageDelegate, APCommentsPostDelegate>
//@interface APGroupWallViewControllerTableViewController () <APImageDelegate>

@property (strong, nonatomic) NSMutableArray* postsArray;

@property (assign, nonatomic) BOOL firstTimeAppear;

@property (strong,nonatomic) NSMutableArray *imageViewSize;


@property (strong, nonatomic) NSString* testTest;

@property (strong,nonatomic) APGroup *group;


@end

static NSInteger postsInRequest = 20;

const static NSInteger contsPostImageWidth = 320;

@implementation APGroupWallViewControllerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.postsArray = [NSMutableArray array];
    
    self.firstTimeAppear = YES;
    
     self.imageViewSize = [[NSMutableArray alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // делаем возможность обновления записей (тянем вниз все посты)
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //делаем кнопку для запуска видео стены
    UIBarButtonItem* plus =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                  target:self
                                                  action:@selector(postOnWall:)];
    
    self.navigationItem.rightBarButtonItem = plus;
    
    // делаем кнопку чтения личных сообщений
    
 
    
    

}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    // запустится только один раз
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[APServerManager sharedManager] authorizeUser:^(APUser *user) {
            
    

            
            NSLog(@"AUTHORIZED!");
            //NSLog(@"%@ %@", user.firstName, user.lastName);
            
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) postOnWall:(id) sender {
    
    NSLog(@"start of videoviewcontroller");
    
    [[APServerManager sharedManager]getGroupById:@"58860049" onSuccess:^(APGroup *group) {
        self.group = group;
        
        
        /*
        self.navigationItem.title = group.name;
        [self.tableView reloadData];
        //self.loadingData = NO;
        //[self getPostsFromServer];
        
        [UIView animateWithDuration:0.8f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.tableView.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            
        }];
        */
        
        
    } onFailure:^(NSError *error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        APVideosViewController* vc = [[APVideosViewController alloc] init];
        
        vc.group =self.group;
        
        
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nv animated:YES completion:nil];
    });
    
    
    /*
    
    [[APServerManager sharedManager]
     postText:@"Это тест из урока номер 47!"
     onGroupWall:@"58860049"
     onSuccess:^(id result) {
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
     }];
     
     */
}

- (void) lichkaPost:(id) sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    APPost* post = [self.postsArray objectAtIndex:indexPath.row];
    
    NSLog(@"lichka is - %@", post.from_id);
    
    
    
    if (![post.from_id hasPrefix:@"-"]) {
        
        
        APPostTextToUserViewController* vc = [[APPostTextToUserViewController alloc] init];
        vc.userID = post.from_id;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nv animated:YES completion:nil];
         
         

    }
    

    
}

- (void)addPostOnWall:(UIButton *)sender {
    
    //APAddPostViewController *vc = [[APAddPostViewController alloc]initWithTypePost:TTPostTypeWall];
    APAddPostViewController *vc = [[APAddPostViewController alloc]init];
    //vc.delegate = self;
    //vc.data = self.group;
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
    
}

- (IBAction)readMyMessagesAction:(UIButton *)sender {
    
    
    
    APMyMessagesTableViewController* vc = [[APMyMessagesTableViewController alloc] init];
    
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
     
    
}


- (void) refreshWall {
    
    [[APServerManager sharedManager]
     getGroupWall:@"58860049"
     withOffset:0
     count:MAX(postsInRequest, [self.postsArray count])
     onSuccess:^(NSArray *posts) {
         
        NSLog(@"refreshing the wall");
         
         [self.postsArray removeAllObjects];
         
         [self.postsArray addObjectsFromArray:posts];
         
         [self.tableView reloadData];
         
         [self.refreshControl endRefreshing];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
         
         [self.refreshControl endRefreshing];
     }];
    
}

- (void) getPostsFromServer {
    
    [[APServerManager sharedManager]
     getGroupWall:@"58860049"
     withOffset:[self.postsArray count]
     count:postsInRequest
     onSuccess:^(NSArray *posts) {
         
         if ([posts count] > 0) {
             
                 
                 [self.postsArray addObjectsFromArray:posts];
                 
                 NSMutableArray *newPaths = [NSMutableArray array];
             
                
                 for (int i = (int)[self.postsArray count] - (int)[posts count]; i < [self.postsArray count]; i++) {
                    
                     [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                 }
                 
                 for (int i = (int)[self.postsArray count] - (int)[posts count]; i < [self.postsArray count]; i++) {
                     
                     CGSize newSize = [self setFramesToImageViews:nil imageFrames:[[self.postsArray objectAtIndex:i] attachment] toFitSize:CGSizeMake(302, 400)];
                     
                     [self.imageViewSize addObject:[NSNumber numberWithFloat:roundf(newSize.height)]];
                 }
                 
                 
                     
                     [self.tableView beginUpdates];
                     [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
                     [self.tableView endUpdates];
                     //self.loadingData = NO;
                     
                
            
         }


     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
}



#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.postsArray count] + 1;
            break;
            
        
        default:
            return 0;
            break;
    }

    
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *addPostCellIdentifier = @"addPostCell";
    static NSString* identifier = @"Cell";
    static NSString* identifierPostCell = @"PostCell";
    
    if (indexPath.section == 0) {
        
        
        APAddPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addPostCellIdentifier];
        
        [cell.addPostButton addTarget:self action:@selector(addPostOnWall:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else if (indexPath.section == 1) {
    
        if (indexPath.row == [self.postsArray count]) {
        
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
            if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
        
        cell.textLabel.text = @"LOAD MORE";
           
        cell.imageView.image = nil;
        
        return cell;
        
        } else   {
            
            
        
        APPostCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierPostCell];
            

        
        APPost* post = [self.postsArray objectAtIndex:indexPath.row];
            
            
        // для отправки сообщения юзеру при нажатии на его аватарку
            self.testTest = post.from_id;

            [cell.lichkabutton addTarget:self
                                  action:@selector(lichkaPost:)
                        forControlEvents:UIControlEventTouchUpInside];
            
            // NSLog(@"for LICHKA - use id is -  %@",post.from_id);


        cell.postTextLabel.text = post.text;
        cell.postTextLabel.text = [self removeHTMLTags:post.text];

        // make size of text rect
        CGRect rect = cell.postTextLabel.frame;
        rect.size.height = [self heightLabelOfTextForString:post.text fontSize:9.f widthLabel:CGRectGetWidth(rect)];
        cell.postTextLabel.frame = rect;
        
        cell.postDateLabel.text = post.postDate;
        
        cell.commentsCountLabel.text = post.commentsCount;
        cell.repostsCountLabel.text = post.repostsCount;
        cell.likesCountLabel.text = post.likesCount;
        

        


            NSURLRequest *request = nil;
            
            if (post.from_user != nil) {
                request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:post.from_user.photo_100]];
                cell.nameSurnameLabel.text = [NSString stringWithFormat:@"%@ %@", post.from_user.firstName, post.from_user.lastName];
                
            } else if (post.from_group != nil) {
                request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:post.from_group.photo_200]];
                cell.nameSurnameLabel.text = [NSString stringWithFormat:@"%@",post.from_group.name];
            }
            
            __weak APPostCell  *weakCell = cell;
            
            [cell.avatarImage setImageWithURLRequest:request
                                      placeholderImage:nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   
                                                   weakCell.avatarImage.image = image;
                                                   CALayer *imageLayer = weakCell.avatarImage.layer;
                                                   [imageLayer setCornerRadius:cell.avatarImage.frame.size.height / 2];
                                                   [imageLayer setBorderWidth:2];
                                                   [imageLayer setBorderColor:[UIColor blueColor].CGColor];
                                                   [imageLayer setMasksToBounds:YES];
                                                   
                                               }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   
                                               }];


            
            if ([cell viewWithTag:11]) [[cell viewWithTag:11] removeFromSuperview];
            
            if ([post.attachment count] > 0) {
                
                CGPoint point = CGPointZero;
                
                if (![post.text isEqualToString:@""]) {
                    point = CGPointMake(CGRectGetMinX(cell.postTextLabel.frame),CGRectGetMaxY(cell.postTextLabel.frame));
                } else {
                    point = CGPointMake(CGRectGetMinX(cell.avatarImage.frame),CGRectGetMaxY(cell.avatarImage.frame));
                }
                
                APImages *galery = [[APImages alloc]initWithImageArray:post.attachment startPoint:point];
                galery.delegate = self;
                galery.tag = 11;
                
                [cell addSubview:galery];
                /*
                cell.addLikeBtn.frame = CGRectMake(CGRectGetMinX(cell.addLikeBtn.frame),
                                                   CGRectGetMaxY(galery.frame),
                                                   CGRectGetWidth(cell.addLikeBtn.frame),
                                                   CGRectGetHeight(cell.addLikeBtn.frame));
                
                cell.repostBtn.frame = CGRectMake(CGRectGetMinX(cell.repostBtn.frame),
                                                  CGRectGetMaxY(galery.frame),
                                                  CGRectGetWidth(cell.repostBtn.frame),
                                                  CGRectGetHeight(cell.repostBtn.frame));
                
                cell.addComentBtn.frame = CGRectMake(CGRectGetMinX(cell.addComentBtn.frame),
                                                     CGRectGetMaxY(galery.frame),
                                                     CGRectGetWidth(cell.addComentBtn.frame),
                                                     CGRectGetHeight(cell.addComentBtn.frame));
                
            } else {
                cell.addLikeBtn.frame = CGRectMake(CGRectGetMinX(cell.addLikeBtn.frame),
                                                   CGRectGetMaxY(cell.postTextLabel.frame),
                                                   CGRectGetWidth(cell.addLikeBtn.frame),
                                                   CGRectGetHeight(cell.addLikeBtn.frame));
                
                cell.repostBtn.frame = CGRectMake(CGRectGetMinX(cell.repostBtn.frame),
                                                  CGRectGetMaxY(cell.postTextLabel.frame),
                                                  CGRectGetWidth(cell.repostBtn.frame),
                                                  CGRectGetHeight(cell.repostBtn.frame));
                
                cell.addComentBtn.frame = CGRectMake(CGRectGetMinX(cell.addComentBtn.frame),
                                                     CGRectGetMaxY(cell.postTextLabel.frame),
                                                     CGRectGetWidth(cell.addComentBtn.frame),
                                                     CGRectGetHeight(cell.addComentBtn.frame));
                 */
            }
            

            
            
        return cell;
       
    }
        
        
    };
    
    return nil;
}



#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    
    switch (indexPath.section) {
        case 0:
            return 24.f;
            break;
        case 1:
            if (indexPath.row == [self.postsArray count]) {
                
                return 24.f;
                
            } else {
                /*
                 
                 APPost* post = [self.postsArray objectAtIndex:indexPath.row];
                 return [APPostCell heightForText:post.text];
                 */
                //return 485.f;
                
                APPost *post = [self.postsArray objectAtIndex:indexPath.row];
                
                float height = 0;
                
                if (![post.text isEqualToString:@""]) {
                    height = height + (int)[self heightLabelOfTextForString:post.text fontSize:9.f widthLabel:300];
                }
                
                if ([post.attachment count] > 0) {
                    
                    height = height + [[self.imageViewSize objectAtIndex:indexPath.row]floatValue];
                }
                
                return 46 + 10 + height+10;
       
            }
            
            break;
                
                     default:
            break;
    }
    
    return 0;

    
    
    
    
    
    
 
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.postsArray count]) {
        [self getPostsFromServer];
    } else if (indexPath.section ==1) {
        
        APPost* post = [self.postsArray objectAtIndex:indexPath.row];
        
        
        NSLog(@"*******************************************post is %@",post.text);
        NSLog(@"*******************************************post PHOTO is %@",post.postImageURL);
        NSLog(@"*******************************************post comments is %@",post.commentsCount);
        NSLog(@"*******************************************post likes is %@",post.likesCount);
        APCommentsPostTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"APCommentsPostTableViewController"];
        vc.post = post;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - Methods

- (NSString*) removeHTMLTags:(NSString*) string {
    
    NSRange r;
    
    if (string != nil) {
        
        while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            
            string = [string stringByReplacingCharactersInRange:r withString:@" "];
        }
        
    }
    
    return string;
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
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


#pragma mark - ABAddPostDelegate
/*
- (void)updateRequest {
    
    [self refreshWall];
    
    [self delegate];
    
}
*/
- (void)refreshPost {
    
    [self refreshWall];
}

#pragma mark - APImageViewGalleryDelegete

- (void)openVideo:(APVideo *)video {
    
    //[self performSegueWithIdentifier:@"videoWallSegue" sender:video];
    
}


@end

