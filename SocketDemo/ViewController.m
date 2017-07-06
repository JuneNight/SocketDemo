//
//  ViewController.m
//  SocketDemo
//
//  Created by 张涛 on 17/5/12.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@property (nonatomic, assign) int clientSocket;
@property (weak, nonatomic) IBOutlet UILabel *recvCoLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *sendContTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startConnect:(id)sender {
    if ([self.ipTextField.text isEqualToString:@""]) {
        return;
    }
    if ([self.portTF.text isEqualToString:@""]) {
        return;
    }
    if ([self connection:self.ipTextField.text port:self.portTF.text.intValue]) {
        self.recvCoLabel.text = @"连接成功";
    }else{
        self.recvCoLabel.text = @"连接失败";
    }
}
- (IBAction)sendMsg:(id)sender {
    if ([self.sendContTF.text isEqualToString:@""]) {
        return;
    }
    self.recvCoLabel.text = [self sendAndRecv:self.sendContTF.text];
}


- (BOOL)connection:(NSString *)hostText port:(int)port{
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (self.clientSocket > 0) {
        NSLog(@"socket success create %d",self.clientSocket);
    }else{
        NSLog(@"socket create failed");
    }
    
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(hostText.UTF8String);
    serverAddress.sin_port = htons(port);
    int result = connect(self.clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    return result == 0;
}

- (NSString *)sendAndRecv:(NSString *)msg{
    size_t sendLen = send(self.clientSocket, msg.UTF8String, strlen(msg.UTF8String), 0);
    NSLog(@"%ld",sendLen);
    uint8_t buffer[1024];
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

- (void)disConnect{
    close(self.clientSocket);
}

@end
