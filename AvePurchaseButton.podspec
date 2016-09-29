Pod::Spec.new do |s|
  s.name         = "AvePurchaseButton"
  s.version      = "1.0.4"
  s.summary      = "iOS App Store Styled Purchase Button"
  s.description  = <<-DESC
	Drop In App Store Styled Purchase Button, with proper animations. Title configurable in Interface Builder.
                   DESC
  s.homepage     = "https://github.com/AndreasVerhoeven/AvePurchaseButton"
  s.screenshots  = "https://cloud.githubusercontent.com/assets/168214/11920880/852741d6-a77a-11e5-839d-e2f572e49475.gif", "https://cloud.githubusercontent.com/assets/168214/11920878/7c5d708e-a77a-11e5-8553-3806e89ba434.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author            = "Andreas Verhoeven"
  s.social_media_url   = "http://twitter.com/aveapps"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/AndreasVerhoeven/AvePurchaseButton.git", :tag => "1.0.4" }
  s.source_files  = "Source", "Source/**/*.{h,m}"
  s.exclude_files = "Example"
  s.public_header_files = "Source/**/AvePurchaseButton.h", "Source/**/AveBorderedButton.h", "Source/**/AveBorderedView.h"
  s.requires_arc = true
end
