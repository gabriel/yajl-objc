//
//  YAJLGen.h
//  YAJL
//
//  Created by Gabriel Handford on 7/19/09.
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

#include "yajl_gen.h"

extern NSString *const YAJLGenInvalidObjectException;

/*!
 @enum Generate options
 @constant YAJLGenOptionsBeautify
 */
enum {
	YAJLGenOptionsNone = 0,	
	YAJLGenOptionsBeautify = 1 << 0,
};
typedef NSUInteger YAJLGenOptions;


@interface YAJLGen : NSObject {
	yajl_gen gen_;
}

- (id)initWithGenOptions:(YAJLGenOptions)genOptions indentString:(NSString *)indentString;

- (void)object:(id)obj;

- (void)null;

- (void)bool:(BOOL)b;

- (void)number:(NSNumber *)number;

- (void)string:(NSString *)s;

- (void)startDictionary;
- (void)endDictionary;

- (void)startArray;

- (void)endArray;

- (void)clear;

- (NSString *)buffer;

@end
