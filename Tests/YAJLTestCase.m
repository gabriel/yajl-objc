//
//	YAJLTestCase.m
//	YAJL
//
//	Created by Gabriel Handford on 6/30/09.
//	Copyright 2009. All rights reserved.
//

#import "YAJLTestCase.h"


@implementation YAJLTestCase

- (NSData *)loadData:(NSString *)name {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
	XCTAssertNotNil(path, @"Invalid name for load data");
	return [NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil];
}

- (NSString *)loadString:(NSString *)name {
	return [[NSString alloc] initWithData:[self loadData:name] encoding:NSUTF8StringEncoding];
}

- (NSString *)directoryWithPath:(NSString *)path {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fullPath = [paths.lastObject stringByAppendingPathComponent:path];
	NSLog(@"Using path: %@", fullPath);
	return fullPath;
}


- (void)parserDidStartDictionary:(YAJLParser *)parser { NSLog(@"{"); }
- (void)parserDidEndDictionary:(YAJLParser *)parser { NSLog(@"}"); }

- (void)parserDidStartArray:(YAJLParser *)parser { NSLog(@"["); }
- (void)parserDidEndArray:(YAJLParser *)parser { NSLog(@"]"); }

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key { NSLog(@"'%@':", key); }
- (void)parser:(YAJLParser *)parser didAdd:(id)value { NSLog(@"%@", [value description]); }

@end