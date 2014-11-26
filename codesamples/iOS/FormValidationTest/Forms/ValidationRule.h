//
//  ValidationRule.h
//  Code Samples
//
//  Created by Tim Hingston on 11/26/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinMaxRange.h"


typedef enum {
    ValidationErrorNone,
    ValidationErrorMinLength,
    ValidationErrorMaxLength,
    ValidationErrorRegex,
    ValidationErrorBlock
} ValidationError;

@interface ValidationResult : NSObject

@property (nonatomic, assign) ValidationError validationError;
@property (nonatomic, strong) NSString *errorMessage;

+ (ValidationResult*)resultWithError:(ValidationError)validationError andMessage:(NSString*)errorMessage;

@end

@interface ValidationRule : NSObject

@property (nonatomic, strong) NSString *errorMessage;

+ (ValidationRule*)ruleWithRegex:(NSString*)regex andErrorMessage:(NSString*)errorMessage;
+ (ValidationRule*)ruleWithMinTextLength:(NSInteger)minTextLength andErrorMessage:(NSString*)errorMessage;
+ (ValidationRule*)ruleWithMaxTextLength:(NSInteger)maxTextLength andErrorMessage:(NSString*)errorMessage;
+ (ValidationRule*)ruleWithValidationBlock:(ValidationResult*(^)(id testObject))validationMethod;

- (ValidationResult*)validate:(id)testObject;
@end

@interface RegexValidationRule : ValidationRule

@property (nonatomic, strong) NSString *regex;

@end

@interface MinTextLengthValidationRule : ValidationRule

@property (nonatomic, strong) NSNumber *minTextLength;

@end

@interface MaxTextLengthValidationRule : ValidationRule

@property (nonatomic, strong) NSNumber *maxTextLength;

@end

@interface BlockValidationRule : ValidationRule

@property (nonatomic, copy) ValidationResult*(^validationMethod)(id testObject);

@end

