import WordPressShared

/// This lives as an extension on a separate file because it's specific to our UI
/// implementation and shouldn't be in a generic ImmuTable that we might eventually
/// release as a standalone library.
///
extension ImmuTableViewHandler {

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        WPStyleGuide.configureTableViewSectionFooter(view)
    }
}

extension WPStyleGuide {
    // TODO: Move this into WPStyleGuide. It's currently duplicated.
    @objc
    class func configureTableViewSectionFooter(_ footer: UIView) {
        guard let footer = footer as? UITableViewHeaderFooterView,
              let textLabel = footer.textLabel else {
            return
        }
        if textLabel.isUserInteractionEnabled {
            textLabel.textColor = .primary
        }
    }
}
