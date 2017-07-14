//
//  YGPopUpTool.m
//  YGPopView
//
//  Created by 我的电脑 on 2017/7/14.
//  Copyright © 2017年 Equal. All rights reserved.
//

#import "YGPopUpTool.h"

#define YGHeight [UIScreen mainScreen].bounds.size.height
#define YGWidth  [UIScreen mainScreen].bounds.size.width

/**
 蒙版view
 */
@interface shadeView : UIView

@end

/**
 自定义一个控制器
 */
@interface MyViewController : UIViewController
/**
 控制器中的蒙版view
 */
@property(nonatomic, weak) shadeView *styleView;
@end

/**
 自定义关闭弹出视图的按钮
 */
@interface MyButton : UIButton

@end

/**
 弹出视图工具类
 */
@interface YGPopUpTool()
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UIView *containerView;
@property ( nonatomic, strong ) MyViewController *viewController;
@property ( nonatomic, strong ) MyButton *closeButton;

@end

@implementation YGPopUpTool

/**
 实现单例方法

 @return return the class
 */
+(YGPopUpTool *)sharedYGPopUpTool
{
    static YGPopUpTool *ygPopUpTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ygPopUpTool =[[YGPopUpTool alloc]init];
    });
    return ygPopUpTool;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.isClickBackgroudDismiss = YES;
    }
    return self;
}

-(void)popUpWithPresentView:(UIView *)presentView animated:(BOOL)animated
{
//    window实现根控制器的初始化
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    MyViewController *viewController = [[MyViewController alloc]init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    self.viewController = viewController;

//    设置弹出视图
    UIView *containerView = [[UIView alloc]initWithFrame:(CGRect){0, YGHeight-presentView.bounds.size.height,presentView.bounds.size}];
    [containerView addSubview:presentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;

//    设置关闭按钮
    MyButton *closeButton = [[MyButton alloc]init];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview: closeButton];
    self.closeButton = closeButton;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
        if (animated) {
            viewController.styleView.alpha = 0.5;
            containerView.transform = CGAffineTransformMakeTranslation(0.01, YGHeight);
            [UIView animateWithDuration:0.3 animations:^{
                containerView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
            }];
        }
    });
}
-(void)close{
    [self hideAnimated:YES withCompletionBlock:nil];
}
-(void)cloaseWithBlock:(void (^)())complete
{
    [self hideAnimated:YES withCompletionBlock:complete];
}
- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion {
    if(!animated){
        [self cleanUp];
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            _containerView.transform = CGAffineTransformMakeTranslation(0.01, YGHeight);
            _containerView.alpha = 0;
            self.viewController.styleView.alpha =0;
            
        } completion:^(BOOL finished) {
            [_containerView removeFromSuperview];
            [self.viewController.styleView removeFromSuperview];
            [self cleanUp];
            if(completion){
                completion();
            }
        }];
    }
}

-(void)cleanUp
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
    [[[[UIApplication sharedApplication]delegate]window]makeKeyWindow];
    [self.window removeFromSuperview];
    self.containerView = nil;
    self.window = nil;
}

-(void)dealloc
{
    [self cleanUp];
}

@end


@implementation MyViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadeView *styleView = [[shadeView alloc] initWithFrame:self.view.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    styleView.opaque = NO;
    [self.view addSubview:styleView];
    self.styleView = styleView;
}

@end


@implementation MyButton

-(instancetype)init
{
    self = [super initWithFrame:(CGRect){ YGWidth-32, 0, 32, 32}];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"red_packge_close"] forState:UIControlStateNormal];
    }
    return self;
}
@end

@implementation shadeView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.55] set];
    CGContextFillRect(context, self.bounds);

    CGContextSaveGState(context);
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace), colorSpace = NULL;
    CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
    CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([YGPopUpTool sharedYGPopUpTool].isClickBackgroudDismiss) {
        [[YGPopUpTool sharedYGPopUpTool] hideAnimated:YES withCompletionBlock:nil];
    }
}

@end
