//
//  ImgProcess.h
//  iOCR
//
//  Created by xwdmac on 14-1-8.
//  Copyright (c) 2014年 liqilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
@interface ImgProcess : NSObject

@property IplImage *srcImg;
@property IplImage *recImg;

-(void)setImg:(IplImage *)src;
-(void)CropedImg:(NSArray*)srcPos;
@end
