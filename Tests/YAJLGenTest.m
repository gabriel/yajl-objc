//
//	YAJLGenTest.m
//	YAJL
//
//	Created by Gabriel Handford on 7/19/09.
//	Copyright 2009 . All rights reserved.
//

#import "YAJLTestCase.h"

#import "YAJLGen.h"

@interface YAJLGenTest : YAJLTestCase {}
@end

@implementation YAJLGenTest

- (void)testGen1 {
	YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsBeautify indentString:@"	"];
	[gen startDictionary];
	[gen string:@"key2"];
	[gen startArray];
	[gen string:@"arrayValue1"];
	[gen bool:YES];
	[gen bool:NO];
	[gen null];
	[gen number:@1];
	[gen number:@234234.234234];
	[gen number:[NSDecimalNumber notANumber]];
	[gen endArray];
	[gen endDictionary];
	NSString *buffer = [gen buffer];
	
	NSString *expected = [self loadString:@"gen_expected1"];
	
	XCTAssertEqualObjects(buffer, expected);
}

- (void)testGen2 {
	YAJLGen *gen = [[YAJLGen alloc] init];
	[gen startDictionary];
	[gen string:@"key2"];
	[gen startArray];
	[gen string:@"arrayValue1"];
	[gen bool:YES];
	[gen bool:NO];
	[gen null];
	[gen number:@1];
	[gen number:@234234.234234];
	[gen number:[NSDecimalNumber notANumber]];
	[gen endArray];
	[gen endDictionary];
	NSString *buffer = [gen buffer];
	[gen clear];
	
	NSString *expected = [self loadString:@"gen_expected2"];
	XCTAssertEqualObjects(buffer, expected);
}

- (void)testGenObject1 {
	NSDictionary *dict = @{@"key2": @[@"arrayValue1", @YES, @NO, [NSNull null],
						   @1, @234234.234234, [NSDecimalNumber notANumber]]};
	
	YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsBeautify indentString:@"	"];
	[gen object:dict];
	NSString *buffer = [gen buffer];
	
	NSString *expected = [self loadString:@"gen_expected1"];
	XCTAssertEqualObjects(buffer, expected);
}

- (void)testGenObjectUnknownType {
	NSDictionary *dict = @{@"date": [NSDate dateWithTimeIntervalSince1970:1]};
	YAJLGen *gen = [[YAJLGen alloc] init];
	XCTAssertThrows([gen object:dict]);
}

- (void)testGenObjectIgnoreUnknownType {
	NSDictionary *dict = @{@"date": [NSDate dateWithTimeIntervalSince1970:1]};
	
	YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsIgnoreUnknownTypes indentString:@""];
	[gen object:dict];
	NSString *buffer = [gen buffer];
	
	NSString *expected = [self loadString:@"gen_expected_ignore_unknown1"];
	XCTAssertEqualObjects(buffer, expected);
}

- (void)testGenObjectPListTypes {
	const char *testData = "ABCDEFG";
	NSArray *array = @[[NSDate dateWithTimeIntervalSince1970:1],
					  [NSData dataWithBytes:testData length:6],
					  [NSURL URLWithString:@"http://www.yelp.com/"]];
	
	YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsIncludeUnsupportedTypes indentString:@""];
	[gen object:array];
	NSString *buffer = [gen buffer];
	
	NSString *expected = [self loadString:@"gen_expected_plist1"];
	XCTAssertEqualObjects(buffer, expected);
}

@end
