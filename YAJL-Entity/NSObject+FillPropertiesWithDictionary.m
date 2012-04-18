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

#import "NSObject+FillPropertiesWithDictionary.h"
#import "NSObject+AQToolkitEXT.h"
#import "NSString+CaseExt.h"


@implementation NSObject(FillPropertiesWithDictionary)

- (void)fillPropertiesWithDictionary:(NSDictionary *)dict
{
    for (NSString *key in dict) {
        NSString *lowerKey = [key stringByLowercaseFirstChar];
        SEL setter = [self setterForPropertyNamed:lowerKey];
        
        if (setter) {
            id value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                const char *type = [self typeOfPropertyNamed:lowerKey];
                
                if (type) {
                    NSString *className =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
//                    NSLog(@"%@", className);
                
                    className = [className substringWithRange:NSMakeRange(3, [className length] - 4)];
                    Class klass = NSClassFromString(className);
                    
                    [self performSelector:setter withObject:[klass objectWithPropertyDictionary:value]];
                }
            } else {
                if (value == [NSNull null]) value = nil;
                
                @try {
                    [self setValue:value forKey:lowerKey];
                } @catch (NSException *exception) {
                }
            }
        }
    }
}

+ (id)objectWithPropertyDictionary:(NSDictionary *)dict
{
    id ret = [[[self alloc] init] autorelease];
    [ret fillPropertiesWithDictionary:dict];
    
    return ret;
}

@end
