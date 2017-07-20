//
//  KYSettingViewController.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/18.
//
//

#import <UIKit/UIKit.h>
#import <CyberLink/UPnPAV.h>
@class ServerContentViewController;
@class CGUpnpAvController;

@interface KYSettingViewController : UIViewController<CGUpnpControlPointDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) ServerContentViewController *detailViewController;
@property (nonatomic, retain) NSArray* dataSource;
@property (nonatomic, retain) NSArray* renderers;
@property (nonatomic, retain) CGUpnpAvController* avController;

@end
