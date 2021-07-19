//
//  AddViewController.m
//  Todo
//
//  Created by MACOS on 4/5/21.
//  Copyright © 2021 MACOS. All rights reserved.
//

#import "AddViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *Describtion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priortySe;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSUserDefaults *userDefaults;
@property NSMutableArray *currentData;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _currentData = [NSMutableArray new];
    
}
- (IBAction)openFile:(id)sender {
    
    UIDocumentMenuViewController *importMenu =
    [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                         inMode:UIDocumentPickerModeImport];

    importMenu.delegate = self;
    [self presentViewController:importMenu animated:YES completion:nil];
    [importMenu addOptionWithTitle:@"Photos" image:nil order:UIDocumentMenuOrderFirst handler:^{

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];

    }
    -(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker

    {
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}


- (IBAction)addBtn:(id)sender {
    Tasks *task=[Tasks new];
    task.name=_nameTF.text;
    task.desc=_Describtion.text;

    task.pri=(int)_priortySe.selectedSegmentIndex;
    task.reminderDate=[self formatDate:_datePicker.date];
    task.status=2;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    task.dateOfCreation=[dateFormatter stringFromDate:[NSDate date]];


    if([_userDefaults objectForKey:@"data"]!=nil){

        NSData *encodedObject = [_userDefaults objectForKey:@"data"];
        NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        _currentData=object;
        [_currentData addObject:task];

        encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_currentData];
        [_userDefaults setObject:encodedObject forKey:@"data"];
        [_userDefaults synchronize];
    }else{
        [_currentData addObject:task];
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_currentData];
        [_userDefaults setObject:encodedObject forKey:@"data"];
        [_userDefaults synchronize];
    }
    [self showNotification];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) showNotification
{
    if(_isGranted){
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:[_datePicker date]];

        content.title = @"Reminder for Your Todo";
        content.subtitle = _nameTF.text;
        content.body = _Describtion.text;
        content.badge = [NSNumber numberWithInteger:([UIApplication sharedApplication].applicationIconBadgeNumber + 1)];

        content.sound = [UNNotificationSound defaultSound];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_nameTF.text content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }

}



- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


@end
