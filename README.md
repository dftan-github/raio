# raio
# A highly customizable ruby application framework for windows

## 偿试在windows7（x64)下基于ruby2.7(x64) 制作高度可定制的应用程序框架（暂定第一个可用版本号为0.1.0.xxxx),版本号的定义尽量跟随开源标准的定义




 ## 依赖gem
  - ffi-wingui-core-1.0.2
  - ffi-1.11.1-x86-mingw32

## 概况：  
- 本项目提供的CObj以树形结构的形式管理对象所有实例变量（属性）
- 对象属性可视化管理
- 任何非win32控件都可嵌入N多个任意类型的控件，且任意摆放（可停靠于父窗口的上、下、左、右、客户区、浮动)
- 继承自CObj的所有类的实例变量使用前都无需声明，会自动动态生成，且默认可读、可写，也可第一次使用到属性时或后期指定只读或者只写，也可随时动态更改可读可写标记
- 因为不存在的属性名（相当于变量）会自动生成，所以使用时需小心不要写错（这可能会是这个库的弊端之一）


# 例如：

```ruby
class CA<CObj
end

o=CA.new
o.a.b.c.val=123   #其中的a,b,c对应树形结点，每个节点都有val实例属性
o.a.b.c.llimit.val=10   #限制o.a.b.c.val 最小值为10
o.a.b.c.ulimit.val=200  #限制o.a.b.c.val 最大值为200
p o.a.b.c.val   #=>123
```


## 目前还只是雏形，使用编译过后的字节码形式分发。使用此形式而非源码发布，主要是基于以下原因
- 是还没成型，代码还杂乱
- 是不想让使用者看到过多的无关代码，让使用者只关心自己想做的事就好了
- 最终是否开源及以何种方式开源还没定（欢迎讨论）

最终可用时鼓励个人使用于非商用项目，公司使用需要授权，目前还没定许可证类型

大致目标原型是制作二次元测量软件作为综合例子

对此项目有任何想法的都可留言讨论

欢迎提出制作Demo的要求（比如仿xxx软件），从小Demo开始制作使用指南，提出制作Demo前先查看是否已经有类似Demo存在

## GUI：
* GUI各控件由 <font face="黑体" color=green size=5>Direct Draw</font>  形式直接自绘，也可以嵌入win32控件
* GUI部分的消息路由例子：on_msg_lb_down->CCmd->App->control

因为在制作过程中发现ruby的一些莫明的表现，例如内存暴涨（也不知道是Bug还是自己没用好），因此非常期望可以得到ruby-core小组的技术支持，以完成制作
 
# 谢谢关注

