//
//  NSDataTest.m
//  YAJLIPhone
//
//  Created by Gabriel Handford on 10/7/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"

#import "NSObject+YAJL.h"

@interface NSDataTest : YAJLTestCase
@end

@implementation NSDataTest

- (void)testExample {
  NSData *data = [[self loadString:@"example"] dataUsingEncoding:NSUTF8StringEncoding];
  id JSON = [data yajl_JSON];
  GHTestLog([JSON description]);
  
  GHAssertTrue([JSON isKindOfClass:[NSDictionary class]], nil);
  NSDictionary *glossary = [JSON objectForKey:@"glossary"];
  GHAssertNotNil(glossary, nil);
  NSString *title = [glossary objectForKey:@"title"];
  GHAssertEqualStrings(title, @"example glossary", nil);
}

@end