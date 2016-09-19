//
//  MFActionSheet.h
//  MFActionSheet
//
//  Created by patpat on 16/9/19.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFActionSheet;

typedef void(^actionSheetClick)(MFActionSheet* actionSheet, NSIndexPath* indexPath, NSString* title);

@interface MFActionSheet : UIView

/**
 *  初始化方法
 *  cancelTitle 取消按钮的标题
 *  alertTitle  提示文本
 *  title       子标题
 */
+ (instancetype)actionSheetCancelTitle:(NSString*)cancelTitle
                            alertTitle:(NSString*)alertTitle
                             subTitles:(NSString*)title,...;
/**
 *  点击某个子标题的回调
 */
- (void)setActionSheetDidItemClick:(actionSheetClick)block;

/**
 *  点击取消按钮的回调
 */
- (void)setActionSheetDismissItemClick:(actionSheetClick)block;

/**
 *  调起ActionSheet
 */
- (void)pop;


@end
