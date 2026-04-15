import { StatsOverview } from '../model/DataModel';
import { dataService } from '../model/DataService';
import { TicketListPage } from './ticket/TicketListPage';
import { InventoryListPage } from './inventory/InventoryListPage';
import { StatsHomePage } from './stats/StatsHomePage';
import { ProfilePage } from './ProfilePage';

interface TabItem {
  key: string;
  label: string;
  icon: string;
  activeIcon: string;
}

@Entry
@Component
export struct MainTabPage {
  @State currentTab: string = 'ticket';
  @State todaySales: number = 0;
  @State todayRevenue: string = '¥0';
  @State currentStock: number = 0;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  private readonly tabItems: TabItem[] = [
    {
      key: 'ticket',
      label: '票务',
      icon: '🎫',
      activeIcon: '🎫'
    },
    {
      key: 'inventory',
      label: '库存',
      icon: '📦',
      activeIcon: '📦'
    },
    {
      key: 'stats',
      label: '统计',
      icon: '📊',
      activeIcon: '📊'
    },
    {
      key: 'profile',
      label: '我的',
      icon: '👤',
      activeIcon: '👤'
    }
  ];

  aboutToAppear(): void {
    this.loadStats();
  }

  private loadStats(): void {
    const overview: StatsOverview = dataService.getStatsOverview();
    this.todaySales = overview.todaySales;
    this.todayRevenue = overview.todayRevenue;
    this.currentStock = overview.currentStock;
  }

  build() {
    Column() {
      // ===== 顶部标题栏 =====
      Row() {
        Column() {
          Text('TTMS')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E88E5')
          Text('票务管理')
            .fontSize(10)
            .fontColor('#9E9E9E')
            .margin({ top: 1 })
        }

        Blank()

        Text('👤')
          .fontSize(24)
          .onClick(() => {
            this.currentTab = 'profile';
          })
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      // ===== 内容区 =====
      Column() {
        if (this.currentTab === 'ticket') {
          // 今日概览卡片
          this.StatsOverviewCards()
          TicketListPage()
        } else if (this.currentTab === 'inventory') {
          InventoryListPage()
        } else if (this.currentTab === 'stats') {
          StatsHomePage()
        } else if (this.currentTab === 'profile') {
          ProfilePage()
        }
      }
      .width('100%')
      .layoutWeight(1)

      // ===== 底部 TabBar（微信风格） =====
      Column() {
        Divider()
          .color('#E8E8E8')
          .vertical(false)

        Row() {
          ForEach(this.tabItems, (item: TabItem) => {
            Column() {
              Text(this.currentTab === item.key ? item.activeIcon : item.icon)
                .fontSize(24)

              Text(item.label)
                .fontSize(11)
                .fontColor(this.currentTab === item.key ? '#1E88E5' : '#9E9E9E')
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
      .height(64 + this.getUIContext().px2vp(this.bottomRectHeight))
      .padding({ bottom: this.getUIContext().px2vp(this.bottomRectHeight) })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    // .padding({
    //   top: this.getUIContext().px2vp(this.topRectHeight),
    //   bottom: this.getUIContext().px2vp(this.bottomRectHeight)
    // })
  }

  // 今日概览卡片Builder
  @Builder
  StatsOverviewCards() {
    Row({ space: 8 }) {
      Column() {
        Text(String(this.todaySales))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Text('今日销量')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .opacity(0.85)
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .height(72)
      .backgroundColor('#1E88E5')
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(this.todayRevenue)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Text('今日营收')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .opacity(0.85)
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .height(72)
      .backgroundColor('#4CAF50')
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(String(this.currentStock))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Text('当前库存')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .opacity(0.85)
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .height(72)
      .backgroundColor('#FF9800')
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8 })
    .backgroundColor('#FFFFFF')
  }
}
