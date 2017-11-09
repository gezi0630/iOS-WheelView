//
//  WheelButton.m
//  10 转盘
//
//  Created by MAC on 2017/8/26.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "WheelButton.h"

@implementation WheelButton

//查找最合适的view（使用这个方法，靠近"开始选号"附近一周的部分，在用户点击时会失效）
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //以这个按钮二分之一部分为分界线，点击上半部分有效果，下半部分没有效果
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;
    
    CGFloat x = 0;
    CGFloat y = btnH /2;
    CGFloat w = btnW;
    CGFloat h = y;
    CGRect rect = CGRectMake(x, y, w, h);
    
    //如果点击的点在这个范围内
    if (CGRectContainsPoint(rect, point)) {
        //那么没有反应
        return nil;
    }else
    {  //否则，执行相应事件
        return [super hitTest:point withEvent:event];
    }
}
/**
 设定按钮的尺寸

 @param contentRect 按钮的尺寸
 
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 40;
    CGFloat imageH = 46;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    
    
    return CGRectMake(imageX, imageY, imageW, imageH);
    
    
}

@end
