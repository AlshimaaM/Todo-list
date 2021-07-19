//
//  myProtocol.h
//  Todo
//
//  Created by MACOS on 4/6/21.
//  Copyright © 2021 MACOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tasks.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myProtocol <NSObject>
-(void)addTasks: (Tasks*) task;
-(void)updateTask: (Tasks*) oldTask : (Tasks*) newTask;


@end

NS_ASSUME_NONNULL_END
