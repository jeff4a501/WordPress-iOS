# frozen_string_literal: true

# This file isolates the definition of which version of Gutenberg to use.
# This way, it can be accessed by multiple sources without duplication.

# Either use commit or tag, if both are left uncommented, tag will take precedence.
#
# If you want to use a local version, please use the LOCAL_GUTENBERG environment variable when calling CocoaPods.
#
# Example:
#
#   LOCAL_GUTENBERG=../my-gutenberg-fork bundle exec pod install
GUTENBERG_CONFIG = {
  # To facilitate the adoption of the XCFramework setup, which greatly speeds up `pod install`,
  # we shipped an ad hoc commit build with the v1.97.1 code,
  # even though the codebase for that tag did not have the necessary automation.
  # This approach will no longer be necessary starting v1.98.0,
  # which should be cut from `trunk` at a point where all the necessary automation is already in place.
  commit: 'ce86d9eafeb6b83c38eb7f4745d4b9be96675778'
  # tag: 'v1.97.1'
}

GITHUB_ORG = 'wordpress-mobile'
REPO_NAME = 'gutenberg-mobile'
