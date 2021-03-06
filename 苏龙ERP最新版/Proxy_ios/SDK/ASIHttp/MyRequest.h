//
//  MyRequest.h
//  KindergartenApp
//
//  Created by apple on 14/12/26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


typedef void(^SuccessBlock)(NSMutableDictionary *);
typedef void(^FaileBlock)(NSMutableDictionary *);

@protocol MyRequestDelegate <NSObject>
-(void)RequestErrorViewController;//请求失败
@end

@interface MyRequest : NSObject

@property (nonatomic ,copy)SuccessBlock backSuccess;
@property (nonatomic ,copy)FaileBlock backFaile;
@property (nonatomic, unsafe_unretained) id<MyRequestDelegate> delegate;

//Post
+ (id)requestWithURL:(NSString *)urlStr withParameter:(NSDictionary *)paraDic;
- (id)initWithURL:(NSString *)urlStr withParameter:(NSDictionary *)paraDic;

//Get
+ (id)requestWithURL:(NSString *)urlStr;
- (id)getDataUseASIForSever :(NSString *)urlStr;
//传入字符串请求
+(id)requestWithURL:(NSString *)urlStr withString:(NSString *)paraStr;
-(id)initWithURL:(NSString *)urlStr withString:(NSString *)paraStr;

@end
