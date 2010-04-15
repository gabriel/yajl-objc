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

@end
