# YAJL Framework

The YAJL framework is an Objective-C framework for the [YAJL](http://lloyd.github.com/yajl/) SAX-style JSON parser.

## Features

- Stream parsing, comments in JSON, better error messages.
- Parse directly from NSString or NSData.
- Generate JSON from default or custom types.
- Properly handles large numeric types.
- Document style parser.
- Error by exception or out error.

# Podfile

```ruby
pod "YAJLO"
```

# Usage

```objc
#import <YAJLO/NSObject+YAJL.h>
#import <YAJLO/YAJLDocument.h>
#import <YAJLO/YAJLGen.h>
#import <YAJLO/YAJLParser.h>
```

### To parse JSON from NSData

```objc
NSData *JSONData = [NSData dataWithContentsOfFile:@"example.json"];
NSArray *arrayFromData = [JSONData yajl_JSON];
```

### To parse JSON from NSString

```objc
NSString *JSONString = @"[1, 2, 3]";
NSArray *arrayFromString = [JSONString yajl_JSON];
```

### To parse JSON from NSString with error and comments

```objc
// With options and out error
NSString *JSONString = @"[1, 2, 3] // Allow comments";
NSError *error = nil;
NSArray *arrayFromString = [JSONString yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
```

### To generate JSON from an object, NSArray, NSDictionary, etc.

```objc
NSDictionary *dict = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
NSString *JSONString = [dict yajl_JSONString];
// ==> {"key":"value"}
```

### To generate JSON from an object, beautified with custom indent

```objc
// Beautified with custon indent string
NSArray *array = [NSArray arrayWithObjects:@"value1", @"value2", nil];
NSString *JSONString = [dict yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"    "];
```

### To use the streaming (or SAX style) parser, use YAJLParser

```objc
NSData *data = [NSData dataWithContentsOfFile:@"example.json"];

YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsAllowComments];
parser.delegate = self;
[parser parse:data];
if (parser.parserError) {
  NSLog(@"Error:\n%@", parser.parserError);
}
parser.delegate = nil;
[parser release];

// Include delegate methods from YAJLParserDelegate
- (void)parserDidStartDictionary:(YAJLParser *)parser { }
- (void)parserDidEndDictionary:(YAJLParser *)parser { }

- (void)parserDidStartArray:(YAJLParser *)parser { }
- (void)parserDidEndArray:(YAJLParser *)parser { }

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key { }
- (void)parser:(YAJLParser *)parser didAdd:(id)value { }
```

### Parser Options

There are options when parsing that can be specified with initWithParserOptions: (YAJLParser).

```objc
YAJLParserOptionsAllowComments: Allows comments in JSON
YAJLParserOptionsCheckUTF8: Will verify UTF-8
YAJLParserOptionsStrictPrecision: Will force strict precision and return integer overflow error, if number is greater than long long.
Parsing as data becomes available

 YAJLParser *parser = [[[YAJLParser alloc] init] autorelease];
 parser.delegate = self;

 // A chunk of data comes...
 YAJLParserStatus status = [parser parse:chunk1];
 // 'status' should be YAJLParserStatusInsufficientData, if its not finished
 if (parser.parserError)
   NSLog(@"Error:\n%@", parser.parserError);

 // Another chunk of data comes...
 YAJLParserStatus status = [parser parse:chunk2];
 // 'status' should be YAJLParserStatusOK if its finished
 if (parser.parserError)
   NSLog(@"Error:\n%@", parser.parserError);
Document style parsing

To use the document style, use YAJLDocument. Usage should be very similar to NSXMLDocument.

 NSData *data = [NSData dataWithContentsOfFile:@"example.json"];
 NSError *error = nil;
 YAJLDocument *document = [[YAJLDocument alloc] initWithData:data parserOptions:YAJLParserOptionsNone error:&error];
 // Access root element at document.root
 NSLog(@"Root: %@", document.root);
 [document release];
Document style parsing as data becomes available

 YAJLDocument *document = [[YAJLDocument alloc] init];
 document.delegate = self;

 NSError *error = nil;
 [document parse:chunk1 error:error];
 [document parse:chunk2 error:error];

 // You can access root element at document.root
 NSLog(@"Root: %@", document.root);
 [document release];

 // Or via the YAJLDocumentDelegate delegate methods

 - (void)document:(YAJLDocument *)document didAddDictionary:(NSDictionary *)dict { }
 - (void)document:(YAJLDocument *)document didAddArray:(NSArray *)array { }
 - (void)document:(YAJLDocument *)document didAddObject:(id)object toArray:(NSArray *)array { }
 - (void)document:(YAJLDocument *)document didSetObject:(id)object forKey:(id)key inDictionary:(NSDictionary *)dict { }
```

### Load JSON from Bundle

```objc
id JSONValue = [[NSBundle mainBundle] yajl_JSONFromResource:@"kegs.json"];
```

### Customized Encoding

To implement JSON encodable value for custom objects or override for existing objects, implement - (id)JSON;

For example:

```objc
@interface CustomObject : NSObject
@end

@implementation CustomObject

- (id)JSON {
 return [NSArray arrayWithObject:[NSNumber numberWithInteger:1]];
}

@end
```
