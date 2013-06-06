//
//  SOCViewController.h
//  SocketIOChat
//
//  Created by Atsushi Nagase on 6/6/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>

@interface SOCViewController : UITableViewController<UISearchBarDelegate, SocketIODelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) SocketIO *socketIO;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
