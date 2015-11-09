//
//	NSObjectTest.m
//	YAJL
//
//	Created by Gabriel Handford on 7/23/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"
#import "NSObject+YAJL.h"

@interface NSObjectTest : YAJLTestCase
@end

@interface CustomJSONObject : NSObject
@end

@implementation NSObjectTest

- (void)testDictionary {
	NSDictionary *dict = @{@"key2": @[@"arrayValue1", @YES, @NO, [NSNull null],
						   @1, @234234.234234, [NSDecimalNumber notANumber]]};
	
	NSString *JSONString = [dict yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"	"];
	
	NSString *expected = [self loadString:@"gen_expected1"];
	XCTAssertEqualObjects(JSONString, expected);
}

- (void)testArray {
	NSArray *array = @[@"arrayValue1", @YES, @NO, [NSNull null],
					  @1, @234234.234234];
	
	NSString *JSONString = [array yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"	"];
	
	NSString *expected = [self loadString:@"object_expected_array"];
	XCTAssertEqualObjects(JSONString, expected);
}

- (void)testCustom {
	CustomJSONObject *obj = [[CustomJSONObject alloc] init];
	NSString *JSONString = [obj yajl_JSONString];
	NSString *expected = @"[\"Test\"]";
	XCTAssertEqualObjects(JSONString, expected);
}

- (void)testComments {
	NSError *error = nil;
	id JSONValue = [[self loadData:@"comments"] yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
	NSLog(@"Error=%@", error);
	XCTAssertNil(error);
	XCTAssertNotNil(JSONValue);
}

- (void)testOverflow {
	NSDictionary *dict = [[self loadData:@"overflow2"] yajl_JSON];
	XCTAssertNotNil(dict);
	XCTAssertTrue([dict count] > 0);
}

- (void)testPrecision {
	NSError *error = nil;
	id JSONValue = [[self loadData:@"overflow2"] yajl_JSONWithOptions:YAJLParserOptionsStrictPrecision error:&error];
	NSLog(@"Error=%@", error);
	XCTAssertNotNil(error);
	NSLog(@"JSONValue=%@", JSONValue);
	XCTAssertNotNil(JSONValue);
	XCTAssertTrue([JSONValue count] == 0);
}

@end


@implementation CustomJSONObject

- (id)JSON {
	return @[@"Test"];
}

@end