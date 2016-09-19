//
//  MFActionSheet.m
//  MFActionSheet
//
//  Created by patpat on 16/9/19.
//  Copyright © 2016年 test. All rights reserved.
//

#import "MFActionSheet.h"

static inline CGFloat kScreenWidth(){
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

static inline CGFloat kScreenHeight(){
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

static inline NSString* kValidString(NSString* string) {
    NSCharacterSet* set  = [NSCharacterSet whitespaceCharacterSet];
    return [string stringByTrimmingCharactersInSet:set];
}
static inline CGFloat kLineHeight(){
    return 1/[UIScreen mainScreen].scale;
}

static inline UIColor * XRHex(rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@interface MFActionSheet()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray* subTitles;//数据源
@property (nonatomic,strong) NSString* calcelTitle;
@property (nonatomic,strong) UIView* backGroundView;//背景视图
@property (nonatomic,strong) UITableView* tableView;//内容视图
@property (nonatomic,strong) NSString* alertTitle;

@end

@implementation MFActionSheet
{
    actionSheetClick _clickBlock;
    actionSheetClick _dismissBlock;
}

+ (instancetype)actionSheetCancelTitle:(NSString*)cancelTitle
                            alertTitle:(NSString*)alertTitle
                             subTitles:(NSString*)title,...
{
    MFActionSheet* sheet = [[MFActionSheet alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth(), kScreenHeight())];
    sheet.calcelTitle = cancelTitle;
    sheet.alertTitle= alertTitle;
    NSString* subTitle;
    va_list argumentList;//初始化指向可变参数列表的指针
    if (title) {
        [sheet.subTitles addObject:title];
        va_start(argumentList, title);//将第一个可变参数的地址付给argumentList，即argumentList指向可变参数列表的开始
        while ((subTitle = va_arg(argumentList, id))) {//取可变参数的内容
            NSString* string = [subTitle copy];
            if ([string isKindOfClass:[NSString class]] && [string length] != 0) {
                [sheet.subTitles addObject:string];
            }
        }
        va_end(argumentList);//ap付值为0，没什么实际用处，主要是为程序健壮性
    }
     return  sheet;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backGroundView];

    }
    return self;
}

#pragma mark set
- (void)setActionSheetDidItemClick:(actionSheetClick)block
{
    _clickBlock = block;
}

- (void)setActionSheetDismissItemClick:(actionSheetClick)block
{
    _dismissBlock = block;
}

- (void)pop
{
    self.backGroundView.alpha = 0.0;
    self.tableView.frame = CGRectMake(0 ,kScreenHeight(), kScreenWidth(), [self heightForTableView]);
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateKeyframesWithDuration:0.22 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.backGroundView.alpha = 1.0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -[self heightForTableView]);
     } completion:^(BOOL finished) {
       
   }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [self dismissWithCell:cell];
    }
}

- (CGFloat)heightForTableView
{
    CGFloat rowHeight = kScreenWidth() > 320 ? 55 : 50;
    return  rowHeight * (self.subTitles.count + 1) + 5.0f + ([kValidString(self.alertTitle) length] != 0 ? 60 : 0);
}

- (void)dismissWithCell:(UITableViewCell*)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        if (_dismissBlock) {
    
        [UIView animateWithDuration:0.22f animations:^{
            self.backGroundView.alpha = 0.0f;
            self.tableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                _dismissBlock(self,indexPath,cell.textLabel.text);
                [self removeFromSuperview];
            }
        }];
     }else {
            [self dismiss];
      }
    }else {
        [UIView animateKeyframesWithDuration:0.22f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.backGroundView.alpha = 0.0;
            self.tableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(finished) {
                if (_clickBlock) {
                    _clickBlock(self, indexPath, cell.textLabel.text);
                }
                [self removeFromSuperview];
            }
        }];
   }
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.22f animations:^{
        self.backGroundView.alpha = 0.0f;
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.subTitles.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kScreenWidth() > 320 ? 16 : 15];
    if(indexPath.section == 0) {
        NSString *subTitle = self.subTitles[indexPath.row];
        if ([subTitle containsString:@"删除"] || [subTitle containsString:@"delete"]) {
            cell.textLabel.textColor = XRHex(0xff5a5f);
        } else {
            cell.textLabel.textColor = XRHex(0x333333);
        }
        cell.textLabel.text = [self.subTitles objectAtIndex:indexPath.row];
    }else {
        cell.textLabel.text = self.calcelTitle;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth() > 320 ? 55 : 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if ([kValidString(self.alertTitle) length] == 0) {
            return nil;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth(), 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kValidString(self.alertTitle)];
        [string addAttribute:NSForegroundColorAttributeName value:[[UIColor blackColor] colorWithAlphaComponent:0.5] range:NSMakeRange(0, self.alertTitle.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kScreenWidth() > 320 ? 14 : 13] range:NSMakeRange(0, self.alertTitle.length)];
        [string addAttribute:NSKernAttributeName value:@(0.2) range:NSMakeRange(0, self.alertTitle.length)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineSpacing = 3;
        [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, self.alertTitle.length)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, kScreenWidth() - 30 * 2, 52)];
        label.attributedText = string;
        label.numberOfLines = 0;
        [view addSubview:label];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 60 - kLineHeight(), kScreenWidth(), kLineHeight());
        [view.layer addSublayer:layer];
        layer.backgroundColor = XRHex(0xcccccc).CGColor;
        return view;
        
        
        // return label;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth(), 5)];
        view.backgroundColor = XRHex(0xe0dfde);
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([kValidString(self.alertTitle) length] != 0) {
            return 60;
        } else {
            return 0.01;
        }
    } else {
        return 5;
    }
    return 0.01;
}


/**
 *  让UITablViewCel的分割线左对齐
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self dismissWithCell:cell];
}

#pragma mark getter

-(UITableView *)tableView
{
    if(!_tableView) {
        UITableView *tab = [[UITableView alloc] init];
        tab.delegate = self;
        tab.dataSource = self;
        tab.tableFooterView = nil;
        [tab setSeparatorInset:UIEdgeInsetsZero];
        [tab setLayoutMargins:UIEdgeInsetsZero];
        [self addSubview:tab];
        tab.scrollEnabled = NO;
        _tableView = tab;
    }
    return _tableView;
}

-(UIView *)backGroundView
{
    if(!_backGroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
        [self addSubview:view];
        _backGroundView = view;
    }
    return _backGroundView;
}

-(NSMutableArray *)subTitles
{
    if (!_subTitles) {
        _subTitles = [NSMutableArray array];
    }
    return _subTitles;
}





@end
