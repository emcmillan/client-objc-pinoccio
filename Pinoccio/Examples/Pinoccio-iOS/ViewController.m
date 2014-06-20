//
//  ViewController.m
//  Pinoccio-iOS
//
//  Created by Haifisch on 6/18/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    Pinoccio *pinoccioAPI;
    NSString *token;
    __block id troopDictionary;
}
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    pinoccioAPI = [[Pinoccio alloc] init]; // Initialize library in memory
    
    // Generate token, email and password parameter is REQUIRED
    [pinoccioAPI generateTokenWithEmail:@"dylan@pinocc.io" password:@"Testing123456" withCompletion:^(NSString *generatedToken, BOOL isOK){
        if (isOK){
            token = generatedToken;
        }else {
            NSLog(@"Username and password is incorrect!");
        }
    }];
    
    [self initialDataCollection];
    
}
-(void)initialDataCollection {
    // Troop for account, token parameter is REQUIRED
    [pinoccioAPI troopWithToken:token withCompletion:^(id temporaryDictionary, BOOL isOK){
        if (isOK) {
            troopDictionary = temporaryDictionary;
        }else if (troopDictionary[@"error"]){
            NSLog(@"Error: %@", temporaryDictionary[@"error"][@"message"]);
        }else {
            NSLog(@"Connection Error: %@", temporaryDictionary);
        }
        [self.tableView reloadData];
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!troopDictionary) { // check if troop dictionary is empty, if it is, return 0.
        return 0;
    }else {
        return [troopDictionary[@"data"] count]; // the dictionary contains a key "data" with an array of dictionaries, but how many arrays are there in "data"?
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TroopCell"];
    cell.textLabel.text = troopDictionary[@"data"][indexPath.row][@"name"]; // Get name: "data" -> indexPath.row integer -> object for key "name"
    
    UIView *online = [[UIView alloc] initWithFrame:CGRectMake(290, 13, 20, 20)];
    if ([troopDictionary[@"data"][indexPath.row][@"online"] boolValue]) {
        online.backgroundColor = [UIColor greenColor];
    }else {
        online.backgroundColor = [UIColor redColor];
    }
    online.layer.cornerRadius = 20/2;
    online.layer.masksToBounds = YES;
    [cell addSubview:online];

    return cell;
}
@end
