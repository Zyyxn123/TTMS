import { Order, OrderStatus, SeatSelection } from '../model/DataModel';

export type OrderCardActionCallback = (orderId: string, actionId: string) => void;
export type TabActionCallback = (tab: string) => void;

export interface Counts {
  all: number;
  pending: number;
  paid: number;
  used: number;
}

// 订单卡片组件
@Component
export struct OrderCard {
  @Prop order: Order;
  onCardAction: OrderCardActionCallback = () => {};

  getStatusColor(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING: return '#FF9800';
      case OrderStatus.PAID: return '#4CAF50';
      case OrderStatus.CANCELLED: return '#999999';
      case OrderStatus.REFUNDED: return '#9E9E9E';
      case OrderStatus.USED: return '#2196F3';
      default: return '#999999';
    }
  }

  getStatusText(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING: return '待支付';
      case OrderStatus.PAID: return '已支付';
      case OrderStatus.CANCELLED: return '已取消';
      case OrderStatus.REFUNDED: return '已退款';
      case OrderStatus.USED: return '已使用';
      default: return '未知状态';
    }
  }

  build() {
    Column() {
      Row() {
        Text('订单号: ' + this.order.id)
          .fontSize(12)
          .fontColor('#999999')

        Blank()

        Text(this.getStatusText(this.order.status))
          .fontSize(12)
          .fontColor(this.getStatusColor(this.order.status))
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })

      Divider()
        .color('#F0F0F0')
        .margin({ top: 10 })

      Row() {
        Column() {
          Column() {
            Text('🎭')
              .fontSize(30)
              .textAlign(TextAlign.Center)
          }
          .width(60)
          .height(80)
          .backgroundColor('#F8F8F8')
          .borderRadius(8)
        }
        .width(60)

        Column() {
          Text(this.order.showName)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')

          Text(this.order.showDate + ' ' + this.order.showTime)
            .fontSize(13)
            .fontColor('#666666')
            .margin({ top: 4 })

          Text(this.order.venue)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 2 })

          Row() {
            ForEach(this.order.seats, (seat: SeatSelection, index: number) => {
              Text(seat.seatNo)
                .fontSize(11)
                .fontColor('#999999')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#F5F5F5')
                .borderRadius(4)
                .margin({ right: 4 })
            })
          }
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .height(80)
        .padding({ left: 12 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })
      .alignItems(VerticalAlign.Top)
      .onClick(() => {
        this.onCardAction(this.order.id, 'view_detail');
      })

      Divider()
        .color('#F0F0F0')
        .margin({ top: 12 })

      Row() {
        Column() {
          Text('下单时间')
            .fontSize(11)
            .fontColor('#999999')
          Text(this.order.createTime)
            .fontSize(11)
            .fontColor('#666666')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Text() {
          Span('合计: ')
            .fontSize(13)
            .fontColor('#666666')
          Span('¥' + this.order.totalAmount)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF4D4F')
        }

        Blank()

        if (this.order.status === OrderStatus.PENDING) {
          Row({ space: 8 }) {
            Button('取消')
              .fontSize(12)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .borderRadius(14)
              .width(60)
              .height(28)
              .onClick(() => {
                this.onCardAction(this.order.id, 'cancel');
              })

            Button('去支付')
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#FF4D4F')
              .borderRadius(14)
              .width(60)
              .height(28)
              .onClick(() => {
                this.onCardAction(this.order.id, 'pay');
              })
          }
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 12 })
  }
}

// 订单统计组件
@Component
export struct OrderStatistics {
  @Prop totalOrders: number = 0;
  @Prop pendingCount: number = 0;
  @Prop paidCount: number = 0;
  @Prop usedCount: number = 0;

  build() {
    Row() {
      Column() {
        Text(this.pendingCount.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF9800')
        Text('待支付')
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)

      Column() {
        Text(this.paidCount.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#4CAF50')
        Text('已支付')
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)

      Column() {
        Text(this.usedCount.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#2196F3')
        Text('已使用')
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)

      Column() {
        Text(this.totalOrders.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#666666')
        Text('全部订单')
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
    .backgroundColor(Color.White)
  }
}

// 订单筛选Tab组件
@Component
export struct OrderFilterTabs {
  @Prop selectedTab: string = 'all';
  @Prop counts: Counts = {
    all: 0,
    pending: 0,
    paid: 0,
    used: 0
  };
  onTabSelect: TabActionCallback = () => {};

  private tabs: string[] = ['all', 'pending', 'paid', 'used'];

  private getCount(tab: string): number {
    switch (tab) {
      case 'all': return this.counts.all;
      case 'pending': return this.counts.pending;
      case 'paid': return this.counts.paid;
      case 'used': return this.counts.used;
      default: return 0;
    }
  }

  private getTabName(tab: string): string {
    switch (tab) {
      case 'all': return '全部';
      case 'pending': return '待支付';
      case 'paid': return '已支付';
      case 'used': return '已使用';
      default: return tab;
    }
  }

  build() {
    Row() {
      ForEach(this.tabs, (tab: string) => {
        Column() {
          Row() {
            Text(this.getTabName(tab))
              .fontSize(14)
              .fontColor(this.selectedTab === tab ? '#FF4D4F' : '#666666')

            if (this.getCount(tab) > 0) {
              Text(this.getCount(tab).toString())
                .fontSize(10)
                .fontColor(this.selectedTab === tab ? '#FF4D4F' : '#999999')
                .backgroundColor(this.selectedTab === tab ? '#FFEBEB' : '#F0F0F0')
                .borderRadius(10)
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .margin({ left: 4 })
            }
          }

          if (this.selectedTab === tab) {
            Text('')
              .width(20)
              .height(2)
              .backgroundColor('#FF4D4F')
              .borderRadius(1)
              .margin({ top: 4 })
          } else {
            Text('')
              .width(20)
              .height(2)
              .margin({ top: 6 })
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.onTabSelect(tab);
        })
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }
}
