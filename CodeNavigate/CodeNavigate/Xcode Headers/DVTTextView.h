//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface DVTTextView : NSTextView
{
    BOOL _settingMinSizeForClipView;
    BOOL _minWidthTracksClipView;
    BOOL _minHeightTracksClipView;
}

@property BOOL minHeightTracksClipView; // @synthesize minHeightTracksClipView=_minHeightTracksClipView;
@property BOOL minWidthTracksClipView; // @synthesize minWidthTracksClipView=_minWidthTracksClipView;
- (void)setMinSize:(struct CGSize)arg1;
- (void)_superviewClipViewFrameChanged:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 textContainer:(id)arg2;

@end

