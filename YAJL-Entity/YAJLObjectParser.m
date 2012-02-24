/*
 * Copyright (c) 2011 Eli Wang
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

#import <Foundation/NSKeyValueCoding.h>
#import "YAJLObjectParser.h"
#import "NSString+CaseExt.h"
#import "NSObject+AQToolkitEXT.h"

@implementation NSObject (EWIsClassObject)

- (BOOL)isClassObject
{
    return [self class] == (Class)self;
}

@end 
//BOOL IsClassObject(id obj)
//{
//    if (obj)
//        return [obj class] == obj;
//    else
//        return false;
//}

//NSString *NSStringFromArray(NSArray *array)
//{
//    if (array && [array count] > 0) {
//        NSMutableString *str = [[[NSMutableString alloc] initWithCapacity:30] autorelease];
//        [str appendString:@"["];
//        
//        for (id obj in array) {
//            [str appendFormat:@"%@, ", obj];
//        }
//        
//        str = [[[str substringToIndex:[str length] - 2] mutableCopy] autorelease];
//        [str appendString:@"]"];
//        
//        return str;
//    } else if (array) {
//        return @"[]";
//    } else {
//        return @"<nil>";
//    }
//}




@interface YAJLObjectParser()

- (void)pop_;
- (void)popKey_;
- (Class)classOfCurrentKey_;
- (void)cleanAndPopLastClassObject_;

@end






@implementation YAJLObjectParser

@synthesize root=root_, skipping;

#pragma mark -
#pragma mark Initializers

- (id)initWithClass:(Class) klass parser:(YAJLParser *) parser
{
	if ((self = [super init])) {
		klass_ = [klass retain];
		parser.delegate = self;
		
		stack_ = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
		keyStack_ = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
		arrayTypeStack_ = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
        classObjectSweeperStack_ = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
		parserStatus_ = YAJLParserStatusNone;
                
        skipping = NO;
	}
	
	return self;
}

- (id)initWithStubObject:(id)obj parser:(YAJLParser *)parser
{
    if ((self = [self initWithClass:nil parser:parser])) {
        stub_ = [obj retain];
    }
    
    return self;
}

#pragma mark - Methods

- (void)cleanClassObjects
{
    [self cleanAndPopLastClassObject_];
}

#pragma mark -
#pragma mark YAJLParserDelegate methods
- (void)parserDidStartDictionary:(YAJLParser *)parser
{
	id dict = nil;
	Class klass;
	
	if (!root_) {
        if (klass_) {
            dict = [[klass_ alloc] initForYAJL];
            root_ = [dict retain];
        } else {
            root_ = [stub_ retain];
            dict = [root_ retain];
        }
	} else {
		// Check whether this dictionary is in an array or another dictionary
		switch (currentType_) {
            case YAJLDecoderCurrentTypeArray:
                if (arrayType_ && arrayType_ != (Class)[NSNull null]) {
                    // The newly started dictionary is in an array, and the parent's property reprensenting
                    // this array how holds the class object which indicates the type of the objects in
                    // the array
                    dict = [[arrayType_ alloc] initForYAJL];
                } 
                
                break;
            case YAJLDecoderCurrentTypeDict:
                klass = [self classOfCurrentKey_];
                dict = [[klass alloc] initForYAJL];
                break;
            default:
                NSAssert(NO, @"currentType_ must be either dict or array"); 
                break;
		}
	}
    
	if (dict) {
		[stack_ addObject:dict]; // Push
        id s = [dict mutableSetOfObjectPropertyNames];
        if (s == nil) {
            s = [NSNull null];
        }
        [classObjectSweeperStack_ addObject:s];
	} else {
		[stack_ addObject:[NSNull null]];
        [classObjectSweeperStack_ addObject:[NSNull null]];
	}
    
	dict_ = dict;
	currentType_ = YAJLDecoderCurrentTypeDict;  
	[dict release];
}

- (void)parserDidEndDictionary:(YAJLParser *)parser
{
	id value = [[stack_ objectAtIndex:[stack_ count]-1] retain];
    [self cleanAndPopLastClassObject_];
	[self pop_];
	[self parser:parser didAdd:value];
    
	
	[value release];
}

- (void)parserDidStartArray:(YAJLParser *)parser
{
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:YAJLDocumentStackCapacity];
	
	if (!root_) {
		root_ = [array retain];
        
        arrayType_ = klass_;
	} else {
		arrayType_ = [self classOfCurrentKey_];
	}
	
	if (arrayType_) {
		[arrayTypeStack_ addObject:arrayType_];
	} else {
		[arrayTypeStack_ addObject:[NSNull null]];
//        [stack_ addObject:[NSNull null]];
	}
    
    [stack_ addObject:array]; // Push
	array_ = array;
	currentType_ = YAJLDecoderCurrentTypeArray;
	[array release];
}

- (void)parserDidEndArray:(YAJLParser *)parser
{
	id value = [[stack_ lastObject] retain];
	
	if ([arrayTypeStack_ count] > 0) [arrayTypeStack_ removeLastObject];
    
    if (arrayType_ == nil && [value count] == 0) {
        [value release];
        value = nil;
    }
	
	if ([arrayTypeStack_ count] > 0) {
		arrayType_ = [arrayTypeStack_ objectAtIndex:[arrayTypeStack_ count] - 1];
	} else {
		arrayType_ = nil;
	}
	
	[self pop_];  
	[self parser:parser didAdd:value];
	[value release];
}

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key
{    
	if ([key isEqualToString:[key uppercaseString]] || [dict_ isKindOfClass:[NSDictionary class]])
        key_ = key;
    else {
        key_ = [key stringByLowercaseFirstChar];
        if (![dict_ hasPropertyNamed:key_]) {
            key_ = [key camelcaseString];
        }
    }
    
	[keyStack_ addObject:key_]; // Push
}

- (void)parser:(YAJLParser *)parser didAdd:(id)value
{
	switch(currentType_) {
        case YAJLDecoderCurrentTypeArray:
            [array_ addObject:value];
            break;
        case YAJLDecoderCurrentTypeDict:
            if ([dict_ isKindOfClass:[NSDictionary class]]) {
                [dict_ setValue:value forKey:key_];
            } else if ([dict_ hasPropertyNamed:key_]) {
                if (value == [NSNull null]) value = nil;
                @try {
                    [dict_ setValue:value forKey:key_];
                }
                @catch (NSException *exception) {
                }
                
                [[classObjectSweeperStack_ lastObject] removeObject:key_];
            }
            
            [self popKey_];
            break;
        default:
            break;
	} 
}

#pragma mark -
#pragma mark Private methods

- (void) pop_
{
	[stack_ removeLastObject];
	array_ = nil;
	dict_ = nil;
	currentType_ = YAJLDecoderCurrentTypeNone;
	
	id value = nil;
	if ([stack_ count] > 0) value = [stack_ objectAtIndex:[stack_ count]-1];
    
	if ([value isKindOfClass:[NSArray class]]) {    
		currentType_ = YAJLDecoderCurrentTypeArray;
        array_ = value;
	} else if (value) {
		dict_ = value;
        
        if ((id)dict_ == [NSNull null]) dict_ = nil;
		currentType_ = YAJLDecoderCurrentTypeDict;
	}
}

- (void) popKey_
{
	key_ = nil;
    
    if ([keyStack_ count] > 0) 
        [keyStack_ removeLastObject]; // Pop  
    
	if ([keyStack_ count] > 0) 
		key_ = [keyStack_ objectAtIndex:([keyStack_ count] - 1)]; 
}

- (Class)classOfCurrentKey_
{
	if ([dict_ hasPropertyNamed:key_]) {
        
        Class klass = [dict_ valueForKey:key_];
        if (klass) {
            return [dict_ valueForKey:key_];
        } else {
            NSString *className = [NSString stringWithUTF8String:[dict_ typeOfPropertyNamed:key_]];
            className = [className substringWithRange:NSMakeRange(3, [className length] - 4)];
            
            Class ret = NSClassFromString(className);
            
            if ([ret isSubclassOfClass:[NSArray class]])
                return nil;
            else
                return ret;            
        }
	} else {
        return nil;
	}
    
}

- (void)cleanAndPopLastClassObject_
{
    id currentPropertySet = [classObjectSweeperStack_ lastObject];
    if (currentPropertySet == [NSNull null] || [currentPropertySet count] == 0) {

    } else {
        if (dict_ && dict_ != (id)[NSNull null]) {
            for (NSString *propName in currentPropertySet) {
                // FIXME: Readonly properties should not be set!
                
                id propValue = [dict_ valueForKey:propName];
                if ([propValue isClassObject])
                    [dict_ setValue:nil forKey:propName];
            }
        }
    }
    if ([classObjectSweeperStack_ count] > 0) [classObjectSweeperStack_ removeLastObject];
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc
{
	[stack_ release];
	[keyStack_ release];
	[arrayTypeStack_ release];
    [classObjectSweeperStack_ release];
	[root_ release];
	[klass_ release];
    [stub_ release];
	[super dealloc];
}
@end
