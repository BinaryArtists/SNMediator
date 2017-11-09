#
# Be sure to run `pod lib lint SNMediator.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'SNMediator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SNMediator.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangjie2/SNMediator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjie2' => '987537564@qq.com' }
  s.source           = { :git => 'git@github.com:yangjie2/SNMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'SNMediator/Classes/**/*.{h,m}'

  s.resources = ['SNMediator/Assets/*','SNMediator/Classes/*.xib']

end
