//
//  APVideosViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 15.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APVideosViewController.h"
#import "APVideoTableViewCell.h"
#import "APServerManager.h"
#import "APVideo.h"
#import "UIImageView+AFNetworking.h"
#import "APVideoViewController.h"

static NSInteger videoInRequest = 20;


@interface APVideosViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) NSMutableArray *videosArray;
@property (assign,nonatomic) BOOL loadingData;

@end

@implementation APVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"count of video *********** - %@", self.group.videos);
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePostView:)];
    
    self.navigationItem.leftBarButtonItem = cancel;

    
    self.navigationItem.title = @"Videos";
    self.view.backgroundColor = [UIColor whiteColor];
    self.videosArray = [NSMutableArray array];
    
    [self getVideoFromServer];
    
}

- (void)getVideoFromServer {
    
    if (self.loadingData != YES) {
        self.loadingData = YES;
        
        [[APServerManager sharedManager]getVideoGroup:self.group.group_id
                                                count:videoInRequest
                                               offset:[self.videosArray count]
                                            onSuccess:^(NSArray *videoGroupArray) {
            
            
            
            if ([videoGroupArray count] > 0) {
                
                [self.videosArray addObjectsFromArray:videoGroupArray];
                 NSLog(@"groupid - %@, nw path %ld",  self.group.group_id,[self.videosArray count]);
                
                NSMutableArray* newPaths = [NSMutableArray array];
                for (int i = (int)[self.videosArray count] - (int)[videoGroupArray count]; i < [self.videosArray count]; i++) {
              
                    [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
              
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView endUpdates];
                    
                    self.loadingData = NO;

                });
                            }
            
        } onFailure:^(NSError *error) {
            
        }];
    }
   
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= self.tableView.contentSize.height - scrollView.frame.size.height/2) {
        if (!self.loadingData) {
            [self getVideoFromServer];
        }
    }
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    return [self.videosArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"videoCell";
    
    APVideoTableViewCell *cell = (APVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[APVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    

    
    APVideo *video = [self.videosArray objectAtIndex:indexPath.row];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    UIFont* font = [UIFont fontWithName:@"Arial" size:9.f];
    cell.textLabel.font = font;
    cell.textLabel.text = video.title;
    
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Times" size:9.f];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", video.duration];

    /*
    cell.durationLabel.text = @"duration";
    cell.titleLabel.text = @"title";
    
    NSLog(@"dration - %@, title - %@", video.duration, video.title);
    //cell.durationLabel.text = video.duration;
    //cell.titleLabel.text = video.title;
    */
    
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:video.photoURL]];
    
    __weak APVideoTableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            [UIView transitionWithView:weakCell.imageView
                                                              duration:0.3f
                                                               options:UIViewAnimationOptionTransitionCrossDissolve
                                                            animations:^{
                                                                weakCell.imageView.image = image;
                                                            } completion:NULL];
                                            
                                            
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            
                                        }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    APVideo *video = [self.videosArray objectAtIndex:indexPath.row];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    APVideoViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"APVideoViewController"];
    dest.video = video;
    
    //UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:dest];
    [self.navigationController pushViewController:dest animated:YES];
    

    
    //[self performSegueWithIdentifier:@"detailVideoSegue" sender:indexPath];
}
/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"detailVideoSegue"]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        APVideo *video = [self.videosArray objectAtIndex:indexPath.row];
        APVideoViewController *dest = [segue destinationViewController];
        dest.video = video;
        
    }
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)dealloc {
    [_tableView setDelegate:nil];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}
*/
- (void)hidePostView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
