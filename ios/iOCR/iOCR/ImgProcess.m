//
//  ImgProcess.m
//  iOCR
//
//  Created by xwdmac on 14-1-8.
//  Copyright (c) 2014年 liqilei. All rights reserved.
//

#import "ImgProcess.h"

@implementation ImgProcess

-(void)CropedImg: (NSArray*)srcPos
{
    cv::Mat matImg(_srcImg);
    std::vector<cv::Point2f> srcPoints;
    std::vector<cv::Point2f> dstPoints;
    cv::Size imgSize;
    
    imgSize.height=_srcImg->height;
    imgSize.width=_srcImg->width;
    
    CGFloat scal=_srcImg->height/330.0;
    
    for (NSValue *dada in srcPos) {
        cv::Point2f point ;
        point.x=dada.CGPointValue.x*scal;
        point.y=dada.CGPointValue.y*scal;
        srcPoints.push_back(point);
    }

    CGFloat correctWidth=srcPoints[1].x-srcPoints[0].x;
    CGFloat correctHeight=correctWidth*239/501;
   // NSLog(@"widthandheight:%f,%f",correctWidth,correctHeight);
    cv::Point2f dpoint;
    dpoint.x=srcPoints[0].x;
    dpoint.y=srcPoints[0].y;
    dstPoints.push_back(dpoint);
    
    dpoint.x=srcPoints[0].x+correctWidth;
    dpoint.y=srcPoints[0].y;
    dstPoints.push_back(dpoint);
    
    dpoint.x=srcPoints[0].x+correctWidth;
    dpoint.y=srcPoints[0].y+correctHeight;
    dstPoints.push_back(dpoint);
    
    dpoint.x=srcPoints[0].x;
    dpoint.y=srcPoints[0].y+correctHeight;
    dstPoints.push_back(dpoint);
    cv::Mat markerTransform = cv::getPerspectiveTransform(srcPoints, dstPoints);
    cv::warpPerspective(matImg, matImg,  markerTransform, imgSize);
    
    
    IplImage temptImage = matImg;
    _recImg=&temptImage;
    
    CvRect cropRect;
    cropRect.x=dstPoints[0].x;
    cropRect.y=fabs(dstPoints[0].y-correctHeight*62/239.0);
    
    cropRect.width=correctWidth;
    cropRect.height=correctHeight+correctHeight*62/239.0;
    cvSetImageROI(_recImg,cropRect);

    _recImg=cvCloneImage(_recImg);
}
-(void)setImg:(IplImage *)src
{
    _srcImg=cvCloneImage(src);
}
@end
