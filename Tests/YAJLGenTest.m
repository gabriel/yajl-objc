//
//  YAJLGenTest.m
//  YAJL
//
//  Created by Gabriel Handford on 7/19/09.
//  Copyright 2009 . All rights reserved.
//

#import "YAJLTestCase.h"

#import "YAJLGen.h"

@interface YAJLGenTest : YAJLTestCase {}
@end

@implementation YAJLGenTest

- (void)testGen1 {
  YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsBeautify indentString:@"  "];
  [gen startDictionary];
  [gen string:@"key2"];
  [gen startArray];
  [gen string:@"arrayValue1"];
  [gen bool:YES];
  [gen bool:NO];
  [gen null];
  [gen number:[NSNumber numberWithInteger:1]];
  [gen number:[NSNumber numberWithDouble:234234.234234]];
  [gen endArray];
  [gen endDictionary];
  NSString *buffer = [gen buffer];
  [gen release];
  
  NSString *expected = [self loadString:@"gen_expected1"];
  
  GHTestLog(buffer);
  GHAssertEqualStrings(buffer, expected, nil);
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
  [gen number:[NSNumber numberWithInteger:1]];
  [gen number:[NSNumber numberWithDouble:234234.234234]];
  [gen endArray];
  [gen endDictionary];
  NSString *buffer = [gen buffer];
  [gen clear];
  [gen release];
  
  NSString *expected = [self loadString:@"gen_expected2"];
  
  GHTestLog(buffer);
  GHAssertEqualStrings(buffer, expected, nil);
}

- (void)testGenObject1 {
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
   [NSArray arrayWithObjects:@"arrayValue1", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNull null], 
    [NSNumber numberWithInteger:1], [NSNumber numberWithDouble:234234.234234], nil], @"key2",
   nil];
  
  YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsBeautify indentString:@"  "];
  [gen object:dict];
  NSString *buffer = [gen buffer];
  [gen release];
  
  NSString *expected = [self loadString:@"gen_expected1"];  
  GHTestLog(buffer);
  GHAssertEqualStrings(buffer, expected, nil);  
}

- (void)testGenObjectUnknownType {
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:1], @"date", nil];  
  YAJLGen *gen = [[YAJLGen alloc] init];
  GHAssertThrows([gen object:dict], nil);
  [gen release];
}

- (void)testGenObjectIgnoreUnknownType {
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:1], @"date", nil];
  
  YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsIgnoreUnknownTypes indentString:@""];
  [gen object:dict];
  NSString *buffer = [gen buffer];
  [gen release];
  
  NSString *expected = [self loadString:@"gen_expected_ignore_unknown1"]; 
  GHTestLog(buffer);
  GHAssertEqualStrings(buffer, expected, nil);  
}

- (void)testGenObjectPListTypes {
  const char *testData = "ABCDEFG";
  NSArray *array = [NSArray arrayWithObjects:
                    [NSDate dateWithTimeIntervalSince1970:1], 
                    [NSData dataWithBytes:testData length:6],
                    [NSURL URLWithString:@"http://www.yelp.com/"],
                    nil];
  
  YAJLGen *gen = [[YAJLGen alloc] initWithGenOptions:YAJLGenOptionsIncludeUnsupportedTypes indentString:@""];
  [gen object:array];
  NSString *buffer = [gen buffer];
  [gen release];
  
  NSString *expected = [self loadString:@"gen_expected_plist1"];  
  GHTestLog(buffer);
  GHAssertEqualStrings(buffer, expected, nil);  
}

@end
