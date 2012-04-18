/*
 * Copyright (c) 2012 Eli Wang
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "NSObject+Properties.h"
#import "YAJL.h"
#import "NSObject+YAJLizable.h"

@interface YAJLObjectParser : NSObject <YAJLParserDelegate> {
	Class klass_;
    id stub_;
	
	id root_; // NSArray or NSDictionary
	YAJLParser *parser_;
    
	// Note for developer: __weak mark does NOTHING in a reference count runtime.
	// iOS only have the reference count runtime, thus __weak does NOTHING in iOS
	id dict_; // weak; if map in progress, points to the current map 
	__weak NSMutableArray *array_;  // weak; If array in progress, points the current array
	__weak NSString *key_;          // weak; If map in progress, points to current key
	__weak Class arrayType_;        // If the current object is an array, this is the type of the objects
                                    // in the array
    
	NSMutableArray *stack_;
	NSMutableArray *keyStack_;
	NSMutableArray *arrayTypeStack_;
    NSMutableArray *classObjectSweeperStack_;
	
	YAJLDecoderCurrentType currentType_;
	
	YAJLParserStatus parserStatus_;
}

@property (nonatomic, retain, readonly) id root;
@property (nonatomic, assign) BOOL skipping;

- (id)initWithClass:(Class)klass parser:(YAJLParser *)parser;
- (id)initWithStubObject:(id)obj parser:(YAJLParser *)parser;

- (void)cleanClassObjects;

@end


@interface NSObject (EWIsClassObject)

- (BOOL)isClassObject;

@end
