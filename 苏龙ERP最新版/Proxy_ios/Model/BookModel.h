//
//  BookModel.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/19.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* tel;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* dept;
@property (nonatomic, strong) NSString* positionName;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* msn;
@property (nonatomic, strong) NSString* deptId;
@property (nonatomic, strong) NSString* positionId;
@property (nonatomic, strong) NSString* userImag;
@property (nonatomic, strong) NSString* pinYin;

+ (instancetype)initWithAddData:(NSDictionary *)aData;

@end
