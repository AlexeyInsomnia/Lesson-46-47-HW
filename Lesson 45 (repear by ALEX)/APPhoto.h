//
//  APPhoto.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhoto : NSObject

@property (assign,nonatomic) NSInteger width;
@property (assign,nonatomic) NSInteger height;
@property (strong,nonatomic) NSString *photo_604;
@property (strong,nonatomic) NSString *photo_75;
@property (strong,nonatomic) NSString *photo_130;
@property (strong,nonatomic) NSString *photo_807;
@property (strong,nonatomic) NSString *photo_1280;
@property (strong,nonatomic) NSString *photo_2560;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end
