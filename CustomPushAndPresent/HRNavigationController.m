//
//  HRNavigationController.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/9/30.
//

#import "HRNavigationController.h"
#import <objc/runtime.h>
#import "HRPushAnimatedTransitioning.h"
#import "HRPercentDrivenInteractiveTransition.h"

@interface HRNavigationController () <UIGestureRecognizerDelegate>
@property(nonatomic, strong)HRPercentDrivenInteractiveTransition *interactive;
@property(nonatomic, assign)UINavigationControllerOperation operation;
@end

@implementation HRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        /*只要自定义navigationItem的leftBarButtonItem或navigationController，滑动手势会失效。
          因此要重新设置系统自带的右滑返回手势的代理为self
         */
        self.interactivePopGestureRecognizer.delegate = weakself;
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    /*给导航控制器设置了delegate，调用pushViewController:animated:后，
      会去执行navigationController:animationControllerForOperation:fromViewController:toViewController:
     */
    self.delegate = (id)viewController;
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    /*给导航控制器设置了delegate，调用popViewControllerAnimated:后，
      会去执行navigationController:animationControllerForOperation:fromViewController:toViewController:
     */
    self.delegate = self.viewControllers.lastObject;
    return [super popViewControllerAnimated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count <= 1 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}
@end
