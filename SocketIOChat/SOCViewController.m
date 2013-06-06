//
//  SOCViewController.m
//  SocketIOChat
//
//  Created by Atsushi Nagase on 6/6/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "SOCViewController.h"
#import <socket.IO/SocketIOPacket.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SOCViewController ()

@end

@implementation SOCViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.socketIO = [[SocketIO alloc] initWithDelegate:self];
  [self.socketIO connectToHost:@"pacific-hamlet-5564.herokuapp.com" onPort:80];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.searchBar becomeFirstResponder];
}

#pragma mark - Private

- (void)appendMessage:(NSDictionary *)message {
  if(!self.messages)
    self.messages = [NSMutableArray array];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.messages insertObject:message atIndex:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
  [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  NSDictionary *dict = self.messages[indexPath.row];
  [cell.textLabel setText:dict[@"msg"]];
  [cell.detailTextLabel setText:dict[@"user"]];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.messages count];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *text = searchBar.text;
  [self.socketIO sendEvent:@"msg" withData:@{ @"msg": text } andAcknowledge:^(id argsData) {

  }];
  [searchBar setText:@""];
}

#pragma mark - SocketIODelegate

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {

}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
  if([[packet args] count] > 0 && [packet args][0][@"msg"]) {
    [self appendMessage:[packet args][0]];
  }
}

- (void) socketIO:(SocketIO *)socket failedToConnectWithError:(NSError *)error {
  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}


@end
