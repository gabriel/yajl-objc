//
//  TwitterTest.m
//  YAJL
//
//  Created by Gabriel Handford on 12/22/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface TwitterTest : YAJLTestCase
@end

@implementation TwitterTest

- (void)testCoordinates {
  NSString *twitterJSONString = [self loadString:@"twitter"];
  id JSON = [twitterJSONString yajl_JSON];
  GHTestLog([JSON description]);
  
  GHAssertTrue([JSON isKindOfClass:[NSDictionary class]], nil);
  NSDictionary *geo = [JSON objectForKey:@"geo"];
  GHAssertNotNil(geo, nil);
  NSArray *coordinates = [geo objectForKey:@"coordinates"];
  NSNumber *coord1 = [coordinates objectAtIndex:0];
  NSNumber *coord2 = [coordinates objectAtIndex:1];
  
  GHAssertEqualObjects([NSNumber numberWithDouble:50.96165050], coord1, nil);
  GHAssertEqualObjects([NSNumber numberWithDouble:-1.42539830], coord2, nil);
}

- (void)testSnowflake {
  // From Twitter snowflake discussion: http://groups.google.com/group/twitter-development-talk/browse_thread/thread/6a16efa375532182#
  NSString *twitterJSONString = [self loadString:@"twitter_snowflake"];
  id JSON = [twitterJSONString yajl_JSON];
  GHTestLog([JSON description]);
  
  GHAssertTrue([JSON isKindOfClass:[NSArray class]], nil);
  NSDictionary *tweet = [JSON objectAtIndex:0];
  GHAssertNotNil(tweet, nil);
  NSNumber *identifier = [tweet objectForKey:@"id"];
  GHAssertEqualObjects([NSNumber numberWithLongLong:12738165059], identifier, nil);
  NSString *identifierStr = [tweet objectForKey:@"id_str"];
  GHAssertEqualStrings(@"12738165059", identifierStr, nil);
  GHAssertEqualStrings([identifier stringValue], identifierStr, nil);
}

@end
