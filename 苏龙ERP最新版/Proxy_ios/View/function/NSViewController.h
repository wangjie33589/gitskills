//
//  NSViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "DirectoryWatcher.h"

@interface NSViewController : UIViewController<QLPreviewControllerDataSource,
QLPreviewControllerDelegate,DirectoryWatcherDelegate,
UIDocumentInteractionControllerDelegate>
{
    IBOutlet UILabel *nsTitle;
    IBOutlet UILabel *time;
    IBOutlet UILabel *name;
    IBOutlet UILabel *contens;
    UIDocumentInteractionController *docInteractionController;
      DirectoryWatcher *docWatcher;
}
@property (nonatomic, retain) DirectoryWatcher *docWatcher;
- (id)initWithUrl:(NSString *)aUrl WithTitleStr:(NSString*)title_Str;
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@end
