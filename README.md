# YAJL (Objective-C Wrapper)

The YAJL framework is an Objective-C wrapper around the [YAJL](http://lloyd.github.com/yajl/) SAX-style JSON parser.

## Docset

Download and copy to docset to `~/Library/Developer/Shared/Documentation/DocSets/YAJL.docset`

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

To use the framework:

	#import <YAJL/YAJL.h>

## Install (iOS)

- Add the `YAJLIOS.framework` to your project.
- Add the following frameworks to `Linked Libraries`:
  - `YAJLIOS.framework`
  - `CoreGraphics.framework`
  - `Foundation.framework`
  - `UIKit.framework`
- Under 'Framework Search Paths' make sure the (parent) directory to YAJLIOS.framework is listed.
- Under 'Other Linker Flags' in the `Test` target, add `-ObjC` and `-all_load`

To use the framework:

	#import <YAJLIOS/YAJLIOS.h>

## Documentation

For documentation see [http://gabriel.github.com/yajl-objc/](http://gabriel.github.com/yajl-objc/)


