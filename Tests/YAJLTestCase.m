//
//  YAJLTestCase.m
//  YAJL
//
//  Created by Gabriel Handford on 6/30/09.
//  Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"


@implementation YAJLTestCase

- (NSData *)loadData:(NSString *)name {
  NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
  GHAssertNotNil(path, @"Invalid name for load data");
  return [NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil]; 
}

- (NSString *)loadString:(NSString *)name {
  return [[[NSString alloc] initWithData:[self loadData:name] encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)directoryWithPath:(NSString *)path {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *fullPath = [[paths lastObject] stringByAppendingPathComponent:path];
  GHTestLog(@"Using path: %@", fullPath);
  return fullPath;
}


- (void)parserDidStartDictionary:(YAJLParser *)parser { GHTestLog(@"{"); }
- (void)parserDidEndDictionary:(YAJLParser *)parser { GHTestLog(@"}"); }

- (void)parserDidStartArray:(YAJLParser *)parser { GHTestLog(@"["); }
- (void)parserDidEndArray:(YAJLParser *)parser { GHTestLog(@"]"); }

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key { GHTestLog(@"'%@':", key); }
- (void)parser:(YAJLParser *)parser didAdd:(id)value { GHTestLog([value description]); }

@end