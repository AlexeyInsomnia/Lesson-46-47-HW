//
//  APLoginViewController.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 03.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APAccessToken;

typedef void(^APLoginCompletionBlock)(APAccessToken* token);

@interface APLoginViewController : UIViewController

- (id) initWithCompletionBlock:(APLoginCompletionBlock) completionBlock;

@end
