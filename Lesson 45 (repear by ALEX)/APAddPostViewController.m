//
//  APAddPostViewController.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 09.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APAddPostViewController.h"
#import "APServerManager.h"

@interface APAddPostViewController () <UITextViewDelegate>


@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIBarButtonItem *done;

@end

@implementation APAddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePostView:)];
    self.done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPostOnWall:)];
    self.done.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.done;
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    
    [txtview setDelegate:self];
    //[txtview setReturnKeyType:UIReturnKeyDefault];
    //[txtview setTag:1];
    txtview.scrollEnabled = NO;
    self.textView = txtview;
    //[self.textView addSubview:self.colectionView];
    [self.view addSubview:self.textView];

    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor grayColor];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
   // NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //self.addPhoto = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhoto:)];
    //UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //[items addObjectsFromArray:@[flexibleSpace,self.addPhoto]];
    //[toolbar setItems:items animated:NO];
    
    //self.toolBar = toolbar;
    //[self.view addSubview:self.toolBar];
    
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

- (void)addPostOnWall:(UIBarButtonItem *)sender {
    
    
    [[APServerManager sharedManager]
     postText:self.textView.text
     onGroupWall:@"58860049"
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
    
    
    
    
    /*
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);

    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.colectionView setFrame:CGRectMake(self.colectionView.frame.origin.x, newFrame.size.height, self.colectionView.frame.size.width, self.colectionView.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
     */
}


@end
