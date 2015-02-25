//
//  NewsListViewController.m
//  piece
//
//  Created by ハマモト  on 2014/09/22.
//  Copyright (c) 2014年 ハマモト . All rights reserved.
//

#import "InfoListViewController.h"

@interface InfoListViewController ()

@end

@implementation InfoListViewController

- (void)loadView {
    [[NSBundle mainBundle] loadNibNamed:@"InfoListViewController" owner:self options:nil];
}

- (void)viewDidAppearLogic
{
    if ([PieceCoreConfig tabnumberInfo]) {
        [[self.tabBarController.tabBar.items objectAtIndex:[PieceCoreConfig tabnumberInfo].intValue]setBadgeValue:nil];
    }
    
    self.isResponse = NO;
    [self syncAction];
    [self.allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.fliyerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"CreateCell%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        InfoListData *model = [self.fillterList objectAtIndex:indexPath.row];
        
        
        NSString *imgName = @"";
        if ([model.type isEqualToString:@"1"]) {
            imgName = @"news_02.jpg";
        } else if ([model.type isEqualToString:@"2"]){
            imgName = @"news_03.jpg";
        } else if ([model.type isEqualToString:@"3"]){
            imgName = @"news_01.jpg";
        }
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        iv.frame = CGRectMake(10, 20, 50, 50);
        [cell.contentView addSubview:iv];
        
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(80,10,200,80)];
        textLbl.text = model.title;
        textLbl.font = [UIFont fontWithName:@"AppleGothic" size:15];
        textLbl.alpha = 1.0f;
        textLbl.backgroundColor = [UIColor clearColor];
        textLbl.numberOfLines = 4;
        [cell.contentView addSubview:textLbl];
        //}
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
            UIImageView *reloadView = [[UIImageView alloc] init];
            reloadView.frame = CGRectMake(80,15, 32, 32);
            reloadView.image = [UIImage imageNamed:@"undo.png"];
            [cell.contentView addSubview:reloadView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125,20,100,25)];
            label.text = @"次を検索する";
            label.font = [UIFont fontWithName:@"AppleGothic" size:16];
            label.alpha = 1.0f;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
        }
        return cell;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.0f;
    } else {
        return 60.0f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.fillterList.count;
    } else {
        return 0;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"to_fliyer"]) {
        FlyerViewController *vcntl = [segue destinationViewController];
        vcntl.fliyerId = self.infoId;
    } else if([[segue identifier] isEqualToString:@"to_news"]){
        NewsViewController *controller = [segue destinationViewController];
        controller.news_id = self.infoId;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        InfoListData *model = [self.fillterList objectAtIndex:indexPath.row];
        
        if ([model.type isEqualToString:@"1"]) {
            self.infoId = model.info_id;
            
             NewsViewController *newsVc = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
            newsVc.news_id = self.infoId;
            [self.navigationController pushViewController:newsVc animated:YES];
            return;
            
        } else if([model.type isEqualToString:@"2"]){
            
            if ([PieceCoreConfig tabnumberFlyer]) {
                self.infoId = model.typeId;
                
                FlyerViewController * resultVC;
                UINavigationController* nc =[[self.tabBarController viewControllers] objectAtIndex:[PieceCoreConfig tabnumberFlyer].intValue];
                
                if (nc.viewControllers.count != 0){
                    resultVC = [nc.viewControllers objectAtIndex:0];
                    resultVC.fliyerId = self.infoId;
                }
                
                
                DLog(@"flyerId:%@",model.typeId);
                
                //遷移先へ移動
                [self.tabBarController setSelectedViewController: nc];
                

            }
            
            
        } else if([model.type isEqualToString:@"3"]){
            
            if ([PieceCoreConfig tabnumberCoupon]) {
                self.infoId = model.typeId;
                
                CouponViewController * resultVC;
                UINavigationController* nc =[[self.tabBarController viewControllers] objectAtIndex:[PieceCoreConfig tabnumberCoupon].integerValue];
                
                if (nc.viewControllers.count != 0){
                    
                    resultVC = [nc.viewControllers objectAtIndex:0];
                    resultVC.mode = getCoupon;
                    resultVC.couponId = model.typeId;
                    resultVC.mode = getCoupon;
                }
                
                
                DLog(@"coupnID:%@",model.typeId);
                
                //遷移先へ移動
                [self.tabBarController setSelectedViewController: nc];
            }
        }
        
    } else if(indexPath.section == 1) {
        //self.selectPage ++;
        [self syncAction];
        
    }
    
}

- (IBAction)allAction:(id)sender {
    self.fillterList = self.data.list;
    [self.allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.fliyerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.table reloadData];
}

- (IBAction)newsAction:(id)sender {
    [self.allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fliyerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"type", @"1"];
    self.fillterList = [self.data.list filteredArrayUsingPredicate:predicate];
    [self.table reloadData];
}

- (IBAction)fliyerAction:(id)sender {
    [self.allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.fliyerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"type", @"2"];
    self.fillterList = [self.data.list filteredArrayUsingPredicate:predicate];
    [self.table reloadData];
}

- (IBAction)couponAction:(id)sender {
    [self.allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.fliyerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"type", @"3"];
    self.fillterList = [self.data.list filteredArrayUsingPredicate:predicate];
    [self.table reloadData];
}

-(void)syncAction{
    
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    //SN app_idを追加するため宣言してパラメータを渡す
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [conecter sendActionSendId:SendIdNewsList param:param];
    
}

-(void)setData:(InfoConnector *)data sendId:(NSString *)sendId{
    self.data = data;
    self.fillterList = self.data.list;
    
    //    pieceAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //    if (appDelegate.isFirstStart) {
    //        //最新のチラシを取得
    //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"type", @"2"];
    //        NSArray *fliyerList = [self.data.list filteredArrayUsingPredicate:predicate];
    //        if (fliyerList.count > 0) {
    //            InfoListModel *model = [fliyerList objectAtIndex:0];
    //            //チラシ画面に遷移
    //            self.infoId = model.typeId;
    //            [self performSegueWithIdentifier:@"to_fliyer" sender:self];
    //
    //        }
    //
    //    }
    [self.table reloadData];
}

-(BaseConnector *)getDataWithSendId:(NSString *)sendId{
    return [InfoConnector alloc];
}


@end
