//
//  APServerManager.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 03.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APServerManager.h"
#import "AFNetworking.h"
#import "APUser.h"
#import "APCommentsPost.h"
#import "APLoginViewController.h"
#import "APAccessToken.h"
#import "APPost.h"


#import "JSQMessage.h"


@interface APServerManager()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager; //this is from AFN 3.0
@property (strong, nonatomic) APAccessToken* accessToken;
@property (strong, nonatomic) NSString* usersName;

@end

@implementation APServerManager

+ (APServerManager*) sharedManager {
    
    static APServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APServerManager alloc] init];
    });
    
    return manager; // чтобы запускался только один раз
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        // http://vk.com/dev/api_requests
        
        NSURL *URL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
        
    }
    return self;
}

- (void) authorizeUser:(void(^)(APUser* user)) completion {
    
    // указать что будет когда мы получим токен
    
    APLoginViewController* vc =
    [[APLoginViewController alloc] initWithCompletionBlock:^(APAccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(APUser *user) {
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    // достучать до главного контроллера
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}


- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(APUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50, can_write_private_message, photo_100 ",   @"fields",
     @"nom",        @"name_case",
     @5.8, @"v", nil];
    
   
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         //NSLog(@"JSON: %@", responseObject);
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count] > 0) {
                             APUser* user = [[APUser alloc] initWithServerResponse:[dictsArray firstObject]];
                             if (success) {
                                 success(user);
                             }
                         } else {
                             if (failure) {
                                 failure(nil, task.response.expectedContentLength);
                             }
                         }

                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, task.response.expectedContentLength);
                         }
                     }];
    

}

- (void)   getMyMessages:(NSInteger)count
                  offset:(NSInteger)offset
               onSuccess:(void (^) (NSArray* messagesArray))success
               onFailure:(void (^) (NSError *error)) failure {
    
    // http://vk.com/dev/messages.get
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(count),               @"count",
     @(offset),              @"offset",
     @"5.37",                @"v",
     self.accessToken.token, @"access_token" ,
     nil];
    
    [self.sessionManager GET:@"messages.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         //NSLog(@"JSON: %@", responseObject);
                         
                         
                         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
                         
                         NSArray *itemsArray = [responseDict objectForKey:@"items"];
                         
                         NSMutableArray *objectArray = [NSMutableArray array];
                         
                         for (int i = 0; i < [itemsArray count]; i++) {
                             
                             //NSString *senderId = [[[itemsArray objectAtIndex:i] objectForKey:@"user_id"] stringValue];
                             
                             NSTimeInterval unixtime = [[[itemsArray objectAtIndex:i] objectForKey:@"date"] doubleValue];
                             
                             NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixtime];
                             
                             
                             NSString *text = [[itemsArray objectAtIndex:i] objectForKey:@"body"];
                             
                             /*
                             
                             [self getUser:senderId
                                 onSuccess:^(APUser *user) {
                                     
                                     APServerManager* test = [[APServerManager alloc] init];
                                     test.usersName = user.firstName;
                                     
                                 } onFailure:^(NSError *error, NSInteger statusCode) {
                                     
                                 }];
                             */
                             //NSLog(@"user is %@" , self.usersName);
                             
                             //NSLog(@"user is %@" , self.usersName);
                             APMyMessages* message = [[APMyMessages alloc] init ];
                             //message.userIs = self.usersName;
                             message.date    = date;
                             message.body    = text;
                             //NSLog(@"from_id  %@", message.userIs);
                             /*
                             JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                                      senderDisplayName:nil
                                                                                   date:date
                                                                                   text:text];
                              */
                             
                             //NSLog(@"from_id  %@, date %@, body %@", message.userIs, message.date, message.body);
                             
                             [objectArray addObject:message];
                             
                         }
                         
                         if (success) {
                             success(objectArray);
                         }

                         
                         
                         
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         
                     }];
    
    
}


- (void) getGroupWall:(NSString*) groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID]; // если не аккаунт физлица а группа то префикс "-"
    }
    
     //    http://vk.com/dev/wall.get
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,       @"owner_id",
     @(count),      @"count",
     @(offset),     @"offset",
     @"all",        @"filter",
     @"5.37",@"v",
     @"1", @"extended",
     self.accessToken.token, @"access_token" ,
     nil];
    
    
    /*
       //@"owner", @"filter",     @"access_token"    : self.accessToken.token };
     @(0), @"extended",
     @"5.21",@"v",
     //@"photo_50,name", @"fields",
     */
    
    [self.sessionManager
     GET:@"wall.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         //NSLog(@"JSON: %@", responseObject);
         
         //  если extended = 0 то делаем так
         /*
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 1) {
             //dictsArray = [dictsArray subarrayWithRange:NSMakeRange(1, (int)[dictsArray count] - 1)];
             NSLog(@"count %ld ", [dictsArray count]);
         } else {
             dictsArray = nil;
         }
        
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictsArray) {
             APPost* post = [[APPost alloc] initWithDictionary:dict];
             [objectsArray addObject:post];
         }
         */

         
         NSDictionary *objects = [responseObject objectForKey:@"response"];
         
         
         NSArray *wallArray = [objects objectForKey:@"items"];
         
         
         NSArray *profilesArray = [objects objectForKey:@"profiles"];
         
         //NSLog(@"profile Array is  is - %@", profilesArray);

         
         NSMutableArray *arrayWithProfiles = [[NSMutableArray alloc]init];
         
         for (NSDictionary* dict in profilesArray) {
             
             APUser *user = [[APUser alloc] initWithServerResponse:dict];
             
             [arrayWithProfiles addObject:user];
             
         }
          
          APGroup *group = [[APGroup alloc]initWithDictionary:[[objects objectForKey:@"groups"] objectAtIndex:0]];
          
        
         
         NSMutableArray *arrayWithWall = [[NSMutableArray alloc]init];
         for (int i = 0; i < [wallArray count]; i++) {
             
             APPost* wall = [[APPost alloc]initWithDictionary:[wallArray objectAtIndex:i]];
             
             if ([wall.from_id hasPrefix:@"-"]) {
                 
                 wall.from_group = group;
                 [arrayWithWall addObject:wall];
                 continue;
             }
             
             for (APUser *user in arrayWithProfiles) {
                 
                 if ([wall.from_id isEqualToString:user.user_id]) {
                     
                     wall.from_user = user;
                     [arrayWithWall addObject:wall];
                     break;
                 }
                 
             }
             
         }
         
         if (success) {
             //success(objectsArray);
             success(arrayWithWall);
             //NSLog(@"array is - %@", arrayWithWall);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         if (failure) {
             failure(error, task.response.expectedContentLength);
         }
     }];
    

}

- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,       @"owner_id",
     text,          @"message",
     self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager
     POST:@"wall.post"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //NSLog(@"JSON: %@", responseObject);
         
         if (success) {
             success(responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         if (failure) {
             failure(error, task.response.expectedContentLength);
         }
     }];
     
    
}

- (void) postTextToUser:(NSString*) text
               onUserID:(NSString*) userID
              onSuccess:(void(^)(id result)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    // http://vk.com/dev/messages.send
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,       @"user_id",
     text,          @"message",
     self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager POST:@"messages.send"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          //NSLog(@"JSON: %@", responseObject);
                          
                          if (success) {
                              success(responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                          if (failure) {
                              failure(error, task.response.expectedContentLength);
                          }
                      }];
    
}

- (void)getCommentsFromPostId:(NSString *)postId
                      ownerId:(NSString *)ownerId
                        count:(NSInteger)count
                       offset:(NSInteger)offset
                    onSuccess:(void(^)(NSArray *array))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.accessToken.token, @"access_token",
                            postId,                 @"post_id",
                            ownerId,                @"owner_id",
                            @(count),               @"count",
                            @(offset),              @"offset",
                            @1,                     @"extended",
                            @1,                     @"need_likes",
                            @"5.37",                @"v",nil];
    
    [self.sessionManager GET:@"wall.getComments"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"JSON SEND: %@", responseObject);
                         
                         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
                         
                         NSArray *profilesArray = [responseDict objectForKey:@"profiles"];
                         
                         NSMutableArray *arrayKey = [NSMutableArray array];
                         
                         for (int i = 0; i < [profilesArray count]; i++) {
                             NSDictionary *dictProf = [profilesArray objectAtIndex:i];
                             
                             NSString *key = [NSString stringWithFormat:@"%@",[dictProf valueForKey:@"id"]];
                             
                             [arrayKey addObject:key];
                         }
                         
                         NSDictionary *dict = [[NSDictionary alloc] initWithObjects:profilesArray forKeys:arrayKey];
                         
                         NSArray *itemsArray = [responseDict objectForKey:@"items"];
                         
                         NSMutableArray *objectArray = [NSMutableArray array];
                         
                         for (int i = 0; i < [itemsArray count]; i++) {
                             
                             APCommentsPost *comments = [[APCommentsPost alloc] initWithServerResponse:[itemsArray objectAtIndex:i]];
                             
                             NSString *uid = [NSString stringWithFormat:@"%@",[[itemsArray objectAtIndex:i] valueForKey:@"from_id"]];
                             NSDictionary *dictionaryUser = nil;
                             dictionaryUser = [dict valueForKey:uid];
                             
                             comments.user = [[APUser alloc] initWithServerResponse:dictionaryUser];
                             
                             NSLog(@"FROM SERVER MANAGER i - %d - getCommentsFromPostId  APCommentsPost %@", i, comments);
                             NSLog(@"FROM SERVER MANAGER i - %d - getCommentsFromPostId  APCommentsPost.USER %@ ", i, comments.user);
                             
                             [objectArray addObject:comments];
                         }
                         
                        
                         
                         if (success) {
                             success(objectArray);
                         }
                         

                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, task.response.expectedContentLength);
                         }
                     }];
    
    }

- (void)getWallById:(NSString *)posts
          onSuccess:(void (^)(id result))success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            posts,     @"posts",
                            @"5.37",     @"version",
                            @1,          @"extended",
                            self.accessToken.token, @"access_token", nil];
    
    
    [self.sessionManager GET:@"wall.getById"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"JSON: %@", responseObject);
                         
                         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
                         
                         NSArray *wallArray = [responseDict objectForKey:@"wall"];
                         
                         NSDictionary *wallDict = [wallArray objectAtIndex:0];
                         
                         NSArray *profilesArray = [responseDict objectForKey:@"profiles"];
                         
                         NSDictionary *profilesDict = [profilesArray objectAtIndex:0];
                         
                         NSLog(@"JSON1: %@", profilesDict);
                         
                         APPost *post = [[APPost alloc] initWithServerResponse:wallDict];
                         
                         post.from_user = [[APUser alloc] initWithServerResponse:profilesDict];
                         
                         //NSLog(@"FROM SERVER MANAGER getWALLbyID %@", post);
                         
                         if (success) {
                             success(post);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
    
   }

- (void)addCommentFromPostId:(NSString *)postId
                     ownerId:(NSString *)ownerId
                        text:(NSString *)text
                   onSuccess:(void(^)(NSArray *array))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.accessToken.token, @"access_token",
                            postId,                 @"post_id",
                            ownerId,                @"owner_id",
                            text,                   @"text",
                            @"5.37",                @"v",nil];
    
    [self.sessionManager POST:@"wall.addComment"
                   parameters:params

                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          //NSLog(@"JSON: %@", responseObject);
                          
                          if (success) {
                              success(responseObject);
                          }

                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                      }];

    
}

- (void)deleteCommentFromPostId:(NSString *)commentId
                        ownerId:(NSString *)ownerId
                      onSuccess:(void(^)(NSArray *array))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.accessToken.token, @"access_token",
                            commentId,              @"comment_id",
                            ownerId,                @"owner_id",
                            @"5.37",                @"v",nil];
    
    [self.sessionManager POST:@"wall.deleteComment"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          //NSLog(@"JSON: %@", responseObject);
                          
                          if (success) {
                              success(responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                      }];
    

    
}

- (void)addLikeFromObjectType:(NSString *)type
                      ownerId:(NSString *)ownerId
                       itemId:(NSString *)itemId
                    onSuccess:(void(^)(NSArray *array))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,                   @"type",
                            ownerId,                @"owner_id",
                            itemId,                 @"item_id",
                            @"5.40",                @"v",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager POST:@"likes.add"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          //NSLog(@"JSON: %@", responseObject);
                          
                          if (success) {
                              success(responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                      }];
    
       
}

- (void)getVideoGroup:(NSString *)group_id
                count:(NSInteger)count
               offset:(NSInteger)offset
            onSuccess:(void (^) (NSArray *videoGroupArray))success
            onFailure:(void (^) (NSError *error)) failure {
    
    
    NSString *idGroup = [NSString stringWithFormat:@"%@",group_id];
    
    if (![idGroup hasPrefix:@"-"]) {
        idGroup = [@"-" stringByAppendingString:idGroup];
    }
    
    NSDictionary *parameters = @{@"owner_id"        : idGroup ,
                                 @"count"           : @(count),
                                 @"offset"          : @(offset),
                                 @"v"               : @"5.21",
                                 @"width"           : @"320",
                                 @"extended"        : @"1",
                                 @"access_token"    : self.accessToken.token };
    
    [self.sessionManager GET:@"video.get"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             NSDictionary *objects = [responseObject objectForKey:@"response"];
                             
                             NSArray *videoArray = [objects objectForKey:@"items"];
                             
                             NSMutableArray *arrayWithVideo = [[NSMutableArray alloc]init];
                             
                             for (int i = 0; i < [videoArray count]; i++) {
                                 
                                 APVideo *user = [[APVideo alloc]initWithDictionary:[videoArray objectAtIndex:i]];
                                 
                                 [arrayWithVideo addObject:user];
                        
                         
                             }
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (success) {
                                     success(arrayWithVideo);
                                 }
                             });
                         });
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       
                     }];
    

                     
}

   
  
- (void)getGroupById:(NSString *)group_id
           onSuccess:(void (^) (APGroup *group))success
           onFailure:(void (^) (NSError *error)) failure {
  
    NSDictionary *parameters = @{@"group_id"        : group_id,
                                 @"fields"          : @"description,counters,members_count,status",
                                 @"v"               : @"5.21",
                                 @"access_token"    : self.accessToken.token };
    
    [self.sessionManager GET:@"groups.getById" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        
        APGroup *group = [[APGroup alloc]initWithDictionary:[objects firstObject]];
        
        
        self.group = group;
        success(group);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}

- (void)getUsersByIds:(NSArray *)user_ids
            onSuccess:(void (^)(NSArray *usersArray))success
            onFailure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{@"user_ids"        : user_ids,
                                 @"fields"          : @"photo_100",
                                 @"v"               : @"5.21",
                                 @"access_token"    : self.accessToken.token };
    
    [self.sessionManager GET:@"users.get"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *objects = [responseObject objectForKey:@"response"];
                         
                         NSMutableArray *arrayWithobjects = [[NSMutableArray alloc]init];
                         
                         for (int i = 0; i < [objects count]; i++) {
                             APUser *user = [[APUser alloc]initWithServerResponse:[objects objectAtIndex:i]];
                             [arrayWithobjects addObject:user];
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             if (success) {
                                 success(arrayWithobjects);
                             }
                         });


                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
    
}

- (void)getVideoComment:(NSString *)group_id
                videoid:(NSString *)video_id
                  count:(NSInteger)count
                 offset:(NSInteger)offset
              onSuccess:(void (^) (NSArray *videoCommentArray))success
              onFailure:(void (^) (NSError *error)) failure {
    
    
    NSString *idGroup = [NSString stringWithFormat:@"%@",group_id];
    
    if (![idGroup hasPrefix:@"-"]) {
        idGroup = [@"-" stringByAppendingString:idGroup];
    }
    
    NSDictionary *parameters = @{@"owner_id"        : idGroup ,
                                 @"video_id"        : video_id,
                                 @"need_likes"      : @"1",
                                 @"sort"            : @"desc",
                                 @"count"           : @(count),
                                 @"offset"          : @(offset),
                                 @"v"               : @"5.21",
                                 @"access_token"    : self.accessToken.token };
    
    [self.sessionManager GET:@"video.getComments"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             NSDictionary *objects = [responseObject objectForKey:@"response"];
                             
                             NSArray *objectsArray = [objects objectForKey:@"items"];
                             
                             NSMutableArray *arrayWithobjects = [[NSMutableArray alloc]init];
                             
                             for (int i = 0; i < [objectsArray count]; i++) {
                                 
                                 APCommentsPost *comment = [[APCommentsPost alloc]initWithServerResponse:[objectsArray objectAtIndex:i]];
                                 
                                 [arrayWithobjects addObject:comment];
                             }
                             
                             dispatch_group_t group = dispatch_group_create();
                             dispatch_group_enter(group);
                             
                             NSArray *users = [arrayWithobjects valueForKeyPath:@"@distinctUnionOfObjects.from_id"];
                             
                             [self getUsersByIds:users onSuccess:^(NSArray *usersArray) {
                                 
                                 for (int i = 0; i < [arrayWithobjects count]; i++) {
                                     
                                     APCommentsPost *comment = [arrayWithobjects objectAtIndex:i];
                                     
                                     for (APUser *user in usersArray) {
                                         if ([comment.fromId isEqualToString:user.user_id]) {
                                             comment.user = user;
                                             break;
                                         }
                                     }
                                 }
                                 
                                 dispatch_group_leave(group);
                                 
                             } onFailure:^(NSError *error) {
                                 
                             }];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                                     
                                     if (success) {
                                         success(arrayWithobjects);
                                     }
                                 });
                             });
                         });
                         
                         
                             
                             
                             
                             
                        
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          failure(error);
                     }];
    
    }


- (void)getVideo:(NSString *)group_id
         videoid:(NSString *)video_id
       onSuccess:(void (^) (APVideo *video))success
       onFailure:(void (^) (NSError *error)) failure {
    
    
    NSString *idGroup = [NSString stringWithFormat:@"%@",group_id];
    
    if (![idGroup hasPrefix:@"-"]) {
        idGroup = [@"-" stringByAppendingString:idGroup];
    }
    
    NSString *videos = [NSString stringWithFormat:@"%@_%@",idGroup,video_id];
    
    NSDictionary *parameters = @{@"owner_id"        : idGroup,
                                 @"videos"          : videos,
                                 @"count"           : @(1),
                                 @"offset"          : @(0),
                                 @"v"               : @"5.21",
                                 @"width"           : @"320",
                                 @"extended"        : @"1",
                                 @"access_token"    : self.accessToken.token };
    [self.sessionManager GET:@"video.get"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSDictionary *objects = [responseObject objectForKey:@"response"];
                         
                         NSArray *videoArray = [objects objectForKey:@"items"];
                         APVideo *video = [[APVideo alloc]initWithDictionary:[videoArray firstObject]];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             if (success) {
                                 success(video);
                             }
                             
                         });
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failure(error);
                     }];
    
      
}

   
@end
