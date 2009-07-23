//
//  NSObjectTest.m
//  YAJL
//
//  Created by Gabriel Handford on 7/23/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface NSObjectTest : YAJLTestCase
@end

@implementation NSObjectTest

- (void)testDictionary {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", 
												[NSArray arrayWithObjects:@"arrayValue1", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNull null], 
												 [NSNumber numberWithInteger:1], [NSNumber numberWithDouble:234234.234234], nil], @"key2",
												nil];

	NSString *JSONString = [dict yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "];
	
	NSString *expected = [self loadString:@"gen_expected1"];	
	GHTestLog(JSONString);
	GHAssertEqualStrings(JSONString, expected, nil);	
}

- (void)testArray {
	NSArray *array = [NSArray arrayWithObjects:@"arrayValue1", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNull null], 
										[NSNumber numberWithInteger:1], [NSNumber numberWithDouble:234234.234234], nil];
	
	NSString *JSONString = [array yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "];
	
	NSString *expected = [self loadString:@"object_expected_array"];	
	GHTestLog(JSONString);
	GHAssertEqualStrings(JSONString, expected, nil);	
}

@end
