# SNMediator

[![CI Status](http://img.shields.io/travis/yangjie2/SNMediator.svg?style=flat)](https://travis-ci.org/yangjie2/SNMediator)
[![Version](https://img.shields.io/cocoapods/v/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![License](https://img.shields.io/cocoapods/l/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![Platform](https://img.shields.io/cocoapods/p/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)


## 0. 概述

SNMediator 是一个灵活的用于 iOS 应用进行模块化拆分的中间件。随着单个APP业务量和代码量的不断膨胀，越来越多的企业/开发团队采用模块化的代码框架，实现跨APP代码复用以及功能复用、保证稳定迭代、能够更好的共享资源，避免重复造轮子、业务隔离，实现跨团队开发代码控制和版本风险控制。彻底的模块化就要做到模块之间真正的解耦，让模块之间没有循环依赖, 让业务模块之间解除依赖，否则模块化就没有意义。

当按照一定规则做好模块化之后，公共模块可以通过架构设计来避免耦合业务，但是业务模块之间还是会有耦合的，这种耦合一般指的是页面跳转、方法调用。那如何解耦不同业务模块之间的代码调用呢？也就是每个模块之间怎么不耦合对方实现通信？

通常，我们使用一个中间调度部件全权负责各个模块之间的通信。SNMediator 就是这样一个中间件，它不依赖任何第三方库，采用 URL 跳转协议实现三端(iOS, Android, H5)统一的资源访问(页面跳转)方式: 模块间任何页面都是通过 URL 来跳转；模块间方法调用通过"服务名"获取对应服务进行调用。


## 1. 基本架构


![基本架构](http://upload-images.jianshu.io/upload_images/2118879-8baf638048dfb0b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所有页面的跳转都统一使用URL进行；模块中想要暴露出来供外部调用的接口，统一定义在一个 protocol 中，该 protocol 需要继承自 SNServiceProtocol 。然后再定义一个实现该 protocol 的类就可以了。protocol 中的方法我们统一称为“服务”。注册URL和服务的方法参考 **[模块注册]**。


## 2. 实现特性


- 所有页面跳转都使用URL，模块间方法(服务)调用使用自定义的"服务名"
- 可定义统一三端(iOS,Android,H5/RN/Weex)的页面跳转逻辑
- App出现bug时可将页面动态降级为H5、RReactNative，或者直接换成本地的一个错误界面
- 插件化的模块开发运行框架
- 模块具体实现与接口调用分离
- 模块生命周期管理
- 支持返回到已经存在于视图栈中的页面，并逆向传参更新页面
	
			
## 3. URL规则


URL 的一般格式为：`scheme://host:port/path?query#fragment`

scheme  通信协议方案，常见的比如 http(s), ftp, mailto, file, data,  irc

host  主机，指定的服务器的域名系统 (DNS) 主机名或 IP 地址

port  端口号，整数，可选，省略时使用方案的默认端口，如http的默认端口为80
           
path  路径，由零或多个“/”符号隔开的字符串，一般用来表示主机上的一个目录或文件地址
           
query  查询，可选，用于给动态网页（如使用CGI、ISAPI、PHP/JSP/ASP/ASP.NET等技术制作的网页）传递参数，可有多个参数，用“&”符号隔开，每个参数的名和值用“=”符号隔开

fragment  信息片断，字符串，用于指定网络资源中的片断。例如一个网页中有多个名词解释，可使用fragment直接定位到某一名词解释
           
比如  http://www.example.com/index.html   包含了 scheme (http), host (www.example.com), 以及path (index.html)

在 SNMediator 中，URL 定义规则如下：
默认: snow://host/path，其中host为对应模块名，path为对应页面名

所有页面跳转都通过 URL 形式进行（包括模块间、模块内）


模块间方法调用: 使用 target - action 形式(解除了模块对 protocol 的依赖)。给模块暴露出来的接口定义相应的服务名，调用时使用 "模块名/服务名" 进行服务调用。


## 4. 模块注册

仅提供一种模块注册方式：通过配置本地 plist 文件进行注册。在app启动时调用   

  
```
[[SNMediator shareInstance] registerAllModules];

```



![注册模块的plist配置](http://upload-images.jianshu.io/upload_images/2118879-5dcd360538390db3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




## 5. 使用

在主APP中注册各个模块,并转发app生命周期系统事件到各个模块中：

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    [SNMediator registerAllModules]; //注册模块
    [[SNAppLifeManger shareInstance] forwardAppDelegate:_cmd, application, launchOptions]; //转发该事件到各个模块
    return YES;
}

```

只要在主app中转发了生命周期，那么在模块中直接在相应代理方法中做你想做的事就好。

假如有模块 SNTestModule ,在主APP内已经配置好了生命周期转发，在该模块内特定的 ModuleAppDelegate 中相应代理中去处理你的任务就行了。

```
//SNTestModule


//SNTestModuleAppDelegate.h

@import UIKit;
#import "SNApplicationDelegate.h"

@interface SNTestModuleAppDelegate : UIResponder <SNApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

//SNTestModuleAppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	//app启动时该模块需要做的一些工作写在这里
	
    return YES;
}

```


页面跳转：

```
//跳转到新的页面
+ (BOOL)routeURL:(NSURL *)URL;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void(^ _Nullable)(id _Nullable result))completion;

//返回到已经存在于视图栈中的页面，并逆向传参更新页面 (页面如果不存在，则无任何响应)
+ (void)routeBackToURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block;

```

服务获取：

```
+ (nullable id)getService:(NSString *)serviceName;

```

比如：

```
//跳转到新的页面
[SNMediator routeURL:SNURL(@"testModule/vcone") params:nil completion:NULL];

//获取服务
[[SNMediator getService:@"testModule/sayHello"] performAction:@"sayHello"];

//返回到已经存在于视图栈中的某个界面, 并传参改变其背景颜色
[SNMediator routeBackToURL:SNURL(@"testModule/vcone") params:@{@"bgColor":[UIColor yellowColor]} completion:NULL];

```


## 集成方式

SNMediator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod 'SNMediator'
```





## 作者

yangjie2, yangjie2107@hotmail.com

## License

SNMediator is available under the MIT license. See the LICENSE file for more info.
