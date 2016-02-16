//
//  APServerManager.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 03.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APGroup.h"
#import "APMyMessages.h"

@class APUser;
@class APVideo;

@interface APServerManager : NSObject

@property (strong, nonatomic, readonly) APUser* currentUser;
@property (strong,nonatomic) APGroup *group;


+ (APServerManager*) sharedManager;


- (void) authorizeUser:(void(^)(APUser* user)) completion;



- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(APUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getGroupWall:(NSString*) groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) postTextToUser:(NSString*) text
               onUserID:(NSString*) userID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)   getMyMessages:(NSInteger)count
                  offset:(NSInteger)offset
               onSuccess:(void (^) (NSArray* messagesArray))success
               onFailure:(void (^) (NSError *error)) failure;

- (void)getCommentsFromPostId:(NSString *)postId
                      ownerId:(NSString *)ownerId
                        count:(NSInteger)count
                       offset:(NSInteger)offset
                    onSuccess:(void(^)(NSArray *array))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;


- (void)getWallById:(NSString *)posts
          onSuccess:(void (^)(id result))success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)addCommentFromPostId:(NSString *)postId
                     ownerId:(NSString *)ownerId
                        text:(NSString *)text
                   onSuccess:(void(^)(NSArray *array))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)deleteCommentFromPostId:(NSString *)commentId
                        ownerId:(NSString *)ownerId
                      onSuccess:(void(^)(NSArray *array))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)addLikeFromObjectType:(NSString *)type
                      ownerId:(NSString *)ownerId
                       itemId:(NSString *)itemId
                    onSuccess:(void(^)(NSArray *array))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getVideoGroup:(NSString *)group_id
                count:(NSInteger)count
               offset:(NSInteger)offset
            onSuccess:(void (^) (NSArray *videoGroupArray))success
            onFailure:(void (^) (NSError *error)) failure;

- (void)getGroupById:(NSString *)group_id
           onSuccess:(void (^) (APGroup *group))success
           onFailure:(void (^) (NSError *error))failure;

- (void)getVideoComment:(NSString *)group_id
                videoid:(NSString *)video_id
                  count:(NSInteger)count
                 offset:(NSInteger)offset
              onSuccess:(void (^) (NSArray *videoCommentArray))success
              onFailure:(void (^) (NSError *error)) failure;

- (void)getUsersByIds:(NSArray *)user_ids
            onSuccess:(void (^)(NSArray *usersArray))success
            onFailure:(void (^)(NSError *error))failure;

- (void)getVideo:(NSString *)group_id
         videoid:(NSString *)video_id
       onSuccess:(void (^) (APVideo *video))success
       onFailure:(void (^) (NSError *error)) failure;





@end
