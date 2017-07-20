//
//  WebViewViewController.h
//  WorkPlan-IOS
//
//  Created by E-Bans on 15/10/29.
//  Copyright © 2015年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController<UIDocumentInteractionControllerDelegate>
{
    IBOutlet UIWebView *webView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (id)initWithUrl:(NSString *)webUrl type:(NSString *)aType;
@end
