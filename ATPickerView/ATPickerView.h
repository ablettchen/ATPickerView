//
//  ATPickerView.h
//  ATPickerView
//  https://github.com/ablettchen/ATPickerView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <ATPopupView/ATPopupView.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ATPickerConfirmBlock)(NSInteger index);

@interface ATPickerView : ATPopupView

@property (copy, nonatomic, nullable) NSString *title;
@property (copy, nonatomic, nonnull) NSArray<NSString *>*items;
@property (copy, nonatomic, nonnull) ATPickerConfirmBlock confirmBlock;


- (instancetype)initWithItems:(nonnull NSArray<NSString *>*)items
confirmBlock:(nullable ATPickerConfirmBlock)confirmBlock;

- (instancetype)initWithTitle:(nullable NSString *)title
                        items:(nonnull NSArray<NSString *>*)items
                 confirmBlock:(nullable ATPickerConfirmBlock)confirmBlock;

- (void)asInputViewLayout;

///////////////////////////////////////////////////////////////////////////

- (__kindof ATPickerView *(^)(NSString * _Nullable title))withTitle;
- (__kindof ATPickerView *(^)(NSArray<NSString *>*_Nonnull items))withItems;
- (__kindof ATPickerView *(^)(ATPickerConfirmBlock _Nullable confirmBlock))confirm;

@end

@interface ATPickerConfig : NSObject

+ (ATPickerConfig *)globalConfig;

@property (nonatomic, assign) CGFloat innerMargin;          ///< Default is 15.
@property (nonatomic, assign) CGFloat titleHeight;          ///< Default is 44.
@property (nonatomic, assign) CGFloat pickerHeight;         ///< Default is 216.
@property (nonatomic, assign) CGFloat itemRowHeight;        ///< Default is 40.

@property (nonatomic, assign) CGFloat titleFontSize;        ///< Default is 18.
@property (nonatomic, assign) CGFloat buttonFontSize;       ///< Default is 17.
@property (nonatomic, assign) CGFloat itemTextSize;         ///< Default is 15.

@property (nonatomic, strong) UIColor *backgroundColor;     ///< Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          ///< Default is #333333.
@property (nonatomic, strong) UIColor *buttonColor;         ///< Default is #333333.
@property (nonatomic, assign) UIColor *itemTextColor;       ///< Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          ///< Default is #CCCCCC.

@property (nonatomic, strong) NSString *defaultTextCancel;      ///< Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm;     ///< Default is "确定".

@property (nonatomic, strong) UIColor *dimBackgroundColor;                       ///< Default is 0x0000007F
@property (nonatomic, assign) BOOL dimBackgroundBlurEnabled;                     ///< Default is NO
@property (nonatomic, assign) UIBlurEffectStyle dimBackgroundBlurEffectStyle;    ///< Default is UIBlurEffectStyleExtraLight

@end


NS_ASSUME_NONNULL_END
