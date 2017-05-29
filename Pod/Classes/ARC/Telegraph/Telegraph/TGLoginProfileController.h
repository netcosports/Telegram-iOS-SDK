/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGViewController.h"

#import "ActionStage.h"

@class TGLoginProfileController;

@protocol TGLoginProfileControllerDelegate <NSObject>

- (void)loginProfileController:(TGLoginProfileController *)loginProfileController didLoginWithObject:(id)object;

@end

@interface TGLoginProfileController : TGViewController <ASWatcher>

@property (nonatomic, strong) ASHandle *actionHandle;
@property (nonatomic, weak) id<TGLoginProfileControllerDelegate> delegate;

- (id)initWithShowKeyboard:(bool)showKeyboard phoneNumber:(NSString *)phoneNumber phoneCodeHash:(NSString *)phoneCodeHash phoneCode:(NSString *)phoneCode;

@end
