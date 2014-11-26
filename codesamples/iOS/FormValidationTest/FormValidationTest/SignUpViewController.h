//
//  SignUpViewController.h
//  FormValidationTest
//
//  Created by Tim Hingston on 11/26/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormFieldController.h"
#import "FormField.h"

@interface SignUpViewController : FormFieldController
{

}

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet FormField *firstNameField;
@property (weak, nonatomic) IBOutlet FormField *lastNameField;
@property (weak, nonatomic) IBOutlet FormField *usernameField;
@property (weak, nonatomic) IBOutlet FormField *emailAddressField;
@property (weak, nonatomic) IBOutlet FormField *passwordField;

- (IBAction)onSignUpClicked:(id)sender;

@end

