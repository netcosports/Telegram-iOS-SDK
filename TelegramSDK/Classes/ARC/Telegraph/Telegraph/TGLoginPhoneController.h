/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGViewController.h"

#import "ActionStage.h"
#import "TGLoginCodeController.h"

@interface TGLoginPhoneController : TGViewController <ASWatcher>

@property (nonatomic, weak) id<TGLoginCodeControllerDelegate> loginCodeDelegate;
@property (nonatomic, strong) ASHandle *actionHandle;

- (void)setPhoneNumber:(NSString *)phoneNumber;

@end
