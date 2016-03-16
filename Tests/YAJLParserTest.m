//
//	YAJLParserTest.m
//	YAJL
//
//	Created by Gabriel Handford on 6/14/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"
#import "YAJLParser.h"

@interface YAJLParserTest : YAJLTestCase {}
@end

@implementation YAJLParserTest

- (void)test {
	YAJLParser *parser = [[YAJLParser alloc] init];
	[parser parse:[self loadData:@"example"]];
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTFail(@"Error: %@", error);
	}
}

- (void)testError {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	YAJLParserStatus status = [parser parse:[self loadData:@"error"]];
	XCTAssertTrue(status == YAJLParserStatusError, @"Should have error status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testError2 {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	YAJLParserStatus status = [parser parse:[self loadData:@"error2"]];
	XCTAssertTrue(status == YAJLParserStatusError, @"Should have error status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTAssertTrue([[error localizedDescription] hasPrefix:@"parse error: invalid object key (must be a string)\n"]);
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testComments {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsAllowComments];
	YAJLParserStatus status = [parser parse:[self loadData:@"comments"]];
	XCTAssertTrue(status == YAJLParserStatusOK, @"Should have OK status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTFail(@"Error: %@", error);
	}
}

- (void)testFailOnComments {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	YAJLParserStatus status = [parser parse:[self loadData:@"comments"]];
	XCTAssertTrue(status == YAJLParserStatusError, @"Should have error status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testDoubleOverflow {
	YAJLParser *parser = [[YAJLParser alloc] init];
	YAJLParserStatus status = [parser parse:[self loadData:@"overflow"]];
	XCTAssertEqual(status, (NSUInteger)YAJLParserStatusError, @"Should have error status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTAssertEqual([error code], (NSInteger)YAJLParserErrorCodeDoubleOverflow);
		XCTAssertEqualObjects([error userInfo][YAJLParserValueKey], @"1.79769e+309");
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testLongLongOverflow {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsStrictPrecision];
#if TARGET_OS_IPHONE
	YAJLParserStatus status = [parser parse:[self loadData:@"overflow_longlong"]];
#else
	YAJLParserStatus status = [parser parse:[self loadData:@"overflow_longlong_macosx"]];
#endif
	XCTAssertEqual(status, (NSUInteger)YAJLParserStatusError, @"Should have error status");
	
	NSError *error = parser.parserError;
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		XCTAssertEqual([error code], (NSInteger)YAJLParserErrorCodeIntegerOverflow);
		XCTAssertEqualObjects([error userInfo][YAJLParserValueKey], @"9223372036854775808");
	} else {
		XCTFail(@"Should have error");
	}
}

- (void)testOverflow2 {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	YAJLParserStatus status = [parser parse:[self loadData:@"overflow2"]];
	XCTAssertTrue(status == YAJLParserStatusOK, @"Should have ok status");
}

- (void)testStreaming {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	YAJLParserStatus status;
	status = [parser parse:[self loadData:@"stream1"]];
	XCTAssertTrue(status == YAJLParserStatusOK, @"Should not have insufficient data");
	
	status = [parser parse:[self loadData:@"stream2"]];
	XCTAssertTrue(status == YAJLParserStatusOK, @"Should have finished");
}

// TODO(gabe): Should error if you try to re-use
- (void)_testParseMoreThanOnce {
	YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:0];
	parser.delegate = self;
	YAJLParserStatus status;
	status = [parser parse:[self loadData:@"example"]];
	XCTAssertTrue(status == YAJLParserStatusOK, @"Should be OK");
	status = [parser parse:[self loadData:@"example"]];
	XCTAssertTrue(status == YAJLParserStatusError, @"Should error");
}

@end