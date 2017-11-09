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




#endif /* SNMediatorMacro_h */
