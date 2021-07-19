//
//  Tasks.h
//  Todo
//
//  Created by MACOS on 4/6/21.
//  Copyright © 2021 MACOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSObject<NSCoding>
@property NSString *name;
@property NSString *desc;
@property NSInteger pri;
@property NSInteger status;
@property NSString *dateOfCreation;
@property NSString *reminderDate;
@property NSString *file;


-(id)initWithValues:(NSString*)name : (NSString*)description : (NSInteger) pri : (NSInteger) stat: (NSString*) reminderDate ;

@end

NS_ASSUME_NONNULL_END
