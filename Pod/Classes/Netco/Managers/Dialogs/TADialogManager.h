//
//  TADialogManager.h
//  ASO_iOS
//
//  Created by Sergey Dikovitsky on 5/29/17.
//  Copyright © 2017 netcosports. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TGConversation;
typedef void (^LoadDialogsCompletion)(NSArray<TGConversation *> *dialogs, NSError *error);

@interface TADialogManager : NSObject

- (void)loadDialogsWithCompletion:(LoadDialogsCompletion)completion;

@end
