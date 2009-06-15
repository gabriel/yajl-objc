//
//  YAJLDocumentTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import <YAJL/YAJLDocument.h>
#import <limits.h>

@interface YAJLDocumentTest : GHTestCase { 
	NSData *testData_;
}
@end

@implementation YAJLDocumentTest

- (void)setUp {
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	testData_ = [[NSData dataWithContentsOfFile:examplePath options:NSUncachedRead error:nil] retain];
}

- (void)tearDown {
	[testData_ release];
}

- (void)test {		
	NSError *error = nil;
	YAJLDocument *document = [[YAJLDocument alloc] initWithData:testData_ parserOptions:0 error:&error];
	if (error) GHFail(@"Error: %@", error);
	GHTestLog(@"Root: %@", document.root);
	[document release];
}

@end
