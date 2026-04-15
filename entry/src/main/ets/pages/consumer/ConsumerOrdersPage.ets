import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Order, OrderStatus } from '../../model/DataModel';
import { consumerUserService } from '../../model/ConsumerUserService';

/**
 * 消费端订单列表页
 */
@Entry
@Component
export struct ConsumerOrdersPage {
  @State orders: Order[] = [];
  @State currentTab: string = 'all';
  @State isLoading: boolean = true;
  @State showCancelDialog: boolean = false;
  @State selectedOrder: Order | null = null;

  private readonly tabs: OrderTab[] = [
    { key: 'all', label: '全部' },
    { key: 'pending', label: '待支付' },
    { key: 'paid', label: '已支付' },
    { key: 'refunded', label: '已退款' }
  ];

  aboutToAppear(): void {
    this.loadOrders();
  }

  private loadOrders(): void {
    this.isLoading = true;
    setTimeout(() => {
      if (consumerUserService.isLoggedIn()) {
        this.orders = dataService.getOrders();
      }
      this.isLoading = false;
    }, 300);
  }

  private getFilteredOrders(): Order[] {
    if (this.currentTab === 'all') {
      return this.orders;
    }
    return this.orders.filter((o: Order): boolean => {
      if (this.currentTab === 'pending') {
        return o.status === OrderStatus.PENDING;
      } else if (this.currentTab === 'paid') {
        return o.status === OrderStatus.PAID;
      } else if (this.currentTab === 'refunded') {
        return o.status === OrderStatus.REFUNDED || o.status === OrderStatus.CANCELLED;
      }
      return true;
    });
  }

  private getStatusText(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING: return '待支付';
      case OrderStatus.PAID: return '已支付';
      case OrderStatus.CANCELLED: return '已取消';
      case OrderStatus.REFUNDED: return '已退款';
      case OrderStatus.USED: return '已使用';
      default: return '';
    }
  }

  private getStatusColor(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING: return '#FF9800';
      case OrderStatus.PAID: return '#4CAF50';
      case OrderStatus.CANCELLED: return '#9E9E9E';
      case OrderStatus.REFUNDED: return '#9E9E9E';
      case OrderStatus.USED: return '#2196F3';
      default: return '#9E9E9E';
    }
  }

  private handleCancel(order: Order): void {
    this.selectedOrder = order;
    this.showCancelDialog = true;
  }

  private confirmCancel(): void {
    if (!this.selectedOrder) return;

    const success = dataService.cancelOrder(this.selectedOrder.id);
    if (success) {
      promptAction.showToast({ message: '订单已取消', duration: 2000 });
      this.loadOrders();
    } else {
      promptAction.showToast({ message: '取消失败', duration: 2000 });
    }
    this.showCancelDialog = false;
    this.selectedOrder = null;
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
        .backgroundColor('#FFFFFF80')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => { router.back(); })

        Text('我的订单')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (!consumerUserService.isLoggedIn()) {
        // 未登录状态
        Column() {
          Text('🔒')
            .fontSize(64)
          Text('请先登录')
            .fontSize(16)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
          Text('登录后可查看您的订单')
            .fontSize(13)
            .fontColor('#BBBBBB')
            .margin({ top: 6 })
          Button('去登录')
            .fontSize(14)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(8)
            .height(40)
            .width(120)
            .margin({ top: 20 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // Tab切换
        Row({ space: 8 }) {
          ForEach(this.tabs, (tab: OrderTab) => {
            Text(tab.label)
              .fontSize(13)
              .fontColor(this.currentTab === tab.key ? '#FFFFFF' : '#FF9800')
              .fontWeight(this.currentTab === tab.key ? FontWeight.Bold : FontWeight.Normal)
              .padding({ left: 14, right: 14, top: 6, bottom: 6 })
              .backgroundColor(this.currentTab === tab.key ? '#FF9800' : '#FFF3E0')
              .borderRadius(16)
              .onClick(() => {
                this.currentTab = tab.key;
              })
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 8 })

        if (this.isLoading) {
          Column() {
            LoadingProgress().width(40).height(40).color('#FF9800')
            Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          Scroll() {
            Column() {
              if (this.getFilteredOrders().length === 0) {
                Column() {
                  Text('📋')
                    .fontSize(64)
                  Text('暂无订单')
                    .fontSize(16)
                    .fontColor('#9E9E9E')
                    .margin({ top: 12 })
                  Text('快去选购精彩演出吧')
                    .fontSize(13)
                    .fontColor('#BBBBBB')
                    .margin({ top: 6 })
                }
                .width('100%')
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
              } else {
                ForEach(this.getFilteredOrders(), (order: Order) => {
                  this.OrderCard(order)
                })
              }
            }
            .width('100%')
            .padding({ bottom: 20 })
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
      }

      // 取消订单对话框
      if (this.showCancelDialog) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showCancelDialog = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Text('确认取消订单')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 16 })

          Text('确定要取消此订单吗？')
            .fontSize(15)
            .fontColor('#666666')
            .padding({ left: 20, right: 20 })

          Text('取消后订单将无法恢复')
            .fontSize(13)
            .fontColor('#9E9E9E')
            .margin({ top: 4 })

          Row() {
            Button('再想想')
              .fontSize(15)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .margin({ right: 8 })
              .onClick(() => { this.showCancelDialog = false; })

            Button('确认取消')
              .fontSize(15)
              .fontColor('#FFFFFF')
              .backgroundColor('#F44336')
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .onClick(() => { this.confirmCancel(); })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
        }
        .width('80%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .position({ x: '10%', y: '35%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  OrderCard(order: Order) {
    Column() {
      Row() {
        Text('订单号：' + order.id)
          .fontSize(12)
          .fontColor('#9E9E9E')
        Blank()
        Text(this.getStatusText(order.status))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getStatusColor(order.status))
          .borderRadius(10)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
      }
      .width('100%')

      Divider().color('#F0F0F0').margin({ top: 8, bottom: 8 })

      Row() {
        Column() {
          Text('🎬')
            .fontSize(40)
            .backgroundColor('#FFF3E0')
            .borderRadius(8)
            .padding(6)
        }
        .width(60)

        Column() {
          Text(order.showName)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${order.showDate} ${order.showTime}`)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
          Text(order.venue)
            .fontSize(12)
            .fontColor('#9E9E9E')
            .margin({ top: 2 })
          Text(order.seats.map((s) => s.seatNo).join('、'))
            .fontSize(12)
            .fontColor('#FF9800')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .margin({ left: 10 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Divider().color('#F0F0F0').margin({ top: 8, bottom: 8 })

      Row() {
        Text('下单时间：' + order.createTime)
          .fontSize(12)
          .fontColor('#9E9E9E')
        Blank()
        Text('合计：')
          .fontSize(12)
          .fontColor('#666666')
        Text(`¥${order.totalAmount}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF9800')
      }
      .width('100%')

      // 操作按钮
      if (order.status === OrderStatus.PENDING) {
        Row() {
          Blank()
          Button('取消订单')
            .fontSize(13)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(6)
            .height(32)
            .padding({ left: 16, right: 16 })
            .onClick(() => { this.handleCancel(order); })

          Button('去支付')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(6)
            .height(32)
            .padding({ left: 16, right: 16 })
            .margin({ left: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/consumer/ConsumerPaymentPage',
                params: { orderId: order.id }
              });
            })
        }
        .width('100%')
        .margin({ top: 12 })
      }

      if (order.status === OrderStatus.PAID) {
        Row() {
          Blank()
          Button('申请退票')
            .fontSize(13)
            .fontColor('#F44336')
            .backgroundColor('#FFEBEE')
            .borderRadius(6)
            .height(32)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              promptAction.showToast({ message: '退票申请已提交', duration: 2000 });
            })
        }
        .width('100%')
        .margin({ top: 12 })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(12)
    .margin({ left: 16, right: 16, bottom: 12 })
  }
}

interface OrderTab {
  key: string;
  label: string;
}
