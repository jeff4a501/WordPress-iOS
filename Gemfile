# frozen_string_literal: true

source 'https://rubygems.org'

gem 'cocoapods', '~> 1.11'
gem 'commonmarker'
gem 'danger', '~> 8.6'
gem 'danger-rubocop', '~> 0.10'
gem 'dotenv'
gem 'fastlane', '~> 2.174'
gem 'fastlane-plugin-appcenter', '~> 1.8'
# The version is pinned because the plugin expects a minimum version of the
# Sentry CLI available on the machine and we want to avoid accidental upgrades
# that might result in it requiring a version different from what CI vendors.
#
# Before upgrading, verify whether the version the updated plugin requires is
# compatible with what is in the latest VM image.
#
# Of course, if a new version is _really_ needed, we can always run `brew
# upgrade sentry-cli` in the CI scripts to get it untill we build a new image
# that has it available.
#
# The Sentry CLI hasn't changed much in the history of the codebase, so this
# seems like a safe compromise for the sake of keeping our setup simple.
gem 'fastlane-plugin-sentry', '1.11.0'
# This comment avoids typing to switch to a development version for testing.
# gem 'fastlane-plugin-wpmreleasetoolkit', git: 'git@github.com:wordpress-mobile/release-toolkit', branch: 'trunk'
gem 'fastlane-plugin-wpmreleasetoolkit', '~> 7.0'
gem 'octokit', '~> 4.0'
gem 'rake'
gem 'rubocop', '~> 1.30'
gem 'rubocop-rake', '~> 0.6'
gem 'xcpretty-travis-formatter'

group :screenshots, optional: true do
  gem 'rmagick', '~> 3.2.0'
end
