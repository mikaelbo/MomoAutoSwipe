#import "MDQuickMatchSelectViewController+AutoSwipe.h"

static BOOL autoSwipeActivated = NO;
static BOOL shouldLikeTopCard = YES;
static NSTimer *autoSwipeTimer;
static NSString *normalTitle;


@interface MDNearbyMatchManager : NSObject

- (BOOL)hasData;

@end


%hook MDQuickMatchSelectViewController

- (void)viewDidLoad {
    %orig;
    normalTitle = self.navigationItem.title;
    if ([self respondsToSelector:@selector(likeButton)]) {
        UIButton *likeButton = self.likeButton;
        if ([likeButton isKindOfClass:[UIButton class]]) {
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                     action:@selector(MBMOMO_likeButtonLongPress:)];
            recognizer.minimumPressDuration = 0.25;
            [likeButton addGestureRecognizer:recognizer];
        }
    }
    if ([self respondsToSelector:@selector(disLikeBtton)]) {
        UIButton *dislikeButton = self.disLikeBtton;
        if ([dislikeButton isKindOfClass:[UIButton class]]) {
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                     action:@selector(MBMOMO_dislikeButtonLongPress:)];
            recognizer.minimumPressDuration = 0.25;
            [dislikeButton addGestureRecognizer:recognizer];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    [self setShouldAutoSwipe:NO];
    autoSwipeActivated = NO;
}

#pragma mark - Long press and timer

%new
- (void)MBMOMO_likeButtonLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan || (autoSwipeActivated && !shouldLikeTopCard)) { return; }
    autoSwipeActivated = !autoSwipeActivated;
    shouldLikeTopCard = YES;
    [self setShouldAutoSwipe:autoSwipeActivated];
}

%new 
- (void)MBMOMO_dislikeButtonLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan || (autoSwipeActivated && shouldLikeTopCard)) { return; }
    autoSwipeActivated = !autoSwipeActivated;
    shouldLikeTopCard = NO;
    [self setShouldAutoSwipe:autoSwipeActivated];
}

%new
- (void)timerTick:(NSTimer *)timer {
    if (![self canPerformAutoSwipe] || ![self shouldAutoSwipe]) {
        [timer invalidate];
        return;
    }
    NSInteger randomNumber = (arc4random() % 89) + 1;
    NSTimeInterval time = 0.37 + (randomNumber * 0.0011);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoSwipeTopCardIfPossible];
    });
}

#pragma mark - AutoSwipe toggling

- (BOOL)canPerformAutoSwipe {
    return [self respondsToSelector:shouldLikeTopCard ? @selector(likeButtonClicked:) : @selector(disLikeButtonClicked:)];
}

- (void)startAutoSwipe {
    [autoSwipeTimer invalidate];
    autoSwipeTimer = nil;
    autoSwipeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [self autoSwipeTopCardIfPossible];
}

- (void)autoSwipeTopCardIfPossible {
    if ([self respondsToSelector:@selector(matchManager)]) {
        MDNearbyMatchManager *manager = [self performSelector:@selector(matchManager)];
        if ([manager respondsToSelector:@selector(hasData)]) {
            if (![manager hasData]) {
                return;
            }
        }
    }
    if ([self canPerformAutoSwipe] && [self shouldAutoSwipe]) {
        shouldLikeTopCard ? [self likeButtonClicked:self.likeButton] : [self disLikeButtonClicked:self.disLikeBtton];
    }
}

- (void)setShouldAutoSwipe:(BOOL)shouldAutoSwipe {
    if ([self shouldAutoSwipe] == shouldAutoSwipe) { return; }

    %orig;

    if (shouldAutoSwipe) {
        self.navigationItem.title = @"Auto-swiping";
        [self startAutoSwipe];
    } else {
        self.navigationItem.title = normalTitle;
        [autoSwipeTimer invalidate];
        autoSwipeTimer = nil;
    }
}

#pragma mark - Match and alerts handling

- (void)showNormalLikeLimitAlert {
    [self setShouldAutoSwipe:NO];
    autoSwipeActivated = NO;
    %orig;
}

- (void)handleMatchHitNotification:(id)notification {
    if (!autoSwipeActivated) {
        %orig;
    }
}

- (void)handleMiniProfileNotification:(id)notification {
    if (!autoSwipeActivated) {
        %orig;
    }
}

%end
