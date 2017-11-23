# SNMediator

[![CI Status](http://img.shields.io/travis/yangjie2/SNMediator.svg?style=flat)](https://travis-ci.org/yangjie2/SNMediator)
[![Version](https://img.shields.io/cocoapods/v/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![License](https://img.shields.io/cocoapods/l/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![Platform](https://img.shields.io/cocoapods/p/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)


##0. 概述

SNMediator 是用于 iOS 应用进行模块化拆分实践的通用实现方案，以 URL 的形式实现三端(iOS, Android, H5)统一的资源访问(页面跳转)，当本地页面出现问题时能够紧急更改为H5；以"服务"的形式实现模块间方法调用，解除类似 BeeHive 中各个模块对Protocol的耦合。

##1. 基本架构


![基本架构](http://upload-images.jianshu.io/upload_images/2118879-8baf638048dfb0b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所有页面的跳转都统一使用URL进行访问，模块暴露给外部调用的方法，叫做服务，模块间方法调用都以“服务”的方式进行。


##2. 实现特性


- 所有页面跳转都使用URL，模块间方法调用使用定义好的"服务名"
- 可定义统一三端(iOS,Android,H5/RN/Weex)的页面跳转逻辑
- App出现bug时可将页面动态降级为H5、RReactNative，或者直接换成本地的一个错误界面
- 插件化的模块开发运行框架
- 模块具体实现与接口调用分离
- 模块生命周期管理

待实现：夸界面传参
	
			
##3. URL规则


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

##4. 模块注册

仅提供一种模块注册方式：通过配置本地 plist 文件进行注册。在app启动时调用   

  
```
[[SNMediator shareInstance] registerAllModules];

```



![注册模块的plist配置](http://upload-images.jianshu.io/upload_images/2118879-6eddb38140b1526b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/2118879-6cc93c787d321eca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




## 使用

To run the example project, clone the repo, and run `pod install` from the Example directory first.

在主APP中注册各个模块,并转发app生命周期系统事件到各个模块中：

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    [SNMediator registerAllModules]; //注册模块
    [[SNAppLifeManger shareInstance] transmitAppDelegate:_cmd, application, launchOptions]; //转发该事件到各个模块
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
+ (BOOL)routeURL:(NSURL *)URL;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void(^ _Nullable)(id _Nullable result))completion;
```

服务获取：

```
+ (nullable id)getService:(NSString *)serviceName;

```

例子如下：

```
[SNMediator routeURL:SNURL(@"testModule/vcone") params:nil completion:NULL];

[[SNMediator getService:@"testModule/sayHello"] performAction:@"sayHello"];

```


## Installation

SNMediator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod 'SNMediator'
```





## Author

yangjie2, 987537564@qq.com

## License

SNMediator is available under the MIT license. See the LICENSE file for more info.
