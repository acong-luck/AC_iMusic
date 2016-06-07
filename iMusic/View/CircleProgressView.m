//
//  CircleProgressView.m
//  Music_for_Acong
//
//  Created by FM-13 on 16/1/16.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    //获取绘图的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
    CGContextSetLineWidth(ctx, 1);
    
    CGContextAddArc(ctx, rect.size.width/2, rect.size.width/2, rect.size.width/2 - 4, 0, 2*M_PI, 0);
    CGContextStrokePath(ctx);
    
    // .画圆弧
    // x/y 圆心
    // radius 半径
    // startAngle 开始的弧度
    // endAngle 结束的弧度
    // clockwise 画圆弧的方向 (0 顺时针, 1 逆时针)
    //    CGContextAddArc(ctx, 100, 100, 50, -M_PI_2, M_PI_2, 0);
    
    CGContextSetRGBStrokeColor(ctx, 0, 1, 1, 1);
    CGContextSetLineWidth(ctx, 1);
    
    
    //NSLog(@"%f", pi);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.width/2, rect.size.width/2 - 5, -M_PI_2, -M_PI_2 +_progressValue * M_PI_2 * 4, 0);
    CGContextStrokePath(ctx);
}

@end
