//
//  NSString+YAJL.m
//  YAJL
//
//  Created by Gabriel Handford on 7/23/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSString+YAJL.h"

#import "YAJLDocument.h"

NSString *const YAJLParserException = @"YAJLParserException";

@implementation NSString (YAJL)

- (id)yajl_JSON {
	NSError *error = nil;
	id JSON = [self yajl_JSON:&error];
	if (error) [NSException raise:YAJLParserException format:[error localizedDescription]];
	return JSON;
}

- (id)yajl_JSON:(NSError **)error {
	return [self yajl_JSONWithOptions:YAJLParserOptionsNone error:error];
}

- (id)yajl_JSONWithOptions:(YAJLParserOptions)options error:(NSError **)error {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	YAJLDocument *document = [[YAJLDocument alloc] initWithData:data parserOptions:YAJLParserOptionsNone error:error];
	id root = [document.root retain];
	[document release];
	return [root autorelease];
}

@end
