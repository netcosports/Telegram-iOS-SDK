#import <Foundation/Foundation.h>

#import "TLObject.h"
#import "TLMetaRpc.h"

@class TLMessage;
@class TLChat;
@class TLUser;

@interface TLmessages_StatedMessage : NSObject <TLObject>

@property (nonatomic, retain) TLMessage *message;
@property (nonatomic, retain) NSArray<TLChat *> *chats;
@property (nonatomic, retain) NSArray<TLUser *> *users;
@property (nonatomic) int32_t pts;
@property (nonatomic) int32_t seq;

@end

@interface TLmessages_StatedMessage$messages_statedMessage : TLmessages_StatedMessage


@end

@interface TLmessages_StatedMessage$messages_statedMessageLink : TLmessages_StatedMessage

@property (nonatomic, retain) NSArray *links;

@end

