//
//  CodeNavigateView.m
//  CodeNavigate
//
//  Created by LIU Can on 16/8/12.
//  Copyright © 2016年 CuiYu. All rights reserved.
//

#import "CodeNavigateView.h"
#import "CodeNavigatePlugin.h"

#import "IDESourceCodeEditor.h"
#import "IDEEditorArea.h"

#import "DVTSourceTextView.h"

@interface CodeNavigateView () <NSLayoutManagerDelegate>

@property (nonatomic, weak) IDESourceCodeEditor *editor;

@property (nonatomic, weak) IDEEditorArea *editorArea;

@property (nonatomic, strong) DVTSourceTextView *editorTextView;

@property (nonatomic, strong) DVTSourceTextView *textView;

@property (nonatomic, strong) NSMutableArray *notificationObservers;
@end

@implementation CodeNavigateView

- (void)dealloc
{
    for(id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    [self.textView.textStorage removeLayoutManager:self.textView.layoutManager];
}

- (instancetype)initWithEditor:(IDESourceCodeEditor *)editor
{
    if (self = [super init]) {
        
        self.editor = editor;
//        [self.editor setSearchResultsDelegate:self];
//        
//        self.editorTextView = editor.textView;
//        
//        [self setWantsLayer:YES];
//        [self setAutoresizingMask:NSViewMinXMargin | NSViewMinYMargin | NSViewWidthSizable | NSViewHeightSizable];
//        
//        self.scrollView = [[SCXcodeMinimapScrollView alloc] initWithFrame:self.bounds editorScrollView:self.editor.scrollView];
//        [self.scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
//        [self.scrollView setDrawsBackground:NO];
//        [self.scrollView setMinMagnification:0.0f];
//        [self.scrollView setMaxMagnification:1.0f];
//        [self.scrollView setAllowsMagnification:NO];
//        
//        [self.scrollView setHasHorizontalScroller:NO];
//        [self.scrollView setHasVerticalScroller:NO];
//        [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
//        [self.scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
//        [self addSubview:self.scrollView];
//        
//        self.textView = [[DVTSourceTextView alloc] initWithFrame:CGRectZero];
//        
//        NSTextStorage *storage = self.editorTextView.textStorage;
//        [self.textView setTextStorage:storage];
//        
//        // The editor's layout manager needs to be the last one, otherwise live issues don't work
//        DVTLayoutManager *layoutManager = self.editorTextView.layoutManager;
//        [(NSMutableArray *)storage.layoutManagers removeObject:layoutManager];
//        [(NSMutableArray *)storage.layoutManagers addObject:layoutManager];
//        
//        [self.editorTextView.layoutManager.foldingManager setDelegate:self];
//        
//        [self.textView setEditable:NO];
//        [self.textView setSelectable:NO];
//        
//        [self.scrollView setDocumentView:self.textView];
//        
//        self.selectionView = [[SCXcodeMinimapSelectionView alloc] init];
//        [self.textView addSubview:self.selectionView];
//        
//        [self updateTheme];
//        
//        for(NSDictionary *providerDictionary in [self.editorTextView.annotationManager valueForKeyPath:@"_annotationProviders"]) {
//            
//            id annotationProvider = providerDictionary[@"annotationProviderObject"];
//            if([annotationProvider isKindOfClass:[DBGBreakpointAnnotationProvider class]]) {
//                self.breakpointAnnotationProvider = annotationProvider;
//                [self.breakpointAnnotationProvider setMinimapDelegate:self];
//            } else if([annotationProvider isKindOfClass:[IDEIssueAnnotationProvider class]]) {
//                self.issueAnnotationProvider = annotationProvider;
//                [self.issueAnnotationProvider setMinimapDelegate:self];
//            }
//        }
//        
//        BOOL shouldHighlightBreakpoints = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHighlightBreakpointsKey] boolValue];
//        BOOL shouldHighlightIssues = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHighlightIssuesKey] boolValue];
//        if(shouldHighlightBreakpoints || shouldHighlightIssues) {
//            [self invalidateBreakpointsAndIssues];
//        }
//        
//        BOOL shouldHighlightSelectedSymbol = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHighlightIssuesKey] boolValue];
//        if(shouldHighlightSelectedSymbol) {
//            [self invalidateHighligtedSymbols];
//        }
//        
//        BOOL shouldHideVerticalScroller = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHideEditorScrollerKey] boolValue];
//        [self.editor.scrollView.verticalScroller setForcedHidden:shouldHideVerticalScroller];
        
        // Notifications
        
        self.notificationObservers = [NSMutableArray array];
        
        __weak typeof(self) weakSelf = self;
        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:CodeNavigateShouldDisplayChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf toggleVisibility];
        }]];
//
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapZoomLevelChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf updateSize];
//            [weakSelf delayedInvalidateMinimap];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightBreakpointsChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf invalidateBreakpointsAndIssues];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightIssuesChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf invalidateBreakpointsAndIssues];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightSelectedSymbolChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf invalidateHighligtedSymbols];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightSearchResultsChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf invalidateSearchResults];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightCommentsChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf delayedInvalidateMinimap];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightPreprocessorChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf delayedInvalidateMinimap];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHighlightEditorChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            
//            BOOL editorHighlightingEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHighlightEditorKey] boolValue];
//            if(editorHighlightingEnabled) {
//                [weakSelf.editorTextView.layoutManager setDelegate:weakSelf];
//            } else {
//                [weakSelf.editorTextView.layoutManager setDelegate:(id<NSLayoutManagerDelegate>)weakSelf.editorTextView];
//            }
//            
//            [weakSelf delayedInvalidateMinimap];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapHideEditorScrollerChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            BOOL shouldHideVerticalScroller = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHideEditorScrollerKey] boolValue];
//            [weakSelf.editor.scrollView.verticalScroller setForcedHidden:shouldHideVerticalScroller];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapAutohideChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [self toggleVisibility];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:SCXcodeMinimapThemeChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf updateTheme];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:DVTFontAndColorSourceTextSettingsChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [weakSelf updateTheme];
//        }]];
//        
//        [self.notificationObservers addObject:[[NSNotificationCenter defaultCenter] addObserverForName:IDESourceCodeEditorTextViewBoundsDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            if([note.object isEqual:weakSelf.editor]) {
//                [weakSelf updateOffset];
//            }
//        }]];
    }
    
    return self;
}

- (void)toggleVisibility
{
    NSLog(@"toggle");
    BOOL visible = [[[NSUserDefaults standardUserDefaults] objectForKey:CodeNavigateShouldDisplayKey] boolValue];
//    BOOL shouldAutohide = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldAutohideKey] boolValue];
    
    if(visible) {
        if(self.editorArea == nil || self.editorArea.editorMode) {
            visible = NO;
        } else {
            NSRange visibleEditorRange = [self.editorTextView visibleCharacterRange];
            if(NSEqualRanges(visibleEditorRange, NSMakeRange(0, self.textView.string.length))) {
                visible = NO;
            }
        }
    }
    
    [self setVisible:visible];
}

#pragma mark - Show/Hide

- (void)setVisible:(BOOL)visible
{
    self.hidden  = !visible;
    
    [self updateSize];
    
    [self.textView.layoutManager setDelegate:(self.hidden ? nil : self)];
    [self.textView.layoutManager setBackgroundLayoutEnabled:YES];
    [self.textView.layoutManager setAllowsNonContiguousLayout:YES];
    
//    DVTLayoutManager *editorLayoutManager = (DVTLayoutManager *)self.editorTextView.layoutManager;
//    [editorLayoutManager setMinimapDelegate:self];
//    
//    BOOL editorHighlightingEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:SCXcodeMinimapShouldHighlightEditorKey] boolValue];
//    if(editorHighlightingEnabled) {
//        [editorLayoutManager setDelegate:self];
//    }
}

#pragma mark - Sizing

- (void)updateSize
{
    CGFloat zoomLevel = 1.0;
    CGFloat minimapWidth = (self.hidden ? 0.0f : self.editor.containerView.bounds.size.width * zoomLevel);
    
    if(CGRectGetWidth(self.bounds) == minimapWidth) {
        return;
    }
    
    NSRect editorScrollViewFrame = self.editor.scrollView.frame;
    editorScrollViewFrame.size.width = self.editor.scrollView.superview.frame.size.width - minimapWidth;
    self.editor.scrollView.frame = editorScrollViewFrame;
    
    [self setFrame:NSMakeRect(CGRectGetMaxX(editorScrollViewFrame), 0, minimapWidth, CGRectGetHeight(self.editor.containerView.bounds))];
    
    CGRect frame = self.textView.bounds;
    frame.size.width = CGRectGetWidth(self.editorTextView.bounds);
    [self.textView setFrame:frame];
    
//    CGFloat actualZoomLevel =  CGRectGetWidth(self.bounds) / CGRectGetWidth(self.editor.textView.bounds);
//    [self.scrollView setMagnification:actualZoomLevel];
//    
//    [self updateOffset];
}
@end
