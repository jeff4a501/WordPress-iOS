import XCTest

@testable import WordPress

class BlogDashboardStateTests: XCTestCase {
    private var dashboardState = BlogDashboardState.shared

    override func setUp() {
        super.setUp()

        BlogDashboardState.shared.reset()
    }

    /// `isFirstLoadFailure` is `true` when the dashboard failed to load
    /// and has not cached data
    ///
    func testIsFirstLoadFailureIsTrue() {
        BlogDashboardState.shared.loadingFailed = true
        BlogDashboardState.shared.hasCachedData = false

        XCTAssertTrue(BlogDashboardState.shared.isFirstLoadFailure)
    }

    /// `isFirstLoadFailure` is `false` when the dashboard failed to load
    /// but it has cached data
    ///
    func testIsFirstLoadFailureIsFalse() {
        BlogDashboardState.shared.loadingFailed = true
        BlogDashboardState.shared.hasCachedData = true

        XCTAssertFalse(BlogDashboardState.shared.isFirstLoadFailure)
    }

    /// `isFirstLoad` is `true` when the dashboard is loading
    /// for the first time
    ///
    func testisFirstLoadIsTrue() {
        BlogDashboardState.shared.loadingFailed = false
        BlogDashboardState.shared.hasCachedData = false

        XCTAssertTrue(BlogDashboardState.shared.isFirstLoad)
    }

    /// `isFirstLoad` is `false` when the dashboard is NOT loading
    /// for the first time
    ///
    func testisFirstLoadIsFalseWhenNotLoadingForFirstTime() {
        BlogDashboardState.shared.loadingFailed = false
        BlogDashboardState.shared.hasCachedData = true

        XCTAssertFalse(BlogDashboardState.shared.isFirstLoad)
    }

    /// `isFirstLoad` is `false` when the dashboard is in a
    /// failure state
    ///
    func testisFirstLoadIsFalseWhenInFailureState() {
        BlogDashboardState.shared.loadingFailed = true
        BlogDashboardState.shared.hasCachedData = false

        XCTAssertFalse(BlogDashboardState.shared.isFirstLoad)
    }
}
