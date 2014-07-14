//
//  ImageView.m
//  iOCR
//
//  Created by liqilei on 12/2/13.
//  Copyright (c) 2013 liqilei. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView
- (id)initWithImageView:(UIImageView *)imageView
{
    
    self = [super initWithFrame:imageView.frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds   = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"TouchBegin");
    UITouch* touch = [touches anyObject];
    self.lastTouch = [touch locationInView: self];
    self.firstTouch = self.lastTouch;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"TouchEnd");
    NSLog(@"newpos:%f,%f",_gsbhX,_gsbhY);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"TouchMove");
    UITouch* touch = [touches anyObject];
    self.lastTouch = [touch locationInView: self];
    [self reDrawAll];
    self.firstTouch = self.lastTouch;
}

- (void) reDrawAll
{
    CGFloat smooth = 0.05;
    self.offsetX += (self.lastTouch.x - self.firstTouch.x) * smooth;
    self.offsetY += (self.lastTouch.y - self.firstTouch.y) * smooth;
    
    [self setNeedsDisplay];
}

- (void) setMode:(int)mode
{
    if(_mode != mode)
    {
        _mode = mode;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.image drawInRect: CGRectMake(0, 0, 430, 330)];
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    //CGFloat leftMost = 10.0;
    //CGFloat topMost = 58.0;
    
    CGFloat leftMost = 5.0;
    CGFloat topMost = 58.0;
    
    CGFloat scale = 2.0;
    
    
    self.gsbhX = leftMost + 35 * scale + self.offsetX * scale;
    self.gsbhY = topMost + 5 * scale + self.offsetY * scale;
    self.gsbhW = 51 * scale;
    self.gsbhH = 6 * scale;
    CGContextAddRect(context, CGRectMake(self.gsbhX, self.gsbhY, self.gsbhW, self.gsbhH));
    
    self.xsbhX = leftMost + 35 * scale + self.offsetX * scale;
    self.xsbhY = topMost + 86 * scale + self.offsetY * scale;
    self.xsbhW = 51 * scale;
    self.xsbhH = 6 * scale;
    CGContextAddRect(context, CGRectMake(self.xsbhX, self.xsbhY, self.xsbhW, self.xsbhH));
    
    self.kprqX = leftMost + 175 * scale + self.offsetX * scale;
    self.kprqY = topMost - 9 * scale + self.offsetY * scale;
    self.kprqW = 31 * scale;
    self.kprqH = 6* scale;
    CGContextAddRect(context, CGRectMake(self.kprqX, self.kprqY, self.kprqW, self.kprqH));
    
    self.jeX = leftMost + 144 * scale + self.offsetX * scale;
    self.jeY = topMost + 65 * scale + self.offsetY * scale;
    self.jeW = 25 * scale;
    self.jeH = 6 * scale;
    CGContextAddRect(context, CGRectMake(self.jeX, self.jeY, self.jeW, self.jeH));
    
    self.seX = leftMost + 183 * scale + self.offsetX * scale;
    self.seY = topMost + 65 * scale + self.offsetY * scale;
    self.seW = 26.5 * scale;
    self.seH = 6 * scale;
    CGContextAddRect(context, CGRectMake(self.seX, self.seY, self.seW, self.seH));
    
    if(_mode == 108)
    {
        self.mmX = leftMost + 126 * scale + self.offsetX * scale;
        self.mmY = topMost + 1.5 * scale + self.offsetY * scale;
        self.mmW = 76 * scale;
        self.mmH = 18 * scale;
        CGContextAddRect(context, CGRectMake(self.mmX, self.mmY, self.mmW, self.mmH));
        
        self.fpdmX = leftMost + 192 * scale + self.offsetX * scale;
        self.fpdmY = topMost - 21 * scale + self.offsetY * scale;
        self.fpdmW = 20 * scale;
        self.fpdmH = 5 * scale;
        CGContextAddRect(context, CGRectMake(self.fpdmX, self.fpdmY, self.fpdmW, self.fpdmH));
        
        self.fphmX = leftMost + 192 * scale + self.offsetX * scale;
        self.fphmY = topMost - 15.5 * scale + self.offsetY * scale;
        self.fphmW = 20* scale;
        self.fphmH = 5 * scale;
        CGContextAddRect(context, CGRectMake(self.fphmX, self.fphmY, self.fphmW, self.fphmH));
    }
    else
    {
        self.mmX = leftMost + 126* scale + self.offsetX * scale;
        self.mmY = topMost + 1.8 * scale + self.offsetY * scale;
        self.mmW = 60 * scale;
        self.mmH = 19 * scale;
        CGContextAddRect(context, CGRectMake(self.mmX, self.mmY, self.mmW, self.mmH));
        
        self.fpdmX = leftMost + 186 * scale + self.offsetX * scale;
        self.fpdmY = topMost + 9 * scale + self.offsetY * scale;
        self.fpdmW = 23 * scale;
        self.fpdmH = 5.5 * scale;
        CGContextAddRect(context, CGRectMake(self.fpdmX, self.fpdmY, self.fpdmW, self.fpdmH));
        
        self.fphmX = leftMost + 186 * scale + self.offsetX * scale;
        self.fphmY = topMost + 14 * scale + self.offsetY * scale;
        self.fphmW = 23 * scale;
        self.fphmH = 6.5 * scale;
        CGContextAddRect(context, CGRectMake(self.fphmX, self.fphmY, self.fphmW, self.fphmH));
    }
    /*
    CGFloat width = 203.0 * scale;
    CGFloat height = 95.0 * scale;
    
    CGFloat rightMost = leftMost + width;
    CGFloat bottomMost = topMost + height;
    
    CGFloat hLine0 = topMost;
    CGFloat hLine1 = topMost + 22.0 * scale;
    CGFloat hLine2 = topMost + 65.0 * scale;
    CGFloat hLine3 = topMost + 75.0 * scale;
    CGFloat hLine4 = topMost + height;
    

    CGFloat redWidth = 30 * scale;
    CGFloat redHeight = 20 * scale;
    CGFloat redX = leftMost + 101 * scale - redWidth * 0.5;
    CGFloat redY = topMost - 2 * scale - redHeight;
    //Draw red stamp
    CGContextAddEllipseInRect(context, CGRectMake(redX, redY, redWidth, redHeight));
    
    //Draw 5 horizonal lines
    CGContextMoveToPoint(context, leftMost, hLine0);
    CGContextAddLineToPoint(context, rightMost, hLine0);
    
    CGContextMoveToPoint(context, leftMost, hLine1);
    CGContextAddLineToPoint(context, rightMost, hLine1);
    
    CGContextMoveToPoint(context, leftMost, hLine2);
    CGContextAddLineToPoint(context, rightMost, hLine2);
    
    CGContextMoveToPoint(context, leftMost, hLine3);
    CGContextAddLineToPoint(context, rightMost, hLine3);
    
    CGContextMoveToPoint(context, leftMost, hLine4);
    CGContextAddLineToPoint(context, rightMost, hLine4);
    
    //Draw vertical lines
    CGContextMoveToPoint(context, leftMost, topMost);
    CGContextAddLineToPoint(context, leftMost, bottomMost);
    
    CGContextMoveToPoint(context, rightMost, topMost);
    CGContextAddLineToPoint(context, rightMost, bottomMost);
    
    //1st row
    CGFloat vLine11 = leftMost + 8.0 * scale;
    CGFloat vLine12 = leftMost + 116.0 * scale;
    CGFloat vLine13 = leftMost + 121.0 * scale;
    
    CGContextMoveToPoint(context, vLine11, hLine0);
    CGContextAddLineToPoint(context, vLine11, hLine1);
    
    CGContextMoveToPoint(context, vLine12, hLine0);
    CGContextAddLineToPoint(context, vLine12, hLine1);
    
    CGContextMoveToPoint(context, vLine13, hLine0);
    CGContextAddLineToPoint(context, vLine13, hLine1);
    
    //2nd row
    CGFloat vLine21 = leftMost + 53.0 * scale;
    CGFloat vLine22 = leftMost + 78.0 * scale;
    CGFloat vLine23 = leftMost + 91.0 * scale;
    CGFloat vLine24 = leftMost + 111.0 * scale;
    CGFloat vLine25 = leftMost + 131.0 * scale;
    CGFloat vLine26 = leftMost + 162.0 * scale;
    CGFloat vLine27 = leftMost + 173.0 * scale;
    
    CGContextMoveToPoint(context, vLine21, hLine1);
    CGContextAddLineToPoint(context, vLine21, hLine3); //special
    
    CGContextMoveToPoint(context, vLine22, hLine1);
    CGContextAddLineToPoint(context, vLine22, hLine2);
    
    CGContextMoveToPoint(context, vLine23, hLine1);
    CGContextAddLineToPoint(context, vLine23, hLine2);
    
    CGContextMoveToPoint(context, vLine24, hLine1);
    CGContextAddLineToPoint(context, vLine24, hLine2);
    
    CGContextMoveToPoint(context, vLine25, hLine1);
    CGContextAddLineToPoint(context, vLine25, hLine2);
    
    CGContextMoveToPoint(context, vLine26, hLine1);
    CGContextAddLineToPoint(context, vLine26, hLine2);
    
    CGContextMoveToPoint(context, vLine27, hLine1);
    CGContextAddLineToPoint(context, vLine27, hLine2);
    
    
    //3rd row
    CGFloat vLine31 = leftMost + 8.0 * scale;
    CGFloat vLine32 = leftMost + 116.0 * scale;
    CGFloat vLine33 = leftMost + 121.0 * scale;
    
    CGContextMoveToPoint(context, vLine31, hLine3);
    CGContextAddLineToPoint(context, vLine31, hLine4);
    
    CGContextMoveToPoint(context, vLine32, hLine3);
    CGContextAddLineToPoint(context, vLine32, hLine4);
    
    CGContextMoveToPoint(context, vLine33, hLine3);
    CGContextAddLineToPoint(context, vLine33, hLine4);
    */
    CGContextStrokePath(context);
}

@end