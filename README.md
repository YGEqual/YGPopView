# YGPopView
Encapsulates a bottom-up view of animation tools：
//first ： The introduction of the header file
#import "YGPopUpTool.h"
//second： open   ----> pop
[[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:<#view which you will pop#> animated:YES];
//third：  close  ----> close
[[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];
