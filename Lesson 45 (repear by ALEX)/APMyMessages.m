//
//  APMyMessages.m
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APMyMessages.h"

@implementation APMyMessages
/*
- (instancetype)initWithDictionary:(NSArray*) dict
{
    self = [super init];
    if (self) {
        
        
        
        for (NSDictionary *dict in dict) {
          
            self.listFromUsers = 
            
            if ([[dict objectForKey:@"type"] isEqualToString:@"photo"]) {
                
                APPhoto *photo = [[APPhoto alloc]initWithDictionary:[dict objectForKey:@"photo"]];
                [tempImageArray addObject:photo];
            }
            
            if ([[dict objectForKey:@"type"] isEqualToString:@"video"]) {
                
                APVideo *video = [[APVideo alloc]initWithDictionary:[dict objectForKey:@"video"]];
                [tempImageArray addObject:video];
            }
            
        }
        
        if ([dict count] != 1) {
            
            self.listFromUsers = [dict objectForKey:@"user_id"];
            
            self.myMessagesDictionary =[dict objectForKey:@"body"];
            
        }
 
    }
    
    return self;
}
*/

@end
