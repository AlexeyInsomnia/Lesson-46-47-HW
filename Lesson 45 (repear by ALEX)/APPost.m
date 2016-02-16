//
//  APPost.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 05.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APPost.h"

@implementation APPost

- (instancetype)initWithDictionary:(NSDictionary*) dict
{
    self = [super init];
    if (self) {
        
        if ([dict count] != 1) {
            
            NSArray *attachments = [dict objectForKey:@"attachments"];
            
            NSMutableArray *tempImageArray = [NSMutableArray array];
            
            for (NSDictionary *dict in attachments) {
                
                if ([[dict objectForKey:@"type"] isEqualToString:@"photo"]) {
                    
                    APPhoto *photo = [[APPhoto alloc]initWithDictionary:[dict objectForKey:@"photo"]];
                    [tempImageArray addObject:photo];
                }
                
                if ([[dict objectForKey:@"type"] isEqualToString:@"video"]) {
                    
                    APVideo *video = [[APVideo alloc]initWithDictionary:[dict objectForKey:@"video"]];
                    [tempImageArray addObject:video];
                }
                
            }
            
            // for master
            self.post_id = [[dict objectForKey:@"id"] stringValue];
            

           // end of for master
            
            self.attachment = tempImageArray;
            
            self.from_id = [NSString stringWithFormat:@"%ld",(long)[[dict objectForKey:@"from_id"] integerValue]];
            
            self.commentsCount = [[[dict objectForKey:@"comments"] objectForKey:@"count"] stringValue];
            
            self.likesCount = [[[dict objectForKey:@"likes"] objectForKey:@"count"] stringValue];
            self.repostsCount = [[[dict objectForKey:@"reposts"] objectForKey:@"count"] stringValue];
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
            
            [dateFormater setDateFormat:@"dd MMM yyyy "];
            
            NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"] floatValue]];
            
            self.postDate = [dateFormater stringFromDate:dateTime];
            
            
            self.text = (NSString*)[dict objectForKey:@"text"];
            self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];// got from 47 lesson
            
          
            
            self.fromId = [[dict objectForKey:@"from_id"] stringValue];
            
            self.postId = [[dict objectForKey:@"id"] stringValue];
            
            
            
            self.attachmentType = (NSString*)[[dict objectForKey:@"attachment"] objectForKey:@"type"];
            
            if ([self.attachmentType isEqualToString:@"video"]) {
                
                self.attachmentData = [[dict objectForKey:@"attachment"] objectForKey:@"video"];
      
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"image_big"]];
                
            } else if ([self.attachmentType isEqualToString:@"link"]) {
                
                self.attachmentData = [[dict objectForKey:@"attachment"] objectForKey:@"link"];
            
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"image_src"]];
                
                if (self.postImageURL == nil) {
                    
                    self.text = (NSString*)[self.attachmentData objectForKey:@"url"];
                    
                }
                
                
            } else if ([self.attachmentType isEqualToString:@"photo"]) {
                
                self.attachmentData = [[dict objectForKey:@"attachment"] objectForKey:@"photo"];
            
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"src_big"]];
                
            } else if ([self.attachmentType isEqualToString:@"audio"]){
                
                
                self.postImageURL = nil;
                self.attachmentData = [[dict objectForKey:@"attachment"] objectForKey:@"audio"];
                

                
        
                
            } else if ([self.attachmentType isEqualToString:@"doc"]) {
                
                
                self.attachmentData = [[dict objectForKey:@"attachment"] objectForKey:@"doc"];
               
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"thumb_s"]];
                
            } else {
                
                self.postImageURL = nil;
                
                
            }
            
        } else {
            
            self.wallError = [dict objectForKey:@"wallError"];
            
        }
        
    }
    return self;
}

/*
 
 
 - (instancetype)initWithDictionary:(NSDictionary *) responseObject {
 
 self = [super init];
 if (self) {
 
 NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
 [dateFormater setDateFormat:@"dd MMM yyyy "];
 NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
 NSString *date = [dateFormater stringFromDate:dateTime];
 self.date = date;
 NSArray *attachments = [responseObject objectForKey:@"attachments"];
 
 NSMutableArray *tempImageArray = [NSMutableArray array];
 
 for (NSDictionary *dict in attachments) {
 
 if ([[dict objectForKey:@"type"] isEqualToString:@"photo"]) {
 
 TTPhoto *photo = [[TTPhoto alloc]initWithDictionary:[dict objectForKey:@"photo"]];
 [tempImageArray addObject:photo];
 }
 
 if ([[dict objectForKey:@"type"] isEqualToString:@"video"]) {
 
 TTVideo *video = [[TTVideo alloc]initWithDictionary:[dict objectForKey:@"video"]];
 [tempImageArray addObject:video];
 }
 
 }
 
 self.attachment = tempImageArray;
 self.text = [self stringByStrippingHTML:[responseObject objectForKey:@"text"]];
 self.owner_id = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"owner_id"]];
 self.post_id = [[responseObject objectForKey:@"id"] stringValue];
 self.likes_count = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"likes"] objectForKey:@"count"]];
 self.can_like = [[[responseObject objectForKey:@"likes"] objectForKey:@"can_like"] boolValue];
 self.can_post = [[[responseObject objectForKey:@"comments"] objectForKey:@"can_post"] boolValue];
 self.comments_count = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"comments"] objectForKey:@"count"]];

 
 }
 
 return self;
 }
 
 */

- (NSString *) stringByStrippingHTML:(NSString *)string {
 
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
 
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    }
 
    return string;
}



@end




/*
 
 self = [super initWithServerResponse:responseObject];
 if (self) {
 self.text = [responseObject objectForKey:@"text"];
 self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
 
 
 
 
 
 
 }
 return self;
 
 */
