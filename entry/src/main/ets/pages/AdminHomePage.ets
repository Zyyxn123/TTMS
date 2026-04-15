import router from '@ohos.router';
import { StatsOverview } from '../model/DataModel';
import { dataService } from '../model/DataService';
import UserService from '../model/UserService';
import { TicketListPage } from './ticket/TicketListPage';
import { InventoryListPage } from './inventory/InventoryListPage';
import { ProfilePage } from './ProfilePage';

interface TabItem {
  key: string;
  label: string;
  activeIcon: ResourceStr;
  inactiveIcon: ResourceStr;
}

export interface ModuleCardType {
  key: string;
  title: string;
  icon: string;
  subtitle: string;
}

@Entry
@Component
export struct AdminHomePage {
  @State currentTab: string = 'home';
  @State todaySales: number = 0;
  @State todayRevenue: string = '¥0';
  @State currentStock: number = 0;
  @State currentTime: string = '';
  private readonly tabItems: TabItem[] = [
    {
      key: 'home',
      label: '首页',
      activeIcon: $r('app.media.layered_image'),
      inactiveIcon: $r('app.media.layered_image')
    },
    {
      key: 'ticket',
      label: '票务',
      activeIcon: $r('app.media.layered_image'),
      inactiveIcon: $r('app.media.layered_image')
    },
    {
      key: 'inventory',
      label: '库存',
      activeIcon: $r('app.media.layered_image'),
      inactiveIcon: $r('app.media.layered_image')
    },
    {
      key: 'profile',
      label: '我的',
      activeIcon: $r('app.media.layered_image'),
      inactiveIcon: $r('app.media.layered_image')
    }
  ];
  private readonly moduleCards: ModuleCardType[] = [
    {
      key: 'ticket_entry',
      title: '票务录入',
      icon: '🎫',
      subtitle: '新增演出票务'
    },
    {
      key: 'ticket_query',
      title: '票务查询',
      icon: '🔍',
      subtitle: '查看票务列表'
    },
    {
      key: 'inventory',
      title: '库存调整',
      icon: '📦',
      subtitle: '调整票务库存'
    },
    {
      key: 'warning',
      title: '库存预警',
      icon: '⚠️',
      subtitle: '预警提醒'
    },
    {
      key: 'stats',
      title: '数据统计',
      icon: '📊',
      subtitle: '销量营收统计'
    },
    {
      key: 'logs',
      title: '操作日志',
      icon: '📋',
      subtitle: '查看操作记录'
    }
  ];

  aboutToAppear(): void {
    this.loadStats();
    this.updateTime();
    setInterval(() => {
      this.updateTime();
    }, 60000);
  }

  private updateTime(): void {
    const now: Date = new Date();
    const year: number = now.getFullYear();
    const month: string = String(now.getMonth() + 1).padStart(2, '0');
    const day: string = String(now.getDate()).padStart(2, '0');
    const hour: string = String(now.getHours()).padStart(2, '0');
    const minute: string = String(now.getMinutes()).padStart(2, '0');
    const weekDays: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    const weekDay: string = weekDays[now.getDay()];
    this.currentTime = `${year}-${month}-${day} ${weekDay} ${hour}:${minute}`;
  }

  private loadStats(): void {
    const overview: StatsOverview = dataService.getStatsOverview();
    this.todaySales = overview.todaySales;
    this.todayRevenue = overview.todayRevenue;
    this.currentStock = overview.currentStock;
  }

  private handleTabChange(key: string): void {
    if (key === 'home') {
      this.loadStats();
    }
    this.currentTab = key;
  }

  private handleModuleClick(module: string): void {
    switch (module) {
      case 'ticket_entry':
        router.pushUrl({ url: 'pages/ticket/TicketAddPage' });
        break;
      case 'ticket_query':
        router.pushUrl({ url: 'pages/ticket/TicketListPage' });
        break;
      case 'inventory':
        router.pushUrl({ url: 'pages/inventory/InventoryListPage' });
        break;
      case 'warning':
        router.pushUrl({ url: 'pages/inventory/InventoryWarningPage' });
        break;
      case 'stats':
        router.pushUrl({ url: 'pages/stats/StatsHomePage' });
        break;
      case 'logs':
        router.pushUrl({ url: 'pages/profile/OperationLogPage' });
        break;
    }
  }

  build() {
    Column() {
      // ===== 顶部导航栏 =====
      Row() {
        Column() {
          Text('TTMS')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E88E5')
          Text('票务管理系统')
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
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // ===== Tab 内容区 =====
      Column() {
        if (this.currentTab === 'home') {
          this.HomeContent()
        } else if (this.currentTab === 'ticket') {
          TicketListPage()
        } else if (this.currentTab === 'inventory') {
          InventoryListPage()
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
              Image(this.currentTab === item.key ? item.activeIcon : item.inactiveIcon)
                .width(22)
                .height(22)
                .fillColor(this.currentTab === item.key ? '#1E88E5' : '#9E9E9E')

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
              this.handleTabChange(item.key);
            })
          })
        }
        .width('100%')
        .height('100%')
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

  @Builder
  HomeContent() {
    Scroll() {
      Column({ space: 16 }) {
        // ===== 欢迎信息 =====
        Column() {
          Text(this.currentTime)
            .fontSize(12)
            .fontColor('#9E9E9E')
            .margin({ bottom: 4 })
          Text('欢迎回来')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .alignSelf(ItemAlign.Start)
        }
        .width('100%')
        .padding({ left: 4 })

        // ===== 今日数据概览 =====
        Column({ space: 8 }) {
          Text('今日概览')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .alignSelf(ItemAlign.Start)
            .padding({ left: 4 })

          Row({ space: 8 }) {
            this.DataCard('今日销量', String(this.todaySales), '张', '#1E88E5', '🎫')
            this.DataCard('今日营收', this.todayRevenue, '', '#4CAF50', '💰')
            this.DataCard('当前库存', String(this.currentStock), '张', '#FF9800', '📦')
          }
          .width('100%')
        }
        .width('100%')

        // ===== 功能模块入口 =====
        Column({ space: 8 }) {
          Text('功能模块')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .alignSelf(ItemAlign.Start)
            .padding({ left: 4 })

          Grid() {
            ForEach(this.moduleCards, (card: ModuleCardType, index: number) => {
              GridItem() {
                this.ModuleCard(card.key, card.title, card.icon, card.subtitle)
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .width('100%')
          .height(220)
        }
        .width('100%')

        // ===== 快捷操作入口 =====
        Column({ space: 8 }) {
          Text('快捷操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .alignSelf(ItemAlign.Start)
            .padding({ left: 4 })

          Row({ space: 12 }) {
            this.QuickActionBtn('新增票务', '#1E88E5', () => {
              router.pushUrl({ url: 'pages/ticket/TicketAddPage' });
            })
            this.QuickActionBtn('查看预警', '#FF9800', () => {
              router.pushUrl({ url: 'pages/inventory/InventoryWarningPage' });
            })
            this.QuickActionBtn('数据统计', '#4CAF50', () => {
              router.pushUrl({ url: 'pages/stats/StatsHomePage' });
            })
          }
          .width('100%')
        }
        .width('100%')
        .margin({ bottom: 16 })
      }
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }

  @Builder
  DataCard(title: string, value: string, unit: string, color: string, icon: string) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(16)
        Text(title)
          .fontSize(12)
          .fontColor('#FFFFFF')
          .opacity(0.9)
          .margin({ left: 4 })
      }
      .width('100%')

      Row() {
        Text(value)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        if (unit !== '') {
          Text(unit)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .opacity(0.8)
            .margin({ left: 4, bottom: 2 })
        }
      }
      .width('100%')
      .margin({ top: 8 })
    }
    .width('100%')
    .height(100)
    .backgroundColor(color)
    .borderRadius(12)
    .padding(14)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  ModuleCard(key: string, title: string, icon: string, subtitle: string) {
    Column() {
      Text(icon)
        .fontSize(28)
        .margin({ bottom: 6 })
      Text(title)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
      Text(subtitle)
        .fontSize(10)
        .fontColor('#9E9E9E')
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .shadow({
      radius: 4,
      color: '#10000000',
      offsetX: 0,
      offsetY: 1
    })
    .onClick(() => {
      this.handleModuleClick(key);
    })
  }

  @Builder
  QuickActionBtn(text: string, color: string, onClick: () => void) {
    Button(text)
      .fontSize(14)
      .fontWeight(FontWeight.Medium)
      .fontColor(color)
      .backgroundColor(color + '15')
      .border({ width: 1, color: color })
      .borderRadius(8)
      .height(40)
      .layoutWeight(1)
      .onClick(onClick)
  }
}
