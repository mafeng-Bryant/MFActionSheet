# MFActionSheet
MFActionSheet是参考微信的ActionSheet仿写的一个轮子，使用方法简单。

##效果演示

![](https://github.com/mafeng-Bryant/MFActionSheet/raw/master/MFActionSheet/actionsheet.gif)

##使用方法
<pre><code>
  //初始化
  MFActionSheet *actionSheet = [MFActionSheet actionSheetWithCancelTitle:@"取消" alertTitle:@"这是提示文字" SubTitles:@"点赞",@"举报", nil];
    
   //按钮的点击回调
  [actionSheet setActionSheetDidItemClick:^(XRActionSheet *actionSheet, NSIndexPath *actionsheetIndexPath, NSString *title) {
      NSLog(@"row:%ld title:%@",(long)actionsheetIndexPath.row,title);
  }];
  
   //取消按钮的事件回调
  [actionSheet setActionSheetDismissItemClick:^(XRActionSheet *actionSheet, NSIndexPath *actionsheetIndexPath, NSString *title) {
      NSLog(@"取消按钮点击");
  }];
    
   //调起actionsheet
  [actionSheet pop];
  
</pre></code>
