//
//  HRPushAnimatedTransitioning.h
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRPushAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@property(nonatomic, assign)UINavigationControllerOperation operation;
@end

NS_ASSUME_NONNULL_END
