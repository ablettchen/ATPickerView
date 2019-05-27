#
# Be sure to run `pod lib lint ATPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name                    = 'ATPickerView'
s.version                 = '0.1.1'
s.summary                 = 'Picker View'
s.homepage                = 'https://github.com/ablettchen/ATPickerView'
s.license                 = { :type => 'MIT', :file => 'LICENSE' }
s.author                  = { 'ablett' => 'ablettchen@gmail.com' }
s.source                  = { :git => 'https://github.com/ablettchen/ATPickerView.git', :tag => s.version.to_s }
s.social_media_url        = 'https://twitter.com/ablettchen'
s.ios.deployment_target   = '8.0'
s.source_files            = 'ATPickerView/**/*.{h,m}'
s.requires_arc            = true
s.frameworks              = 'UIKit', 'Foundation'

s.dependency 'ATPopupView'

end
