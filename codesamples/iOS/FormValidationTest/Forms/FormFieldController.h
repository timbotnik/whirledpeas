//
//  FormFieldController.h
//  Code Samples
//
//  Created by Tim Hingston on 7/31/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormFieldController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIView* editingView;

- (IBAction)onBackgroundTapped:(id)sender;
- (void)hideKeyboard;
- (BOOL)validateTextField:(UITextField *)textField;

@end
