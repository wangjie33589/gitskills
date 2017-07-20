//
//  ConFunc.h
//  Ulife_Service
//
//  Created by fengyixiao on 15/11/6.
//  Copyright © 2015年 UHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConFunc : NSObject<UIAlertViewDelegate>
+ (BOOL)isFirstLaunching;
+ (void)addTapGesturesWithView:(UIView*)view target:(id)target selector:(SEL)selector;

+(UIView *)createLineframe:(CGRect)frame;

+ (CGSize)getLabelSize:(UILabel *)label;
+ (CGFloat)getLabelWidth:(UILabel *)label;
+ (CGFloat)getLabelHeight:(UILabel *)label;
+ (CGSize)getStringSize:(NSString *)text strMaxWidth:(CGFloat )width fontSize:(UIFont *)fontSize;

+ (BOOL)validateEmail:(NSString*)emailStr;
+ (BOOL)validateQQ:(NSString *)QQNumber;
+ (BOOL)validatePhoneNumber:(NSString*)phoneNumStr;

+ (NSString *)timestampToNow:(NSInteger)secondsSince1970;
+ (NSString *)stringForAgoFromDate:(NSDate *)fdate toDate:(NSDate *)tdate;
+ (NSDateFormatter *)agoFormatter;

+ (void)dwMakeCircleOnView:(UIView *)tView;
+ (void)dwMakeTopRoundCornerWithRadius:(CGFloat)radius onLayer:(CALayer *)tLayer;
+ (void)setMaskWithUIBezierPath:(UIBezierPath *)bezierPath onView:(UIView *)tView;
+ (void)drawLineOnView:(UIView *)superView
             lineWidth:(CGFloat )width
          strokeColor :(UIColor *)color
            startPoint:(CGPoint )sPoint
              endPoint:(CGPoint )ePoint;


+ (UIImage*) createImageWithColor:(UIColor*) color
                             size:(CGSize)size;




@end
