//
//  APCommentsPost.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 11.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APUser.h"

#import <Foundation/Foundation.h>

@interface APCommentsPost : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger likesCount;
@property (assign, nonatomic) NSInteger commentsCount;
@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *fromId;
@property (strong, nonatomic) APUser *user;

@property (strong, nonatomic) NSURL *avatar;

@property (strong, nonatomic) NSString *descriptionLink;
@property (strong, nonatomic) NSURL *photoLink;
@property (strong, nonatomic) NSURL *photoPhoto;
@property (strong, nonatomic) NSString *textLink;
@property (strong, nonatomic) NSString *titleLink;
@property (strong, nonatomic) NSString *urlLink;
@property (strong, nonatomic) NSString *type;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
