//
//  HRPresentAnimatedTransitioning.h
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PictureTransitionType) {
    PictureTransitionPresent = 0,//显示
    PictureTransitionDismiss //消失
};

@interface HRPresentAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initType:(PictureTransitionType)type;

@end

NS_ASSUME_NONNULL_END
