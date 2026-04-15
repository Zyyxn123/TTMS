import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import UserService from '../model/UserService';
import { AdminUser, AdminRole, OperationLog } from '../model/DataModel';
import { DividerLine } from '../components/Common';

interface MenuItem {
  id: string;
  icon: string;
  title: string;
  showArrow: boolean;
}

@Entry
@Component
export struct ProfilePage {
  @State user: AdminUser | null = null;
  @State showLogoutDialog: boolean = false;
  @State menuItems: MenuItem[] = [];

  private allMenuItems: MenuItem[] = [
    { id: 'profile_edit', icon: '📝', title: '个人信息编辑', showArrow: true },
    { id: 'operation_log', icon: '📋', title: '操作日志', showArrow: true },
    { id: 'password_change', icon: '🔑', title: '修改密码', showArrow: true },
    { id: 'settings', icon: '⚙️', title: '系统设置', showArrow: true },
    { id: 'help_center', icon: '❓', title: '帮助中心', showArrow: true }
  ];

  aboutToAppear(): void {
    this.user = UserService.getCurrentUser();
    if (this.user !== null && this.user.role === AdminRole.OPERATOR_ADMIN) {
      this.menuItems = this.allMenuItems;
    } else {
      this.menuItems = this.allMenuItems.filter((item: MenuItem): boolean => item.id !== 'settings');
    }
  }

  private handleMenuClick(itemId: string): void {
    switch (itemId) {
      case 'profile_edit':
        router.pushUrl({ url: 'pages/profile/ProfileEditPage' });
        break;
      case 'operation_log':
        router.pushUrl({ url: 'pages/profile/OperationLogPage' });
        break;
      case 'password_change':
        router.pushUrl({ url: 'pages/profile/PasswordChangePage' });
        break;
      case 'settings':
        router.pushUrl({ url: 'pages/settings/SettingsPage' });
        break;
      case 'help_center':
        promptAction.showToast({ message: '帮助中心功能开发中', duration: 2000 });
        break;
    }
  }

  private handleLogout(): void {
    this.showLogoutDialog = true;
  }

  private confirmLogout(): void {
    UserService.logout();
    this.showLogoutDialog = false;
    router.replaceUrl({ url: 'pages/LoginPage' });
  }

  private getRoleText(role: AdminRole): string {
    return role === AdminRole.OPERATOR_ADMIN ? '运营管理员' : '票务管理员';
  }

  private getRoleColor(role: AdminRole): string {
    return role === AdminRole.OPERATOR_ADMIN ? '#1E88E5' : '#FF9800';
  }

  build() {
    Column() {
      // 个人信息区
      Column() {
        Row() {
          Column() {
            Text('👤')
              .fontSize(40)
          }
          .width(60)
          .height(60)
          .backgroundColor('#FFFFFF30')
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Text(this.user?.name ?? '管理员')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Row() {
              Text(this.user !== null ? this.getRoleText(this.user.role) : '')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .backgroundColor(this.user !== null ? this.getRoleColor(this.user.role) : '#FFFFFF')
                .borderRadius(10)
                .margin({ top: 4 })
            }
          }
          .layoutWeight(1)
          .height(60)
          .padding({ left: 16 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 40, bottom: 20 })
      }
      .width('100%')
      .backgroundColor('#1E88E5')

      Scroll() {
        Column() {
          // 权限说明卡
          Column() {
            Row() {
              Text('🔐')
                .fontSize(16)
              Text('账号权限')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ left: 8 })
            }
            .width('100%')
            .margin({ bottom: 8 })

            if (this.user !== null && this.user.role === AdminRole.OPERATOR_ADMIN) {
              Text('运营管理员：拥有全部功能权限，包括系统设置、数据备份、审计日志等高级管理功能。')
                .fontSize(12)
                .fontColor('#666666')
                .lineHeight(18)
            } else {
              Text('票务管理员：拥有票务管理、库存管理、数据统计等业务功能权限，暂不支持系统设置等高级管理功能。')
                .fontSize(12)
                .fontColor('#666666')
                .lineHeight(18)
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(14)
          .margin({ left: 16, right: 16, top: 16 })

          // 菜单列表
          Column() {
            ForEach(this.menuItems, (item: MenuItem, index: number) => {
              Column() {
                Row() {
                  Text(item.icon)
                    .fontSize(20)
                    .width(32)
                  Text(item.title)
                    .fontSize(16)
                    .fontColor('#1A1A1A')
                    .layoutWeight(1)
                  if (item.showArrow) {
                    Text('>')
                      .fontSize(16)
                      .fontColor('#9E9E9E')
                  }
                }
                .width('100%')
                .padding({ left: 12, right: 16, top: 14, bottom: 14 })
                .onClick(() => {
                  this.handleMenuClick(item.id);
                })

                if (index < this.menuItems.length - 1) {
                  DividerLine({ edgeMargin: 52 })
                }
              }
            })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 12 })

          // 退出登录按钮
          Button('退出登录')
            .width('90%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E88E5')
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .border({ width: 1, color: '#1E88E5' })
            .margin({ top: 24, bottom: 40 })
            .onClick(() => {
              this.handleLogout();
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 退出确认弹窗
      if (this.showLogoutDialog) {
        Column() {
          Blank()
            .onClick(() => {
              this.showLogoutDialog = false;
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#66000000')
        .position({ x: 0, y: 0 })

        Column() {
          Text('退出登录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ top: 24, bottom: 12 })

          Text('确定要退出登录吗？')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 24 })

          Row({ space: 5 }) {
            Button('取消')
              .fontSize(16)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .width('45%')
              .onClick(() => {
                this.showLogoutDialog = false;
              })
            Text('')
              .width(1)
              .height(40)
              .backgroundColor('#F0F0F0')
            Button('确定')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#1E88E5')
              .borderRadius(8)
              .width('45%')
              .onClick(() => {
                this.confirmLogout();
              })
          }
          .width('100%')
          .height(48)
          .padding({ left: 10, right: 10 })
        }
        .width('80%')
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .position({ x: '10%', y: '35%' })
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
