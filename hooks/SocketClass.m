//
//  SocketClass.m
//  actionlisten
//
//  Created by 梁伟 on 13-12-2.
//
//

#import "SocketClass.h"


#define PREFERENCE_PATH @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.socket.plist"


@implementation SocketClass



-(void)SendSocket:(NSString *)string_send
{
    if([string_send length]>1024){
        return;
    }
//    NSString *processName = [[NSProcessInfo processInfo] processName];
  
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    
//    NSString *isListening = [prefDic objectForKey:@"isListening"];
//    NSLog(@"lw: islistening %@",isListening);
//    if (TRUE)
//    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *IPaddress = [prefDic objectForKey:@"ServerIP"];
            NSString *IPport = [prefDic objectForKey:@"ServerPort"];
//            NSString *IPaddress = @"192.168.3.209";
//            NSString *IPport = @"9001";
//            NSLog(@"IPaddress is qwe %@,%@",IPaddress,string_send);
//            const char *sendmsg = [string_send cStringUsingEncoding:NSUTF8StringEncoding];
//            const char *sendmsg = [string_send cStringUsingEncoding:NSASCIIStringEncoding];
//            NSLog(@"yujianbo NSString:%@",string_send);
            const char *sendmsg = [string_send UTF8String];
//            NSLog(@"yujianbo char  * :%s",sendmsg);
            int sockfd;
            struct sockaddr_in des_addr;
            
            
            sockfd = socket(AF_INET, SOCK_STREAM, 0);//创建socket
                if (sockfd < 0)
                {
                perror("socket error");
                return ;
                }
            
            /* 设置连接目的地址 */
            des_addr.sin_family = AF_INET;
            des_addr.sin_port = htons([IPport intValue]);
            des_addr.sin_addr.s_addr = inet_addr([IPaddress UTF8String]);
            bzero(&(des_addr.sin_zero), 8);
            
            /* 发送连接请求 */
            if (connect(sockfd, (struct sockaddr *)&des_addr, sizeof(struct sockaddr)) < 0)
            {
                NSLog(@"[yujianbo] socket connect failed");
                perror("connect failed");
                return ;
            }
//            NSLog(@"[yujianbo] socket connect sucess");
            if (send(sockfd, sendmsg, strlen(sendmsg) + 1, 0) < 0)
            {//发送信息
                NSLog(@"[yujianbo] socket send  failed");
                printf("send msg failed!");
                return ;
            }
            
        close(sockfd);
            
        });
    }
     
//}

 
@end

