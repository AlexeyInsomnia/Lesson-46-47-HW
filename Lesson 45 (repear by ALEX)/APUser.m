//
//  APUser.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 03.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APUser.h"

@implementation APUser

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.user_id = [[responseObject objectForKey:@"id"] stringValue];
        self.photo_100 = [responseObject objectForKey:@"photo_100"];
        
        NSString* urlString = [responseObject objectForKey: @"photo_50"];
        
        if (urlString) {
            self.image50URL = [NSURL URLWithString:urlString];
        }
        
        NSString *urlStringPhotoMedium = [responseObject objectForKey:@"photo_medium_rec"];
        
        if (urlStringPhotoMedium) {
            self.photoMediumURL = [NSURL URLWithString:urlStringPhotoMedium];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"user is %@, %@, %@, %@, %@", self.firstName, self.lastName, self.user_id, self.photo_100, self.image50URL];
}

@end

