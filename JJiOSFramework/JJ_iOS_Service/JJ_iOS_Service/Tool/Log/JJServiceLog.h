//
//  JJLog.h
//  JJ_iOS_Service
//
//  Created by JJ on 12/27/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//FOUNDATION_EXPORT void JJLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

#ifdef DEBUG
#define JJServiceLog(fmt, ...) NSLog(fmt @" %s line:%d", ##__VA_ARGS__, __PRETTY_FUNCTION__, __LINE__)
#else
#define JJServiceLog(fmt, ...)
#endif