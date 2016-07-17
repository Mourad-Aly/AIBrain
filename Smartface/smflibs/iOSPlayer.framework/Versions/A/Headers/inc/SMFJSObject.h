#ifdef SMF_PLUGINS_ENABLED

typedef NS_ENUM(NSInteger, SMFType) {
	Undefined,
    Null,
    Booleanx,
    Number,
    String,
    Object
};

#ifdef SMARTFACE_IOS_EMULATOR
#import "JavaScriptCore.h"
#else
#import <JavaScriptCore/JavaScriptCore.h>
#endif

@interface SMFJSObject : NSObject

@property (assign) JSValueRef jsValueRef;

-(instancetype)init;
-(instancetype)initWithInt:(int)val;
-(instancetype)initWithDouble:(double)val;
-(instancetype)initWithString:(NSString *)val;
-(instancetype)initWithBool:(BOOL)val;
-(instancetype)initWithValue:(JSValueRef)val;

-(void)dealloc;

-(SMFType)getType;
-(BOOL)hasProperty:(NSString *)propertyName;
-(SMFJSObject *)getProperty:(NSString *)propertyName;
-(void)setProperty:(NSString *)propertyName to:(SMFJSObject *)value;
-(BOOL)deleteProperty:(NSString *)propertyName;
-(SMFJSObject *)getPropertyAtIndex:(int)propertyIndex;
-(void)setPropertyAtIndex:(int)propertyIndex to:(SMFJSObject *)value;

-(BOOL)isFunction;
-(BOOL)isUndefined;
-(BOOL)isNull;
-(BOOL)isBoolean;
-(BOOL)isNumber;
-(BOOL)isString;
-(BOOL)isObject;

-(BOOL)isObjectOfClass:(SMFJSObject *)aClass;
-(BOOL)isEqual:(SMFJSObject *)value;
-(BOOL)isStrictEqual:(SMFJSObject *)value;

-(SMFJSObject *)callSelfAsFunctionWithArgs:(NSArray *)arguments;
-(SMFJSObject *)callAsFunction:(SMFJSObject *)thisObject withArgs:(NSArray *)arguments;
-(NSArray *)copyPropertyNames;
-(int)getPropertyNameArrayLength;

-(BOOL)toBoolean;
-(double)toDouble;
-(int)toInt;
-(NSString *)toStringCopy;

@end

#endif /* SMF_PLUGINS_ENABLED */