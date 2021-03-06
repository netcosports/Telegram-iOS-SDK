#import "TGModernGalleryModel.h"
#import "TGCommon.h"

@implementation TGModernGalleryModel

- (void)_transitionCompleted
{
}

- (void)_replaceItems:(NSArray *)items focusingOnItem:(id<TGModernGalleryItem>)item
{
    TGDispatchOnMainThread(^
    {
        _items = items;
        _focusItem = item;
        
        if (_itemsUpdated)
            _itemsUpdated(item);
    });
}

- (void)_focusOnItem:(id<TGModernGalleryItem>)item
{
    TGDispatchOnMainThread(^
    {
        _focusItem = item;
        
        if (_focusOnItem)
            _focusOnItem(item);
    });
}

- (UIView<TGModernGalleryInterfaceView> *)createInterfaceView
{
    return nil;
}

- (UIView<TGModernGalleryDefaultHeaderView> *)createDefaultHeaderView
{
    return nil;
}

- (UIView<TGModernGalleryDefaultFooterView> *)createDefaultFooterView
{
    return nil;
}

- (UIView<TGModernGalleryDefaultFooterAccessoryView> *)createDefaultLeftAccessoryView
{
    return nil;
}

- (UIView<TGModernGalleryDefaultFooterAccessoryView> *)createDefaultRightAccessoryView
{
    return nil;
}

@end
