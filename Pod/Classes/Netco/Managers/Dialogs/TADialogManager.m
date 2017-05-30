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
#import "SGraphObjectNode.h"

@interface TADialogManager() <ASWatcher>

@property (nonatomic, copy) LoadDialogsCompletion loadDialogsCompletion;
@property (nonatomic, copy) CreateDialogCompletion createDialogCompletion;

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

- (void)createDialogWithUIDs:(NSArray<NSNumber *> *)UIDs
                        title:(NSString *)title
                   completion:(CreateDialogCompletion)completion
{
    self.createDialogCompletion = completion;

    static int actionId = 0;

    NSDictionary *options = @{
                              @"uids": UIDs,
                              @"title": [title ?: @"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                              };
    [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/conversation/createChat/(%d)", actionId++] options:options watcher:self];
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
        if (status == ASStatusSuccess) {
            self.loadDialogsCompletion(items, nil);
        } else {
            self.loadDialogsCompletion(nil, [NSError new]);
        }
    } else if ([path hasPrefix:@"/tg/conversation/createChat/"]) {

        if (![result isKindOfClass:SGraphObjectNode.class]) {
            return;
        }
        if (!self.createDialogCompletion) {
            return;
        }

        if (status == ASStatusSuccess) {
            TGConversation *dialog = ((SGraphObjectNode *)result).object;
            self.createDialogCompletion(dialog, nil);
        } else {
            self.createDialogCompletion(nil, [NSError new]);
        }

    }
}

@end
