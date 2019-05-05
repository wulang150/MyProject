//
//  TcpClientViewController.m
//  MyProject
//
//  Created by Anker on 2019/1/23.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "TcpClientViewController.h"

#include <sys/stat.h>

#include <fcntl.h>

#include <errno.h>

#include <netdb.h>

#include <sys/types.h>

#include <sys/socket.h>

#include <netinet/in.h>

#include <arpa/inet.h>

#include <stdio.h>

#include <string.h>

#include <stdlib.h>

#include <unistd.h>


#define SERVER_PORT 6667

@interface TcpClientViewController ()

@end

@implementation TcpClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavWithTitle:@"TcpClient" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
}

- (void)connect{
    //客户端只需要一个套接字文件描述符，用于和服务器通信
    printf("start connecting\n");
    int clientSocket;
    //描述服务器的socket
    struct sockaddr_in serverAddr;
    
    if((clientSocket = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        perror("socket");
        return;
        
    }
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(SERVER_PORT);
    //inet_addr()函数，将点分十进制IP转换成网络字节序IP
    serverAddr.sin_addr.s_addr = inet_addr("192.168.50.41");
    
    if(connect(clientSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) < 0)
    {
        
        perror("connect");
        return;
        
    }
    printf("连接到主机...\n");

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self connect];
    SimpleAlertView *alert = [[SimpleAlertView alloc] initAlertView:@"tip" content:@"dfdf" vi:nil btnTilte:nil];
    [alert show];
}

@end
