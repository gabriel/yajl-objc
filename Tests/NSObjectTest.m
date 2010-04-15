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

@interface CustomJSONObject : NSObject
@end

@implementation NSObjectTest

- (void)testDictionary {
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
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

- (void)testCustom {
  CustomJSONObject *obj = [[[CustomJSONObject alloc] init] autorelease];
  NSString *JSONString = [obj yajl_JSONString];
  NSString *expected = @"[\"Test\"]";
  GHTestLog(JSONString);
  GHAssertEqualStrings(JSONString, expected, nil);  
}

- (void)testComments {
  NSError *error = nil;
  id JSONValue = [[self loadData:@"comments"] yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
  GHTestLog(@"Error=%@", error);
  GHAssertNil(error, nil);
  GHAssertNotNil(JSONValue, nil);
}

- (void)testOverflow {
  NSDictionary *dict = [[self loadData:@"overflow2"] yajl_JSON];
  GHAssertNotNil(dict, nil);
  GHAssertTrue([dict count] > 0, nil);
}

- (void)testPrecision {
  NSError *error = nil;
  id JSONValue = [[self loadData:@"overflow2"] yajl_JSONWithOptions:YAJLParserOptionsStrictPrecision error:&error];
  GHTestLog(@"Error=%@", error);
  GHAssertNotNil(error, nil);
  GHTestLog(@"JSONValue=%@", JSONValue);
  GHAssertNotNil(JSONValue, nil);
  GHAssertTrue([JSONValue count] == 0, nil);
}  

@end


@implementation CustomJSONObject

- (id)JSON {
  return [NSArray arrayWithObject:@"Test"];
}

@end