//
//  APGroup.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 09.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APGroup.h"

@implementation APGroup

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.group_id = [[responseObject objectForKey:@"id"] stringValue];
        self.name = [responseObject objectForKey:@"name"];
        self.desc = [responseObject objectForKey:@"description"];
        self.photo_200 = [responseObject objectForKey:@"photo_200"];
        self.is_closed = [[responseObject objectForKey:@"is_closed"] boolValue];
        self.is_member = [[responseObject objectForKey:@"is_member"] boolValue];
        self.photos = [[[responseObject objectForKey:@"counters"] objectForKey:@"photos"] stringValue];
        self.topics = [[[responseObject objectForKey:@"counters"] objectForKey:@"topics"] stringValue];
        self.docs = [[[responseObject objectForKey:@"counters"] objectForKey:@"docs"] stringValue];
        self.videos = [[[responseObject objectForKey:@"counters"] objectForKey:@"videos"] stringValue];
        self.albums = [[[responseObject objectForKey:@"counters"] objectForKey:@"albums"] stringValue];
        self.members_count = [[responseObject objectForKey:@"members_count"] stringValue];
        self.status = [responseObject objectForKey:@"status"];
        NSString *photoMediumURL = [responseObject objectForKey:@"photo_medium"];
        
        if (photoMediumURL) {
            self.photoMediumURL = [NSURL URLWithString:photoMediumURL];
        }
        
    }
    return self;
}


@end
