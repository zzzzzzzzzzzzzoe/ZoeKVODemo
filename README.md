# ZoeKVODemo
![](https://img.shields.io/badge/Title-ZoeKVODemo-ff69b4.svg)
![](https://img.shields.io/badge/Author-zoe-0f69b4.svg)
## 关于这个Demo
> 看了很多关于kvo的文章，觉得自己也有必要动动手写一写。这样可以让自己更好更深刻的了解kvo的原理。

> 这篇文写的很好推荐一下[iOS-手动实现KVO](http://www.jianshu.com/p/bf053a28accb)


## KVO(Key-Value Observing, 键值观察)
###KVO原理
>当你对一个对象进行观察时, 系统会动态创建一个类继承自原类, 然后重写被观察属性的setter方法. 然后重写的setter方法会负责在调用原setter方法前后通知观察者. KVO还会修改原对象的isa指针指向这个新类.


![](https://github.com/zzzzzzzzzzzzzoe/ZoeKVODemo/blob/master/gifFile/kvo.gif)
