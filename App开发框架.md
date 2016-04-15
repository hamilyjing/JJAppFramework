# APP开发框架

本文主要介绍APP开发框架，包含从UI到底层的整个框架。如果你准备做一个新APP，此框架可以让你快速入手，如果你是准备重构APP代码，此框架可以带给你重构的方法。

先上代码：
[iOS框架代码](https://github.com/hamilyjing/JJAppFramework/tree/master/JJiOSFramework)
[Android框架代码](https://github.com/hamilyjing/JJAppFramework/tree/master/JJAndroidFramework)

## 框架简介

![image](file:///Users/JJ/Desktop/JJ/Github/JJAppFramework/APP开发框架.png)

1. 通用层

	通用层包含第三方库和通用工具，这些工具和业务无任何关系，并且可以单独拿出来放到任何工程中。iOS可以使用CocoaPods管理第三方库。
	
2. 服务层
	
	服务层由服务工厂管理所有服务组件，对外提供装载和卸载服务接口。服务组件采用插件模式，满足特定协议（代码中新增组件需要继承JJService，并且实现serviceName方法）的组件就可以放到服务层。服务组件处理业务逻辑，组件之间不要有任何依赖关系（除少数组件被依赖，如登录服务，配置服务等），也不要有任何UI代码。服务组件由不同的功能集合（FeatureSet）组成，具体的业务逻辑写在每个功能集合中，数据模型也是保存在功能集合中。
	
3. 视图层

	视图层使用MVP模式开发每个功能模块，MVP模式达到视图和业务逻辑分离。对于相同的模块，在不同设备上，View可以不同，Presenter是可以复用，Presenter提供业务接口给View使用，Presenter调用不同的服务组件来满足View的需求，并将服务组件返回的结果回调给View。除非View的需求需要在UI层创建新的模型，其他可以直接使用服务组件中的业务数据模型。

## 框架详解

### 服务组件的装载和卸载

### 网路

### 数据存储

### 数据回调

### 代码自动生成

### 发布服务

	