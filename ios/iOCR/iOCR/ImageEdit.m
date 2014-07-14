//
//  ImageEdit.m
//  iOCR
//
//  Created by xwdmac on 13-12-28.
//  Copyright (c) 2013年 liqilei. All rights reserved.
//

#import "ImageEdit.h"
#import <QuartzCore/QuartzCore.h>

#define k_POINT_WIDTH 25

@interface ImageEdit () {
    
    CGPoint lastPoint;
}

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UIView *activePoint;


@end

@implementation ImageEdit

- (id)initWithImageView:(UIImageView *)imageView
{
    
    self = [super initWithFrame:imageView.frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.pointColor      = [UIColor redColor];
        self.lineColor       = [UIColor yellowColor];
        self.clipsToBounds   = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.points.count <= 0) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, self.frame);
    
    const CGFloat *components = CGColorGetComponents(self.lineColor.CGColor);
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    if(CGColorGetNumberOfComponents(self.lineColor.CGColor) == 2)
    {
        red   = 1;
        green = 1;
        blue  = 1;
        alpha = 1;
    }
    else
    {
        red   = components[0];
        green = components[1];
        blue  = components[2];
        alpha = components[3];
        if (alpha <= 0) alpha = 1;
    }

    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, 2.0);
    
    UIView *point1 = [self.points objectAtIndex:0];
    CGContextMoveToPoint(context, point1.frame.origin.x +k_POINT_WIDTH/2, point1.frame.origin.y +k_POINT_WIDTH/2);
    
    for (uint i=1; i<self.points.count; i++)
    {
        UIView *point = [self.points objectAtIndex:i];
        CGContextAddLineToPoint(context, point.frame.origin.x +k_POINT_WIDTH/2, point.frame.origin.y +k_POINT_WIDTH/2);
    }
    
    CGContextAddLineToPoint(context, point1.frame.origin.x +k_POINT_WIDTH/2, point1.frame.origin.y +k_POINT_WIDTH/2);
    CGContextStrokePath(context);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    
    for (UIView *point in self.points)
    {
        CGPoint viewPoint = [point convertPoint:locationPoint fromView:self];
        
        if ([point pointInside:viewPoint withEvent:event])
        {
            self.activePoint = point;
            self.activePoint.backgroundColor = [UIColor redColor];
            break;
        }
    }
    lastPoint = locationPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    self.activePoint.frame = CGRectMake(locationPoint.x -k_POINT_WIDTH/2, locationPoint.y -k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH);
        [self setNeedsDisplay];
    lastPoint = locationPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint.backgroundColor = self.pointColor;
    self.activePoint = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint.backgroundColor = self.pointColor;
    self.activePoint = nil;
}



//顶点相关
//
//初始化定点位置

- (void)initPoints
{
    
    NSMutableArray *tmp = [NSMutableArray array];
    int pointsAdded= 0;
    int pointsToAdd= 3;
    float pointsPerSide = 0.0;
    
    
    //各顶点按顺时针
    //左上角
    UIView *point = [self getPointView:pointsAdded at:CGPointMake(30, 77)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    if (pointsPerSide - (int)pointsPerSide >= 0.25)
        pointsPerSide ++;
    
    for (uint i=0; i<(int)pointsPerSide; i++)
    {
        float x = ((self.frame.size.width -40) / ((int)pointsPerSide +1)) * (i+1);
        
        point = [self getPointView:pointsAdded at:CGPointMake(x +10, 10)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.25)
        pointsPerSide --;
    
    //  右上角
    point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -30, 77)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    if (pointsPerSide - (int)pointsPerSide >= 0.5)
        pointsPerSide ++;
    
    for (uint i=0; i<(int)pointsPerSide; i++)
    {
        float y = (self.frame.size.height -40) / ((int)pointsPerSide +1)  * (i+1);
        
        point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -30, 20+y)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.5)
        pointsPerSide --;
    
    // 右下角
    point = [self getPointView:pointsAdded at:CGPointMake(self.frame.size.width -30, self.frame.size.height -77)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    
    if (pointsPerSide - (int)pointsPerSide >= 0.75)
        pointsPerSide ++;
    
    for (uint i=(int)pointsPerSide; i > 0; i--)
    {
        float x = (self.frame.size.width -40) / ((int)pointsPerSide +1) * i;
        
        point = [self getPointView:pointsAdded at:CGPointMake(x +30, self.frame.size.height -50)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    if (pointsPerSide - (int)pointsPerSide >= 0.75)
        pointsPerSide --;
    
    //左下角
    point = [self getPointView:pointsAdded at:CGPointMake(30, self.frame.size.height -77)];
    [tmp addObject:point];
    [self addSubview:point];
    pointsAdded ++;
    pointsToAdd --;
    
    for (uint i=pointsPerSide; i>0; i--)
    {
        float y = (self.frame.size.height -40) / (pointsPerSide +1) * i;
        
        point = [self getPointView:pointsAdded at:CGPointMake(30, 30+y)];
        [tmp addObject:point];
        [self addSubview:point];
        pointsAdded ++;
        pointsToAdd --;
    }
    
    
    self.points = tmp;
}
//获取顶点位置数组
- (NSArray *)getPoints
{
    NSMutableArray *p = [NSMutableArray array];
    
    for (uint i=0; i<self.points.count; i++)
    {
        UIView *v = [self.points objectAtIndex:i];
        CGPoint point = CGPointMake(v.frame.origin.x +k_POINT_WIDTH/2, v.frame.origin.y +k_POINT_WIDTH/2);
        [p addObject:[NSValue valueWithCGPoint:point]];
        NSLog(@"weizhi:%f,%f",point.x,point.y);
    }
    
    return p;
}

- (UIView *)getPointView:(int)num at:(CGPoint)point
{
    UIView *point1 = [[UIView alloc] initWithFrame:CGRectMake(point.x -k_POINT_WIDTH/2, point.y-k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH)];
    point1.alpha = 0.8;
    point1.backgroundColor    = self.pointColor;
    point1.layer.borderColor  = self.lineColor.CGColor;
    point1.layer.borderWidth  = 4;
    point1.layer.cornerRadius = k_POINT_WIDTH/2;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_POINT_WIDTH, k_POINT_WIDTH)];
    number.text = [NSString stringWithFormat:@"+"];
    number.textColor = [UIColor whiteColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:14];
    number.textAlignment = NSTextAlignmentCenter;
    
    [point1 addSubview:number];
    
    return point1;
}

+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}


@end
