//
//  AboutUsVC.m
//  QuPassenger
//
//  Created by 朱青 on 2017/11/1.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "AboutUsVC.h"

#define ServicePhone @"4001399169"

@interface AboutUsVC ()

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibContentLab;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //偏移问题
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.backgroundColor = NavColor;
    self.navigationItem.title = @"关于我们";
    
    [self.view setBackgroundColor:HEXCOLOR(@"f6f6f6")];
    
//    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"客户服务："];
//    NSAttributedString *tempAttributeString1 = [[NSAttributedString alloc] initWithString:ServicePhone attributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"FF5C41")}];
//    [attributeString1 appendAttributedString:tempAttributeString1];
//    [self.serviceLabel setAttributedText:attributeString1];
//    UITapGestureRecognizer *phoneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
//    [self.serviceLabel addGestureRecognizer:phoneTapGestureRecognizer];
//
//    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:@"商务合作："];
//    NSAttributedString *tempAttributeString2 = [[NSAttributedString alloc] initWithString:@"market@qyueche.com" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"FF5C41")}];
//    [attributeString2 appendAttributedString:tempAttributeString2];
//    [self.businessLabel setAttributedText:attributeString2];
//
//    NSMutableAttributedString *attributeString3 = [[NSMutableAttributedString alloc] initWithString:@"服务支持："];
//    NSAttributedString *tempAttributeString3 = [[NSAttributedString alloc] initWithString:@"support@qyueche.com" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(@"FF5C41")}];
//    [attributeString3 appendAttributedString:tempAttributeString3];
//    [self.supportLabel setAttributedText:attributeString3];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version%@",CLIENT_VERSION]];
    BaseRequest *req = [BaseRequest new];
    req.id = @"2";//1:用户协议2:关于我们3:隐私政策
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[responseObject[@"data"][@"content"][@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.ibContentLab.attributedText = attrStr;
        
    } withError:^(NSError *error) {
        
    }];
}

#pragma mark UITapGestureRecognizer
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer
{
    [PublicManager makePhoneCallWithPhoneNumber:ServicePhone];
}
- (IBAction)ibXieyiBtnClick:(id)sender {
    BaseRequest *req = [BaseRequest new];
    req.id = @"1";//1:用户协议2:关于我们3:隐私政策
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.content = responseObject[@"data"][@"content"][@"content"];
        vc.titleStr = responseObject[@"data"][@"content"][@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}
- (IBAction)ibYinsi:(id)sender {
    BaseRequest *req = [BaseRequest new];
    req.id = @"3";//1:用户协议2:关于我们3:隐私政策
    [[HTTPRequest sharedManager]requestDataWithApiName:article withParameters:req isEnable:YES withSuccess:^(id responseObject) {
        BaseWKWebController *vc = [[BaseWKWebController alloc]init];
        vc.content = responseObject[@"data"][@"content"][@"content"];
        vc.titleStr = responseObject[@"data"][@"content"][@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } withError:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
