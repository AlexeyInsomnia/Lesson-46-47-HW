//
//  APImages.h
//  Lesson 45 (repear by ALEX)
//
//  Created by Alex on 10.02.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>



@class APVideo;

@protocol APImageDelegate;

@interface APImages : UIView

@property (weak,nonatomic) id <APImageDelegate> delegate;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *framesArray;

- (instancetype) initWithImageArray:(NSArray *)imageArray startPoint:(CGPoint)point;

@end


@protocol APImageDelegate <NSObject>

- (void)openVideo:(APVideo *)video;

@end