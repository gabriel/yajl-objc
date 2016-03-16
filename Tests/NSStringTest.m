//
//	NSStringTest.m
//	YAJL
//
//	Created by Gabriel Handford on 7/23/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface NSStringTest : YAJLTestCase
@end

@implementation NSStringTest

- (void)testExample {
	NSString *exampleString = [self loadString:@"example"];
	NSLog(@"Example string: %@", exampleString);
	id JSON = [exampleString yajl_JSON];
	
	XCTAssertTrue([JSON isKindOfClass:[NSDictionary class]]);
	NSDictionary *glossary = JSON[@"glossary"];
	XCTAssertNotNil(glossary);
	NSString *title = glossary[@"title"];
	XCTAssertEqualObjects(title, @"example glossary");
}

- (void)testArrayNumbers {
	NSString *JSONString = @"[1, 2, 3]";
	NSArray *JSON = [JSONString yajl_JSON];
	NSArray *expected = @[@1, @2, @3];
	XCTAssertEqualObjects(expected, JSON);
}

- (void)testAllowComments {
	NSString *JSONString = @"[1, 2, 3] // Allow comments";
	NSError *error = nil;
	NSArray *JSON = [JSONString yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
	NSArray *expected = @[@1, @2, @3];
	XCTAssertEqualObjects(expected, JSON);
}

@end
