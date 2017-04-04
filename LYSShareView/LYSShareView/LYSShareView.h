//
//  LYSShareView.h
//  LYSShareView
//
//  Created by jk on 2017/4/4.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSShareCell : UICollectionViewCell

#pragma mark - item
@property(nonatomic,copy)NSDictionary *item;

@end

@interface LYSShareView : UIView

#pragma mark - 数据
@property(nonatomic,copy)NSArray *items;

#pragma mark - 列数
@property(nonatomic,assign)NSUInteger column;

#pragma mark - item的高度
@property(nonatomic,assign)CGFloat itemH;

#pragma mark - 标题
@property(nonatomic,copy) NSString *shareTitle;

#pragma mark - 标题的高度
@property(nonatomic,assign)CGFloat titleH;

#pragma mark - 取消按钮的高度
@property(nonatomic,assign)CGFloat cancelBtnH;

#pragma mark - 取消按钮标题
@property(nonatomic,copy) NSString *cancelBtnTitle;

#pragma mark - item被选中时的回调
@property(nonatomic,copy) void(^ItemSelectedBlock)(NSDictionary *item);

#pragma mark - 取消按钮被点击后的回调
@property(nonatomic,copy) void(^CancelBtnClickedBlock)();

#pragma mark - 显示
-(void)showInView:(UIView*)targetView finishBlock:(void(^)())finishBlock;

#pragma mark - 显示
-(void)show:(void(^)())finishBlock;

#pragma mark - 隐藏
-(void)hide:(void(^)())finishedBlock;

@end
