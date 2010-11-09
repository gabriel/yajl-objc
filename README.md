# YAJL Framework

The YAJL framework is an Objective-C framework for the [YAJL](http://lloyd.github.com/yajl/) SAX-style JSON parser.

## Features

- Stream parsing, comments in JSON, better error messages.
- Parse directly from NSString or NSData.
- Generate JSON from default or custom types.
- Properly handles large numeric types.
- Document style parser.
- Error by exception or out error.

## Links

- The online [API documentation](http://gabriel.github.com/yajl-objc/).

## Docset

Download and copy the YAJL.docset to `~/Library/Developer/Shared/Documentation/DocSets/YAJL.docset`

(You may need to restart XCode after copying the file.)

The documentation will appear within XCode:

![YAJL-Docset](http://rel.me.s3.amazonaws.com/yajl/images/docset.png)

## Install (Mac OS X)

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

## Install (iOS)

- Add `YAJL.framework` to your project.
- Add the frameworks to `Linked Libraries`:
  - `YAJL.framework`
  - `CoreGraphics.framework`
  - `Foundation.framework`
  - `UIKit.framework`
- Under `Framework Search Paths` make sure the (parent) directory to `YAJL.framework` is listed.
- Under `Other Linker Flags` in your target, add `-ObjC` and `-all_load`




