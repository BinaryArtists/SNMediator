//
//  SNMediatorMacro.h
//  Pods
//
//  Created by 杨洁 on 2017/11/4.
//

#ifndef SNMediatorMacro_h
#define SNMediatorMacro_h

#ifdef DEBUG
#define SNDEBUG 1
#else
#define SNDEBUG 0
#endif

#ifdef DEBUG
#define SNAssert(condition,...) NSAssert(condition,__VA_ARGS__)
#else
#define SNAssert(condition,...)
#endif

#define SNURL(urlString) [NSURL sn_URLWithString:urlString]

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif /* SNMediatorMacro_h */
