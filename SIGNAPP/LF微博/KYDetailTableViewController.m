//
//  KYDetailTableViewController.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/24.
//  Copyright © 2016年 lf. All rights reserved.
//
#define SIM_CODE [[NSUserDefaults standardUserDefaults] objectForKey:@"Code"]
//#define LAT [[NSUserDefaults standardUserDefaults] objectForKey:@"LAT"]
//#define LNG [[NSUserDefaults standardUserDefaults] objectForKey:@"LNG"]
#define P_NO [[NSUserDefaults standardUserDefaults] objectForKey:@"PNO"]
#import "KYDataViewController.h"
#import "XMLDictionary.h"
#import "CommonTool.h"
#import "KYDetailTableViewController.h"
#import "KYDataViewController.h"
@interface KYDetailTableViewController ()
{
    NSDictionary * _XMLDic;
    NSArray* _XmlArray;
    NSDictionary *_showDic;
}
@property(nonatomic,strong)NSString *btimetext;
@property(nonatomic,strong)NSString *etimetext;
@property(nonatomic,strong)NSString *lattext;
@property(nonatomic,strong)NSString *lngtext;
@property(nonatomic,strong)NSString *phonetext;
@property(nonatomic,strong)NSString *pnotext;
@end

@implementation KYDetailTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签到记录";
    self.tableView.rowHeight = 50;
    
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:1 target:self action:@selector(backCLick)];
    self.navigationItem.leftBarButtonItem=leftbtn;
}
-(void)backCLick{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self request];
}

- (void)request{
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string=[NSString stringWithFormat:@"<Data><Action>QUERY</Action><SIM>%@</SIM><LNG>%@</LNG><LAT>%@</LAT><BDATE>%@</BDATE><EDATE>%@</EDATE><PNO>%@</PNO></Data>",_phonetext,_lngtext,_lattext,_btimetext,_etimetext,_pnotext];
    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"%@%@",HTTPIP,SIGN_URL] withString:string];
    manger.backSuccess=^void(NSDictionary *dictt){
        if ((NSObject*)[dictt objectForKey:@"ERROR"]==[NSNull null]) {
            _XMLDic=[NSDictionary dictionaryWithXMLString:dictt[@"XML"]];
            _XmlArray=_XMLDic[@"R"];
            
            
            if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
                _XmlArray=_XMLDic[@"R"];
                
            }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
                _showDic=_XMLDic[@"R"];
            }
            
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"ERROR"]];
            NSLog(@"---%@",ERROR);
            return;
        }
    };
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
        return _XmlArray.count;
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    
    if ([_XMLDic[@"R"] isKindOfClass:[NSArray class]]) {
        
        //         cell.textLabel.text=[NSString stringWithFormat:@" %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"FDATETIME"]]];
        //         cell.detailTextLabel.text=[NSString stringWithFormat:@" %@",  [CommonTool cleanNULL:_XmlArray[indexPath.row][@"FREMARK"]]];
        NSString *str = [CommonTool cleanNULL:_XmlArray[indexPath.row][@"FDATETIME"]];
        
        NSLog(@"%@----12345",str);
        NSString *str1= [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSLog(@"%@----67890",str1);
        NSString *str2 = [str1 substringToIndex:19];
        cell.textLabel.text =[NSString stringWithFormat:@"%@",str2];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[CommonTool cleanNULL:_XmlArray[indexPath.row][@"FREMARK"]]];
        
    }else if ([_XMLDic[@"R"] isKindOfClass:[NSDictionary class]]){
        
        
        //         cell.textLabel.text=[NSString stringWithFormat:@"%@",[CommonTool cleanNULL:_XMLDic[@"R"][@"FDATETIME"]]];
        //        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[CommonTool cleanNULL:_XMLDic[@"R"][@"FREMARK"]]];
        
        NSString *str = [NSString stringWithFormat:@"%@",[CommonTool cleanNULL:_XMLDic[@"R"][@"FDATETIME"]]];
        
        NSLog(@"%@----12345",str);
        NSString *str1= [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSLog(@"%@----67890",str1);
        NSString *str2 = [str1 substringToIndex:19];
        cell.textLabel.text =[NSString stringWithFormat:@"%@",str2];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[CommonTool cleanNULL:_XMLDic[@"R"][@"FREMARK"]]];
    }
    
    
    return cell;
    
}

@end
