//
//  APUser.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 03.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APUser : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* image50URL;
@property (strong,nonatomic) NSString *user_id;
@property (strong,nonatomic) NSString *photo_100;
@property (strong, nonatomic) NSURL *photoMediumURL;


- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end




