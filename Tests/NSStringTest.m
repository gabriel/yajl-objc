//
//  NSStringTest.m
//  YAJL
//
//  Created by Gabriel Handford on 7/23/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface NSStringTest : YAJLTestCase
@end

@implementation NSStringTest

- (void)testExample {
  NSString *exampleString = [self loadString:@"example"];
  GHTestLog(@"Example string: %@", exampleString);
  id JSON = [exampleString yajl_JSON];
  GHTestLog([JSON description]);
    
  GHAssertTrue([JSON isKindOfClass:[NSDictionary class]], nil);
  NSDictionary *glossary = [JSON objectForKey:@"glossary"];
  GHAssertNotNil(glossary, nil);
  NSString *title = [glossary objectForKey:@"title"];
  GHAssertEqualStrings(title, @"example glossary", nil);
}

- (void)testArrayNumbers {
  NSString *JSONString = @"[1, 2, 3]";
  NSArray *JSON = [JSONString yajl_JSON];
  GHTestLog([JSON description]);
  NSArray *expected = [NSArray arrayWithObjects:
                       [NSNumber numberWithInteger:1],
                       [NSNumber numberWithInteger:2],
                       [NSNumber numberWithInteger:3],
                       nil];
  GHAssertEqualObjects(expected, JSON, nil);  
}

- (void)testAllowComments {
  NSString *JSONString = @"[1, 2, 3] // Allow comments";
  NSError *error = nil;
  NSArray *JSON = [JSONString yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
  GHTestLog([JSON description]);
  NSArray *expected = [NSArray arrayWithObjects:
                       [NSNumber numberWithInteger:1],
                       [NSNumber numberWithInteger:2],
                       [NSNumber numberWithInteger:3],
                       nil];
  GHAssertEqualObjects(expected, JSON, nil);  
}  

@end
