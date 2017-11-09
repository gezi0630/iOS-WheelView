//
//  ViewController.m
//  10 转盘
//
//  Created by MAC on 2017/8/25.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"


@interface ViewController ()

@property(nonatomic,weak)WheelView * wheelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //添加转盘View
    WheelView * wheel = [WheelView wheelView];
    _wheelView = wheel;
    
    wheel.center = self.view.center;
    
    [self.view addSubview:wheel];



}


/**
 开始
 */
- (IBAction)startRotation {
    
    [_wheelView start];
}

/**
 暂停
 */
- (IBAction)pauseRotation {
    
    [_wheelView pause];
}


@end
