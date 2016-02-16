//
//  APVideo.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APVideo : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *views;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *like_count;
@property (assign,nonatomic) BOOL can_like;
@property (strong,nonatomic) NSString *owner_id;
@property (strong,nonatomic) NSString *videoid;
@property (strong,nonatomic) NSString *photoURL;
@property (strong,nonatomic) NSString *duration;
@property (strong,nonatomic) NSString *fileURl;
@property (strong,nonatomic) NSString *playerURl;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end

