//
//  FormField.h
//  Code Samples
//
//  Created by Tim Hingston on 3/24/14.
//  Copyright (c) 2014 Tim Hingston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormValidation.h"

@interface FormField : UITextField

@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL lowercaseOnly;
@property (nonatomic, strong) NSMutableArray* validationRules;
@property (nonatomic, assign) NSUInteger maxTextLength;

- (void)showError;
- (IBAction)onTextEdited:(id)sender;
- (IBAction)onErrorButtonClicked:(id)sender;

// Checks the validation rules and returns the first error if one is found, otherwise nil
- (ValidationResult*)firstValidationError;

@end
