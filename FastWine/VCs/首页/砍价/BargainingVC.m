//
//  BargainingVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainingVC.h"
#import "BargainingCell.h"
#import "BargainDetalisVC.h"
@interface BargainingVC ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

@implementation BargainingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"砍价免费拿";
    self.ibTableView.rowHeight = 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BargainingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BargainingCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BargainingCell" owner:nil options:nil][0];
    }
 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BargainDetalisVC *vc = [[BargainDetalisVC alloc]initWithNibName:@"BargainDetalisVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
