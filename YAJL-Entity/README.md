This extension can deserialize JSON data to custom objects. Currently it do has limitations. But it can handle 90% of the situations for you. 

# A Short Demo

**Import line:** 

```objective-c
#import <YAJLiOS/YAJL-Entity.h>
```

In `YAJL-EntityTest.m`:


```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"my-entity.json" ofType:nil];
NSData *data = [NSData dataWithContentsOfFile:path];

// Deserialization
MyEntity *entity = [data objectFromJSONOfType:[MyEntity class]];

// Serialization.
// You have to implement - (id)JSON method in your entity class. This is easy. See below
NSString *jsonString = [entity yajl_JSONString];
```

In `MyEntity.m`, the following code:

```objective-c
// A informal protocol. By default it simply calls [self init
// Override this only if your class has properties to be deserialzed which are NSArray or NSMutableArray
- (id)initForYAJL
{
    if ((self = [super initForYAJL])) {
	// Assign the class object to the array property as a hint.
	// This is valid since Objective C is dynamically typed. 
        self.addresses = (NSArray *)[MyAddress class];
    }
    
    return self;
}
```
is required to make the array work. 

By looking into the defination of the class MyEntity you can find that it has 2 array properties, one of which contains custom objects while the other contains primitives, and one property of other model class. So this is enough for most of the situations.

# Convention over Configuration

Conventionally the names in Objective C are camel-cased. Snake-cased names can be automatically converted.


In order to support serializing an object to JSON string, you have to implement `- (id)JSON` method. Here is a default implementation. Add this to your entities' common superclass.

```objective-c
- (id)JSON
{
    return [self dictionaryOfProperyties];
}
```

the `- (id)JSON` method is required by the YAJL framework to serialize the object. It should return the json reprensentation of itself in `NSArray` or `NSDictionary`. The `- (NSDictionary *)dictionaryOfProperty` method is provided by YAJL-Entity which can make a `NSDictionary` containing all the properies and values of this project. Usually, you can have this method in the common parent class of all your models.

For the generated names of the json string's properties, they are same as the ones in the ObjC class. If you want it snake-cased, you can use `- (NSDictionary *)dictionaryOfProperytiesWithOption:` instead.

# To Developers

For the JSON, it lacks any class info. So one of the difficulties is the type inferring. In YAJL-Entity, I look up the obj-c 2.0 declared property info in runtime. I thought it is just a syntactic sugar for declaring getter/setter methods, but it's not. This is kept until runtime. And another thing is the generics in C#/Java. For the objects in an array, we are unable to keep their types either in the obj-c objects or in json objects. For this, I created a 'informal' protocol, a method called initForYAJL. In this method, we just provide the info for the types in arrays, e.g:

```objective-c
- (id)initForYAJL
{
	if ((self = [super initForYAJL])) {
		self.customers = (NSArray *)[Customer class];
	}

	return self;
}
```

YAJL-Entity will use this class object to initialize the instances in the array.

But for the nested arrays, I can do nothing. When facing nested arrays, I parse the json into a NSDictionary/NSArray nested object, which can be done by most json libs in objc. Then I have a helper category method, which can fill the property of an object, with an NSDictionary. It's in `NSObject+FillPropertiesWithDictionary.h`. This can reduce some boilerplate.

