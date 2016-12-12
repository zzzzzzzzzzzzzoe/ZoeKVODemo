//
//  NSObject+Zoe_KVO.h
//  ZoeKVO
//
//  Created by mac on 2016/12/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ZoeObserveBlock)(id  observer,NSString * key,id newValue , id oldValue);

@interface ZoeKVOInfo : NSObject

@property (nonatomic,weak) id observer;

@property (nonatomic,copy)ZoeObserveBlock observeBlock;

@property (nonatomic,copy)NSString * key;

- (instancetype)initWithObserver:(id)observer withkey:(NSString *)key AndBlock:(ZoeObserveBlock)block;

@end

@interface NSObject(Zoe_KVO)

- (void)ZoeKVO_addObserver:(id)observer withkey:(NSString *)key AndBlock:(ZoeObserveBlock)block;

- (void)ZoeKVO_removeObserver:(id)observer key:(NSString *)key;

@end
