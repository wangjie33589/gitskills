//
//  versionVC.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/29.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "versionVC.h"

@interface versionVC ()<UIAlertViewDelegate>{

    NSString *_currentVision;
    NSString *_latestVersion;
    NSDictionary *_xmlDict;



}

@end

@implementation versionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)versionChange:(UIButton *)sender {
    [self APPUpdata];
    
}

-(void)APPUpdata{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ProxyMobile/getiosversion.html",HTTPIP]]];
    NSLog(@"sjdgfjgdsfjfdkga====%@",[NSString stringWithFormat:@"%@/ProxyMobile/getiosversion.html",HTTPIP]);
    NSData *reponse =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSLog(@"rsponce=====%@",reponse);
    _xmlDict =[NSDictionary dictionaryWithXMLData:reponse];
    NSLog(@"xumDATA=%@",_xmlDict);
    
    _latestVersion =_xmlDict[@"versionCode"];
    NSDictionary *infoDict =[[NSBundle mainBundle]infoDictionary];
    NSLog(@"VIESSS=%@",[infoDict objectForKey:@"CFBundleVersion"]);
    _currentVision=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    if ([_currentVision intValue]<[_latestVersion intValue]) {
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:_xmlDict[@"versionName"]  message:_xmlDict[@"versionDescription"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        alert.delegate=self;
        [alert show];
        
        
    }else{
        
        
        UIAlertController *controler =[UIAlertController alertControllerWithTitle:@"提示" message:@"暂无新版本" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controler addAction:action];
        [self presentViewController:controler animated:YES completion:nil];
    
    
    
    
    
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
            
        case 1:{
            
            if ([_xmlDict[@"versionURL"] rangeOfString:FLAG].location!=NSNotFound ) {
                NSString *NEWtitle= [_xmlDict[@"versionURL"] stringByReplacingOccurrencesOfString:FLAG withString:HTTPIP];
                NSString *urlString =[NSString stringWithFormat:@"%@",NEWtitle];
                NSLog(@"sdhjfghjdf====%@",urlString);
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                
                
            }
            else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_xmlDict[@"versionURL"]]];
            }
        }break;
    }
    
}



@end
