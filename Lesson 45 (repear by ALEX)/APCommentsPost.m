//
//  APCommentsPost.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 11.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APCommentsPost.h"

@implementation APCommentsPost


- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        NSTimeInterval unixtime = [[responseObject objectForKey:@"date"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixtime];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        self.date = [formatter stringFromDate:date];
        
        NSString* string = [responseObject objectForKey:@"text"];
        
        NSString *newString = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        self.text = [self transformString:newString];
        
        NSDictionary *likes = [responseObject objectForKey:@"likes"];
        
        self.likesCount = [[likes objectForKey:@"count"] integerValue];
        
        NSDictionary *comments = [responseObject objectForKey:@"comments"];
        
        self.commentsCount = [[comments objectForKey:@"count"] integerValue];
        
        NSArray *attachments = [responseObject objectForKey:@"attachments"];
        NSDictionary *firstObject = [attachments firstObject];
        
        NSDictionary *link = [firstObject objectForKey:@"link"];
        
        NSDictionary *lastObject = [attachments lastObject];
        
        self.type =  [lastObject objectForKey:@"type"];
        
        NSDictionary *photoLink  = [link objectForKey:@"photo"];
        
        NSString *photoLinkString = [photoLink objectForKey:@"photo_75"];
        if (photoLinkString) {
            self.photoLink = [NSURL URLWithString:photoLinkString];
        }
        
        NSDictionary *photoPhoto = [firstObject objectForKey:@"photo"];
        
        NSString *photoPhotoString = [photoPhoto objectForKey:@"photo_75"];
        if (photoPhotoString) {
            self.photoLink = [NSURL URLWithString:photoPhotoString];
        }
        
        self.textLink = [photoLink objectForKey:@"text"];
        self.titleLink = [link objectForKey:@"title"];
        self.urlLink = [link objectForKey:@"url"];
        self.descriptionLink = [link objectForKey:@"description"];
        
        self.commentId = [responseObject objectForKey:@"id"];
        
        self.fromId = [responseObject objectForKey:@"from_id"];
        
        //NSLog(@"commentId - %@", self.commentId);
        

        }
        
    
    return self;
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"date %@, text %@, likes %ld, commentscount %ld, type %@, photo %@, textLink %@, titlelink %@, urllink %@, descriptio %@, commentID %@, fromId %@", self.date, self.text, self.likesCount, self.commentsCount, self.type, self.photoLink, self.textLink, self.titleLink, self.urlLink ,self.descriptionLink,self.commentId,self.fromId];
}

- (NSString *)transformString:(NSString *)string {
    
    NSArray *arrayString1 = [string componentsSeparatedByString:@"]"];
    
    NSString *firstObject = [arrayString1 firstObject];
    
    NSArray *arrayString2 = [firstObject componentsSeparatedByString:@"|"];
    
    NSString *lastObject = [arrayString2 lastObject];
    
    if ([lastObject length] > 0 && [arrayString1 count] > 1) {
        
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
        
        [mutableString replaceCharactersInRange:NSMakeRange(0, [firstObject length] + 1) withString:lastObject];
        
        return mutableString;
        
    } else {
        return string;
    }
}


@end
