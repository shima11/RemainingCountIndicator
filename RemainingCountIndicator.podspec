#
#  Be sure to run `pod spec lint RemainingCountIndicator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RemainingCountIndicator"
  s.version      = "0.0.2"
  s.summary      = "Remaining count indicator like a tweet screen of twitter."

  s.description  = <<-DESC
RemainingCountIndicator is remaining count indicator like a tweet screen of twitter.
                  DESC

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.homepage = "https://github.com/shima11/RemainingCountIndicator"

  s.author             = { "shima" => "shima.jin@icloud.com" }

  s.platform     = :ios, "9.0"

  s.source = { :git => "https://github.com/shima11/RemainingCountIndicator.git", :tag => "#{s.version}"}

  s.source_files = "RemainingCountIndicator", "RemainingCountIndicator/**/*.{h,m,swift}"

end
