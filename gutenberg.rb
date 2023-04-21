# frozen_string_literal: true

# CocoaPods helpers for the Gutenberg integration.

GUTENBERG_VERSION = 'v1.93.0'

USE_XCFRAMEWORK = true

# Note that the pods in this array might seem unused if you look for
# `import` statements in this codebase. However, make sure to also check
# whether they are used in the gutenberg-mobile and Gutenberg projects.
#
# See https://github.com/wordpress-mobile/gutenberg-mobile/issues/5025
DEPENDENCIES = %w[
  FBLazyVector
  React
  ReactCommon
  RCTRequired
  RCTTypeSafety
  React-Core
  React-CoreModules
  React-RCTActionSheet
  React-RCTAnimation
  React-RCTBlob
  React-RCTImage
  React-RCTLinking
  React-RCTNetwork
  React-RCTSettings
  React-RCTText
  React-RCTVibration
  React-callinvoker
  React-cxxreact
  React-jsinspector
  React-jsi
  React-jsiexecutor
  React-logger
  React-perflogger
  React-runtimeexecutor
  boost
  Yoga
  RCT-Folly
  glog
  react-native-safe-area
  react-native-safe-area-context
  react-native-video
  react-native-webview
  RNSVG
  react-native-slider
  BVLinearGradient
  react-native-get-random-values
  react-native-blur
  RNScreens
  RNReanimated
  RNGestureHandler
  RNCMaskedView
  RNCClipboard
  RNFastImage
  React-Codegen
  React-bridging
].freeze

REPO = 'wordpress-mobile/gutenberg-mobile'

def gutenberg_dependencies(options:)
  if options[:path]
    podspec_prefix = options[:path]
  else
    tag_or_commit = options[:tag] || options[:commit]
    podspec_prefix = "https://raw.githubusercontent.com/#{REPO}/#{tag_or_commit}"
  end

  # FBReactNativeSpec needs special treatment because of react-native-codegen code generation
  pod 'FBReactNativeSpec', podspec: "#{podspec_prefix}/third-party-podspecs/FBReactNativeSpec/FBReactNativeSpec.podspec.json"

  DEPENDENCIES.each do |pod_name|
    pod pod_name, podspec: "#{podspec_prefix}/third-party-podspecs/#{pod_name}.podspec.json"
  end
end

def gutenberg_pods(options: {})
  if USE_XCFRAMEWORK
    pod 'Gutenberg', path: './Gutenberg'
  else
    # TODO: We'll want to remove the option to use the pods from gutenberg-mobile and only leave the local path option once the XCFramework implementation is solid
    options[:git] = "https://github.com/#{REPO}.git"
    options[:submodules] = true
    options[:tag] = GUTENBERG_VERSION

    local_gutenberg = ENV.fetch('LOCAL_GUTENBERG', nil)
    if local_gutenberg
      options = { path: local_gutenberg.include?('/') ? local_gutenberg : '../gutenberg-mobile' }
    end

    pod 'Gutenberg', options
    pod 'RNTAztecView', options
    gutenberg_dependencies(options: options)
  end
end
