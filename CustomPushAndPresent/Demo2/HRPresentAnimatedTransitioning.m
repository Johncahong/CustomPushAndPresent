//
//  HRPresentAnimatedTransitioning.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/1.
//

#import "HRPresentAnimatedTransitioning.h"

@interface HRPresentAnimatedTransitioning ()
@property(nonatomic, assign)PictureTransitionType type;
@end

@implementation HRPresentAnimatedTransitioning

- (instancetype)initType:(PictureTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //present时，fromVC是导航控制器，toVC是HRDetailViewController。dismiss时，fromVC是HRDetailViewController，toVC是导航控制器
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
    
    if (_type == PictureTransitionPresent) {
        toViewStartFrame.origin.x -= toViewEndFrame.size.width;
    }else if (_type == PictureTransitionDismiss) {
        fromViewEndFrame.origin.x += fromViewStartFrame.size.width;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end
