#import "TLMessage.h"

#import "../NSInputStream+TL.h"
#import "../NSOutputStream+TL.h"
#import "TGCommon.h"
#import "TLPeer.h"
#import "TLMessageMedia.h"
#import "TLMessageAction.h"

@implementation TLMessage


- (int32_t)TLconstructorSignature
{
    TGLog(@"constructorSignature is not implemented for base type");
    return 0;
}

- (int32_t)TLconstructorName
{
    TGLog(@"constructorName is not implemented for base type");
    return 0;
}

- (id<TLObject>)TLbuildFromMetaObject:(std::shared_ptr<TLMetaObject>)__unused metaObject
{
    TGLog(@"TLbuildFromMetaObject is not implemented for base type");
    return nil;
}

- (void)TLfillFieldsWithValues:(std::map<int32_t, TLConstructedValue> *)__unused values
{
    TGLog(@"TLfillFieldsWithValues is not implemented for base type");
}


@end

@implementation TLMessage$messageEmpty : TLMessage


- (int32_t)TLconstructorSignature
{
    return (int32_t)0x83e5de54;
}

- (int32_t)TLconstructorName
{
    return (int32_t)0x777e7e3c;
}

- (id<TLObject>)TLbuildFromMetaObject:(std::shared_ptr<TLMetaObject>)metaObject
{
    TLMessage$messageEmpty *object = [[TLMessage$messageEmpty alloc] init];
    object.n_id = metaObject->getInt32((int32_t)0x7a5601fb);
    return object;
}

- (void)TLfillFieldsWithValues:(std::map<int32_t, TLConstructedValue> *)values
{
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.n_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x7a5601fb, value));
    }
}


@end

@implementation TLMessage$message : TLMessage


- (int32_t)TLconstructorSignature
{
    return (int32_t)0x567699b3;
}

- (int32_t)TLconstructorName
{
    return (int32_t)0xc43b7853;
}

- (id<TLObject>)TLbuildFromMetaObject:(std::shared_ptr<TLMetaObject>)metaObject
{
    TLMessage$message *object = [[TLMessage$message alloc] init];
    object.flags = metaObject->getInt32((int32_t)0x81915c23);
    object.n_id = metaObject->getInt32((int32_t)0x7a5601fb);
    object.from_id = metaObject->getInt32((int32_t)0xf39a7861);
    object.to_id = metaObject->getObject((int32_t)0x98822893);
    object.date = metaObject->getInt32((int32_t)0xb76958ba);
    object.message = metaObject->getString((int32_t)0xc43b7853);
    object.media = metaObject->getObject((int32_t)0x598de2e7);
    return object;
}

- (void)TLfillFieldsWithValues:(std::map<int32_t, TLConstructedValue> *)values
{
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.flags;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x81915c23, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.n_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x7a5601fb, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.from_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xf39a7861, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.to_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x98822893, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.date;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xb76958ba, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeString;
        value.nativeObject = self.message;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xc43b7853, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.media;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x598de2e7, value));
    }
}


@end

@implementation TLMessage$messageForwarded : TLMessage


- (int32_t)TLconstructorSignature
{
    return (int32_t)0xa367e716;
}

- (int32_t)TLconstructorName
{
    return (int32_t)0x349f2f8b;
}

- (id<TLObject>)TLbuildFromMetaObject:(std::shared_ptr<TLMetaObject>)metaObject
{
    TLMessage$messageForwarded *object = [[TLMessage$messageForwarded alloc] init];
    object.flags = metaObject->getInt32((int32_t)0x81915c23);
    object.n_id = metaObject->getInt32((int32_t)0x7a5601fb);
    object.fwd_from_id = metaObject->getInt32((int32_t)0x3d97b085);
    object.fwd_date = metaObject->getInt32((int32_t)0xb08aba8b);
    object.from_id = metaObject->getInt32((int32_t)0xf39a7861);
    object.to_id = metaObject->getObject((int32_t)0x98822893);
    object.date = metaObject->getInt32((int32_t)0xb76958ba);
    object.message = metaObject->getString((int32_t)0xc43b7853);
    object.media = metaObject->getObject((int32_t)0x598de2e7);
    return object;
}

- (void)TLfillFieldsWithValues:(std::map<int32_t, TLConstructedValue> *)values
{
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.flags;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x81915c23, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.n_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x7a5601fb, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.fwd_from_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x3d97b085, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.fwd_date;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xb08aba8b, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.from_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xf39a7861, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.to_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x98822893, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.date;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xb76958ba, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeString;
        value.nativeObject = self.message;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xc43b7853, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.media;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x598de2e7, value));
    }
}


@end

@implementation TLMessage$messageService : TLMessage


- (int32_t)TLconstructorSignature
{
    return (int32_t)0x1d86f70e;
}

- (int32_t)TLconstructorName
{
    return (int32_t)0xfa56953c;
}

- (id<TLObject>)TLbuildFromMetaObject:(std::shared_ptr<TLMetaObject>)metaObject
{
    TLMessage$messageService *object = [[TLMessage$messageService alloc] init];
    object.flags = metaObject->getInt32((int32_t)0x81915c23);
    object.n_id = metaObject->getInt32((int32_t)0x7a5601fb);
    object.from_id = metaObject->getInt32((int32_t)0xf39a7861);
    object.to_id = metaObject->getObject((int32_t)0x98822893);
    object.date = metaObject->getInt32((int32_t)0xb76958ba);
    object.action = metaObject->getObject((int32_t)0xc2d4a0f7);
    return object;
}

- (void)TLfillFieldsWithValues:(std::map<int32_t, TLConstructedValue> *)values
{
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.flags;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x81915c23, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.n_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x7a5601fb, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.from_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xf39a7861, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.to_id;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0x98822893, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypePrimitiveInt32;
        value.primitive.int32Value = self.date;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xb76958ba, value));
    }
    {
        TLConstructedValue value;
        value.type = TLConstructedValueTypeObject;
        value.nativeObject = self.action;
        values->insert(std::pair<int32_t, TLConstructedValue>((int32_t)0xc2d4a0f7, value));
    }
}


@end

