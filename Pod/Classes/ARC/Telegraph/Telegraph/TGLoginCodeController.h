/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGViewController.h"

#import "ActionStage.h"

#import "TGNavigationController.h"

@class TGLoginCodeController;

@protocol TGLoginCodeControllerDelegate <NSObject>

- (void)loginCodeController:(TGLoginCodeController *)loginCodeController didLoginWithObject:(id)object;

@end

@interface TGLoginCodeController : TGViewController <ASWatcher, TGNavigationControllerItem>

@property (nonatomic, strong) ASHandle *actionHandle;
@property (nonatomic, weak) id<TGLoginCodeControllerDelegate> delegate;

- (id)initWithShowKeyboard:(bool)showKeyboard phoneNumber:(NSString *)phoneNumber phoneCodeHash:(NSString *)phoneCodeHash phoneTimeout:(NSTimeInterval)phoneTimeout messageSentToTelegram:(bool)messageSentToTelegram;

- (void)applyCode:(NSString *)code;

@end
