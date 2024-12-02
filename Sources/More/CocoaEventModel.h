//
//  CocoaEventModel.h
//  CocoaDebug
//
//  Created by 杨波 on 2023/8/30.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingItemType) {
    SettingItemTypeSelectionItem = 0,
    SettingItemTypeSwitchItem    = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface CocoaEventModel : NSObject

@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, assign) SettingItemType cellType;

@property (nonatomic, copy, nullable) void (^ eventCallBack)(void);
@property (nonatomic, copy, nullable) void (^ switchEventCallBack)(void);

@end
NS_ASSUME_NONNULL_END
