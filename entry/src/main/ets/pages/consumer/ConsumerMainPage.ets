import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Show } from '../../model/DataModel';
import { consumerUserService } from '../../model/ConsumerUserService';
import { ConsumerOrdersPage } from './ConsumerOrdersPage';

/**
 * 消费端主页 - 底部四大Tab
 */
@Entry
@Component
export struct ConsumerMainPage {
  @State currentTab: string = 'home';
  @State isLoggedIn: boolean = false;
  @State userName: string = '游客';
  @State userPhone: string = '';

  private readonly tabItems: TabItem[] = [
    { key: 'home', label: '首页', icon: '🏠' },
    { key: 'shows', label: '演出', icon: '🎭' },
    { key: 'orders', label: '订单', icon: '📋' },
    { key: 'profile', label: '我的', icon: '👤' }
  ]

  aboutToAppear(): void {
    this.checkLoginStatus();
  }

  aboutToResume(): void {
    this.checkLoginStatus();
  }

  private checkLoginStatus(): void {
    const user = consumerUserService.getCurrentUser();
    if (user) {
      this.isLoggedIn = true;
      this.userName = user.name;
      this.userPhone = user.phone;
    } else {
      this.isLoggedIn = false;
      this.userName = '游客';
      this.userPhone = '';
    }
  }

  private handleLogout(): void {
    consumerUserService.logout();
    this.isLoggedIn = false;
    this.userName = '游客';
    this.userPhone = '';
    router.replaceUrl({ url: 'pages/Index' });
  }

  build() {
    Column() {
      // ===== 内容区 =====
      Column() {
        if (this.currentTab === 'home') {
          this.ConsumerHomeContent()
        } else if (this.currentTab === 'shows') {
          this.ConsumerShowListContent()
        } else if (this.currentTab === 'orders') {
          this.ConsumerOrdersContent()
        } else if (this.currentTab === 'profile') {
          this.ConsumerProfileContent()
        }
      }
      .width('100%')
      .layoutWeight(1)

      // ===== 底部 TabBar =====
      Column() {
        Divider()
          .color('#E8E8E8')
          .vertical(false)

        Row() {
          ForEach(this.tabItems, (item: TabItem) => {
            Column() {
              Text(item.icon)
                .fontSize(24)

              Text(item.label)
                .fontSize(11)
                .fontColor(this.currentTab === item.key ? '#FF9800' : '#9E9E9E')
                .fontWeight(this.currentTab === item.key ? FontWeight.Medium : FontWeight.Normal)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              if (this.currentTab !== item.key) {
                this.currentTab = item.key;
              }
            })
          })
        }
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 8 })
      }
      .width('100%')
      .height(64)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // ===== 首页内容 =====
  @Builder
  ConsumerHomeContent() {
    Column() {
      // 顶部导航
      Row() {
        Column() {
          Text('🎭')
            .fontSize(18)
          Text('TTMS票务')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })
        }

        Blank()

        Text('🔍')
          .fontSize(22)
          .margin({ right: 12 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/consumer/ConsumerSearchPage' });
          })

        Text('👤')
          .fontSize(24)
          .onClick(() => {
            this.currentTab = 'profile';
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column({ space: 12 }) {
          // 轮播图区域（模拟）
          Column() {
            Row() {
              Text('🎬')
                .fontSize(48)
              Column() {
                Text('精彩演出')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('尽享视听盛宴')
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 4 })
              }
              .margin({ left: 12 })
            }
          }
          .width('100%')
          .height(160)
          .backgroundColor('#FF9800')
          .borderRadius(12)
          .justifyContent(FlexAlign.Center)
          .margin({ left: 16, right: 16 })

          // 分类入口
          Row({ space: 8 }) {
            this.CategoryItem('🎵', '演唱会')
            this.CategoryItem('🎭', '话剧', '#E91E63')
            this.CategoryItem('🎻', '音乐会', '#9C27B0')
            this.CategoryItem('💃', '舞蹈', '#673AB7')
            this.CategoryItem('🎪', '喜剧', '#2196F3')
            this.CategoryItem('👶', '儿童', '#4CAF50')
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 热门演出
          Column() {
            Row() {
              Text('🔥 热门演出')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Blank()
              Text('更多 >')
                .fontSize(13)
                .fontColor('#FF9800')
                .onClick(() => { this.currentTab = 'shows'; })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16 })
            .margin({ bottom: 8 })

            ForEach(dataService.getNowShowingShows().slice(0, 3), (show: Show) => {
              this.ShowCard(show)
            })
          }
          .width('100%')
          .margin({ top: 8 })

          // 即将开售
          if (dataService.getUpcomingShows().length > 0) {
            Column() {
              Row() {
                Text('📅 即将开售')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 16 })
              .margin({ bottom: 8 })

              ForEach(dataService.getUpcomingShows().slice(0, 2), (show: Show) => {
                this.ShowCard(show)
              })
            }
            .width('100%')
          }
        }
        .padding({ bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CategoryItem(icon: string, name: string, color: string = '#FF9800') {
    Column() {
      Text(icon)
        .fontSize(24)
      Text(name)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .padding({ top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  ShowCard(show: Show) {
    Column() {
      Row() {
        Column() {
          Text('🎬')
            .fontSize(40)
            .backgroundColor('#FFF3E0')
            .borderRadius(8)
            .padding(8)
        }
        .width(80)

        Column() {
          Text(show.name)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${show.date} · ${show.venue}`)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
          Row() {
            Text(`¥${show.price}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
            Text('起')
              .fontSize(12)
              .fontColor('#999999')
              .margin({ left: 2 })
            Blank()
            Text('立即购买 >')
              .fontSize(12)
              .fontColor('#FF9800')
          }
          .width('100%')
          .margin({ top: 6 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 8 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/consumer/ConsumerShowDetailPage',
        params: { showId: show.id }
      });
    })
  }

  // ===== 演出列表内容 =====
  @Builder
  ConsumerShowListContent() {
    Column() {
      // 顶部导航
      Row() {
        Column() {
          Text('🎭')
            .fontSize(18)
          Text('全部演出')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })
        }

        Blank()

        Text('筛选')
          .fontSize(13)
          .fontColor('#FF9800')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor('#FFF3E0')
          .borderRadius(16)
          .onClick(() => {
            router.pushUrl({ url: 'pages/consumer/ConsumerFilterPage' });
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          ForEach(dataService.getShows(), (show: Show) => {
            this.ShowCard(show)
          })
        }
        .padding({ bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }


  @Builder
  ConsumerOrdersContent() {
    // ===== 订单内容 =====
    Column() {
      ConsumerOrdersPage()
    }
    .width('100%')
    .height('100%')
  }

  // ===== 个人中心内容 =====
  @Builder
  ConsumerProfileContent() {
    Column() {
      // 个人信息区
      Column() {
        Row() {
          Column() {
            Text(this.isLoggedIn ? '👤' : '👤')
              .fontSize(40)
          }
          .width(60)
          .height(60)
          .backgroundColor('#FFFFFF30')
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Text(this.userName)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            if (this.isLoggedIn) {
              Text(this.userPhone)
                .fontSize(12)
                .fontColor('#FFFFFF')
                .opacity(0.8)
                .margin({ top: 2 })
            } else {
              Text('点击登录/注册')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .opacity(0.8)
                .margin({ top: 2 })
            }
          }
          .layoutWeight(1)
          .height(60)
          .padding({ left: 16 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)

          if (this.isLoggedIn) {
            Text('退出')
              .fontSize(13)
              .fontColor('#FFFFFF')
              .opacity(0.8)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#FFFFFF30')
              .borderRadius(12)
              .onClick(() => {
                this.handleLogout();
              })
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 40, bottom: 20 })
      }
      .width('100%')
      .backgroundColor('#FF9800')

      Scroll() {
        Column() {
          // 菜单列表
          Column() {
            this.ProfileMenuItem('🎫', '我的票券', this.isLoggedIn ? '查看已购票券' : '登录后查看', () => {
              if (this.isLoggedIn) {
                this.currentTab = 'orders';
              } else {
                router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
              }
            })
            Divider().color('#F5F5F5').margin({ left: 56 })
            this.ProfileMenuItem('❤️', '我的收藏', '收藏的演出', () => {
              promptAction.showToast({ message: '收藏功能开发中', duration: 2000 });
            })
            Divider().color('#F5F5F5').margin({ left: 56 })
            this.ProfileMenuItem('📍', '收货地址', '管理收货地址', () => {
              if (this.isLoggedIn) {
                router.pushUrl({ url: 'pages/consumer/ConsumerAddressPage' });
              } else {
                router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
              }
            })
            Divider().color('#F5F5F5').margin({ left: 56 })
            this.ProfileMenuItem('💳', '支付方式', '管理支付方式', () => {
              if (this.isLoggedIn) {
                router.pushUrl({ url: 'pages/consumer/ConsumerPaymentMethodsPage' });
              } else {
                router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
              }
            })
            Divider().color('#F5F5F5').margin({ left: 56 })
            this.ProfileMenuItem('🔔', '消息通知', '查看系统消息', () => {
              if (this.isLoggedIn) {
                router.pushUrl({ url: 'pages/consumer/ConsumerMessagesPage' });
              } else {
                router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
              }
            })
            Divider().color('#F5F5F5').margin({ left: 56 })
            this.ProfileMenuItem('❓', '帮助中心', '常见问题解答', () => {
              promptAction.showToast({ message: '帮助中心开发中', duration: 2000 });
            })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 16 })

          if (!this.isLoggedIn) {
            // 未登录时显示登录按钮
            Button('登录 / 注册')
              .width('90%')
              .height(48)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#FF9800')
              .borderRadius(8)
              .margin({ top: 24 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
              })
          }

          // 切换角色
          Text('切换角色（管理员入口）')
            .fontSize(12)
            .fontColor('#BBBBBB')
            .margin({ top: 24, bottom: 30 })
            .onClick(() => {
              router.replaceUrl({ url: 'pages/Index' });
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  ProfileMenuItem(icon: string, title: string, subtitle: string, onClick?: () => void) {
    Row() {
      Text(icon)
        .fontSize(20)
        .width(36)
      Column() {
        Text(title)
          .fontSize(15)
          .fontColor('#1A1A1A')
        Text(subtitle)
          .fontSize(12)
          .fontColor('#9E9E9E')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Text('>')
        .fontSize(14)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .onClick(() => {
      if (onClick) {
        onClick();
      }
    })
  }
}

interface TabItem {
  key: string;
  label: string;
  icon: string;
}