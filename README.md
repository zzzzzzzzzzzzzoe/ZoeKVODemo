# ZoeKVODemo
![](https://img.shields.io/badge/Title-ZoeKVODemo-ff69b4.svg)
![](https://img.shields.io/badge/Author-zoe-0f69b4.svg)
## 关于这个Demo
> 看了很多关于kvo的文章，觉得自己也有必要动动手写一写。这样可以让自己更好更深刻的了解kvo的原理。

> 这篇文写的很好推荐一下。[iOS-手动实现KVO](http://www.jianshu.com/p/bf053a28accb)


## KVO(Key-Value Observing, 键值观察)
###KVO原理
>    当你对一个对象进行观察时, 系统会动态创建一个类继承自原类, 然后重写被观察属性的setter方法. 然后重写的setter方法会负责在调用原setter方法前后通知观察者. KVO还会修改原对象的isa指针指向这个新类.当我们去用[self class]查看类的类型时候，发现返回还是原类。其实只是Apple重写了原类的- class方法, 视图欺骗我们, 这个类没有变, 还是原来的那个类(偷龙转凤). 只要我们懂得Runtime的原理, 这一切都只是掩耳盗铃罢了.


###KVO缺陷
>    KVO的监听都会返回到一个固定方法里，但是如果监听的很多就会让方法里的代码过于庞大，并且也会用很多if语句来判断，很麻烦。


## ZoeKVO实现解析


###实现思路


-判断监听方法属性是否存在


-添加继承原本类的新类，并将isa指向新类


-给新类添加setter方法


-创建观察者info

![](https://github.com/zzzzzzzzzzzzzoe/ZoeKVODemo/blob/master/gifFile/kvo.gif)
