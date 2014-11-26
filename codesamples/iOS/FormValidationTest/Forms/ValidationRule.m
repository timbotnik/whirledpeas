//
//  ValidationRule.m
//  FormValidationTest
//
//  Created by Tim Hingston on 11/26/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import "ValidationRule.h"

@implementation ValidationResult

+ (ValidationResult*)resultWithError:(ValidationError)validationError andMessage:(NSString*)errorMessage
{
    ValidationResult *result = [[ValidationResult alloc] init];
    result.validationError = validationError;
    result.errorMessage = errorMessage;
    return result;
}

@end
@implementation ValidationRule

- (ValidationResult*)validate:(id)testObject
{
    return nil;
}

+ (ValidationRule*)ruleWithRegex:(NSString*)regex andErrorMessage:(NSString*)errorMessage
{
    RegexValidationRule *rule = [[RegexValidationRule alloc] init];
    rule.regex = regex;
    rule.errorMessage = errorMessage;
    return rule;
}

+ (ValidationRule*)ruleWithMinTextLength:(NSInteger)minTextLength andErrorMessage:(NSString*)errorMessage
{
    MinTextLengthValidationRule *rule = [[MinTextLengthValidationRule alloc] init];
    rule.minTextLength = [NSNumber numberWithInteger:minTextLength];
    rule.errorMessage = errorMessage;
    return rule;
}

+ (ValidationRule*)ruleWithMaxTextLength:(NSInteger)maxTextLength andErrorMessage:(NSString*)errorMessage
{
    MaxTextLengthValidationRule *rule = [[MaxTextLengthValidationRule alloc] init];
    rule.maxTextLength = [NSNumber numberWithInteger:maxTextLength];
    rule.errorMessage = errorMessage;
    return rule;
}

+ (ValidationRule*)ruleWithValidationBlock:(ValidationResult*(^)(id testObject))validationMethod
{
    BlockValidationRule *rule = [[BlockValidationRule alloc] init];
    rule.validationMethod = validationMethod;
    return rule;
}

@end


@implementation RegexValidationRule : ValidationRule

- (ValidationResult*)validate:(id)testObject
{
    NSString* testString = (NSString*)testObject;
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
    if(![test evaluateWithObject:testString]) {
        return [ValidationResult resultWithError:ValidationErrorRegex andMessage:self.errorMessage];
    }
    return [super validate:testObject];
}

@end

@implementation MinTextLengthValidationRule : ValidationRule

- (ValidationResult*)validate:(id)testObject
{
    NSString* testString = (NSString*)testObject;
    if (testString.length < self.minTextLength.integerValue) {
        return [ValidationResult resultWithError:ValidationErrorMinLength andMessage:self.errorMessage];
    }
    return [super validate:testObject];
}

@end

@implementation MaxTextLengthValidationRule : ValidationRule

- (ValidationResult*)validate:(id)testObject
{
    NSString* testString = (NSString*)testObject;
    if (testString.length > self.maxTextLength.integerValue) {
        return [ValidationResult resultWithError:ValidationErrorMinLength andMessage:self.errorMessage];
    }
    return [super validate:testObject];
}

@end

@implementation BlockValidationRule : ValidationRule

- (ValidationResult*)validate:(id)testObject
{
    return _validationMethod(testObject);
}

@end
