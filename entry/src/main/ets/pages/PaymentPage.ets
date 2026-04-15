import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../model/DataService';

// 路由参数接口
interface RouteParams {
  orderId: string;
  amount: string;
}

// 订单列表路由参数接口
interface OrdersRouteParams {
  fromPayment: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: OrdersRouteParams;
}

// 支付页面
@Entry
@Component
struct PaymentPage {
  @State orderId: string = '';
  @State amount: number = 0;
  @State selectedPayment: string = 'alipay';
  @State isPaying: boolean = false;
  @State countDown: number = 15 * 60;
  private timer: number = -1;

  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params) {
      this.orderId = params.orderId || '';
      const parsedAmount = parseFloat(params.amount);
      this.amount = isNaN(parsedAmount) ? 0 : parsedAmount;
    }
    this.startCountDown();
  }

  aboutToDisappear() {
    this.stopCountDown();
  }

  startCountDown(): void {
    this.timer = setInterval(() => {
      if (this.countDown > 0) {
        this.countDown = this.countDown - 1;
      } else {
        this.stopCountDown();
        promptAction.showToast({ message: '订单已超时，请重新下单' });
        router.back();
      }
    }, 1000);
  }

  stopCountDown(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
    }
  }

  formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  doPayment(): void {
    if (this.isPaying) {
      return;
    }

    this.isPaying = true;

    const success: boolean = dataService.payOrder(this.orderId);

    if (success) {
      this.stopCountDown();
      promptAction.showToast({ message: '支付成功！' });
      setTimeout(() => {
        const routeParams: OrdersRouteParams = {
          fromPayment: 'true'
        };
        const routerOptions: RouterOptions = {
          url: 'pages/OrdersPage',
          params: routeParams
        };
        router.pushUrl(routerOptions);
      }, 1500);
    } else {
      promptAction.showToast({ message: '支付失败，请重试' });
      this.isPaying = false;
    }
  }

  build() {
    Column() {
      Column() {
        this.buildNavigationBar()

        Scroll() {
          Column() {
            this.buildAmountSection()
            this.buildPaymentMethods()
            Column().height(100)
          }
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      Column() {
        Button(this.isPaying ? '支付中...' : '确认支付 ¥' + this.amount)
          .fontSize(16)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.isPaying ? '#CCCCCC' : '#FF4D4F')
          .borderRadius(22)
          .width('100%')
          .height(44)
          .enabled(!this.isPaying)
          .onClick(() => {
            this.doPayment();
          })
      }
      .width('100%')
      .padding({
        left: 20,
        right: 20,
        top: 10,
        bottom: 20
      })
      .backgroundColor(Color.White)
    }
  }

  @Builder
  buildNavigationBar(): void {
    Row() {
      Row() {
        Text('<')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width(40)
      .height(40)
      .backgroundColor('#FFFFFF80')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        promptAction.showDialog({
          title: '确认离开',
          message: '支付尚未完成，确定要离开吗？',
          buttons: [
            { text: '取消', color: '#999999' },
            { text: '确定离开', color: '#FF4D4F' }
          ]
        }).then((result) => {
          if (result.index === 1) {
            router.back();
          }
        });
      })

      Blank()

      Text('订单支付')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')

      Blank()

      Row() {
        Text('剩余 ')
          .fontSize(12)
          .fontColor('#666666')
        Text(this.formatTime(this.countDown))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.countDown <= 60 ? '#FF4D4F' : '#FF9800')
      }
      .padding({
        left: 8,
        right: 8,
        top: 4,
        bottom: 4
      })
      .backgroundColor('#FFF7E6')
      .borderRadius(12)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  @Builder
  buildAmountSection(): void {
    Column() {
      Text('支付金额')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 30, bottom: 10 })

      Row() {
        Text('¥')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF4D4F')
        Text(this.amount.toFixed(2))
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF4D4F')
      }

      Text('订单号: ' + this.orderId)
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 16, bottom: 20 })

      Divider()
        .color('#F0F0F0')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12 })
  }

  @Builder
  buildPaymentMethods(): void {
    Column() {
      Text('选择支付方式')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .padding({ left: 16, top: 16, bottom: 12 })

      Row() {
        Text('💙')
          .fontSize(28)
          .margin({ right: 12 })

        Column() {
          Text('支付宝')
            .fontSize(15)
            .fontColor('#1A1A1A')
          Text('推荐使用')
            .fontSize(11)
            .fontColor('#FF9800')
            .margin({ top: 2 })
        }

        Blank()

        if (this.selectedPayment === 'alipay') {
          Radio({ value: 'alipay', group: 'payment' })
            .checked(true)
            .radioStyle({
              checkedBackgroundColor: '#FF4D4F',
              indicatorColor: Color.White
            })
            .onChange((isChecked: boolean) => {
              if (!isChecked) {
                this.selectedPayment = '';
              }
            })
        } else {
          Radio({ value: 'alipay', group: 'payment' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: '#FF4D4F',
              indicatorColor: Color.White
            })
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedPayment = 'alipay';
              }
            })
        }
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 14,
        bottom: 14
      })
      .backgroundColor(Color.White)

      Divider()
        .color('#F0F0F0')
        .margin({ left: 56 })

      Row() {
        Text('🟢')
          .fontSize(28)
          .margin({ right: 12 })

        Column() {
          Text('微信支付')
            .fontSize(15)
            .fontColor('#1A1A1A')
        }

        Blank()

        if (this.selectedPayment === 'wechat') {
          Radio({ value: 'wechat', group: 'payment' })
            .checked(true)
            .radioStyle({
              checkedBackgroundColor: '#FF4D4F',
              indicatorColor: Color.White
            })
            .onChange((isChecked: boolean) => {
              if (!isChecked) {
                this.selectedPayment = '';
              }
            })
        } else {
          Radio({ value: 'wechat', group: 'payment' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: '#FF4D4F',
              indicatorColor: Color.White
            })
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedPayment = 'wechat';
              }
            })
        }

        Divider()
          .color('#F0F0F0')
          .margin({ left: 56 })

        Row() {
          Text('💳')
            .fontSize(28)
            .margin({ right: 12 })

          Column() {
            Text('银行卡支付')
              .fontSize(15)
              .fontColor('#1A1A1A')
          }

          Blank()

          if (this.selectedPayment === 'card') {
            Radio({ value: 'card', group: 'payment' })
              .checked(true)
              .radioStyle({
                checkedBackgroundColor: '#FF4D4F',
                indicatorColor: Color.White
              })
              .onChange((isChecked: boolean) => {
                if (!isChecked) {
                  this.selectedPayment = '';
                }
              })
          } else {
            Radio({ value: 'card', group: 'payment' })
              .checked(false)
              .radioStyle({
                checkedBackgroundColor: '#FF4D4F',
                indicatorColor: Color.White
              })
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.selectedPayment = 'card';
                }
              })
          }
        }
        .width('100%')
        .padding({
          left: 16,
          right: 16,
          top: 14,
          bottom: 14
        })
        .backgroundColor(Color.White)
      }
      .width('100%')
      .margin({ top: 12 })
    }
  }
}
