//
//  CodeNavigateView.h
//  CodeNavigate
//
//  Created by LIU Can on 16/8/12.
//  Copyright © 2016年 CuiYu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IDESourceCodeEditor;
@interface CodeNavigateView : NSView
- (instancetype)initWithEditor:(IDESourceCodeEditor *)editor;
@end
