//
//  upnpSetTableViewCell.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/6/20.
//
//

#import "upnpSetTableViewCell.h"

@implementation upnpSetTableViewCell


// Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numBerBtn.layer.cornerRadius=40/2;
    self.numBerBtn.layer.masksToBounds=YES;
    
}


- (IBAction)mySider:(UISlider *)sender {
}

- (void)setDevice:(CGUpnpDevice *)upnpDevice{
    self.TitleLab.text =[upnpDevice friendlyName];
    
    
    
    NSLog(@"self==Tible====%@",[upnpDevice friendlyName]);
    UIImage *iconImage = nil;
    CGUpnpIcon *smallestIcon = [upnpDevice smallestIconWithMimeType:@"image/png"];
    if (smallestIcon == nil)
        smallestIcon = [upnpDevice smallestIconWithMimeType:@"image/jpeg"];
    if (smallestIcon != nil) {
        NSString *iconUrl = [upnpDevice absoluteIconUrl:smallestIcon];
        //NSLog(@"iconUrl = %@", iconUrl);
        if (0 < [iconUrl length])
            iconImage = [self getIconImage:iconUrl];
    }
        if (iconImage == nil)
        iconImage = [UIImage imageNamed:@"icon_device.png"];
    self.iconImgView.image=iconImage;
      //[self.iconImgView setImage:iconImage];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
   // [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];







}
- (UIImage *)getIconImage:(NSString *)iconUrl
{
    //NSLog(@"getIconImage = %@" , iconUrl);
    NSURL *url = [NSURL URLWithString:iconUrl];
    if (url == nil)
        return nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (url == nil)
        return nil;
    UIImage *iconImage = [[UIImage alloc] initWithData:data];
//    if (iconImage != nil)
//        [iconImage autorelease];
    return iconImage;
}

@end
