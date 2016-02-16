//
//  APPostTextToUserViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APPostTextToUserViewController.h"
#import "APServerManager.h"

@interface APPostTextToUserViewController () <UITextViewDelegate>


@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIBarButtonItem *done;


@end

@implementation APPostTextToUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePostView:)];
    self.done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPostTextToUser:)];
    self.done.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.done;
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    
    [txtview setDelegate:self];

    txtview.scrollEnabled = NO;
    self.textView = txtview;

    [self.view addSubview:self.textView];
    

    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor grayColor];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);

    
    [self.textView becomeFirstResponder]; //  напоминаю, это сразу вызывает клавиатуру
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (void)hidePostView:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPostTextToUser:(UIBarButtonItem *)sender {
    
    [[APServerManager sharedManager] postTextToUser:self.textView.text
                                           onUserID:self.userID
                                          onSuccess:^(id result) {
                                              
                                          }
                                          onFailure:^(NSError *error, NSInteger statusCode) {
                                              
                                          }];
    

    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        self.done.enabled = NO;
    } else {
        self.done.enabled = YES;
    }
    
    
    
    

}


@end
