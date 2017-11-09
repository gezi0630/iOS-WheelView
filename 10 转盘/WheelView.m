//
//  WheelView.m
//  10 转盘
//
//  Created by MAC on 2017/8/25.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "WheelView.h"
#import "WheelButton.h"

@interface WheelView()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *centerView;

@property(weak,nonatomic) UIButton * selBtn;

/**定时器*/
@property(nonatomic,strong)CADisplayLink * link;
@end
@implementation WheelView
//懒加载定时器
-(CADisplayLink *)link
{
    if (_link == nil) {
        _link =[CADisplayLink displayLinkWithTarget:self selector:@selector(angleChange)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
    
}

//加载xib
+(instancetype)wheelView
{
   return  [[NSBundle mainBundle]loadNibNamed:@"WheelView" owner:nil options:nil][0];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _centerView.userInteractionEnabled = YES;
    //按照图片的尺寸设置的btn尺寸
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    //xib的宽高尺寸
    CGFloat wh = self.bounds.size.width;
    
    //加载大图片
    UIImage * bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    
    //加载选中时的大图片
    UIImage * selBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    
    //获取当前图片像素和点的比例
    CGFloat scale = [UIScreen mainScreen].scale;
    //裁剪后图片的宽度
    CGFloat imageW = bigImage.size.width /12 * scale;
    //高度
    CGFloat imageH = bigImage.size.height * scale;
    
    
    //添加按钮
    for (int i= 0; i < 12; i++) {
        
        WheelButton * btn = [WheelButton buttonWithType:UIButtonTypeCustom];
        
        //设置按钮的位置
        btn.layer .anchorPoint = CGPointMake(0.5, 1);
        //大小
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        
        btn.layer.position = CGPointMake(wh * 0.5, wh * 0.5);
        
        //按钮的旋转角度（12个按钮，每个30度）
        CGFloat angle = (30 * i) /180.0 * M_PI;
        btn.transform = CGAffineTransformMakeRotation(angle);
        
        [_centerView addSubview:btn];
        
        
       /**加载按钮的图片**/
        //计算裁剪区域
        CGRect clipRect = CGRectMake(i*imageW, 0, imageW, imageH);
        
        //裁剪图片
        CGImageRef imageClip = CGImageCreateWithImageInRect(bigImage.CGImage, clipRect);
        
        UIImage * imageBtn = [UIImage imageWithCGImage:imageClip];
        //设置按钮的图片
        [btn setImage:imageBtn forState:UIControlStateNormal];
      //-----------
        //裁剪选中时的图片
        CGImageRef imageSel = CGImageCreateWithImageInRect(selBigImage.CGImage, clipRect);
        UIImage * selImageBtn = [UIImage imageWithCGImage:imageSel];
        
        [btn setImage:selImageBtn forState:UIControlStateSelected];
        
        //设置选中背景图片
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        //监听按钮的点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //默认选中第一个
        if (i == 0) {
            [self btnClick:btn];
        }
    }
    
}


-(void)btnClick:(UIButton*)btn
{
    _selBtn .selected = NO;
    btn.selected = YES;
    _selBtn = btn;
}
/**
 开始旋转
 */
-(void)start
{
    
    
//    CABasicAnimation * anim = [CABasicAnimation animation];
//    
//    anim.keyPath = @"transform.rotation";
//    
//    anim.toValue = @(M_PI * 2);
//    
//    anim.duration = 2;
//    
//    anim.repeatCount = MAXFLOAT;
//    
//    [_centerView.layer addAnimation:anim forKey:nil];

    self.link.paused = NO;
    
}

/**
 暂停
 */
-(void)pause
{
    self.link.paused = YES;
}

#pragma mark - 旋转centerView的方法
-(void)angleChange
{
    NSLog(@"%s",__func__);
    //这个方法每秒刷新60次， 每秒让它旋转45˚
    
    CGFloat angle = (45 / 60.0) * M_PI / 180.0;
    
    _centerView.transform = CGAffineTransformRotate(_centerView.transform, angle);
    
    
}

#pragma mark - 点击开始选号
- (IBAction)startPicker {
    
    self.link.paused = YES;
    //使转盘快速旋转
    CABasicAnimation * anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI *2 * 3);
    anim.duration = 0.5;
    anim.delegate = self;
    [_centerView.layer addAnimation:anim forKey:nil];
    
    //通过transform获取角度
    CGFloat angle = atan2(_selBtn.transform.b, _selBtn.transform.a);
    //旋转
    _centerView.transform = CGAffineTransformMakeRotation(-angle);
    
    
}
//动画结束之后
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //1秒后继续旋转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.link.paused = NO;
        
    });
    
}

@end
