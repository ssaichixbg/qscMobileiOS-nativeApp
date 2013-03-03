//
//  userManagementViewController.m
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "userManagementViewController.h"

@interface userManagementViewController (){
    NSMutableArray *_users;
    zjuXuehaoDataModel *_mainUser;
}

@end

@implementation userManagementViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView dropShadows];
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;

}
- (void)viewWillAppear:(BOOL)animated{
    if (!_users) _users = [NSMutableArray arrayWithArray:[[[zjuXuehaoController alloc] init] showAllUsers]];
    if (!_mainUser) _mainUser = [[[zjuXuehaoController alloc] init] getMainUser];
}
- (void)viewWillDisappear:(BOOL)animated{
    _users = nil;
    _mainUser = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_users count];
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}
- (PrettyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrettyTableViewCell *cell = nil;
    NSString *CellIdentifier;
    switch(indexPath.section){
        case 1:
            CellIdentifier = @"add";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            break;
        case 0:
            CellIdentifier = @"user";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            zjuXuehaoDataModel *userModel = [[zjuXuehaoDataModel alloc] initWithLocalJson:[_users objectAtIndex:indexPath.row]];
            
            UILabel *lblName = (UILabel *)[cell viewWithTag:0];
            lblName.text = userModel.real_name;
            UILabel *lblStuid = (UILabel *)[cell viewWithTag:1];
            lblStuid.text = userModel.stuid;
            if ([_mainUser.stuid isEqualToString:userModel.stuid]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];

            }
            break;
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
    return cell;
}
//section title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if ([_users count] > 1) {
                return @"请选择用户";
            }
            else if([_users count] == 1){
                return @"当前用户";
            }
            else{
                return nil;
            }
            break;
        default:
            return nil;
            break;
    }

}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if ([_users count] == 0) {
            return @"没有可用用户，请点击“添加新用户”。";
        }
        return @"横向滑动列表来删除用户";
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lblTitle = nil;
        return lblTitle;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([_users count] == 1) {
            XYShowAlert(MSG_LAST_USER);
            return;
        }
        if ([[[zjuXuehaoController alloc] init] deleteUser:[[zjuXuehaoDataModel alloc] initWithLocalJson:[_users objectAtIndex:indexPath.row]]]){
            [_users removeObjectAtIndex:indexPath.row];
            _mainUser = [[[zjuXuehaoController alloc] init] getMainUser];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    //send current view
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UILabel *lblStuid = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            lblStuid = (UILabel *)[cell viewWithTag:1];
            if (![_mainUser.stuid isEqualToString:lblStuid.text]) {
                zjuXuehaoDataModel *newMainUser = [[zjuXuehaoDataModel alloc] initWithLocalJson: [_users objectAtIndex:indexPath.row]];
                [[[zjuXuehaoController alloc] init] setMainUser:newMainUser];
                _mainUser = newMainUser;
                [self fresh];
            }
            break;
        case 1:
            //[self performSegueWithIdentifier:@"login" sender:self];
            return;
        default:
            break;
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}

- (IBAction)editAciton:(id)sender {
    
}

-(void)fresh{
    _mainUser = nil;
    _mainUser = [[[zjuXuehaoController alloc] init] getMainUser];
    _users = nil;
    _users = [NSMutableArray arrayWithArray:[[[zjuXuehaoController alloc] init] showAllUsers]];
    [[self tableView] reloadData];
}
@end
