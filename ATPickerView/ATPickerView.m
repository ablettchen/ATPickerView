//
//  ATPickerView.m
//  ATPickerView
//  https://github.com/ablettchen/ATPickerView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPickerView.h"
#import <ATCategories/ATCategories.h>
#import <Masonry/Masonry.h>
#import <ATPopupView/UIView+ATPopup.h>

@interface ATPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *comfirmBtn;

@property (assign, nonatomic) NSInteger selectedIndex;

@end
@implementation ATPickerView

#pragma mark - lifecycle

#pragma mark - privite

- (void)setupWithTitle:(NSString *)title
                 items:(NSArray<NSString *> *)items
          confirmBlock:(nullable ATPickerConfirmBlock)confirmBlock {
    
    NSAssert(items.count>0, @"Could not find any items.");
    
    self.type = ATPopupTypeSheet;
    self.items = items;
    self.selectedIndex = 0;
    
    ATPickerConfig *config = [ATPickerConfig globalConfig];
    
    self.backgroundColor = config.splitColor;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    {
        self.titleView = [UIView new];
        [self addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(config.titleHeight));
        }];
        self.titleView.backgroundColor = config.backgroundColor;
        
        CGFloat cancelWidth = ceilf([config.defaultTextCancel?:@"-" widthForFont:[UIFont systemFontOfSize:config.buttonFontSize]]);
        CGFloat confirmWidth = ceilf([config.defaultTextConfirm?:@"-" widthForFont:[UIFont systemFontOfSize:config.buttonFontSize]]);
        
        UIButton *cancelButton = [UIButton buttonWithTarget:self action:@selector(cancelAction:)];
        [self.titleView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleView).offset(config.innerMargin);
            make.top.bottom.equalTo(self.titleView);
            make.width.equalTo(@(cancelWidth));
        }];
        [cancelButton setTitle:config.defaultTextCancel?:@"-" forState:UIControlStateNormal];
        [cancelButton setTitleColor:config.buttonColor forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:config.buttonFontSize]];
        
        UIButton *confirmButton = [UIButton buttonWithTarget:self action:@selector(confirmAction:)];
        [self.titleView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleView).offset(-config.innerMargin);
            make.top.bottom.equalTo(self.titleView);
            make.width.equalTo(@(confirmWidth));
        }];
        [confirmButton setTitle:config.defaultTextConfirm?:@"-" forState:UIControlStateNormal];
        [confirmButton setTitleColor:config.buttonColor forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:config.buttonFontSize]];
        
        if (title.length > 0) {
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cancelButton.mas_right).offset(5);
                make.right.equalTo(confirmButton.mas_left).offset(-5);
                make.centerY.equalTo(self.titleView);
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.text = title;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        lastAttribute = self.titleView.mas_bottom;
    }
    
    {
        self.pickerView = [UIPickerView new];
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(AT_SPLIT_WIDTH);
            make.left.right.equalTo(self);
            make.height.equalTo(@(config.pickerHeight));
        }];
        self.pickerView.backgroundColor = config.backgroundColor;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        [self.pickerView reloadAllComponents];
        
        lastAttribute = self.pickerView.mas_bottom;
    }
    
    {
        CGFloat height = IS_IPHONE_X ? 33 : 0;
        
        UIView *extraView = [[UIView alloc] init];
        extraView.backgroundColor = config.backgroundColor;
        extraView.clipsToBounds = YES;
        [self addSubview:extraView];
        [extraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastAttribute);//.offset(AT_SPLIT_WIDTH);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(height);
        }];
        
        lastAttribute = extraView.mas_bottom;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
    [[ATPopupWindow sharedWindow] setTouchWildToHide:YES];
    self.attachedView.at_dimBackgroundColor = config.dimBackgroundColor;
    self.attachedView.at_dimBackgroundBlurEnabled = config.dimBackgroundBlurEnabled;
    self.attachedView.at_dimBackgroundBlurEffectStyle = config.dimBackgroundBlurEffectStyle;
}

- (void)cancelAction:(UIButton *)sender {
    [self hide];
}

- (void)confirmAction:(UIButton *)sender {
    [self hide];
    if (self.confirmBlock) {
        self.confirmBlock(self.selectedIndex);
    }
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.items.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    ATPickerConfig *config = [ATPickerConfig globalConfig];
    return config.itemRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    ATPickerConfig *config = [ATPickerConfig globalConfig];
    UILabel *label = (UILabel *)view;
    if (!label) {label = [UILabel new];}
    label.textColor = config.itemTextColor;
    label.font = [UIFont systemFontOfSize:config.itemTextSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.items[row];
    return label;
}

#pragma mark - overwrite

- (void)show:(ATPopupCompletionBlock)block {
    
    [self setupWithTitle:self.title items:self.items confirmBlock:self.confirmBlock];
    
    [super show:block];
}

#pragma mark - public

- (instancetype)initWithItems:(nonnull NSArray<NSString *>*)items
                 confirmBlock:(nullable ATPickerConfirmBlock)confirmBlock {
    return [self initWithTitle:nil items:items confirmBlock:confirmBlock];
}

- (instancetype)initWithTitle:(nullable NSString *)title
                        items:(nonnull NSArray<NSString *>*)items
                 confirmBlock:(nullable ATPickerConfirmBlock)confirmBlock {
    
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.items = items;
    self.confirmBlock = confirmBlock;
    
    return self;
}

- (void)asInputViewLayout {
    if (!self.attachedView) {
        self.attachedView = [ATPopupWindow sharedWindow].attachView;
    }
    [self.attachedView at_showDimBackground];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
    }];
}

///////////////////////////////////////////////////////////////////////////

- (__kindof ATPickerView *(^)(NSString * _Nullable title))withTitle {
    return ^ __kindof ATPickerView *(NSString * _Nullable title) {
        self.title = title;
        return self;
    };
}

- (__kindof ATPickerView *(^)(NSArray<NSString *>*_Nonnull items))withItems {
    return ^ __kindof ATPickerView *(NSArray<NSString *>*_Nonnull items) {
        self.items = items;
        return self;
    };
}

- (__kindof ATPickerView *(^)(ATPickerConfirmBlock _Nullable confirmBlock))confirm {
    return ^ __kindof ATPickerView *(ATPickerConfirmBlock _Nullable confirmBlock) {
        self.confirmBlock = confirmBlock;
        return self;
    };
}

@end

@implementation ATPickerConfig

+ (ATPickerConfig *)globalConfig {
    static ATPickerConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [ATPickerConfig new];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.innerMargin = 15.0f;
    self.titleHeight = 44.0f;
    self.pickerHeight = 216.0f;
    self.itemRowHeight = 40.0f;
    
    self.titleFontSize  = 15.0f;
    self.buttonFontSize = 16.0f;
    self.itemTextSize   = 15.0f;
    
    self.backgroundColor    = UIColorHex(0xFFFFFFFF);
    self.titleColor         = UIColorHex(0x333333FF);
    self.buttonColor        = UIColorHex(0x333333FF);
    self.itemTextColor      = [UIColor blackColor]; //UIColorHex(0x000000FF);
    self.splitColor         = UIColorHex(0xCCCCCCFF);
    
    self.defaultTextCancel  = @"取消";
    self.defaultTextConfirm = @"确定";
    
    self.dimBackgroundColor = UIColorHex(0x0000007F);
    self.dimBackgroundBlurEnabled = NO;
    self.dimBackgroundBlurEffectStyle = UIBlurEffectStyleExtraLight;
    
    return self;
}

@end
