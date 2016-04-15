# APP开发框架

本文主要介绍APP开发框架，包含从UI到底层的整个框架。如果你准备做一个新APP，此框架可以让你快速入手，如果你是准备重构APP代码，此框架可以带给你重构的方法。

先上代码：
[iOS框架代码](https://github.com/hamilyjing/JJAppFramework/tree/master/JJiOSFramework)
[Android框架代码](https://github.com/hamilyjing/JJAppFramework/tree/master/JJAndroidFramework)

## 框架简介

![image](file:///Users/JJ/Desktop/JJ/Github/JJAppFramework/APP开发框架.png)

* 通用层

通用层包含第三方库和通用工具，这些工具和任何业务无任何关系，可单独拿出来放到任何工程中。第三方库可以由任何