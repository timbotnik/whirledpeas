//
//  SignUpViewController.m
//  FormValidationTest
//
//  Created by Tim Hingston on 11/26/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import "SignUpViewController.h"
#import "MinMaxRange.h"
#import "FormValidation.h"

#define kFormSignupFirstNameLength MinMaxRangeMake(1, 15)
#define kFormSignupLastNameLength  MinMaxRangeMake(0, 15)
#define kFormSignupEmailLength     MinMaxRangeMake(4, 60)
#define kSignupUsernameLength  MinMaxRangeMake(1, 15)
#define kFormSignupPasswordLength  MinMaxRangeMake(6, 60)

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    self.firstNameField.maxTextLength = kFormSignupFirstNameLength.max;
    [self.firstNameField.validationRules addObject:
     [ValidationRule ruleWithMinTextLength:kFormSignupFirstNameLength.min andErrorMessage:@"First Name is too short"]];
    [self.firstNameField.validationRules addObject:
     [ValidationRule ruleWithMaxTextLength:kFormSignupFirstNameLength.max andErrorMessage:@"First Name is too long"]];
    
    self.lastNameField.maxTextLength = kFormSignupLastNameLength.max;
    [self.lastNameField.validationRules addObject:
     [ValidationRule ruleWithMinTextLength:kFormSignupLastNameLength.min andErrorMessage:@"Last Name is too short"]];
    [self.lastNameField.validationRules addObject:
     [ValidationRule ruleWithMaxTextLength:kFormSignupLastNameLength.max andErrorMessage:@"Last Name is too long"]];
    
    self.usernameField.lowercaseOnly = YES;
    self.usernameField.maxTextLength = kSignupUsernameLength.max;
    [self.usernameField.validationRules addObject:
     [ValidationRule ruleWithMinTextLength:kSignupUsernameLength.min andErrorMessage:@"Username is too short"]];
    [self.usernameField.validationRules addObject:
     [ValidationRule ruleWithMaxTextLength:kSignupUsernameLength.max andErrorMessage:@"Username is too long"]];
    [self.usernameField.validationRules addObject:
     [ValidationRule ruleWithRegex:kFormValidationRegexUsername andErrorMessage:@"Invalid username entered"]];
    
    self.emailAddressField.lowercaseOnly = YES;
    self.emailAddressField.maxTextLength = kFormSignupEmailLength.max;
    [self.emailAddressField.validationRules addObject:
     [ValidationRule ruleWithMinTextLength:kFormSignupEmailLength.min andErrorMessage:@"Email is too short"]];
    [self.emailAddressField.validationRules addObject:
     [ValidationRule ruleWithMaxTextLength:kFormSignupEmailLength.max andErrorMessage:@"Email is too long"]];
    [self.emailAddressField.validationRules addObject:
     [ValidationRule ruleWithRegex:kFormValidationRegexEmail andErrorMessage:@"Invalid email entered"]];
    
    self.passwordField.maxTextLength = kFormSignupPasswordLength.max;
    [self.passwordField.validationRules addObject:
     [ValidationRule ruleWithMinTextLength:kFormSignupPasswordLength.min andErrorMessage:@"Password is too short"]];
    [self.passwordField.validationRules addObject:
     [ValidationRule ruleWithMaxTextLength:kFormSignupPasswordLength.max andErrorMessage:@"Password is too long"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)clearFields
{
    self.firstNameField.text = @"";
    self.lastNameField.text = @"";
    self.usernameField.text = @"";
    self.emailAddressField.text = @"";
    self.passwordField.text = @"";
}

- (void)displayFormError:(NSString*)errorMessage
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Form Error" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [errorView show];
}

- (IBAction)onSignUpClicked:(id)sender
{
    if ([self validateSignup]) {
        NSString *userInfo = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n", self.firstNameField.text, self.lastNameField.text, self.emailAddressField.text, self.usernameField.text];
        UIAlertView *successView = [[UIAlertView alloc] initWithTitle:@"Form Validated" message:userInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [successView show];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if ([textField isKindOfClass:[FormField class]]) {
        FormField* ptf = (FormField*)textField;
        return newLength <= ptf.maxTextLength;
    }
    return YES;
}

- (BOOL)validateTextField:(UITextField*)textField
{
    BOOL valid = YES;
    FormField* formField = (FormField*)textField;
    ValidationResult* result = [formField firstValidationError];
    if (result && result.validationError != ValidationErrorNone) {
        valid = NO;
        formField.hasError = YES;
        [self displayFormError:result.errorMessage];
    }
    
    return valid;
}

- (BOOL)validateSignup
{
    __block BOOL valid = YES;
    __block NSString* errorMessage;
    __block FormField* errorField;
    
    NSArray* formFields = [NSArray arrayWithObjects:self.firstNameField, self.lastNameField, self.emailAddressField, self.usernameField, self.passwordField, nil];
    
    [formFields enumerateObjectsUsingBlock:^(FormField* textField, NSUInteger idx, BOOL *stop) {
        ValidationResult* result = [textField firstValidationError];
        if (result && result.validationError != ValidationErrorNone) {
            errorField = textField;
            errorMessage = result.errorMessage;
            valid = NO;
            *stop = YES;
        }
    }];
    if (!valid) {
        [errorField setHasError:YES];
        [self displayFormError:errorMessage];
    }
    return valid;
}


@end
