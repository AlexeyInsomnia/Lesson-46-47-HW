//
//  APMyMessagesTableViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APMyMessagesTableViewController.h"

@interface APMyMessagesTableViewController ()

@property (strong, nonatomic) NSMutableArray* myMessages;

@end

@implementation APMyMessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePostView:)];
    
    self.navigationItem.leftBarButtonItem = cancel;

    
    self.myMessages = [[NSMutableArray alloc] init];
    
    [self gotMyMessages];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gotMyMessages {
    
    
    
    [[APServerManager sharedManager] getMyMessages:20
                                            offset:0
                                         onSuccess:^(NSArray *messagesArray) {
                                             
                                             
                                             [self.myMessages addObjectsFromArray:messagesArray];
                                             
                                             NSMutableArray *newPaths = [NSMutableArray array];
                                             
                                             
                                             for (int i = 0; i < [self.myMessages count]; i++) {
                                                 
                                                 [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                             }
                                             
                                         
                                         
                                             [self.tableView beginUpdates];
                                             [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView endUpdates];
                                             
                                         }
                                         onFailure:^(NSError *error) {
                                             
                                         }];
    
  
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.myMessages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    APMyMessages* message = [[APMyMessages alloc] init];
   
    
    message = [self.myMessages objectAtIndex:indexPath.row];
    //NSLog(@"array %@", self.myMessages);
    //NSLog(@"date and body is - %@ %@", message.date, message.body);
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    UIFont* font = [UIFont fontWithName:@"Arial" size:8.f];
    cell.textLabel.font = font;
    cell.textLabel.text = message.body;
    
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Times" size:6.f];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", message.date];
    
    
    return cell;
}

- (void)hidePostView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
