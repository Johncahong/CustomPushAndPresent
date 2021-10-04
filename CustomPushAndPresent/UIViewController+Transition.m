//
//  UIViewController+Transition.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/3.
//

#import "UIViewController+Transition.h"
#import "HRPushAnimatedTransitioning.h"
#import "HRPercentDrivenInteractiveTransition.h"

//分类中的变量相当于全局静态变量，不属于UIViewController
UINavigationControllerOperation _operation;
HRPercentDrivenInteractiveTransition *_interactive;

@implementation UIViewController (Transition)

#pragma mark Push/Pop
//用于自定义Push or Pop的转场
//返回值非nil表示使用自定义的Push or Pop转场。nil表示使用系统默认的转场
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (!self.hr_addTransitionFlag) {
        return nil;
    }
    HRPushAnimatedTransitioning *obj = [[HRPushAnimatedTransitioning alloc] init];
    obj.operation = operation;
    _operation = operation;
    if (operation == UINavigationControllerOperationPush) {
//            NSLog(@"_interactive:%@--%@", _interactive, self);
        if (_interactive == nil) {
            _interactive = [[HRPercentDrivenInteractiveTransition alloc] init];
        }
        [_interactive addGestureToViewController:self];
    }
    return obj;
}

//使用自定义的Push or Pop转场才会回调该方法，用于自定义滑动手势的转场交互方式
//返回值非nil表示可交互处理转场进度。nil表示无法交互处理转场进度，直接完成转场
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if (_operation == UINavigationControllerOperationPush) {
        return nil;
    }else{
        if (_interactive.canInteractive) {
            return  _interactive;
        }else{
            return nil;
        }
    }
}


@end
