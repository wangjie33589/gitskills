//
//  upnpSetTableViewCell.h
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/20.
//
//

#import "UPnPTableViewCell.h"
#import <CyberLink/UPnP.h>
@class CGUpnpDevice;

@interface upnpSetTableViewCell : UPnPTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UIButton *numBerBtn;
@property (strong, nonatomic) IBOutlet UISlider *mySlider;
@property (strong, nonatomic) IBOutlet UIButton *iconBtn;

- (IBAction)mySider:(UISlider *)sender;

- (void)setDevice:(CGUpnpDevice *)upnpDevice;
@end
