#
# Be sure to run `pod lib lint SNMediator.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'SNMediator'
  s.version          = '0.1.0'
  s.summary          = 'SNMediator 是用于 iOS 应用进行模块化拆分实践的轻量级实现方案，
                        使用 URL 实现三端(iOS, Android, H5)统一的资源访问(页面跳转)方式，在出现bug时能够不使用JSPath实现紧急更改为H5页面；
                        实现以服务的形进行模块间方法调用，解除类似 BeeHive 中对Protocol的耦合。'

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
