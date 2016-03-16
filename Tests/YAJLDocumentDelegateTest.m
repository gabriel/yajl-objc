//
//  YAJLDocumentDelegateTest.m
//  YAJL
//
//  Created by Gabriel Handford on 3/29/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "NSString+SBJSON.h"

@interface YAJLDocumentDelegateTest : YAJLTestCase <YAJLDocumentDelegate> {}
@end

@implementation YAJLDocumentDelegateTest

- (void)test {
  NSData *data = [self loadData:@"document_streaming"];
  NSError *error = nil;
  YAJLDocument *document = [[YAJLDocument alloc] init];
  document.delegate = self;
  [document parse:data error:&error];
  GHAssertNil(error, nil);
  [document release];
}

- (void)document:(YAJLDocument *)document didSetObject:(id)object forKey:(id)key inDictionary:(NSDictionary *)dict {
  if ([key isEqualToString:@"test"]) return;
  
  static NSInteger index = 1;
  NSString *expectedKey = [NSString stringWithFormat:@"array%ld", (signed long)index];
  NSArray *expectedValue = [NSArray arrayWithObject:[NSNumber numberWithInteger:index]];
  index++;
  GHAssertEqualStrings(expectedKey, key, nil);
  GHAssertEqualObjects(expectedValue, object, nil);
  GHTestLog(@"Set object (dict): %@=%@", key, object);
}

@end
