//
//  SXLCustomView.m
//  WeatherRequest
//
//  Created by didi on 2017/1/19.
//  Copyright © 2017年 didi. All rights reserved.
//

#import "SXLCustomView.h"

@implementation SXLCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画圆角矩形*/
//    float fw = 180;
//    float fh = 280;
    
//    
//    CGContextMoveToPoint(context, CGRectGetWidth(rect)-40, 0);  // 开始坐标右边开始
//    CGContextAddArcToPoint(context, CGRectGetWidth(rect)-40, 0, CGRectGetWidth(rect), 40, 20);  // 右上角角度
//    CGContextAddArcToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-40, CGRectGetWidth(rect)-40, CGRectGetHeight(rect), 20);  // 右下角角度
//    CGContextAddArcToPoint(context, 40, CGRectGetHeight(rect), 0, CGRectGetHeight(rect)-40, 20); // 左下角角度
//    CGContextAddArcToPoint(context, 0, 40, 40, 0, 20); // 左上角
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    CGContextAddRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    aColor = [UIColor redColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    aColor = [UIColor blueColor];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
}




@end
