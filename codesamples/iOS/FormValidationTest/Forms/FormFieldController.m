//
//  FormFieldController.m
//  Code Samples
//
//  Created by Tim Hingston on 7/31/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import "FormFieldController.h"

@interface FormFieldController ()

@end

@implementation FormFieldController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView*)self.view;
    }
    else {
        [[self.view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIScrollView class]]) {
                self.scrollView = (UIScrollView*)obj;
            }
        }];
    }
    
    [self findTextFields:self.scrollView];

    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    [self registerForKeyboardNotifications];
}

- (void)findTextFields:(UIView*)parent
{
    [parent.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *field = obj;
            field.delegate = self;
        }
        if ([obj isKindOfClass:[UITextView class]]) {
            UITextView *field = obj;
            field.delegate = self;
        }
        if ([obj isMemberOfClass:[UIView class]]) {
            [self findTextFields:obj];
        }
    }];
}

- (void)dealloc
{
    [self unregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Related

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)onBackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [touch.view isKindOfClass: [UIScrollView class]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BOOL autoScroll = self.editingView != nil;
    self.editingView = textField;
    self.scrollView.scrollEnabled = YES;
    if (autoScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToCurrentField];
        });
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.editingView = textView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // nothing yet
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    [UIView animateWithDuration:0.15 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
    } completion:^(BOOL finished) {
        [self scrollToCurrentField];
    }];
}

- (void)scrollToCurrentField
{
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    if (!self.editingView) {
        return;
    }
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= self.scrollView.contentInset.bottom;
    
    CGRect editFrame = self.editingView.frame;
    CGPoint testPoint = CGPointMake(0.0, CGRectGetMaxY(editFrame));
    testPoint.y += 40;
    CGPoint actualTestPoint = [self.view convertPoint:testPoint fromView:self.editingView.superview];
    if (!CGRectContainsPoint(aRect, actualTestPoint)) {
        editFrame = self.editingView.frame;
        editFrame.origin.y += 40;
        CGRect scrollFrame = [self.scrollView convertRect:editFrame fromView:self.editingView.superview];
        [self.scrollView scrollRectToVisible:scrollFrame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder based on tag IDs
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        if ([self validateTextField:textField]) {
            [nextResponder becomeFirstResponder];
        }
    } else {
        if ([self validateTextField:textField]) {
            [self onTextFieldReturned:textField];
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)validateTextField:(UITextField*)textField
{
    // gives subclasses the chance to invalidate
    return YES;
}

- (IBAction)onTextFieldReturned:(id)sender
{
    // should by handled by subclasses
    [self hideKeyboard];
}

- (IBAction)onBackgroundTapped:(id)sender
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    if (self.editingView != nil) {
        [self.editingView resignFirstResponder];
    }
}

@end
