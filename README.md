# SNMediator

[![CI Status](http://img.shields.io/travis/yangjie2/SNMediator.svg?style=flat)](https://travis-ci.org/yangjie2/SNMediator)
[![Version](https://img.shields.io/cocoapods/v/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![License](https://img.shields.io/cocoapods/l/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)
[![Platform](https://img.shields.io/cocoapods/p/SNMediator.svg?style=flat)](http://cocoapods.org/pods/SNMediator)


##0. 概述

SNMediator 是用于 iOS 应用进行模块化拆分实践的通用实现方案，以 URL 的形式实现三端(iOS, Android, H5)统一的资源访问(页面跳转)，当本地页面出现问题时能够紧急更改为H5；以"服务"的形式实现模块间方法调用，解除类似 BeeHive 中各个模块对Protocol的耦合。

##1. 基本架构


![](/Users/yangjie/Desktop/未命名文件 (1).png)

URL规则:

URL 的一般格式为：scheme://host:port/path?query#fragment
其中，scheme  通信协议方案，常见的比如 http(s), ftp, mailto, file, data,  irc
           host  主机，指定的服务器的域名系统 (DNS) 主机名或 IP 地址
           port  端口号，整数，可选，省略时使用方案的默认端口，如http的默认端口为80
           path  路径，由零或多个“/”符号隔开的字符串，一般用来表示主机上的一个目录或文件地址
           query  查询，可选，用于给动态网页（如使用CGI、ISAPI、PHP/JSP/ASP/ASP.NET等技术制作的网页）传递参数，
可有多个参数，用“&”符号隔开，每个参数的名和值用“=”符号隔开
           fragment  信息片断，字符串，用于指定网络资源中的片断。例如一个网页中有多个名词解释，可使用fragment直接定位到某一名词解释
           
比如  http://www.example.com/index.html   包含了 scheme (http), host (www.example.com), 以及path (index.html)

在 SNMediator 中，URL 定义规则如下：
默认: snow://host/path，其中host为对应模块名，path为对应页面名/服务名

所有页面跳转和方法调用都通过 URL 形式进行（包括模块间、模块内）
模块间方法调用: 使用 target - action 形式(解除了模块对 protocol 的依赖)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

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
