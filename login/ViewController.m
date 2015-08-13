//
//  ViewController.m
//  login
//
//  Created by 肖准 on 15/8/13.
//  Copyright (c) 2015年 肖准. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property(nonatomic,strong) UIActivityIndicatorView* act;
@property CGSize size;
@end

@implementation ViewController

//login登陆
- (IBAction)login:(id)sender {
    
    [self loginpost:self.user.text pwd:self.password.text];
    
}

//点击背景隐藏键盘
- (IBAction)back:(id)sender {
    [self.password resignFirstResponder];
    [self.user resignFirstResponder];

}

//点击return 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return  YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user.delegate =self;
    self.password.delegate =self;
    self.size = self.view.frame.size;
    
    //初始化活动指示器
//    
//    self.act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.size.width/2-50, self.size.height/3, 100, 50)];
//    self.act.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    //设置活动指示器的颜色
    self.act.color=[UIColor redColor];
    //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
    self.act.hidesWhenStopped=NO;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)loginpost:(NSString*)user pwd:(NSString*)password{
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
//    [self.act startAnimating];
//    [self.view addSubview:self.act];
    
    NSURL* host = [NSURL URLWithString:@"http://127.0.0.1:3000/login?"];
    NSString* path = [[NSString alloc]initWithFormat:@"user=%@&password=%@",user,password];
    NSData* pathdata = [path dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:host cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:pathdata];
    NSError* e=nil;
    
    NSData* recivedata = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&e];
    if(e){
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(connectfailed:) userInfo:[e localizedDescription] repeats:NO];
         
        
        return;
    }
    
    
    if(recivedata){
      
        
        NSError* er = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:recivedata options:NSJSONReadingAllowFragments error:&er];
        if(!er){
            NSString* rescode = [dict valueForKey:@"resultcode"];
            if([rescode isEqualToString:@"true"]){
                [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logined) userInfo:nil repeats:NO];
            }else{
                [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(loginedfailed) userInfo:nil repeats:NO];
                
                
            }
            
        }
    
    }
    
    
    
}

//链接失败
-(void)connectfailed:(NSTimer*)timer{
    [GMDCircleLoader hideFromView:self.view animated:YES];
//    [self.act stopAnimating];
//    [self.act removeFromSuperview];
    NSLog(@"conenctd failed");
    UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"错误" message:[timer userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alter show];
}
//登陆成功
-(void)logined{
    [GMDCircleLoader hideFromView:self.view animated:YES];
//    [self.act stopAnimating];
//    [self.act removeFromSuperview];
    NSLog(@"login success!");
    [self performSegueWithIdentifier:@"showdetail" sender:self];
}

//用户名或密码错误
-(void)loginedfailed{
    [GMDCircleLoader hideFromView:self.view animated:YES];
//    [self.act stopAnimating];
//    [self.act removeFromSuperview];
     NSLog(@"login failed!");
    UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
