import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Order, OrderStatus } from '../model/DataModel';
import { dataService } from '../model/DataService';
import { OrderCard, OrderStatistics, OrderFilterTabs, Counts } from '../components/OrderCard';
import { EmptyState } from '../components/Common';

// 支付路由参数接口
interface PaymentRouteParams {
  orderId: string;
  amount: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: PaymentRouteParams;
}

// 订单列表页
@Entry
@Component
struct OrdersPage {
  @State orders: Order[] = [];
  @State filteredOrders: Order[] = [];
  @State selectedTab: string = 'all';
  @State isLoading: boolean = true;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @State counts: Counts = {
    all: 0,
    pending: 0,
    paid: 0,
    used: 0
  };

  aboutToAppear() {
    this.loadOrders();
  }

  loadOrders(): void {
    this.orders = dataService.getOrders();
    const allCount: number = this.orders.length;
    const pendingCount: number = this.orders.filter((o: Order): boolean => o.status === OrderStatus.PENDING).length;
    const paidCount: number = this.orders.filter((o: Order): boolean => o.status === OrderStatus.PAID).length;
    const usedCount: number = this.orders.filter((o: Order): boolean => o.status === OrderStatus.USED).length;
    this.counts = {
      all: allCount,
      pending: pendingCount,
      paid: paidCount,
      used: usedCount
    };
    this.filterOrders();
    this.isLoading = false;
  }

  filterOrders(): void {
    if (this.selectedTab === 'all') {
      this.filteredOrders = [...this.orders];
    } else if (this.selectedTab === 'pending') {
      this.filteredOrders = this.orders.filter((o: Order): boolean => o.status === OrderStatus.PENDING);
    } else if (this.selectedTab === 'paid') {
      this.filteredOrders = this.orders.filter((o: Order): boolean => o.status === OrderStatus.PAID);
    } else if (this.selectedTab === 'used') {
      this.filteredOrders = this.orders.filter((o: Order): boolean => o.status === OrderStatus.USED);
    }
  }

  onTabChange(tab: string): void {
    this.selectedTab = tab;
    this.filterOrders();
  }

  cancelOrder(order: Order): void {
    promptAction.showDialog({
      title: '确认取消',
      message: '确定要取消该订单吗？',
      buttons: [
        { text: '不取消', color: '#999999' },
        { text: '确认取消', color: '#FF4D4F' }
      ]
    }).then((result) => {
      if (result.index === 1) {
        const success: boolean = dataService.cancelOrder(order.id);
        if (success) {
          promptAction.showToast({ message: '订单已取消' });
          this.loadOrders();
        } else {
          promptAction.showToast({ message: '取消失败，请稍后重试' });
        }
      }
    });
  }

  goToPayment(order: Order): void {
    const routeParams: PaymentRouteParams = {
      orderId: order.id,
      amount: order.totalAmount.toString()
    };
    const routerOptions: RouterOptions = {
      url: 'pages/PaymentPage',
      params: routeParams
    };
    router.pushUrl(routerOptions);
  }

  handleOrderCardAction(orderId: string, actionId: string): void {
    if (actionId === 'cancel') {
      const order: Order | undefined = this.orders.find((o: Order): boolean => o.id === orderId);
      if (order !== undefined) {
        this.cancelOrder(order);
      }
    } else if (actionId === 'pay') {
      const order: Order | undefined = this.orders.find((o: Order): boolean => o.id === orderId);
      if (order !== undefined) {
        this.goToPayment(order);
      }
    } else if (actionId === 'view_detail') {
      promptAction.showToast({ message: '订单详情: ' + orderId });
    }
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .onClick(() => {
            router.back();
          })

        Blank()

        Text('我的订单')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Blank()

        Text('')
          .width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#FF4D4F')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          OrderStatistics({
            totalOrders: this.counts.all,
            pendingCount: this.counts.pending,
            paidCount: this.counts.paid,
            usedCount: this.counts.used
          })

          OrderFilterTabs({
            selectedTab: this.selectedTab,
            counts: this.counts,
            onTabSelect: (tab: string): void => {
              this.onTabChange(tab);
            }
          })

          if (this.filteredOrders.length > 0) {
            List() {
              ForEach(this.filteredOrders, (order: Order) => {
                ListItem() {
                  OrderCard({
                    order: order,
                    onCardAction: (orderId: string, actionId: string): void => {
                      this.handleOrderCardAction(orderId, actionId);
                    }
                  })
                }
              })
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ top: 12, bottom: 60 })
            .edgeEffect(EdgeEffect.Spring)
          } else {
            Column() {
              EmptyState({
                icon: '📋',
                title: '暂无订单',
                message: this.selectedTab === 'all' ? '快去选购演出票吧' : '该状态下暂无订单',
                actionText: this.selectedTab === 'all' ? '去购票' : '',
                actionId: 'go_home',
                onAction: (actionId: string): void => {
                  if (actionId === 'go_home') {
                    router.back();
                  }
                }
              })
            }
            .width('100%')
            .layoutWeight(1)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({
      top: this.getUIContext().px2vp(this.topRectHeight),
      bottom: this.getUIContext().px2vp(this.bottomRectHeight)
    })
  }
}
