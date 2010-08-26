//
//  NSBundleTest.m
//  YAJLIPhone
//
//  Created by Gabriel Handford on 8/25/10.
//  Copyright 2010. All rights reserved.
//

#import "YAJLTestCase.h"

@interface NSBundleTest : YAJLTestCase
@end

@implementation NSBundleTest

- (void)testLoadWithOptions {
  NSError *error = nil;
  id JSON = [[NSBundle mainBundle] yajl_JSONFromResource:@"example.json" options:YAJLParserOptionsAllowComments error:&error];
  GHAssertNil(error, nil);
  GHTestLog([JSON description]);  
  GHAssertTrue([JSON isKindOfClass:[NSDictionary class]], nil);
}

- (void)testLoadAndException {  
  GHAssertThrowsSpecificNamed([[NSBundle mainBundle] yajl_JSONFromResource:@"error.json"], NSException, YAJLParserException, nil);
}

@end