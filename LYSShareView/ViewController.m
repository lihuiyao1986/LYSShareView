//
//  ViewController.m
//  LYSShareView
//
//  Created by jk on 2017/4/4.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"
#import "LYSShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"立即分享" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btn.layer.borderWidth = 1;
    _btn.layer.cornerRadius = 8;
    _btn.layer.borderColor = [UIColor redColor].CGColor;
    _btn.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 44.f);
    [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClicked:(UIButton*)sender{
    LYSShareView *_view = [[LYSShareView alloc]init];
    _view.cancelBtnTitle = @"取消分享";
    _view.ItemSelectedBlock = ^(NSDictionary *item){
        NSLog(@"您选中了 = %@",item);
    };
    _view.CancelBtnClickedBlock = ^(){
        NSLog(@"取消按钮被点击");
    };
    _view.shareTitle = @"分享";
    _view.items = @[@{@"title":@"微信好友",@"image":@"LYSShareView.bundle/webchat_friend"},@{@"title":@"微信朋友圈",@"image":@"LYSShareView.bundle/webchat_circle"},@{@"title":@"QQ",@"image":@"LYSShareView.bundle/QQ"},@{@"title":@"QQ空间",@"image":@"LYSShareView.bundle/qzone"}];
    [_view show:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
