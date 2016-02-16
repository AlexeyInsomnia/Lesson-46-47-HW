//
//  APPhoto.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APPhoto.h"

@implementation APPhoto

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        
        self.width = [[responseObject objectForKey:@"width"] integerValue];
        self.height = [[responseObject objectForKey:@"height"] integerValue];
        self.photo_75 = [responseObject objectForKey:@"photo_75"];
        self.photo_130 = [responseObject objectForKey:@"photo_130"];
        self.photo_807 = [responseObject objectForKey:@"photo_807"];
        self.photo_604 = [responseObject objectForKey:@"photo_604"];
        self.photo_1280 = [responseObject objectForKey:@"photo_1280"];
        self.photo_2560 = [responseObject objectForKey:@"photo_2560"];
    }
    return self;
}

@end
