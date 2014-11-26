//
//  FormField.m
//  Code Samples
//
//  Created by Tim Hingston on 3/24/14.
//  Copyright (c) 2014 Tim Hingston. All rights reserved.
//

#import "FormField.h"
#import "FormValidation.h"

@implementation FormField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Initialization code
    self.errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, 22, 22);
    [self.errorButton setImage:[UIImage imageNamed:@"Field-Error"] forState:UIControlStateNormal];
    [self.errorButton setFrame:frame];
    [self.errorButton addTarget:self action:@selector(onErrorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self addTarget:self action:@selector(onTextEdited:) forControlEvents:UIControlEventEditingChanged];
    self.validationRules = [NSMutableArray array];
}

- (void)dealloc
{
    [self.errorButton removeTarget:self action:@selector(onErrorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self removeTarget:self action:@selector(onTextEdited:) forControlEvents:UIControlEventEditingChanged];
    self.errorButton = nil;
}

- (void)setHasError:(BOOL)hasError
{
    if (hasError) {
        self.rightViewMode = UITextFieldViewModeAlways;
        if (!self.isFirstResponder) {
            [self becomeFirstResponder];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRightView:self.errorButton];
        });
    }
    else {
        [self setRightView:nil];
    }
    _hasError = hasError;
}

- (void)showError
{
    self.rightViewMode = UITextFieldViewModeAlways;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setRightView:self.errorButton];
    });
    _hasError = YES;
}

- (ValidationResult*)firstValidationError
{
    NSArray* results = [FormValidation validateRules:self.validationRules forTestObject:self.text stopOnError:YES];
    if (results && results.count > 0) {
        return [results objectAtIndex:0];
    }
    return nil;
}


- (IBAction)onTextEdited:(id)sender
{
    if (self.lowercaseOnly) {
        self.text = self.text.lowercaseString;
    }
    if (self.hasError) {
        [self setHasError:NO];
    }
}

- (IBAction)onErrorButtonClicked:(id)sender
{
    self.text = @"";
    [self setHasError:NO];
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
