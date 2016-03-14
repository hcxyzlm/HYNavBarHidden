//
//  UIViewController+scrollerHidden.m
//  自定义导航控制器
//
//  Created by HelloYeah on 16/3/12.
//  Copyright © 2016年 HelloYeah. All rights reserved.
//

#import "UIViewController+NavBarHidden.h"
#import <objc/runtime.h>
#import "UIImage+imageFromColor.h"


@implementation UIViewController (NavBarHidden)

- (void)clearNavBar{
    
    //清除背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    //清除阴影图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}


static CGFloat alpha = 0; //透明度

- (void)scrollControlRate:(CGFloat)rate colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue isNavBarItemAlpha:(BOOL)isAlpha{
    
    //传值处理
    if (rate >= 1) {
        rate = 0.999999;
    }else if(rate <= 0.000001){
        rate = 0.000001;
    }
    
    
    //根据滚动距离计算透明度
    CGFloat height = (1 - rate) * [UIScreen mainScreen].bounds.size.height;
    
    if ([self getScrollerView]){
        
        UIScrollView * scrollerView = [self getScrollerView];
        
        alpha =  scrollerView.contentOffset.y/height;
    }
    
    if (alpha <= 0) {
        alpha = 0.00001;
    }
    
    //设置背景图片
    UIImage * image = [UIImage imageFromColor:[UIColor colorWithRed:red green:green blue:blue  alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置导航条上的标签为透明
    if (isAlpha)
    {
        self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
        self.navigationItem.titleView.alpha = alpha;
        self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    }
    
}


// 获取tableView 或者 collectionView
- (UIScrollView *)getScrollerView{

    if ([self isKindOfClass:[UITableViewController class]]) {

        return  (UIScrollView *)self.view;
        
    }else if ([self isKindOfClass:[UICollectionViewController class]]){

        return  (UIScrollView *)self.view;

    }else{
        for (UIView * view in self.view.subviews) {
            
            if ([view isEqual:self.keyScrollView] & [view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
                
                return (UIScrollView *)view;
            }
        }
    }
    return nil;
}


#pragma mark - 通过运行时动态添加keyScrollView属性
//定义关联的Key
static const char * key = "keyScrollView";

- (UIScrollView *)keyScrollView{
    
    return objc_getAssociatedObject(self, key);
}

- (void)setKeyScrollView:(UIScrollView *)keyScrollView{
    
    objc_setAssociatedObject(self, key, keyScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self scrollControlRate:0.999999 colorWithRed:1 green:1 blue:1 isNavBarItemAlpha:YES];
}

@end
