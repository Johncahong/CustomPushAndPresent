//
//  UIViewController+TransitionProperty.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/3.
//

#import "UIViewController+TransitionProperty.h"
#import <objc/runtime.h>

static NSString *hr_addTransitionFlagKey = @"hr_addTransitionFlagKey";

@implementation UIViewController (TransitionProperty)

//----- hr_addTransitionFlag
- (void)setHr_addTransitionFlag:(BOOL)hr_addTransitionFlag {
    objc_setAssociatedObject(self, &hr_addTransitionFlagKey, @(hr_addTransitionFlag), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)hr_addTransitionFlag {
    return [objc_getAssociatedObject(self, &hr_addTransitionFlagKey) integerValue] == 0 ?  NO : YES;
}

@end
