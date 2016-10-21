//
//  MyNavgationController.m
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "MyNavgationController.h"

@interface MyNavgationController ()

@end

@implementation MyNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        UINavigationBar *bar = [UINavigationBar appearance];
        CGFloat rgb = 0.1;
        bar.barTintColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.9];
        bar.tintColor = [UIColor whiteColor];
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
