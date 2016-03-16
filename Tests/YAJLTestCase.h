//
//  YAJLTestCase.h
//  YAJL
//
//  Created by Gabriel Handford on 6/30/09.
//  Copyright 2009. All rights reserved.
//

@import XCTest;
#import "YAJLParser.h"

@interface YAJLTestCase : XCTestCase <YAJLParserDelegate> {}

- (NSData *)loadData:(NSString *)name;
- (NSString *)loadString:(NSString *)name;
- (NSString *)directoryWithPath:(NSString *)path;

@end
