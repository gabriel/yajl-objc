# YAJL (Objective-C Wrapper)

YAJL.framework is an Objective-C wrapper around the [YAJL](http://lloyd.github.com/yajl/) SAX-style JSON parser.

## Download

### Mac OS X

[YAJL-0.2.1.zip](http://rel.me.s3.amazonaws.com/yajl/YAJL-0.2.1.zip) *YAJL.framework* (2009/06/14)

## Install

There are two options. You can install it globally in /Library/Frameworks or with a little extra effort embed it with your project.

### Installing in /Library/Frameworks

- Copy `YAJL.framework` to `/Library/Frameworks/`
- In the target Info window, General tab:
	- Add a linked library, under `Mac OS X 10.5 SDK` section, select `YAJL.framework`

### Installing in your project

- Copy `YAJL.framework` to your project directory (maybe in MyProject/Frameworks/.)
- Add the `YAJL.framekwork` files (from MyProject/Frameworks/) to your target. It should be visible as a `Linked Framework` in the target. 
- Under Build Settings, add `@loader_path/../Frameworks` to `Runpath Search Paths` 
- Add `New Build Phase` | `New Copy Files Build Phase`. 
	- Change the Destination to `Frameworks`.
	- Drag `YAJL.framework` into the the build phase
	- Make sure the copy phase appears before any `Run Script` phases 


## Using (SAX-style)

To use the SAX style parser, use `YAJLParser`. Usage should be very similar to `NSXMLParser`.

	NSData *data = [NSData dataWithContentsOfFile:@"example.json"];

	YAJLParser *parser = [[YAJLParser alloc] initWithData:data parserOptions:0];
	parser.delegate = self;
	[parser parse];

	NSError *error = [parser parserError];
	if (error) NSLog(@"Error:\n%@", error);

	[parser release];	
	
	// Include delegate methods from YAJLParserDelegate
	/*
	- (void)parserDidStartDictionary:(YAJLParser *)parser;
	- (void)parserDidEndDictionary:(YAJLParser *)parser;

	- (void)parserDidStartArray:(YAJLParser *)parser;
	- (void)parserDidEndArray:(YAJLParser *)parser;

	- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key;
	- (void)parser:(YAJLParser *)parser didAdd:(id)value;
	*/
	
## Using (Document-style)

To use the document style, use `YAJLDocument`. Usage should be very similar to `NSXMLDocument`.

	NSData *data = [NSData dataWithContentsOfFile:@"example.json"];
	NSError *error = nil;
	YAJLDocument *document = [[YAJLDocument alloc] initWithData:data parserOptions:0 error:&error];
	// Access root element at document.root
	NSLog(@"Root: %@", document.root);
	[document release];

