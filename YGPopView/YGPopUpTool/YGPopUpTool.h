//
//  YGPopUpTool.h
//  YGPopView
//
//  Created by 我的电脑 on 2017/7/14.
//  Copyright © 2017年 Equal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YGPopUpTool : NSObject
/**
 点击蒙版是否退出视图
 */
@property (nonatomic, assign) BOOL isClickBackgroudDismiss;

+(YGPopUpTool *)sharedYGPopUpTool;

-(void)popUpWithPresentView:(UIView *)presentView animated:(BOOL)animated;

-(void)cloaseWithBlock:(void(^)())complete;

@end
