//
//	NSDataTest.m
//	YAJLIPhone
//
//	Created by Gabriel Handford on 10/7/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"
#import "NSObject+YAJL.h"

@interface NSDataTest : YAJLTestCase
@end

@implementation NSDataTest

- (void)testExample {
	NSData *data = [[self loadString:@"example"] dataUsingEncoding:NSUTF8StringEncoding];
	id JSON = [data yajl_JSON];
	
	XCTAssertTrue([JSON isKindOfClass:[NSDictionary class]]);
	NSDictionary *glossary = JSON[@"glossary"];
	XCTAssertNotNil(glossary);
	NSString *title = glossary[@"title"];
	XCTAssertEqualObjects(title, @"example glossary");
}

@end