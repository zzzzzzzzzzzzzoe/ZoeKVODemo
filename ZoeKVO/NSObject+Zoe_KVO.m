//
//  NSObject+Zoe_KVO.m
//  ZoeKVO
//
//  Created by mac on 2016/12/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSObject+Zoe_KVO.h"
#import <objc/objc-runtime.h>

#define ZOEKVOString @"ZOEKVO_"

@implementation ZoeKVOInfo
- (instancetype)initWithObserver:(id)observer withkey:(NSString *)key AndBlock:(ZoeObserveBlock)block{
    if (self = [super init]) {
        _observer = observer;
        _key = key;
        _observeBlock = block;
    }
    return self;
}


@end


@implementation NSObject(Zoe_KVO)

NSMutableArray * observerInfoArray;

- (void)ZoeKVO_addObserver:(id)observer withkey:(NSString *)key AndBlock:(ZoeObserveBlock)block{
    
    if (!observerInfoArray) {
        observerInfoArray = [[NSMutableArray alloc]init];
    }
    
    //1 判断是否存在要求观察的方法
    SEL setterSelector = NSSelectorFromString([self getSetterName:key]);
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSLog(@"--------------未有此方法---------------");
        return;
    }
    
    //2 添加继承原本类的新类，并将isa指向新类
    
    Class myClass = object_getClass(self);
    NSString *className = NSStringFromClass(myClass);
    if (![className hasPrefix:ZOEKVOString]) {
        myClass = [self getKOVClass:className];
        object_setClass(self, myClass);
    }
    
    //3 给新类添加set方法
    class_addMethod(myClass, setterSelector, (IMP)getSetFunc, method_getTypeEncoding(setterMethod));
    
    //4 创建观察者info
    ZoeKVOInfo * info = [[ZoeKVOInfo alloc]initWithObserver:observer withkey:key AndBlock:block];
    [observerInfoArray addObject:info];
    

}

- (void)ZoeKVO_removeObserver:(id)observer key:(NSString *)key{
    if (observerInfoArray && observerInfoArray.count > 0) {
        for (ZoeKVOInfo * info in observerInfoArray){
            if ([info.key isEqualToString:key]) {
                [observerInfoArray removeObject:info];
                break;
            }
        }
    }
}//删除观察


void getSetFunc(id self, SEL _cmd, id newValue){
    
    NSString * keyName = [self getGetterName:NSStringFromSelector(_cmd)];
    
    id oldValue = [self valueForKey:keyName];
    
    struct objc_super SupermyClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&SupermyClass, _cmd, newValue);
    
    for (ZoeKVOInfo * info in observerInfoArray) {
        if ([info.key isEqualToString:keyName]) {
            // gcd异步调用callback
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.observeBlock(info.observer, keyName, newValue,oldValue);
            });
        }
    }
    
}//新类的setter


-(Class)getKOVClass:(NSString *)name{
    NSString * className = [NSString stringWithFormat:@"%@%@",ZOEKVOString,name];
    Class KVOClass = NSClassFromString(className);
    if (KVOClass) {
        return KVOClass;
    }else{
        KVOClass = objc_allocateClassPair(object_getClass(self), className.UTF8String, 0);
        class_addMethod(KVOClass, @selector(class), class_getMethodImplementation([self class], @selector(zoe_class)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(zoe_class))));
        objc_registerClassPair(KVOClass);
        return KVOClass;
    }
}//添加新类并继承原本类


-(Class)zoe_class{
    Class clazz = object_getClass(self);
    Class superClazz = class_getSuperclass(clazz);
    return superClazz;
} //乔装，返回原本类


-(NSString *)getSetterName:(NSString *)name{
    
    NSString * letter = [name substringToIndex:1];
    NSString * nameStr = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter.uppercaseString];
    NSString *setterName = [NSString stringWithFormat:@"set%@:", nameStr];
    return setterName;
}//setName:(id )name

-(NSString *)getGetterName:(NSString *)name{
    NSString *subStr1 = [[name substringToIndex:name.length - 1] substringFromIndex:3];
    NSString * letter = [subStr1 substringToIndex:1];
    NSString *getterName = [subStr1 stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter.lowercaseString];
    return getterName;
}//name

@end
