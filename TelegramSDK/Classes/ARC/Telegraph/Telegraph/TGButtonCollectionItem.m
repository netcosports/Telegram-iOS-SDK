#import "TGButtonCollectionItem.h"

#import "TGButtonCollectionItemView.h"
#import "TGCommon.h"

@implementation TGButtonCollectionItem

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action
{
    self = [super init];
    if (self != nil)
    {
        _title = title;
        _titleColor = TGAccentColor();
        _alignment = NSTextAlignmentLeft;
        _enabled = true;
        
        _leftInset = 15;
        
        _action = action;
    }
    return self;
}

- (Class)itemViewClass
{
    return [TGButtonCollectionItemView class];
}

- (CGSize)itemSizeForContainerSize:(CGSize)containerSize
{
    return CGSizeMake(containerSize.width, 44);
}

- (void)itemSelected:(id)actionTarget
{
    if (_action != NULL && [actionTarget respondsToSelector:_action])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [actionTarget performSelector:_action];
#pragma clang diagnostic pop
    }
}

- (void)bindView:(TGButtonCollectionItemView *)view
{
    [super bindView:view];
    
    [view setTitle:_title];
    [view setTitleColor:_titleColor];
    [view setTitleAlignment:_alignment];
    [view setEnabled:_enabled];
    
    view.leftInset = _leftInset;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (self.view != nil)
        [(TGButtonCollectionItemView *)self.view setTitle:title];
}

- (void)setEnabled:(bool)enabled
{
    if (_enabled != enabled)
    {
        _enabled = enabled;
        self.selectable = enabled;
        
        [(TGButtonCollectionItemView *)[self boundView] setEnabled:_enabled];
    }
}

@end