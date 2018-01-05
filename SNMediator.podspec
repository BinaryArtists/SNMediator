#
# Be sure to run `pod lib lint SNMediator.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'SNMediator'
  s.version          = '0.1.7'
  s.summary          = 'SNMediator is a solution for iOS Application module programs, it is the bridge to communicate between modules without bring about coupling.'

  s.description      = <<-DESC
    SNMediator is a flexible mediator for iOS applications that will be modularized. 
    By Using "URL" to implement the unified resource access method of the three terminals (iOS, Android, H5).
    When bugs occurred, you can easily change native pages to H5 urgently.
    It does  function invocation in the form of "service" among modules , removed the dependency on "procotol"  among modules like in BeeHive.                       
DESC

  s.homepage         = 'https://github.com/yangjie2/SNMediator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjie2' => '987537564@qq.com' }
  s.source           = { :git => 'https://github.com/yangjie2/SNMediator.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.source_files = 'SNMediator/Classes/**/*.{h,m}'
  s.resources = 'SNMediator/Assets/*'

end
