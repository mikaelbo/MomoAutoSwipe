#import "MDQuickMatchSelectViewController+AutoSwipe.h"
#import <objc/runtime.h>

@implementation UIViewController (AutoSwipe)

- (BOOL)shouldAutoSwipe {
    return [objc_getAssociatedObject(self, @selector(shouldAutoSwipe)) boolValue];
}

- (void)setShouldAutoSwipe:(BOOL)shouldAutoSwipe {
    objc_setAssociatedObject(self, @selector(shouldAutoSwipe), @(shouldAutoSwipe), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)toggleAutoSwipeIfNeeded {

}

- (void)autoSwipeTopCardIfPossible {

}

- (void)startAutoSwipe {

}

- (BOOL)canPerformAutoSwipe {
    return NO;
}

@end
