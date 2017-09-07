#
#  Be sure to run `pod spec lint rupert.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  
    s.name         = "Rupert"
    s.version      = "0.0.1"
    s.summary      = "Functional form validation library written in Swift"
  
    s.description  = <<-DESC
    Lightweight form validation library.
    Takes advantage of functional programming and provides testable and easy-to-read code.
    Read more about usage in
    [the README](https://github.com/sunshinejr/Moya-ModelMapper)
    DESC
  
    s.homepage     = "https://github.com/josefdolezal/rupert"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Josef Doležal" => "pepik.ml@gmail.com" }
    s.social_media_url   = "http://twitter.com/josefdolezal"
  
    s.requires_arc = true
    s.source        = { :git => "https://github.com/sunshinejr/Moya-ModelMapper.git", :tag => s.version.to_s }
    s.source_files  = "Classes", "Sources/**/*.swift"  
  
    s.ios.deployment_target = "8.0"
    s.osx.deployment_target = "10.10"
    s.watchos.deployment_target = "2.0"
    s.tvos.deployment_target = "9.0"
  end
  