# ZCJTemplateTool
一个代码生成器，自动生成网络请求api类文件

# 前言
最近在为一个新项目搭建项目框架。网络层在iOS项目中的地位不言而喻，一个不可或缺的部分，它负责api请求，上传下载等通信功能。之前也曾在AFNetworking的基础上封装过网络库。但在发现了猿题库的网络库后，发现它提供了很强大的功能，比如链式请求，断点上传等功能，这次新项目决定尝试下。猿题库的地址：[https://github.com/yuantiku/YTKNetwork](https://github.com/yuantiku/YTKNetwork)

YTKNetwork虽然功能强大，但在使用过程中发现它的代码量比较大，到处是重复地复制粘贴。因为它是将每个网络请求都封装起来，即一个api对应一个网络请求类，而且将请求参数也作为成员变量封装起来。使用起来很不便。

最后尝试使用代码生成器的方式，配置好请求的各项参数，根据模板自动自成网络api类文件。以下是具体实现方法和源码实例。
# MGTemplateEngine
MGTemplateEngine是mac平台下的一个代码生成器工具，根据模板和数据自动生成结果。它的使用很简单，语法比较灵活。

	NSString *name = @"zcj"
	
	//Hellow {{ name }}!
	//打印结果：Hellow zcj!
当然了，MGTemplateEngine也支持循环和条件判断，如下所示：

	NSArray *arr = [NSArray arrayWithObjects:
									@"matt", @"iain", @"neil", @"chris", @"steve", nil], @"guys"];
	
	//{% for dude in guys %}
		Current dude is {{ dude | uppercase }}
	{% /for %}
	//打印结果：Current dude is matt
	//Current dude is iain
	//Current dude is neil
	//Current dude is chris

	Is 1 less than 2? {% if 1 < 2 %} Yes! {% else %} No? {% /if %}
	//打印结果：Is 1 less than 2? Yes! 
	
MGTemplateEngine还提供更强大的规则和语法，详细信息请前往官方文档查询，地址：[https://github.com/mattgemmell/MGTemplateEngine](https://github.com/mattgemmell/MGTemplateEngine)。
# 代码生成器
我们看一下YTKNetwork的请求类是什么样的

	// RegisterApi.h
	#import "YTKRequest.h"
	
	@interface RegisterApi : YTKRequest
	
	- (id)initWithUsername:(NSString *)username password:(NSString *)password;
	
	@end
	
	
	// RegisterApi.m
	
	#import "RegisterApi.h"
	
	@implementation RegisterApi {
	    NSString *_username;
	    NSString *_password;
	}
	
	- (id)initWithUsername:(NSString *)username password:(NSString *)password {
	    self = [super init];
	    if (self) {
	        _username = username;
	        _password = password;
	    }
	    return self;
	}
	
	- (NSString *)requestUrl {
	    // “ http://www.yuantiku.com ” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
	    return @"/iphone/register";
	}
	
	- (YTKRequestMethod)requestMethod {
	    return YTKRequestMethodPOST;
	}
	
	- (id)requestArgument {
	    return @{
	        @"username": _username,
	        @"password": _password
	    };
	}
	
	@end
我们发现，这个类的内容格式比较固定，只有类名，成员变量名，url和请求类型是不固定的，这样我们就能使用代码生成器制作模板了。

先画个界面，放置一些需要输入的参数，包括类名，成员变量名，url和请求类型。

将用户输入的数据按一定的格式组织起来，放置到字典中。其中请求参数的数据结构是以键值对的格式放到数组中，具体请看源码。
	
	    // Set up some variables for this specific template.
	    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
	                               mArr, @"Param",
	                               _classNameTF.stringValue, @"ClassName",
	                               _urlTF.stringValue, @"Url",
	                               [_typeCB objectValueOfSelectedItem], @"MethodType",
	                               nil];
下面来做类的模板，这个类基本结构不变，将类名，成员变量名，url和请求类型等几处替换掉成变量形式，成员变量部分要根据输入的数据动态生成，代码如下：

	//
	//  {{ ClassName }}.m
	//  ZCJNetworkCodeGenerateTool
	//
	//  Created by zcj on 2017/2/24.
	//  Copyright © 2017年 zcj. All rights reserved.
	//
	
	#import "{{ ClassName }}.h"
	
	@implementation {{ ClassName }} {
	{% for p in Param %}
	    {{ p.value }} *_{{ p.key }};
	{% /for %}
	}
	
	
	- (id)init{% for p in Param %}With{{ p.key | capitalized }}:({{ p.value }} *){{ p.key }} {% /for %}{
	    self = [super init];
	    if (self) {
	        {% for p in Param %}
	        _{{ p.key }} = {{ p.key }};
			{% /for %}
	    }
	    return self;
	}
	
	- (NSString *)requestUrl {
	    return @"{{ Url }}";
	}
	
	- (YTKRequestMethod)requestMethod {
	    return {{ MethodType }};
	}
	
	- (id)requestArgument {
	
	    return @{ {% for p in Param %}@"{{ p.key }}": _{{ p.key }}{% if Param.@lastObject.key equalsString p.key %}{% else %}, {% /if %}{% /for %}};
	}
	@end
	
# 总结
代码生成器的实现还是比较简单的，了解一下MGTemplateEngine的语法和规则，很容易写出自己的代码生成器。利用MGTemplateEngine之类的工具可以帮助我们简化了大部分的重复性工作，节省大家的时间。

掌握了代码生成器的基本使用，我们就可以在遇到类似的场景，做出自己的自动处理方法。
