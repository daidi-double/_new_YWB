//
//  VoiceChatViewController.m
//  YuWa
//
//  Created by double on 17/7/6.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "VoiceChatViewController.h"

@interface VoiceChatViewController ()<EMCallManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_session;
    AVCaptureVideoDataOutput *_captureOutput;
    AVCaptureDeviceInput *_captureInput;
}
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UILabel *FriendsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,strong)NSTimer * timer;
@end

@implementation VoiceChatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rejectBtn.hidden = self.isSender;
    self.answerBtn.hidden = self.isSender;
    self.hangupBtn.hidden = !self.isSender;
    
}
#pragma mark - Camera


- (void)viewDidLoad {
    [super viewDidLoad];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    self.FriendsNameLabel.text = self.friendsNiceName;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.friendsIcon]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (self.type == 1) {
        if (self.callSession.type == EMCallTypeVideo) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
        if (self.callSession == nil) {
            
            [[EMClient sharedClient].callManager startVideoCall:self.friendsName completion:^(EMCallSession *aCallSession, EMError *aError) {
                if (!aError) {
                    _callSession = aCallSession;
                    [self createUI];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }];
        }else{
            [[EMClient sharedClient].callManager startVideoCall:self.callSession.sessionId completion:^(EMCallSession *aCallSession, EMError *aError) {
                if (!aError) {
                    _callSession = aCallSession;
                    [self createUI];
                }else{
                    if (aError.code == 801) {
                        
                        [self createUI];
                    }else{
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                
            }];
        }
    }else{
        if (self.callSession==nil) {
            [[EMClient sharedClient].callManager startVoiceCall:self.friendsName completion:^(EMCallSession *aCallSession, EMError *aError) {
                
                if (!aError) {
                    _callSession = aCallSession;
                    [self createUI];
                }else{
                    if (aError.code == 801) {
                        
                        [self createUI];
                    }else{
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                
            }];
            
        }else{
            
            [[EMClient sharedClient].callManager startVoiceCall:self.callSession.sessionId completion:^(EMCallSession *aCallSession, EMError *aError) {
                
                if (!aError) {
                    _callSession = aCallSession;
                    [self createUI];
                }else{
                    if (aError.code == 801) {
                        
                        [self createUI];
                    }else{
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                
            }];
        }
    }
    

}

-(void)createUI{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//休眠关闭
    if (self.status == 0) {
        
        [self startCallTimer];
    }
    _statusLabel.text = @"正在呼叫";
    _answerBtn.hidden = NO;
    _hangupBtn.hidden = YES;
    _rejectBtn.hidden = NO;
    
    if (_type == 1) {
        
        //对方窗口
        _callSession.remoteVideoView = [[EMCallRemoteView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _callSession.remoteVideoView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_callSession.remoteVideoView];

        
        //自己窗口
        _callSession.localVideoView = [[EMCallLocalView alloc]initWithFrame:CGRectMake(kScreen_Width-100, 64, 80, 120)];
        [self.view addSubview:_callSession.localVideoView];
        
    }
    [self.view bringSubviewToFront:_answerBtn];
    [self.view bringSubviewToFront:_hangupBtn];
    [self.view bringSubviewToFront:_rejectBtn];
}
/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    MyLog(@" 通话通道完成");
    if ([aSession.remoteUsername isEqualToString:_callSession.remoteUsername]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    self.statusLabel.text = @"正在通话中";
    self.rejectBtn.hidden = YES;
    self.answerBtn.hidden = YES;
    self.hangupBtn.hidden = NO;
}
/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    
    MyLog(@" 同意通话");
    [self _stopCallTimer];
    self.hangupBtn.hidden = NO;
    _statusLabel.text = @"正在通话中";
    
    
}
/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    if (self.status == 0) {
        
        switch (aReason) {
            case EMCallEndReasonHangup:
                [JRToast showWithText:@"通话结束"];
                break;
            case EMCallEndReasonNoResponse:
                [JRToast showWithText:@"对方没有响应"];
                break;
            case EMCallEndReasonDecline:
                [JRToast showWithText:@"对方拒绝接听"];
                break;
            case EMCallEndReasonBusy:
                [JRToast showWithText:@"对方正在通话中"];
                break;
            default:
                [JRToast showWithText:@"对方不在线"];
                break;
        }
    }else{
        switch (aReason) {
            case EMCallEndReasonHangup:
                [JRToast showWithText:@"通话结束"];
                break;
            case EMCallEndReasonNoResponse:
                [JRToast showWithText:@"对方已挂断"];
                break;
            case EMCallEndReasonDecline:
//                [JRToast showWithText:@"对方拒绝接听"];
                break;
            case EMCallEndReasonBusy:
//                [JRToast showWithText:@"对方正在通话中"];
                break;
            default:
//                [JRToast showWithText:@"对方不在线"];
                break;
        }
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [self _stopCallTimer];
    _callSession = nil;
    self.rejectBtn.hidden = NO;
    self.hangupBtn.hidden = NO;
    self.answerBtn.hidden = NO;
    [self clearData];

}
- (void)startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_timeoutBeforeCallAnswered
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"对方暂时无法接听,请稍后再试！", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"好的", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}
- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    if (self.callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.sessionId reason:aReason];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}
//拒绝
- (IBAction)rejectAction:(UIButton *)sender {
    [self _stopCallTimer];
    
    [self hangupCallWithReason:EMCallEndReasonDecline];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//挂断
- (IBAction)hangupAction:(UIButton *)sender {

    if (_callSession) {

        [[EMClient sharedClient].callManager endCall:self.callSession.sessionId reason:EMCallEndReasonHangup];
        _callSession = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

//接听
- (IBAction)answerAction:(UIButton *)sender {

    
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:self.callSession.sessionId];

    if (error) {
        
    [[EMClient sharedClient].callManager endCall:self.callSession.sessionId reason:EMCallEndReasonFailed];
    }else{
        self.rejectBtn.hidden = YES;
        sender.hidden = YES;
    }
}



-(void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//休眠关闭
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.sessionId reason:EMCallEndReasonHangup];
    }else{
        [[EMClient sharedClient].callManager endCall:self.friendsName reason:EMCallEndReasonHangup];
    }

    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;

    
}

- (void)clearData{
    [self dismissViewControllerAnimated:YES completion:nil];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView = nil;
    _callSession = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
