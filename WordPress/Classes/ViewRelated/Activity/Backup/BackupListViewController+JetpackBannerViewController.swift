import Foundation

extension BackupListViewController {
    @objc
    static func withJPBannerForBlog(_ blog: Blog) -> UIViewController? {
        guard let backupListVC = BackupListViewController(blog: blog) else {
            return nil
        }
        return JetpackBannerWrapperViewController(childVC: backupListVC, analyticsId: .backup)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let jetpackBannerWrapper = parent as? JetpackBannerWrapperViewController {
            jetpackBannerWrapper.processJetpackBannerVisibility(scrollView)
        }
    }
}
