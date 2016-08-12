//
//  CodeNavigatePlugin.m
//  CodeNavigate
//
//  Created by LIU Can on 16/8/12.
//  Copyright © 2016年 CuiYu. All rights reserved.
//

#import "CodeNavigatePlugin.h"
#import "IDESourceCodeEditor.h"
#import "DVTSourceTextView.h"

#import "CodeNavigateView.h"

NSString *const IDESourceCodeEditorDidFinishSetupNotification = @"IDESourceCodeEditorDidFinishSetup";

NSString *const CodeNavigateShouldDisplayChangeNotification = @"CodeNavigateShouldDisplayChangeNotification";
NSString *const CodeNavigateShouldDisplayKey = @"CodeNavigateShouldDisplayKey";

NSString *const kViewMenuItemTitle = @"View";

NSString *const kCodeNavigateMenuItemTitle = @"CodeNavigate";
NSString *const kShowCodeNavigateMenuItemTitle = @"Show CodeNavigate";
NSString *const kHideCodeNavigateMenuItemTitle = @"Hide CodeNavigate";

@implementation CodeNavigatePlugin

//整个插件的入口
+ (void)pluginDidLoad:(NSBundle *)plugin
{
    BOOL isApplicationXcode = [[[NSBundle mainBundle] infoDictionary][@"CFBundleName"] isEqual:@"Xcode"];
    if (isApplicationXcode) {
        static CodeNavigatePlugin *sharedCodeNavigate = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedCodeNavigate = [[self alloc] init];
        });
    }
}

- (id)init
{
    if (self = [super init]) {
        
        [self registerUserDefaults];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self createMenuItem];
        });

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidFinishSetup:) name:IDESourceCodeEditorDidFinishSetupNotification object:nil];
    }
    return self;
}

- (void)registerUserDefaults
{
    NSDictionary *userDefaults = @{CodeNavigateShouldDisplayKey   : @(YES)};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaults];
}

#pragma mark - Menu Items and Actions

- (void)createMenuItem
{
    NSMenuItem *viewMenuItem = [[NSApp mainMenu] itemWithTitle:kViewMenuItemTitle];
    
    if(viewMenuItem == nil) {
        return;
    }
    
    [viewMenuItem.submenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *minimapMenuItem = [[NSMenuItem alloc] initWithTitle:kCodeNavigateMenuItemTitle action:nil keyEquivalent:@""];
    [viewMenuItem.submenu addItem:minimapMenuItem];
    
    NSMenu *minimapMenu = [[NSMenu alloc] init];
    {
        NSMenuItem *showHideMinimapItem = [[NSMenuItem alloc] initWithTitle:@"" action:@selector(toggleCodeNavigate:) keyEquivalent:@"N"];
        [showHideMinimapItem setKeyEquivalentModifierMask:NSControlKeyMask | NSShiftKeyMask];
        [showHideMinimapItem setTarget:self];
        [minimapMenu addItem:showHideMinimapItem];
        
        BOOL shouldDisplayMinimap = [[[NSUserDefaults standardUserDefaults] objectForKey:CodeNavigateShouldDisplayKey] boolValue];
        [showHideMinimapItem setTitle:(shouldDisplayMinimap ? kHideCodeNavigateMenuItemTitle : kShowCodeNavigateMenuItemTitle)];
        
        [minimapMenu addItem:[NSMenuItem separatorItem]];
    }
    
    [minimapMenuItem setSubmenu:minimapMenu];
}

- (void)toggleCodeNavigate:(NSMenuItem *)sender
{
    BOOL shouldDisplayMinimap = [[[NSUserDefaults standardUserDefaults] objectForKey:CodeNavigateShouldDisplayKey] boolValue];
    
    [sender setTitle:(!shouldDisplayMinimap ? kHideCodeNavigateMenuItemTitle : kShowCodeNavigateMenuItemTitle)];
    [[NSUserDefaults standardUserDefaults] setObject:@(!shouldDisplayMinimap) forKey:CodeNavigateShouldDisplayKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:CodeNavigateShouldDisplayChangeNotification object:nil];
}
#pragma mark - Xcode Notification

- (void)onDidFinishSetup:(NSNotification*)sender
{
    if(![sender.object isKindOfClass:[IDESourceCodeEditor class]]) {
        NSLog(@"Could not fetch source code editor container");
        return;
    }
    
    IDESourceCodeEditor *editor = (IDESourceCodeEditor *)[sender object];
    [editor.textView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable];
    [editor.scrollView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable];
    [editor.containerView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable];
    
    CodeNavigateView *codeNaviateView = [[CodeNavigateView alloc] initWithEditor:editor];
    [editor.containerView addSubview:codeNaviateView];
}
@end
