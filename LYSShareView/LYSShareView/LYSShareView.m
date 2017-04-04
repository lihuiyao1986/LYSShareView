//
//  LYSShareView.m
//  LYSShareView
//
//  Created by jk on 2017/4/4.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSShareView.h"


@interface  LYSShareCell()

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation LYSShareCell

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

-(void)setItem:(NSDictionary *)item{
    _item = item;
    NSString *imageUrl = [_item objectForKey:@"image"];
    NSString *title = [_item objectForKey:@"title"];
    self.imgView.image = [UIImage imageNamed:imageUrl];
    self.titleLb.text = title;
}

#pragma mark - 初始化配置
-(void)initConfig{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLb];
}

#pragma mark - 图片视图
-(UIImageView*)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeCenter;
    }
    return _imgView;
}


#pragma mark - layoutSubviews方法重写
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.7);
    self.titleLb.frame = CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 20.f);
}

#pragma mark - 标题视图
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [self colorWithHexString:@"414141" alpha:1.0];
        _titleLb.font = [UIFont systemFontOfSize:12];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

#pragma mark - 生成16进制颜色
-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end

@interface LYSShareView () <UICollectionViewDataSource,UICollectionViewDelegate>

#pragma mark - 列表视图
@property(nonatomic,strong)UICollectionView *collectView;

#pragma mark - 标题视图
@property(nonatomic,strong)UILabel *titleLb;

#pragma mark - 取消按钮
@property(nonatomic,strong)UIButton *cancelBtn;

#pragma mark - 内容视图
@property(nonatomic,strong)UIView *containerView;

@end

@implementation LYSShareView

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - 取消按钮标题
-(void)setCancelBtnTitle:(NSString *)cancelBtnTitle{
    _cancelBtnTitle = cancelBtnTitle;
    [self.cancelBtn setTitle:_cancelBtnTitle forState:UIControlStateNormal];
    [self.cancelBtn setTitle:_cancelBtnTitle forState:UIControlStateHighlighted];
}

#pragma mark - 标题
-(void)setShareTitle:(NSString *)shareTitle{
    _shareTitle = shareTitle;
    self.titleLb.text = _shareTitle;
}

#pragma mark - 初始化配置
-(void)initConfig{
    
    _column = 4;
    
    _itemH = 100.f;
    
    _titleH = 44.f;
    
    _cancelBtnH = 40.f;
    
    self.backgroundColor = [self colorWithHexString:@"000000" alpha:0.4];
        
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.titleLb];
    
    [self.containerView addSubview:self.collectView];
    
    [self.containerView addSubview:self.cancelBtn];
}

-(UICollectionView*)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.pagingEnabled = YES;
        _collectView.backgroundColor = [UIColor clearColor];
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        [_collectView registerClass:[LYSShareCell class] forCellWithReuseIdentifier:NSStringFromClass([LYSShareCell class])];
    }
    return _collectView;
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [self colorWithHexString:@"ffffff" alpha:0.8];
    }
    return _containerView;
}

#pragma mark - 获取取消按钮视图
-(UIButton*)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[self colorWithHexString:@"414141" alpha:1.0] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[self colorWithHexString:@"414141" alpha:0.8] forState:UIControlStateHighlighted];
        [_cancelBtn setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"ffffff" alpha:1.0]] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"ffffff" alpha:0.8]] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancelBtn;
}


#pragma mark - 按钮被点击回调
-(void)btnClicked:(UIButton*)sender{
    __weak typeof (self) MyWeakSelf = self;
    [self hide:^{
        if (MyWeakSelf.CancelBtnClickedBlock) {
            MyWeakSelf.CancelBtnClickedBlock();
        }
    }];
}


#pragma mark - 获取标题视图
-(UILabel*)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [self colorWithHexString:@"999999" alpha:1.0];
    }
    return _titleLb;
}

#pragma mark - layoutSubviews方法重写
-(void)layoutSubviews{
    [super layoutSubviews];
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - [self containerViewH], CGRectGetWidth(self.frame), [self containerViewH]);
    self.titleLb.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.titleH);
    self.collectView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame), CGRectGetWidth(self.frame), self.itemH);
    self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.collectView.frame), CGRectGetWidth(self.frame), _cancelBtnH);
}

#pragma mark - 内容视图的高度
-(CGFloat)containerViewH{
    return self.titleH + self.itemH + self.cancelBtnH;
}

#pragma mark - 将颜色转换成图片
- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -  UICollectionViewDataSource代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYSShareCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LYSShareCell class]) forIndexPath:indexPath];
    _cell.item = self.items[indexPath.row];
    return _cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.width / self.column, self.itemH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self) MyWeakSelf = self;
    [self hide:^{
        if (MyWeakSelf.ItemSelectedBlock) {
            MyWeakSelf.ItemSelectedBlock(MyWeakSelf.items[indexPath.row]);
        }
    }];
    
}

#pragma mark - 显示
-(void)showInView:(UIView*)targetView finishBlock:(void(^)())finishBlock{
    __weak typeof (self) MyWeakSelf = self;
    [self removeFromSuperview];
    [targetView addSubview:self];
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), [self containerViewH]);
    [UIView animateWithDuration:0.35 animations:^{
        MyWeakSelf.containerView.frame = CGRectMake(0, CGRectGetHeight(MyWeakSelf.frame) - [MyWeakSelf containerViewH], CGRectGetWidth(MyWeakSelf.frame), [MyWeakSelf containerViewH]);
    } completion:^(BOOL finished) {
        if (finishBlock) {
            finishBlock();
        }
    }];
}

#pragma mark - 显示
-(void)show:(void(^)())finishBlock{
    [self showInView:[UIApplication sharedApplication].keyWindow finishBlock:nil];
}

#pragma mark - 开始
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.containerView.frame, touchPoint)) {
        [self hide:nil];
    }
}

#pragma mark - 隐藏
-(void)hide:(void(^)())finishedBlock{
    __weak typeof (self) MyWeakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        MyWeakSelf.containerView.frame = CGRectMake(0, CGRectGetHeight(MyWeakSelf.frame), CGRectGetWidth(MyWeakSelf.frame), [MyWeakSelf containerViewH]);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}

#pragma mark - 生成16进制颜色
-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
@end
