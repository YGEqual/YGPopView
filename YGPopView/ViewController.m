//
//  ViewController.m
//  YGPopView
//
//  Created by 我的电脑 on 2017/7/14.
//  Copyright © 2017年 Equal. All rights reserved.
//

#import "ViewController.h"
#import "YGPopUpTool.h"

#define YGHeight [UIScreen mainScreen].bounds.size.height
#define YGWidth  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
@property (strong, nonatomic) UIView *popView;
@property (strong, nonatomic) UIButton *popBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGWidth, 350)];
    _popView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 50);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(popViewShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _popBtn.frame = CGRectMake(0, 250, 200, 50);
    _popBtn.backgroundColor = [UIColor greenColor];
    [_popBtn setTitle:@"PPOP" forState:UIControlStateNormal];
    [_popBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_popBtn addTarget:self action:@selector(closeAndBack) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popViewShow {
    NSLog(@"dian le PPOP");
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_popView.bounds];
    imageV.image = [UIImage imageNamed:@"show"];
    [_popView addSubview:imageV];

    [[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:_popView animated:YES];
    
}

- (void)closeAndBack {
    [[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
