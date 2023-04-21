# frozen_string_literal: true

# FIXME: This spec generates lots of warnings because of what looks like garbage files being in the XCFrameworks
#
# Example:
#
# - NOTE  | [iOS] xcodebuild:  note: note: while processing while processing /Users/gio/Developer/a8c/gutenberg-mobile/Johannes/DerivedData/ModuleCache.noindex/29X134XZYNZEH/Foundation-TDMNIE45PJWJ.pcm/Users/gio/Developer/a8c/gutenberg-mobile/Johannes/DerivedData/ModuleCache.noindex/2HX40YJG1I01Y/Foundation-TDMNIE45PJWJ.pcm

# A spec for a pod whose only job is delegating the XCFrameworks integration to CocoaPods.
# We do this so that we can retain the ability to use local sources for Gutenberg.
Pod::Spec.new do |s|
  s.name = 'Gutenberg'
  s.version = '1.0.0' # The value here is irrelevant, but required
  s.summary = 'A spec to help integrating the Gutenberg XCFramework'
  s.homepage = 'https://apps.wordpress.com'
  s.license = 'TODO' # FIXME: Use the same license a gutenberg-mobile
  s.authors = 'Automattic'

  s.ios.deployment_target = '13.0' # TODO: Read from common source
  s.swift_version = '5.0' # TODO: read from common source

  s.requires_arc = true # TODO: Can this be omitted?

  # TODO: Explain how the setup works
  # See https://github.com/CocoaPods/CocoaPods/issues/10288
  #
  # TODO: This might be an opportunity to store the ZIP on S3 and fetch it by tag or commit 🤞
  s.source = { http: "#{__dir__}/Gutenberg.zip", type: 'zip' }
  # Fun fact: Using './name.xcframework' didn't work
  s.ios.vendored_frameworks = [
    'Aztec.xcframework',
    'Johannes.xcframework', # FIXME: This will become Gutenberg.xcframework once I rewrite my prototype for production
    'RNTAztecView.xcframework',
    'React.xcframework',
    'yoga.xcframework'
  ]
end
