//
//  ImageEdit.h
//  iOCR
//
//  Created by xwdmac on 13-12-28.
//  Copyright (c) 2013年 liqilei. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ImageEdit : UIView

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) UIColor *lineColor;

- (void)initPoints;
- (NSArray *)getPoints;
- (id)initWithImageView:(UIImageView *)imageView;

+ (CGPoint)convertPoint:(CGPoint)point1
              fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;
@end
