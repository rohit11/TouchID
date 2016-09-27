//
//  ViewController.m
//  TouchIDDemo
//
//  Created by Rohit Nisal on 7/21/16.
//  Copyright © 2016 Rohit Nisal. All rights reserved.
//

#import "ViewController.h"
#import "KTouchIDAuthentication.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[KTouchIDAuthentication sharedInstance] setReason:@"Because i can"];
    [[KTouchIDAuthentication sharedInstance] setFallbackButtonTitle:@"Enter Passcode"];
    [[KTouchIDAuthentication sharedInstance] setUseDefaultFallbackTitle:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString * authErrorString = @"Check your Touch ID Settings.";
    NSError *error;
    if([KTouchIDAuthentication canAuthenticateWithError:&error]){
        
    }else{
        switch (error.code) {
            case KTouchIDAuthenticationErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case KTouchIDAuthenticationErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case KTouchIDAuthenticationErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
    }
    
    NSLog(@"%@",authErrorString);
}

- (IBAction)authenticate:(id)sender {
    [[KTouchIDAuthentication sharedInstance] authenticateBiometricsWithSuccess:^(){
        [self presentAlertControllerWithMessage:@"Successfully Authenticated!"];
    } andFailure:^(long errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case KTouchIDAuthenticationErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case KTouchIDAuthenticationErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case KTouchIDAuthenticationErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
            case KTouchIDAuthenticationErrorUserFallback:
               // authErrorString = @"Fallback auth method should be implemented here.";
                //authErrorString = nil;
                [self authenticateDevicePasscode];
                break;
            case KTouchIDAuthenticationErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case KTouchIDAuthenticationErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case KTouchIDAuthenticationErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        if(authErrorString)
        [self presentAlertControllerWithMessage:authErrorString];
    }];
}

- (IBAction)authenticatePasscode:(id)sender{
    [self authenticateDevicePasscode];
}
-(void)authenticateDevicePasscode {
    [[KTouchIDAuthentication sharedInstance] authenticatePasscodeWithSuccess:^(){
        [self presentAlertControllerWithMessage:@"Successfully Authenticated!"];
    } andFailure:^(long errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case KTouchIDAuthenticationErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case KTouchIDAuthenticationErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case KTouchIDAuthenticationErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
            case KTouchIDAuthenticationErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case KTouchIDAuthenticationErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case KTouchIDAuthenticationErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case KTouchIDAuthenticationErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        [self presentAlertControllerWithMessage:authErrorString];
    }];
}

-(void) presentAlertControllerWithMessage:(NSString *) message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
