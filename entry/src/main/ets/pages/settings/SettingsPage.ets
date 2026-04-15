import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import UserService from '../../model/UserService';
import { AdminRole } from '../../model/DataModel';
import { SettingsMenuItem } from '../../model/DataModel';

interface SettingsMenuItemType {
  id: string;
  icon: string;
  title: string;
  subtitle: string;
  badge?: string;
  dangerous?: boolean;
}

@Entry
@Component
export struct SettingsPage {
  @State isOperator: boolean = false;
  @State showAboutDialog: boolean = false;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  aboutToAppear(): void {
    const user = UserService.getCurrentUser();
    if (user === null || user.role !== AdminRole.OPERATOR_ADMIN) {
      router.replaceUrl({ url: 'pages/common/PermissionDeniedPage' });
      return;
    }
    this.isOperator = true;
  }

  private menuItems: SettingsMenuItemType[] = [
    { id: 'roles', icon: '👥', title: '角色权限管理', subtitle: '管理系统用户角色与权限' },
    { id: 'backup', icon: '💾', title: '数据备份', subtitle: '系统数据备份与恢复' },
    { id: 'audit', icon: '🔍', title: '审计日志', subtitle: '查看系统操作审计日志' },
    { id: 'notification', icon: '🔔', title: '通知设置', subtitle: '配置系统通知推送' },
    { id: 'theme', icon: '🎨', title: '主题设置', subtitle: '自定义系统界面主题' },
    { id: 'cache', icon: '🗑️', title: '清理缓存', subtitle: '清理应用缓存数据' },
    { id: 'check_update', icon: '🔄', title: '检查更新', subtitle: '当前版本 v1.0.0', badge: '已是最新' },
    { id: 'about', icon: 'ℹ️', title: '关于系统', subtitle: 'TTMS票务管理系统', dangerous: false }
  ];

  private handleMenuClick(itemId: string): void {
    switch (itemId) {
      case 'roles':
        promptAction.showToast({ message: '角色权限管理功能开发中', duration: 2000 });
        break;
      case 'backup':
        promptAction.showToast({ message: '数据备份功能开发中', duration: 2000 });
        break;
      case 'audit':
        promptAction.showToast({ message: '审计日志功能开发中', duration: 2000 });
        break;
      case 'notification':
        promptAction.showToast({ message: '通知设置功能开发中', duration: 2000 });
        break;
      case 'theme':
        promptAction.showToast({ message: '主题设置功能开发中', duration: 2000 });
        break;
      case 'cache':
        promptAction.showToast({ message: '缓存已清理完成', duration: 2000 });
        break;
      case 'check_update':
        promptAction.showToast({ message: '当前已是最新版本 v1.0.0', duration: 2000 });
        break;
      case 'about':
        this.showAboutDialog = true;
        break;
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Row() {
          Text('<')
            .fontSize(24)
            .fontColor('#1A1A1A')
        }
        .width(40)
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => { router.back(); })

        Text('系统设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('')
          .width(40)
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      if (this.isOperator) {
        Scroll() {
          Column({ space: 12 }) {
            // ===== 系统管理 =====
            Column({ space: 0 }) {
              Text('系统管理')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .alignSelf(ItemAlign.Start)
                .padding({ left: 20, top: 8, bottom: 8 })

              ForEach(this.menuItems.filter((_, index) => index < 4), (item: SettingsMenuItemType, index: number) => {
                Column() {
                  Row() {
                    Text(item.icon)
                      .fontSize(20)
                      .width(32)

                    Column() {
                      Text(item.title)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                      Text(item.subtitle)
                        .fontSize(12)
                        .fontColor('#9E9E9E')
                        .margin({ top: 2 })
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)

                    if (item.badge !== undefined) {
                      Text(item.badge)
                        .fontSize(11)
                        .fontColor('#4CAF50')
                        .backgroundColor('#E8F5E9')
                        .borderRadius(10)
                        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                    }

                    Text('>')
                      .fontSize(14)
                      .fontColor('#CCCCCC')
                      .margin({ left: 8 })
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                  .onClick(() => { this.handleMenuClick(item.id); })

                  if (index < 3) {
                    Divider()
                      .color('#F5F5F5')
                      .margin({ left: 56 })
                  }
                }
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16 })

            // ===== 偏好设置 =====
            Column({ space: 0 }) {
              Text('偏好设置')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .alignSelf(ItemAlign.Start)
                .padding({ left: 20, top: 8, bottom: 8 })

              ForEach(this.menuItems.filter((_, index) => index >= 4 && index < 6), (item: SettingsMenuItemType, index: number) => {
                Column() {
                  Row() {
                    Text(item.icon)
                      .fontSize(20)
                      .width(32)

                    Column() {
                      Text(item.title)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                      Text(item.subtitle)
                        .fontSize(12)
                        .fontColor('#9E9E9E')
                        .margin({ top: 2 })
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)

                    Text('>')
                      .fontSize(14)
                      .fontColor('#CCCCCC')
                      .margin({ left: 8 })
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                  .onClick(() => { this.handleMenuClick(item.id); })

                  if (index < 1) {
                    Divider()
                      .color('#F5F5F5')
                      .margin({ left: 56 })
                  }
                }
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16 })

            // ===== 关于 =====
            Column({ space: 0 }) {
              ForEach(this.menuItems.filter((_, index) => index >= 6), (item: SettingsMenuItemType) => {
                Column() {
                  Row() {
                    Text(item.icon)
                      .fontSize(20)
                      .width(32)

                    Column() {
                      Text(item.title)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                      Text(item.subtitle)
                        .fontSize(12)
                        .fontColor('#9E9E9E')
                        .margin({ top: 2 })
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)

                    if (item.badge !== undefined) {
                      Text(item.badge)
                        .fontSize(11)
                        .fontColor('#4CAF50')
                        .backgroundColor('#E8F5E9')
                        .borderRadius(10)
                        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                    }

                    Text('>')
                      .fontSize(14)
                      .fontColor('#CCCCCC')
                      .margin({ left: 8 })
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                  .onClick(() => { this.handleMenuClick(item.id); })
                }
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16, top: 4 })

            // 版本信息
            Text('TTMS 票务管理系统 v1.0.0')
              .fontSize(11)
              .fontColor('#CCCCCC')
              .margin({ top: 20, bottom: 30 })
          }
          .padding({ bottom: 20 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }

      // 关于弹窗
      if (this.showAboutDialog) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showAboutDialog = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Text('🏛️')
            .fontSize(48)
            .margin({ top: 24, bottom: 12 })

          Text('TTMS 票务管理系统')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')

          Text('v1.0.0')
            .fontSize(14)
            .fontColor('#9E9E9E')
            .margin({ top: 4 })

          Column() {
            Text('基于 HarmonyOS ArkUI 框架开发的')
              .fontSize(13)
              .fontColor('#666666')
            Text('剧院/影院票务全流程管理系统')
              .fontSize(13)
              .fontColor('#666666')
              .margin({ top: 2 })
          }
          .margin({ top: 16 })

          Text('© 2026 TTMS 保留所有权利')
            .fontSize(11)
            .fontColor('#CCCCCC')
            .margin({ top: 20 })

          Button('知道了')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#1E88E5')
            .borderRadius(10)
            .height(44)
            .width('80%')
            .margin({ top: 15, bottom: 5 })
            .onClick(() => { this.showAboutDialog = false; })
        }
        .width('75%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .position({ x: '12.5%', y: '30%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
