//
//  HRPushAnimatedTransitioning.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/1.
//

#import "HRPushAnimatedTransitioning.h"

@implementation HRPushAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    //containerView本来有fromView，只需添加toView
    [containerView addSubview:toView];
    
    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toViewStartFrame = [transitionContext finalFrameForViewController:toVC];

    CGRect fromViewEndFrame = fromViewStartFrame;
    CGRect toViewEndFrame = toViewStartFrame;

    if (_operation == UINavigationControllerOperationPush) {
        toViewStartFrame.origin.y -= toViewEndFrame.size.height;
    }else if (_operation == UINavigationControllerOperationPop) {
        fromViewEndFrame.origin.y += fromViewStartFrame.size.height;
        [containerView sendSubviewToBack:toView];
    }

    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        //transitionContext.transitionWasCancelled
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
