//
//  YAJLDocumentTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009. All rights reserved.
//

#import "NSString+SBJSON.h"

@interface YAJLDocumentTest : YAJLTestCase {}
@end

@implementation YAJLDocumentTest

- (YAJLDocument *)_loadDocument:(NSString *)sampleName parserOptions:(YAJLParserOptions)parserOptions error:(NSError **)error {
  NSData *data = [self loadData:sampleName];
  YAJLDocument *document = [[[YAJLDocument alloc] initWithData:data parserOptions:parserOptions error:error] autorelease];
  return document;
}

- (void)test {    
  NSError *error = nil;
  YAJLDocument *document = [self _loadDocument:@"example" parserOptions:0 error:&error];
  if (error) GHFail(@"Error: %@", error);
  GHTestLog(@"Root: %@", document.root);
}

- (void)testStreaming {
  YAJLDocument *document = [[YAJLDocument alloc] init];

  NSError *error = nil;
  NSData *data1 = [self loadData:@"stream_array1"];
  YAJLParserStatus status1 = [document parse:data1 error:&error];
  GHAssertTrue(status1 == YAJLParserStatusInsufficientData, nil);
  if (error) GHFail(@"Error: %@", error);
  GHTestLog(@"First part: %@", document.root);
  
  NSData *data2 = [self loadData:@"stream_array2"];
  YAJLParserStatus status2 = [document parse:data2 error:&error];
  GHAssertTrue(status2 == YAJLParserStatusOK, nil);
  if (error) GHFail(@"Error: %@", error);

  GHTestLog(@"Root: %@", document.root);
  [document release]; 
}

- (void)testDoubleOverflow {
  NSError *error = nil;
  YAJLDocument *document = [self _loadDocument:@"overflow" parserOptions:0 error:&error];
  GHAssertNotNil(document, nil);
  GHTestLog(@"Root: %@", document.root);
  YAJLParserStatus status = document.parserStatus;
  GHAssertEquals(status, (NSUInteger)YAJLParserStatusError, @"Should have error status");
  
  if (error) {
    GHTestLog(@"Parse error:\n%@", error);    
    GHAssertEquals([error code], (NSInteger)YAJLParserErrorCodeDoubleOverflow, nil);
    GHAssertEqualStrings([[error userInfo] objectForKey:YAJLParserValueKey], @"1.79769e+309", nil);    
  } else {
    GHFail(@"Should have error");
  }
}

- (void)testOverflow2 {
  NSError *error = nil;
  YAJLDocument *document = [self _loadDocument:@"overflow2" parserOptions:0 error:&error];
  GHTestLog(@"Root: %@", document.root);
  YAJLParserStatus status = document.parserStatus;
  GHAssertEquals(status, (NSUInteger)YAJLParserStatusOK, @"Should have OK status");
  GHAssertEqualObjects([document.root objectForKey:@"key1"], [NSNumber numberWithDouble:12343434343434343434343434344343434.0], nil);
  GHAssertEqualObjects([document.root objectForKey:@"key2"], [NSNumber numberWithDouble:343434343434344343434343434.0], nil);
}

// This sample.json is too insane; Will need to revisit
- (void)_testEqualToSBJSON {
  
  NSData *data = [self loadData:@"sample"];
  GHTestLog(@"Sample data size: %d", [data length]);
  
  NSError *error = nil;

  // Build from YAJL  
  YAJLDocument *document = [[YAJLDocument alloc] initWithData:data parserOptions:0 error:&error];
  if (error) GHFail(@"Error: %@", error);
  id YAJLRoot = [document.root retain]; 
  // Save
  [NSKeyedArchiver archiveRootObject:YAJLRoot toFile:[self directoryWithPath:@"yajl_sample.plist"]];
  [document release];
  
  // Build from SBJSON  
  NSString *testString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  id SBJSONRoot = [[testString JSONValue] retain];
  // Save 
  [NSKeyedArchiver archiveRootObject:SBJSONRoot toFile:[self directoryWithPath:@"sbjson_sample.plist"]];
  [testString release];

}

@end
