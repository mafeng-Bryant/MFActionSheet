//
//  ViewController.m
//  MFActionSheet
//
//  Created by patpat on 16/9/19.
//  Copyright © 2016年 test. All rights reserved.
//

#import "ViewController.h"
#import "MFActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"MFActionSheet";

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MFActionSheet* sheet = [MFActionSheet actionSheetCancelTitle:@"cancel" alertTitle:@"提示文字" subTitles:@"点赞",@"举报",nil];
    [sheet setActionSheetDidItemClick:^(MFActionSheet *actionSheet, NSIndexPath *indexPath, NSString *title) {
        NSLog(@"title = %@",title);
    }];
    [sheet setActionSheetDismissItemClick:^(MFActionSheet *actionSheet, NSIndexPath *indexPath, NSString *title) {
        NSLog(@"cancel");
    }];
    [sheet pop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
