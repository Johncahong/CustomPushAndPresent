//
//  HRPercentDrivenInteractiveTransition.h
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//UIPercentDrivenInteractiveTransition实现UIViewControllerInteractiveTransitioning协议
@interface HRPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (readonly, assign, nonatomic) BOOL canInteractive;
-(void)addGestureToViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
