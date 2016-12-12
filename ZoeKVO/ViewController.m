//
//  ViewController.m
//  ZoeKVO
//
//  Created by mac on 2016/12/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Zoe_KVO.h"
@interface ViewController ()
@property (nonatomic,strong) UILabel * KVOLabel;
@property (nonatomic,strong) UIButton * KVOButton;
@property (nonatomic,strong) UILabel * newcolorView, * oldColorView;
@property (nonatomic,strong) NSArray * colorArray;
@end

@implementation ViewController

-(void)dealloc {
    
    [_KVOLabel ZoeKVO_removeObserver:_newcolorView key:@"textColor"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _KVOLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0 , 100, self.view.frame.size.width, 30)];
    _KVOLabel.text = @"我是啥子颜色？？";
    _KVOLabel.textColor = [UIColor redColor];
    _KVOLabel.textAlignment = NSTextAlignmentCenter;

    _KVOButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y, 80, 30)];
    [_KVOButton setBackgroundColor:[UIColor blueColor]];
    [_KVOButton setTitle:@"变颜色" forState:UIControlStateNormal];
    [_KVOButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    _newcolorView = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y + 50, 100, 30)];
    _newcolorView.backgroundColor = [UIColor redColor];
    _newcolorView.text = @"new color";
    _oldColorView = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y + 130, 100, 30)];
    _oldColorView.backgroundColor = [UIColor whiteColor];
    _oldColorView.text = @"old color";


    [_KVOLabel ZoeKVO_addObserver:_newcolorView withkey:@"textColor" AndBlock:^(UILabel * observer, NSString *key, UIColor * newValue, UIColor * oldValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            observer.backgroundColor = newValue;
            _oldColorView.backgroundColor = oldValue;
        });
        
    }];
    
    [self.view addSubview:_KVOButton];
    [self.view addSubview:_KVOLabel];
    [self.view addSubview:_newcolorView];
    [self.view addSubview:_oldColorView];

    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)click{
   _KVOLabel.textColor =  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
