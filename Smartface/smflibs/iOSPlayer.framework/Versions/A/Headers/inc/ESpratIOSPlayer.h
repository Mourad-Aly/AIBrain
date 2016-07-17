#import <UIKit/UIKit.h>

#ifdef SMARTFACE_EMULATOR
#import "../JavaScriptCore/inc/JavaScriptCore.h"
#else
#import <JavaScriptCore/JavaScriptCore.h>
#endif

@protocol CloudEmulatorDelegate <NSObject>

- (void) clearDone;
- (void) invalidProtocolVersionWithEmulatorVersion:(NSString*)emulatorVersion andDispatcherVersion:(NSString*)dispatcherVersion;
- (void) filesRecieved:(uint8_t*) bytes : (int) byteLength;
- (void) chunkReceived:(uint8_t*)chunk withSize:(int)size withStatus:(BOOL)isFinal withOffset:(int)offset;
- (void) fileInfoReceived:(int)message;
- (void) handleError:(NSString*) errorMessage;
- (void) timeOutException;
- (void) setEmulatorProjectName:(NSString*) projectName;

@end


__attribute__ ((visibility ("default"))) @protocol ESpratIOSPlayerInterface <NSObject>
-(void) SMFRun;
-(void) SMFClean;
-(void) SMFAppWillTerminate;
-(void) SMFAppEnteredBackground;
-(void) SMFAppCameFromBackground;
-(void) SMFReceiveNotification :(UILocalNotification*)notification;
-(void) SMFRegisteredNotification:(NSData *)token andError:(NSError *)error;
-(void) SMFSetRemoteTempDict:(NSDictionary *)dictionary;
-(void) SMFHandleRemoteNotification:(UIApplication *)application andDict:(NSDictionary *)dict;
-(void) SMFHandleUrlAppCall:(NSURL *)url;
-(void) SMFSetAppCallUrl:(NSURL *)url;
-(BOOL) SMFIsCameFromBack;
-(void) SMFLoadCustomPluginIdentifier:(const char *)definitonString andDefinition:(const JSClassDefinition *)classDefinition withObject:(void **)privateObject;
-(void) SMFRunJavaScriptSmartface:(JSObjectRef)object :(JSObjectRef)thisObject :(size_t)argumentCount :(const JSValueRef[])args;
-(JSGlobalContextRef) SMFGetGlobalContextRef;
-(void) SMFCreateJSInterfaceForClass:(Class)objcClass refString:(NSString *)refString;
-(void) SMFCreateViewJSInterfaceForClass:(Class)objcClass refString:(NSString *)refString;
-(void) SMFSetCloudEmulatorDelegate:(id)delegate;
@end

__attribute__ ((visibility ("default"))) @interface ESpratIOSPlayer : NSObject{
}

+(id<ESpratIOSPlayerInterface>) SMFGetPlayer;

@end
