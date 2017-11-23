#
# Be sure to run `pod lib lint SNMediator.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'SNMediator'
  s.version          = '0.1.2'
  s.summary          = 'SNMediator is a lightweight implementation plan for iOS applications to be modularized. 
    By Using "URL" to implement the unified resource access method of the three terminals (iOS, Android, H5), when a bug occurred, you can easily change native pages to H5 urgently, instead of JSPath;
    It implemented  function invocation in the form of "service" among modules , removed the dependency of the module on "procotol" like in BeeHive.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangjie2/SNMediator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjie2' => '987537564@qq.com' }
  s.source           = { :git => 'https://github.com/yangjie2/SNMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SNMediator/Classes/**/*.{h,m}'
  s.resources = ['SNMediator/Assets/*','SNMediator/Classes/*.xib']

end
