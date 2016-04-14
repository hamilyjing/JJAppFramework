//
//  JJWeatherModel.h
//  JJ_iOS_Service
//
//  Created by JJ on 4/14/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJWeatherModel : JJBaseResponseModel

@property (nonatomic, assign) long errNum;
@property (nonatomic, copy) NSString *errMsg;

@end
