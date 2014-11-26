//
//  FormValidation.m
//  Code Samples
//
//  Created by Tim Hingston on 3/24/14.
//  Copyright (c) 2014 Tim Hingston. All rights reserved.
//

#import "FormValidation.h"

@implementation FormValidation

+ (BOOL)isValidEmail:(NSString *)email
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kFormValidationRegexEmail];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidUsername:(NSString*)username
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kFormValidationRegexUsername];
    return [test evaluateWithObject:username];
}

+ (ValidationError)testCharacterLimitForField:(UITextField*)textField withRange:(MinMaxRange)range;
{
    if (!MinMaxRangeIsNull(range)) {
        if (textField.text.length > range.max) {
            return ValidationErrorMinLength;
        }
        else if (textField.text.length < range.min) {
            return ValidationErrorMaxLength;
        }
    }
    return ValidationErrorNone;
}

+ (NSArray*)validateRules:(NSArray*)validationRules forTestObject:(id)testObject stopOnError:(BOOL)stopOnError
{
    __block NSMutableArray *results = [NSMutableArray array];
    [validationRules enumerateObjectsUsingBlock:^(ValidationRule*  rule, NSUInteger idx, BOOL *stop) {
        ValidationResult *result = [rule validate:testObject];
        if (result) {
            [results addObject:result];
            if (stopOnError) {
                *stop = YES;
            }
        }
    }];
    return results;
}

@end
