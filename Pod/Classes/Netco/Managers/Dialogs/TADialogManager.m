//
//  TADialogManager.m
//  ASO_iOS
//
//  Created by Sergey Dikovitsky on 5/29/17.
//  Copyright © 2017 netcosports. All rights reserved.
//

#import "TADialogManager.h"
#import "TGTelegraph.h"
#import "SGraphListNode.h"

@interface TADialogManager() <ASWatcher>

@property (nonatomic, copy) LoadDialogsCompletion loadDialogsCompletion;

@end

@implementation TADialogManager

@synthesize actionHandle = _actionHandle;

- (instancetype)init
{
    if (self = [super init]) {
        _actionHandle = [[ASHandle alloc] initWithDelegate:self releaseOnMainThread:false];
    }
    return self;
}

- (void)loadDialogsWithCompletion:(LoadDialogsCompletion)completion
{
    self.loadDialogsCompletion = completion;

    [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/dialoglist/(%d)", INT_MAX] options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100], @"limit", [NSNumber numberWithInt:INT_MAX], @"date", @[], @"excludeConversationIds", nil] watcher:self];
}

#pragma mark - ASWatcher

- (void)actorCompleted:(int)status path:(NSString *)path result:(id)result
{
    if ([path hasPrefix:@"/tg/dialoglist"]) {
        if (![result isKindOfClass:SGraphListNode.class]) {
            return;
        }
        if (!self.loadDialogsCompletion) {
            return;
        }
        NSArray *items = ((SGraphListNode *)result).items;
        if (status == 0) {
            self.loadDialogsCompletion(items, nil);
        } else {
            self.loadDialogsCompletion(nil, [NSError new]);
        }
    }
}

@end
