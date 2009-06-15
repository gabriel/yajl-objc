//
//  YAJLParserTest.m
//  YAJL
//
//  Created by Gabriel Handford on 6/14/09.
//  Copyright 2009. All rights reserved.
//


#import <GHUnit/GHUnit.h>

#import <YAJL/YAJLParser.h>

@interface YAJLParserTest : GHTestCase <YAJLParserDelegate> { 
	NSData *testData_;
}
@end

@implementation YAJLParserTest

- (void)setUp {
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	testData_ = [[NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil] retain];
}

- (void)tearDown {
	[testData_ release];
}

- (void)test {	
	
	YAJLParser *parser = [[YAJLParser alloc] initWithData:testData_ parserOptions:0];
	parser.delegate = self;
	[parser parse];
	
	NSError *error = [parser parserError];
	if (error) {
		NSLog(@"Parse error:\n%@", error);
		GHFail(@"Error: %@", error);
	}
	
	[parser release];	
}

#pragma mark Delegates (YAJLParser)

- (void)parserDidStartDictionary:(YAJLParser *)parser { }
- (void)parserDidEndDictionary:(YAJLParser *)parser { }

- (void)parserDidStartArray:(YAJLParser *)parser { }
- (void)parserDidEndArray:(YAJLParser *)parser { }

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key { }
- (void)parser:(YAJLParser *)parser didAdd:(id)value { }



@end