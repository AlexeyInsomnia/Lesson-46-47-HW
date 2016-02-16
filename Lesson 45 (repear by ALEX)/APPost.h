//
//  APPost.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 05.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APServerObject.h"
#import <UIKit/UIKit.h>
#import "APGroup.h"
#import "APPhoto.h"
#import "APVideo.h"

@class APUser;


@interface APPost : APServerObject

@property (strong,nonatomic) NSString *post_id;
@property (strong,nonatomic) NSString *from_id;
@property (strong,nonatomic) NSString *owner_id;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *text;
@property (assign,nonatomic) BOOL can_like;
@property (assign,nonatomic) BOOL can_post;
//@property (strong,nonatomic) NSString *likes_count;
//@property (strong,nonatomic) NSString *comments_count;
@property (strong,nonatomic) APUser *from_user;
@property (strong,nonatomic) APGroup *from_group;
@property (strong,nonatomic) NSArray *attachment;


@property (strong, nonatomic) NSURL *photo;
@property (strong, nonatomic) NSString *type;


@property (strong, nonatomic) NSString* commentsCount;
@property (strong, nonatomic) NSString* likesCount;
@property (strong, nonatomic) NSString* repostsCount;
@property (strong, nonatomic) NSString* postDate;

@property (strong, nonatomic) NSString* attachmentType;

// далее свойства, которые зависят от attachmentType, которое может быть video, photo, link, doc



// video
@property (strong, nonatomic) NSDictionary* attachmentData;
@property (strong, nonatomic) NSURL* postImageURL;
// image key
// link - image_src key
// photo - src key

@property (strong, nonatomic) UIImage* userImage;
@property (strong, nonatomic) UIImage* postImage;

@property (strong, nonatomic) NSString* wallError; // Если стена не доступна!



@property (strong, nonatomic) NSString *fromId;
@property (strong, nonatomic) NSString *vid;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSArray *users;



- (instancetype)initWithDictionary:(NSDictionary*) dict;


@end









/*


 @interface TTWall : NSObject
 
 @property (strong,nonatomic) NSString *post_id;
 @property (strong,nonatomic) NSString *from_id;
 @property (strong,nonatomic) NSString *owner_id;
 @property (strong,nonatomic) NSString *date;
 @property (strong,nonatomic) NSString *text;
 @property (assign,nonatomic) BOOL can_like;
 @property (assign,nonatomic) BOOL can_post;
 @property (strong,nonatomic) NSString *likes_count;
 @property (strong,nonatomic) NSString *comments_count;
 @property (strong,nonatomic) TTUser *from_user;
 @property (strong,nonatomic) TTGroup *from_group;
 @property (strong,nonatomic) NSArray *attachment;
 
 


*/