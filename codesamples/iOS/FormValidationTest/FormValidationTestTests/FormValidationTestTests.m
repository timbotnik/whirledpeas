//
//  FormValidationTestTests.m
//  FormValidationTestTests
//
//  Created by Tim Hingston on 11/26/14.
//  Copyright (c) 2014 Fullstack Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FormValidation.h"

@interface FormValidationTestTests : XCTestCase

@end

@implementation FormValidationTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMinText {
    // This is an example of a functional test case.
    ValidationRule *rule = [ValidationRule ruleWithMinTextLength:3 andErrorMessage:@"Too Short"];
    ValidationResult *shouldFail = [rule validate:@"ab"];
    ValidationResult *shouldPass = [rule validate:@"abc"];
    
    XCTAssert(shouldFail != nil);
    XCTAssert(shouldPass == nil);
}

- (void)testMaxText {
    // This is an example of a functional test case.
    ValidationRule *rule = [ValidationRule ruleWithMaxTextLength:3 andErrorMessage:@"Too Long"];
    ValidationResult *shouldFail = [rule validate:@"abcd"];
    ValidationResult *shouldPass = [rule validate:@"abc"];
    
    XCTAssert(shouldFail != nil);
    XCTAssert(shouldPass == nil);
}

- (void)testEmail {
    // This is an example of a functional test case.
    ValidationRule *rule = [ValidationRule ruleWithRegex:kFormValidationRegexEmail andErrorMessage:@"Bad Email"];
    ValidationResult *shouldFail = [rule validate:@"a@b"];
    ValidationResult *shouldPass = [rule validate:@"a@b.com"];
    
    XCTAssert(shouldFail != nil);
    XCTAssert(shouldPass == nil);
}

@end
