//
//  YAJLParser.h
//  YAJL
//
//  Created by Gabriel Handford on 6/14/09.
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


#include "yajl_parse.h"


extern NSString *const YAJLErrorDomain;

#ifdef DEBUG
#define YAJLDebug(...) NSLog(__VA_ARGS__)
#else
#define YAJLDebug(...) do {} while(0)
#endif


/*!
 @enum Parser options
 @constant YAJLParserOptionsAllowComments Javascript style comments will be allowed in the input (both /&asterisk; &asterisk;/ and //)
 @constant YAJLParserOptionsCheckUTF8 Invalid UTF8 strings will cause a parse error
 */
enum {
	YAJLParserOptionsNone = 0,	
	YAJLParserOptionsAllowComments = 1 << 0,
	YAJLParserOptionsCheckUTF8 = 1 << 1,
};
typedef NSUInteger YAJLParserOptions;

enum {
	YAJLParserStatusNone = 0,
	YAJLParserStatusOK = 1,
	YAJLParserStatusInsufficientData,
	YAJLParserStatusError
};
typedef NSUInteger YAJLParserStatus;


@class YAJLParser;


@protocol YAJLParserDelegate <NSObject>

- (void)parserDidStartDictionary:(YAJLParser *)parser;
- (void)parserDidEndDictionary:(YAJLParser *)parser;

- (void)parserDidStartArray:(YAJLParser *)parser;
- (void)parserDidEndArray:(YAJLParser *)parser;

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key;

/*!
 Did add value.
 @param parser Sender
 @param value Value of type NSNull, NSString or NSNumber
 */
- (void)parser:(YAJLParser *)parser didAdd:(id)value;

@end


@interface YAJLParser : NSObject {
	
	yajl_handle handle_;
	
	id <YAJLParserDelegate> delegate_; // weak
		
	YAJLParserOptions parserOptions_;

	NSError *parserError_;
}

@property (assign, nonatomic) id <YAJLParserDelegate> delegate;
@property (readonly, retain, nonatomic) NSError *parserError;

/*!
 Create parser with data and options.
 @param parserOptions
 */
- (id)initWithParserOptions:(YAJLParserOptions)parserOptions;

/*!
 Parse data.
 
 If streaming, you can call parse multiple times as long as 
 previous calls return YAJLParserStatusInsufficientData.
 
 @param data
 @result See YAJLParserStatus
 */
- (YAJLParserStatus)parse:(NSData *)data;

@end
