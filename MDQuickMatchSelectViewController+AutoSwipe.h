@interface MDQuickMatchSelectViewController : UIViewController

- (void)doLike;
- (BOOL)isNormalLikeActionDisable;
- (UIButton *)likeButton;
- (UIButton *)disLikeBtton;
- (void)likeButtonClicked:(UIButton *)sender;
- (void)disLikeButtonClicked:(UIButton *)sender;

@end


@interface MDQuickMatchSelectViewController (AutoSwipe)

- (BOOL)shouldAutoSwipe;
- (void)setShouldAutoSwipe:(BOOL)shouldAutoSwipe;

- (void)startAutoSwipe;
- (void)autoSwipeTopCardIfPossible;
- (BOOL)canPerformAutoSwipe;

@end
