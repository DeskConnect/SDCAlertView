//
//  SDCAlertController.m
//  SDCAlertView
//
//  Created by Ari on 6/1/16.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertController.h"
#import "SDCAlertActionPrivate.h"
#import "SDCTextFieldsViewController.h"
#import "UIViewController+SDCExtension.h"
#import "SDCAnimationController.h"
#import "SDCActionSheetView.h"
#import "UIView+SDCAutoLayout.h"
#import "SDCAlertViewClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCAlertController ()

@property (nonatomic, strong) IBOutlet SDCAlertControllerView *alertView;
@property (nonatomic, strong) SDCAlertControllerTransitioningDelegate *transitionDelegate;
@property (nonatomic, copy, nullable) NSArray<UITextField *> *textFields;
@property (nonatomic, assign) BOOL didAssignFirstResponder;

@end

@implementation SDCAlertController

- (void)setTitle:(nullable NSString *)title {
    if (title)
        self.attributedTitle = [[NSAttributedString alloc] initWithString:title];
}

- (nullable NSString *)title {
    return self.attributedTitle.string;
}

- (void)setMessage:(nullable NSString *)message {
    if (message)
        self.attributedMessage = [[NSAttributedString alloc] initWithString:message];
}

- (nullable NSString *)message {
    return self.attributedMessage.string;
}

- (void)setAttributedTitle:(nullable NSAttributedString *)attributedTitle {
    self.alertView.title = attributedTitle;
}

- (nullable NSAttributedString *)attributedTitle {
    return self.alertView.title;
}

- (void)setAttributedMessage:(nullable NSAttributedString *)attributedMessage {
    self.alertView.message = attributedMessage;
}

- (nullable NSAttributedString *)attributedMessage {
    return self.alertView.message;
}

- (UIView *)contentView {
    return self.alertView.contentView;
}

- (void)setActions:(NSArray<SDCAlertAction *> *)actions {
    _actions = [actions copy];
    self.alertView.actions = _actions;
}

- (nullable SDCAlertAction *)preferredAction {
    for (SDCAlertAction *action in self.actions)
        if (action.style == SDCAlertActionStylePreferred)
            return action;
    
    return nil;
}

- (void)setPreferredAction:(nullable SDCAlertAction *)preferredAction {
    NSArray<SDCAlertAction *> *actions = self.actions;
    
    if (preferredAction) {
        preferredAction.style = SDCAlertActionStylePreferred;
        if (![actions indexOfObject:preferredAction])
            self.actions = [actions arrayByAddingObject:preferredAction];
        
    } else {
        for (SDCAlertAction *action in actions)
            if (action.style == SDCAlertActionStylePreferred)
                action.style = SDCAlertActionStyleDefault;
    }
}

- (SDCActionLayout)actionLayout {
    SDCAlertView *alertView = (SDCAlertView *)self.alertView;
    if (![alertView isKindOfClass:[SDCAlertView class]])
        return SDCActionLayoutAutomatic;
    
    return alertView.actionLayout;
}

- (void)setActionLayout:(SDCActionLayout)actionLayout {
    SDCAlertView *alertView = (SDCAlertView *)self.alertView;
    if (![alertView isKindOfClass:[SDCAlertView class]])
        return;
    
    alertView.actionLayout = actionLayout;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    _preferredStyle = SDCAlertControllerStyleAlert;
    [self commonInit];
    
    return self;
}

- (instancetype)initWithAttributedTitle:(nullable NSAttributedString *)attributedTitle attributedMessage:(nullable NSAttributedString *)attributedMessage preferredStyle:(SDCAlertControllerStyle)preferredStyle {
    self = [super init];
    if (!self)
        return nil;
    
    _preferredStyle = preferredStyle;
    [self commonInit];
    
    self.attributedTitle = attributedTitle;
    self.attributedMessage = attributedMessage;
    
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(SDCAlertControllerStyle)preferredStyle {
    self = [super init];
    if (!self)
        return nil;
    
    _preferredStyle = preferredStyle;
    [self commonInit];
    
    self.title = title;
    self.message = message;
    
    return self;
}

- (void)commonInit {
    SDCAlertControllerStyle preferredStyle = self.preferredStyle;
    _actions = @[];
    _behaviors = SDCDefaultAlertBehaviorsForAlertStyle(preferredStyle);
    _visualStyle = [[SDCAlertVisualStyle alloc] initWithAlertStyle:preferredStyle];
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self.transitionDelegate = [[SDCAlertControllerTransitioningDelegate alloc] initWithAlertStyle:preferredStyle];
    
    if (preferredStyle == SDCAlertControllerStyleActionSheet) {
        NSString *nibName = NSStringFromClass([SDCActionSheetView class]);
        [[NSBundle bundleForClass:[self class]] loadNibNamed:nibName owner:self options:nil];
    } else {
        _alertView = [SDCAlertView new];
    }
}

#pragma mark - Public

- (void)addAction:(SDCAlertAction *)action {
    self.actions = [self.actions arrayByAddingObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(nullable void (^)(UITextField *))configurationHandler {
    UITextField *textField = [UITextField new];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (configurationHandler)
        configurationHandler(textField);
    
    NSArray<UITextField *> *textFields = (self.textFields ?: @[]);
    self.textFields = [textFields arrayByAddingObject:textField];
}

- (void)presentAnimated:(BOOL)animated completion:(nullable void (^)())completion {
    UIViewController *topViewController = [UIViewController sdc_topViewController];
    [topViewController presentViewController:self animated:animated completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(nullable void (^)())completion {
    [self.presentingViewController dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self listenForKeyboardChanges];
    [self configureAlertView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ((self.behaviors & SDCAlertBehaviorAutomaticallyFocusTextField) == SDCAlertBehaviorAutomaticallyFocusTextField) {
        // Explanation of why the first responder is set here:
        // http://stackoverflow.com/a/19580888/751268
        
        if (!self.didAssignFirstResponder) {
            [self.textFields.firstObject becomeFirstResponder];
            self.didAssignFirstResponder = YES;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return (self.presentingViewController ? self.presentingViewController.preferredStatusBarStyle : UIStatusBarStyleDefault);
}

#pragma mark - Private

- (void)listenForKeyboardChanges {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardChange:(NSNotification *)notification {
    NSValue *newFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (!newFrameValue)
        return;
    
    CGRect newKeyboardFrame = newFrameValue.CGRectValue;
    
    CGRect frame = self.view.frame;
    frame.size.height = CGRectGetMinY(newKeyboardFrame);
    self.view.frame = frame;
    
    if (!self.isBeingPresented)
        [self.view layoutIfNeeded];
}

- (void)configureAlertView {
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    self.alertView.visualStyle = self.visualStyle;
    if (self.behaviors != 0)
        [self.alertView addBehaviors:self.behaviors];
    
    [self addTextFieldsIfNecessary];
    [self addChromeTapHandlerIfNecessary];
    
    [self.view addSubview:self.alertView];
    [self createViewConstraints];
    
    [self.alertView prepareLayout];
    __weak __typeof(self) weakSelf = self;
    self.alertView.actionTappedHandler = ^(SDCAlertAction *action) {
        if (weakSelf.shouldDismissHandler && !weakSelf.shouldDismissHandler(action))
            return;
        
        [weakSelf dismissAnimated:YES completion:^{
            if (action.handler)
                action.handler(action);
        }];
    };
}

- (void)createViewConstraints {
    UIEdgeInsets margins = self.visualStyle.margins;
    
    switch (self.preferredStyle) {
        case SDCAlertControllerStyleActionSheet: {
            CGRect bounds = (self.presentingViewController ? self.presentingViewController.view.bounds : self.view.bounds);
            CGFloat width = (MIN(bounds.size.width, bounds.size.height) - margins.left - margins.right);
            [self.alertView sdc_pinWidth:(width * self.visualStyle.width)];
            [self.alertView sdc_horizontallyCenterInSuperview];
            [self.alertView sdc_alignEdgesWithSuperview:UIRectEdgeBottom insets:margins];
            [self.alertView sdc_setMaximumHeightToSuperviewHeightWithOffset:-margins.top];
            break;
        }
            
        case SDCAlertControllerStyleAlert: {
            [self.alertView sdc_pinWidth:self.visualStyle.width];
            [self.alertView sdc_centerInSuperview];
            CGFloat maximumHeightOffset = -(margins.top + margins.bottom);
            [self.alertView sdc_setMaximumHeightToSuperviewHeightWithOffset:maximumHeightOffset];
            [self.alertView setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisVertical];
            break;
        }
    }
}

- (void)addTextFieldsIfNecessary {
    NSArray<UITextField *> *textFields = self.textFields;
    SDCAlertView *alert = (SDCAlertView *)self.alertView;
    if (!textFields.count || ![alert isKindOfClass:[SDCAlertView class]])
        return;
    
    SDCTextFieldsViewController *textFieldsViewController = [[SDCTextFieldsViewController alloc] initWithTextFields:textFields];
    [textFieldsViewController willMoveToParentViewController:self];
    [self addChildViewController:textFieldsViewController];
    alert.textFieldsViewController = textFieldsViewController;
    [textFieldsViewController didMoveToParentViewController:self];
}

- (void)addChromeTapHandlerIfNecessary {
    if ((self.behaviors & SDCAlertBehaviorDismissOnOutsideTap) != SDCAlertBehaviorDismissOnOutsideTap)
        return;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chromeTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)chromeTapped:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.alertView.frame, [sender locationInView:self.view]))
        [self dismissAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end

NS_ASSUME_NONNULL_END
