@import UIKit;

@class Blog;

@protocol ScenePresenter;

@interface BlogListViewController : UIViewController

@property (nonatomic) BOOL canBypassBlogList;
@property (nonatomic, strong) Blog *selectedBlog;
@property (nonatomic, strong) id<ScenePresenter> meScenePresenter;
@property (nonatomic, copy) void (^blogSelected)(BlogListViewController* blogListViewController, Blog* blog);

- (id)initWithMeScenePresenter:(id<ScenePresenter>)meScenePresenter;
- (void)setSelectedBlog:(Blog *)selectedBlog animated:(BOOL)animated;

- (void)presentInterfaceForAddingNewSiteFrom:(UIView *)sourceView;
- (void)bypassBlogListViewController;
- (BOOL)shouldBypassBlogListViewController;

@end
