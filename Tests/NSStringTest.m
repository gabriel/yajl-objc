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

@end
