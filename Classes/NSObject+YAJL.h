//
//  NSObject+YAJL.h
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

#import "YAJLGen.h"
#import "YAJLParser.h"

@interface NSObject (YAJL)

#pragma mark Gen

/*!
 Create JSON string from object.
 Supported objects include: NSArray, NSDictionary, NSNumber, NSString, NSNull
 To handle JSON manually, implement (id)yajl_JSONObject;
 Otherwise throws YAJLGenInvalidObjectException.
 @result JSON String
 */
- (NSString *)yajl_JSONString;

/*!
 Create JSON string from object.
 Supported objects include: NSArray, NSDictionary, NSNumber, NSString, NSNull
 To handle JSON manually, implement (id)yajl_JSONObject;
 Otherwise throws YAJLGenInvalidObjectException.
 @param options
 @param indentString
 @result JSON String
 */
- (NSString *)yajl_JSONStringWithOptions:(YAJLGenOptions)options indentString:(NSString *)indentString;


#pragma mark Parsing

/*!
 Parse JSON string.
 @result JSON object
 @throws YAJLParserException If a parse error occured
 @throws YAJLParsingUnsupportedException If not NSData or doesn't respond to dataUsingEncoding:
 
 @code
 NSString *JSONString = @"{'foo':['bar', true]}";
 [JSONString yajl_JSON];
 @endcode
 */
- (id)yajl_JSON;

/*!
 Parse JSON string with out error.
 @param error Error to set if we failed to parse
 @result JSON object
 @throws YAJLParserException If a parse error occured
 @throws YAJLParsingUnsupportedException If not NSData or doesn't respond to dataUsingEncoding:
 
 @code
 NSString *JSONString = @"{'foo':['bar', true]}";
 NSError *error = nil;
 [JSONString yajl_JSON:error];
 if (error) ...;
 @endcode
 */
- (id)yajl_JSON:(NSError **)error;

/*!
 Parse JSON string with options and out error.
 @param options Options (see YAJLParserOptions)
 @param error Error to set if we failed to parse
 @result JSON object
 @throws YAJLParserException If a parse error occured
 @throws YAJLParsingUnsupportedException If not NSData or doesn't respond to dataUsingEncoding:
 
 @code
 NSString *JSONString = @"{'foo':['bar', true]} // comment";
 NSError *error = nil;
 [JSONString yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:error];
 if (error) ...;
 @endcode
 */
- (id)yajl_JSONWithOptions:(YAJLParserOptions)options error:(NSError **)error;

@end

