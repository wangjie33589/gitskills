//
//  RenderList_detilVC.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import <CyberLink/UPnPAV.h>
@class CGUpnpAvController;



@interface RenderList_detilVC : UIViewController<CGUpnpControlPointDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, retain)NSArray* dataSource;
@property (nonatomic, retain)NSMutableArray*ipArray;
@property (nonatomic, retain)NSMutableArray*DeviceNameArr;
- (id)initWithAvController:(CGUpnpAvController*)aController;
//@property (nonatomic, retain) NSArray* dataSource;
@property (nonatomic, retain) NSArray* renderers;
@property (nonatomic, retain) CGUpnpAvController* avController;
@property (strong, nonatomic) IBOutlet UIButton *sender;

- (IBAction)btnClick:(UIButton *)sender;

@end
