//
//  ZLStateView.m
//  ZLStateView
//
//  Created by admin on 2025/12/29.
//

#import "ZLStateView.h"
#import <objc/runtime.h>


ZLStateViewStatus const ZLStateViewStatusNoNetwork     = @"ZLStateViewStatusNoNetwork";
ZLStateViewStatus const ZLStateViewStatusError         = @"ZLStateViewStatusError";
ZLStateViewStatus const ZLStateViewStatusNoData        = @"ZLStateViewStatusNoData";

@interface ZLStateView ()
@property (nonatomic, strong, nullable) UILabel *titleLabel;
@property (nonatomic, strong, nullable) UILabel *detailLabel;
@property (nonatomic, strong, nullable) UIImageView *imageView;
@property (nonatomic, strong, nullable) UIButton *button;
@property (nonatomic, strong, nullable) UIView *customView;
@property (nonatomic,strong)UIStackView *stackView;
@property (nonatomic,strong)NSLayoutConstraint *centerYConstraint;
@property (nonatomic,strong)NSLayoutConstraint *topConstraint;
@property (nonatomic,strong)NSLayoutConstraint *bottomConstraint;

@property (nonatomic,strong)NSLayoutConstraint *stackcviewCenterYConstraint;

@property (nonatomic, copy,readwrite) ZLStateViewStatus status;


@end
@implementation ZLStateView
- (ZLStateViewStatus)zl_stateViewStatus {
    return self.status;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = ZLStateViewStatusNoData;
    }
    return self;
}
- (UIImageView *)__imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.tag = 10;
    }
    return _imageView;
}
- (UILabel *)__titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"无数据";
        _titleLabel.tag = 11;
    }
    return _titleLabel;
}
- (UILabel *)__detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.tag = 12;
        _detailLabel.text = @"暂无数据，请稍后再试";

    }
    return _detailLabel;
}

- (UIButton *)__button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        _button.layer.cornerRadius = 5;
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = [UIColor systemBlueColor].CGColor;
        _button.backgroundColor = [UIColor clearColor];
        [_button setTitle:@"重试" forState:UIControlStateNormal];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.tag = 13;
    }
    return _button;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.spacing = 10;
        _stackView.layoutMargins = UIEdgeInsetsMake(20, 20, 20, 20);
        _stackView.layoutMarginsRelativeArrangement = YES;
        [self addSubview:_stackView];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            self.stackcviewCenterYConstraint,
            [_stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        ]];
    }
    return _stackView;
}
- (NSLayoutConstraint *)centerYConstraint {
    if (!_centerYConstraint) {
        _centerYConstraint = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
    }
    return _centerYConstraint;
}
- (NSLayoutConstraint *)topConstraint {
    if (!_topConstraint) {
        _topConstraint = [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor];
    }
    return _topConstraint;
}
- (NSLayoutConstraint *)bottomConstraint {
    if (!_bottomConstraint) {
        _bottomConstraint = [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    }
    return _bottomConstraint;
}
- (NSLayoutConstraint *)stackcviewCenterYConstraint {
    if (!_stackcviewCenterYConstraint) {
        _stackcviewCenterYConstraint = [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    }
    return _stackcviewCenterYConstraint;
}
@end
@interface ZLWeakObjectContainer : NSObject
@property (nonatomic, readonly, weak) id weakObject;
- (instancetype)initWithWeakObject:(id)object;
@end
@implementation ZLWeakObjectContainer
- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}
@end

@interface NSObject ()
@property (nonatomic, strong) ZLStateView *zl_stateView;
@end

@implementation NSObject (ZLStateView)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _zl_hook_swizzleInstanceMethod:@selector(numberOfSectionsInTableView:) with:@selector(zl_hook_numberOfSectionsInTableView:)];
    });
}
+ (BOOL)_zl_hook_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}
- (NSInteger)zl_hook_numberOfSectionsInTableView:(UITableView *)tableView {
    return [self zl_hook_numberOfSectionsInTableView:tableView];
}

- (ZLStateView *)zl_stateView {
    return objc_getAssociatedObject(self, @selector(zl_stateView));
}
- (void)setZl_stateView:(ZLStateView *)zl_stateView {
    objc_setAssociatedObject(self, @selector(zl_stateView), zl_stateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setZl_stateViewDelegate:(id<IZLStateViewDelegate>)zl_stateViewDelegate {
    ZLWeakObjectContainer *container = [[ZLWeakObjectContainer alloc] initWithWeakObject:zl_stateViewDelegate];
    if (self.zl_stateViewDelegate &&
        zl_stateViewDelegate &&
        ![self.zl_stateViewDelegate isEqual:zl_stateViewDelegate]) {
        [self.zl_stateView removeFromSuperview];
        self.zl_stateView = nil;
    }
    objc_setAssociatedObject(self, @selector(zl_stateViewDelegate), container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<IZLStateViewDelegate>)zl_stateViewDelegate {
    ZLWeakObjectContainer *container = objc_getAssociatedObject(self, @selector(zl_stateViewDelegate));
    return container.weakObject;
}
- (ZLStateViewStatus)zl_stateViewStatus {
    return objc_getAssociatedObject(self, @selector(zl_stateViewStatus));
}
- (void)setZl_stateViewStatus:(ZLStateViewStatus)zl_stateViewStatus {
    self.zl_stateView.status = zl_stateViewStatus;
    objc_setAssociatedObject(self, @selector(zl_stateViewStatus), zl_stateViewStatus, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)zl_reloadStateView {
    
    if (!self.zl_stateViewDelegate) {
        [self.zl_stateView removeFromSuperview];
        return;
    }
    
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_reloadStateView:)]) {
        [self.zl_stateViewDelegate zl_reloadStateView:self.zl_stateView];
    }
    
    if (![self zl_zl_stateViewShouldDisplay]) {
        [self.zl_stateView removeFromSuperview];
        if ([self isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            scrollView.scrollEnabled = YES;
        }
        return;
    }
    
    UIView *superview = nil;
    if (!self.zl_stateView) {
        ZLStateView *stateView = [[ZLStateView alloc] initWithFrame:CGRectZero];
        self.zl_stateView = stateView;
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_initializeStateView:)]) {
            [self.zl_stateViewDelegate zl_initializeStateView:stateView];
        }
    }
   
    ZLStateView *stateView = self.zl_stateView;
    
   
    
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_superViewForStateView:)]) {
        superview = [self.zl_stateViewDelegate zl_superViewForStateView:stateView];
    }else {
        if ([self isKindOfClass:UIView.class]) {
            superview = (UIView *)self;
        }else if ([self isKindOfClass:UIViewController.class]) {
            superview = ((UIViewController *)self).view;
        }
    }
    
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_stateViewScrollEnabled:)]) {
            scrollView.scrollEnabled = [self.zl_stateViewDelegate zl_stateViewScrollEnabled:stateView];
        }
    }
    
    if (!superview) {
        [self.zl_stateView removeFromSuperview];
        return;
    }
    
    if (!stateView.superview && superview) {
        void(^animationBK)(void) = ^(void) {
            stateView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                stateView.alpha = 1.0;
            }];
        };
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_stateViewShouldFadeIn:)]) {
            BOOL shouldFadeIn = [self.zl_stateViewDelegate zl_stateViewShouldFadeIn:stateView];
            if (shouldFadeIn) {
                animationBK();
            }
        }else {
            animationBK();
        }
    }
    [superview addSubview:stateView];
    
    [self zl_setUI:stateView];
}
- (void)zl_setUI:(ZLStateView *)stateView {
    CGRect frame = CGRectZero;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_frameForStateView:)]) {
        frame = [self.zl_stateViewDelegate zl_frameForStateView:stateView];
        stateView.frame = frame;
    }else {
        UIView *superView = stateView.superview;
        [stateView removeFromSuperview];
        [superView addSubview:stateView];
        stateView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [stateView.leadingAnchor constraintEqualToAnchor:stateView.superview.leadingAnchor],
            [stateView.trailingAnchor constraintEqualToAnchor:stateView.superview.trailingAnchor],
            stateView.centerYConstraint,
            [stateView.centerXAnchor constraintEqualToAnchor:stateView.superview.centerXAnchor],
        ]];
        [NSLayoutConstraint activateConstraints:@[stateView.topConstraint, stateView.bottomConstraint]];
    }
    
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_verticalOffsetInStateView:)]) {
        CGFloat offset = [self.zl_stateViewDelegate zl_verticalOffsetInStateView:stateView];
        [stateView stackView];
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_frameForStateView:)]) {
            stateView.stackcviewCenterYConstraint.constant = offset;
        }else {
            stateView.centerYConstraint.constant = offset;
        }
    }
    
    BOOL useCustomView = NO;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_useCustomViewInStateView:)]) {
         useCustomView = [self.zl_stateViewDelegate zl_useCustomViewInStateView:stateView];
    }
    if (useCustomView) {
        [self zl_addCustomView:stateView];
        [stateView.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqual:stateView.customView]) {
                [stateView.stackView removeArrangedSubview:obj];
                [obj removeFromSuperview];
            }
        }];
    }else {
        if (stateView.customView) {
            [stateView.stackView removeArrangedSubview:stateView.customView];
            [stateView.customView removeFromSuperview];
        }
        [self zl_addImageView:stateView];
        [self zl_addTitleLabel:stateView];
        [self zl_addDetailLabel:stateView];
        [self zl_addButton:stateView];
        [self zl_sortStackViewSubviews:stateView];
    }

    
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_insetsForStateView:)]) {
        stateView.stackView.layoutMargins = [self.zl_stateViewDelegate zl_insetsForStateView:stateView];
        stateView.stackView.layoutMarginsRelativeArrangement = YES;
    }
        
}

- (void)zl_sortStackViewSubviews:(ZLStateView *)stateView {
    NSArray *arrangedSubviews = stateView.stackView.arrangedSubviews;
    NSArray *sortSubviews = [arrangedSubviews sortedArrayUsingComparator:^NSComparisonResult(UIView *v1, UIView *v2) {
        return v1.tag < v2.tag ? NSOrderedAscending :
               v1.tag > v2.tag ? NSOrderedDescending :
               NSOrderedSame;
    }];
    
    if ([arrangedSubviews isEqualToArray:sortSubviews]) {
        return;
    }
    
    [UIView performWithoutAnimation:^{
        for (UIView *view in arrangedSubviews) {
            [stateView.stackView removeArrangedSubview:view];
            [view removeFromSuperview];
        }

        for (UIView *view in sortSubviews) {
            [stateView.stackView addArrangedSubview:view];
        }
    }];
}

- (BOOL)zl_zl_stateViewShouldDisplay {
    BOOL display = NO;
    if (self.zl_stateViewDelegate) {
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_stateViewShouldDisplay)]) {
            display = [self.zl_stateViewDelegate zl_stateViewShouldDisplay];
        }else {
            if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
                NSInteger numberOfSections = 0;
                if ([self isKindOfClass:UITableView.class]) {
                    UITableView *tableView = (UITableView *)self;
                    numberOfSections = [tableView.dataSource numberOfSectionsInTableView:tableView];
                }else {
                    UICollectionView *collectionView = (UICollectionView *)self;
                    numberOfSections = [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
                }
                display = numberOfSections <= 0;
            }
        }
    }
    return display;
}
- (void)zl_addCustomView:(ZLStateView *)stateView {
    if (!stateView.customView) {
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_customViewForStateView:)]) {
            UIView *customView = [self.zl_stateViewDelegate zl_customViewForStateView:stateView];
            if (customView) {
                stateView.customView = customView;
                [stateView.stackView addArrangedSubview:stateView.customView];
            }
        }
    }
    if (!stateView.customView.superview) {
        [stateView.stackView addArrangedSubview:stateView.customView];
    }
}
- (void)zl_addImageView:(ZLStateView *)stateView {
    BOOL display = YES;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_imageViewShouldDisplayInStateView:)]) {
        display = [self.zl_stateViewDelegate zl_imageViewShouldDisplayInStateView:stateView];
    }
    if (display) {
        if (!stateView.imageView) {
            stateView.imageView = [stateView __imageView];
            if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_initializeImageView:inStateView:)]) {
                [self.zl_stateViewDelegate zl_initializeImageView:stateView.imageView inStateView:stateView];
            }
        }
        if (stateView.imageView.superview == nil) {
            [stateView.stackView addArrangedSubview:stateView.imageView];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_configureImageView:inStateView:)]) {
            [self.zl_stateViewDelegate zl_configureImageView:stateView.imageView inStateView:stateView];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_spacingAfterImageViewInStateView:)]) {
            if (@available(iOS 11.0, *)) {
                [stateView.stackView setCustomSpacing:[self.zl_stateViewDelegate zl_spacingAfterImageViewInStateView:stateView] afterView:stateView.imageView];
            } else {
            }
        }
    }else {
        [stateView.stackView removeArrangedSubview:stateView.imageView];
        [stateView.imageView removeFromSuperview];
    }
}
- (void)zl_addTitleLabel:(ZLStateView *)stateView {
    BOOL display = YES;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_titleLabelShouldDisplayInStateView:)]) {
        display = [self.zl_stateViewDelegate zl_titleLabelShouldDisplayInStateView:stateView];
    }
    if (display) {
        if (!stateView.titleLabel) {
            stateView.titleLabel = [stateView __titleLabel];
            if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_initializeTitleLabel:inStateView:)]) {
                [self.zl_stateViewDelegate zl_initializeTitleLabel:stateView.titleLabel inStateView:stateView];
            }
        }
        if (stateView.titleLabel.superview == nil) {
            [stateView.stackView addArrangedSubview:stateView.titleLabel];

        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_configureTitleLabel:inStateView:)]) {
            [self.zl_stateViewDelegate zl_configureTitleLabel:stateView.titleLabel inStateView:stateView];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_spacingAfterTitleLabelInStateView:)]) {
            if (@available(iOS 11.0, *)) {
                [stateView.stackView setCustomSpacing:[self.zl_stateViewDelegate zl_spacingAfterTitleLabelInStateView:stateView] afterView:stateView.titleLabel];
            } else {
            }
        }
    }else {
        [stateView.stackView removeArrangedSubview:stateView.titleLabel];
        [stateView.titleLabel removeFromSuperview];
    }
}
- (void)zl_addDetailLabel:(ZLStateView *)stateView {
    BOOL display = NO;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_detailLabelShouldDisplayInStateView:)]) {
        display = [self.zl_stateViewDelegate zl_detailLabelShouldDisplayInStateView:stateView];
    }
    if (display) {
        if (!stateView.detailLabel) {
            stateView.detailLabel = [stateView __detailLabel];
            if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_initializeDetailLabel:inStateView:)]) {
                [self.zl_stateViewDelegate zl_initializeDetailLabel:stateView.detailLabel inStateView:stateView];
            }
        }
        if (stateView.detailLabel.superview == nil) {
            [stateView.stackView addArrangedSubview:stateView.detailLabel];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_configureDetailLabel:inStateView:)]) {
            [self.zl_stateViewDelegate zl_configureDetailLabel:stateView.detailLabel inStateView:stateView];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_spacingAfterDetailLabelInStateView:)]) {
            if (@available(iOS 11.0, *)) {
                [stateView.stackView setCustomSpacing:[self.zl_stateViewDelegate zl_spacingAfterDetailLabelInStateView:stateView] afterView:stateView.detailLabel];
            } else {
            }
        }
    }else {
        [stateView.stackView removeArrangedSubview:stateView.detailLabel];
        [stateView.detailLabel removeFromSuperview];
    }
}
- (void)zl_addButton:(ZLStateView *)stateView {
    BOOL display = NO;
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_buttonShouldDisplayInStateView:)]) {
        display = [self.zl_stateViewDelegate zl_buttonShouldDisplayInStateView:stateView];
    }
    if (display) {
        if (!stateView.button) {
            stateView.button = [stateView __button];
            if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_initializeButton:inStateView:)]) {
                [self.zl_stateViewDelegate zl_initializeButton:stateView.button inStateView:stateView];
            }
            [stateView.button addTarget:self action:@selector(zl_didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (stateView.button.superview == nil) {
            [stateView.stackView addArrangedSubview:stateView.button];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_configureButton:inStateView:)]) {
            [self.zl_stateViewDelegate zl_configureButton:stateView.button inStateView:stateView];
        }
        if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_spacingAfterButtonInStateView:)]) {
            if (@available(iOS 11.0, *)) {
                [stateView.stackView setCustomSpacing:[self.zl_stateViewDelegate zl_spacingAfterButtonInStateView:stateView] afterView:stateView.button];
            } else {
            }
        }
    }else {
        [stateView.stackView removeArrangedSubview:stateView.button];
        [stateView.button removeFromSuperview];
    }
}
- (void)zl_didTapButton:(UIButton *)button {
    if ([self.zl_stateViewDelegate respondsToSelector:@selector(zl_stateView:didTapButton:)]) {
        [self.zl_stateViewDelegate zl_stateView:self.zl_stateView didTapButton:button];
    }
}
@end


@implementation UITableView(ZLStateView)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _zl_hook_swizzleInstanceMethod:@selector(reloadData) with:@selector(zl_hook_reloadData)];
    });
}
- (void)zl_hook_reloadData{
    [self zl_hook_reloadData];
    if (self.zl_stateViewDelegate) {
        [self zl_reloadStateView];
    }
}
@end
@implementation UICollectionView (ZLStateView)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _zl_hook_swizzleInstanceMethod:@selector(reloadData) with:@selector(zl_hook_reloadData)];
    });
}
- (void)zl_hook_reloadData{
    [self zl_hook_reloadData];
    if (self.zl_stateViewDelegate) {
        [self zl_reloadStateView];
    }
}
@end
