//
//	TwitterTest.m
//	YAJL
//
//	Created by Gabriel Handford on 12/22/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface TwitterTest : YAJLTestCase
@end

@implementation TwitterTest

- (void)testCoordinates {
	NSString *twitterJSONString = [self loadString:@"twitter"];
	id JSON = [twitterJSONString yajl_JSON];

	XCTAssertTrue([JSON isKindOfClass:[NSDictionary class]]);
	NSDictionary *geo = JSON[@"geo"];
	XCTAssertNotNil(geo);
	NSArray *coordinates = geo[@"coordinates"];
	NSNumber *coord1 = coordinates[0];
	NSNumber *coord2 = coordinates[1];

	XCTAssertEqualObjects(@50.96165050, coord1);
	XCTAssertEqualObjects(@-1.42539830, coord2);
}

- (void)testSnowflake {
	// From Twitter snowflake discussion: http://groups.google.com/group/twitter-development-talk/browse_thread/thread/6a16efa375532182#
	NSString *twitterJSONString = [self loadString:@"twitter_snowflake"];
	id JSON = [twitterJSONString yajl_JSON];

	XCTAssertTrue([JSON isKindOfClass:[NSArray class]]);
	NSDictionary *tweet = JSON[0];
	XCTAssertNotNil(tweet);
	NSNumber *identifier = tweet[@"id"];
	XCTAssertEqualObjects([NSNumber numberWithLongLong:12738165059], identifier);
	NSString *identifierStr = tweet[@"id_str"];
	XCTAssertEqualObjects(@"12738165059", identifierStr);
	XCTAssertEqualObjects([identifier stringValue], identifierStr);
}

@end
