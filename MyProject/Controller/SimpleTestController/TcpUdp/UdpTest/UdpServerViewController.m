//
//  UdpServerViewController.m
//  MyProject
//
//  Created by Anker on 2019/1/16.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "UdpServerViewController.h"
#include<stdlib.h>
#include<string.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<netdb.h>
#include<errno.h>
#include<sys/types.h>
#include<fcntl.h>//for open
#include<unistd.h> //for close

int port=8888;
@interface UdpServerViewController ()

@end

@implementation UdpServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];

}

- (void)setupUI{
    [self setNavWithTitle:@"udpServer" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setupData];
    });
}
- (void)setupData{
    int sockfd;
    int len;
    int z;
    char buf[256];
    struct sockaddr_in adr_inet;
    struct sockaddr_in adr_clnt;
    printf("waiting for client...\n");
    sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(sockfd==-1){
        perror("socket error_1");
        exit(1);
    }
    printf("start bind..\n");
    adr_inet.sin_family=AF_INET;
    adr_inet.sin_port=htons(port);
    adr_inet.sin_addr.s_addr=htonl(INADDR_ANY);
    printf("bind para ok\n");
    bzero(&(adr_inet.sin_zero),8);
    len=sizeof(adr_clnt);
    z=bind(sockfd,(struct sockaddr *)&adr_inet,sizeof(adr_inet));
    if(z==-1){
        perror("bind error_1");
    }else{
        printf("bind ok\n");
    }
    while(1){
        z=recvfrom(sockfd,buf,sizeof(buf),0,(struct sockaddr *)&adr_clnt, &len);
        printf("rx data_len: %d \n", z);
        if(z<0){
            perror("recvfrom error_1");
            exit(1);
        }
        buf[z]=0;
        printf("接收：%s\n",buf);
        if(strncmp(buf,"stop",4)==0){
            printf("结束....\n");
            break;
        }
    }
    close(sockfd);

}

@end
