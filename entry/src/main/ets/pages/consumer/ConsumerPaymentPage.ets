import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Order, OrderStatus } from '../../model/DataModel';

/**
 * 消费端支付页
 */
@Entry
@Component
export struct ConsumerPaymentPage {
  @State order: Order | null = null;
  @State selectedPayment: string = 'wechat';
  @State isLoading: boolean = true;
  @State isPaying: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params && params.orderId) {
      const orders = dataService.getOrders();
      this.order = orders.find((o: Order): boolean => o.id === params.orderId) || null;
    }
    this.isLoading = false;
  }

  // 点击支付
  private handlePay(): void {
    if (!this.order) {
      return;
    }

    this.isPaying = true;

    // 模拟支付
    setTimeout(() => {
      const success = dataService.payOrder(this.order!.id);
      this.isPaying = false;

      if (success) {
        promptAction.showToast({ message: '支付成功', duration: 2000 });
        // 跳转到支付成功页
        router.replaceUrl({
          url: 'pages/consumer/ConsumerPaySuccessPage',
          params: { orderId: this.order!.id }
        });
      } else {
        promptAction.showToast({ message: '支付失败，请重试', duration: 2000 });
      }
    }, 2000);
  }

  // 获取支付方式图标
  private getPaymentIcon(type: string): string {
    switch (type) {
      case 'wechat':
        return '💬';
      case 'alipay':
        return '💰';
      case 'bank':
        return '🏦';
      default:
        return '💳';
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
        .backgroundColor('#FFFFFF80')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          router.back();
        })

        Text('订单支付')
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

      if (this.isLoading || !this.order) {
        Column() {
          Text('加载中...').fontSize(14).fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          // 订单金额卡片
          Column() {
            Text('订单金额')
              .fontSize(14)
              .fontColor('#9E9E9E')
            Text(`¥${this.order.totalAmount}`)
              .fontSize(36)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
              .margin({ top: 8 })
            Text('订单号：' + this.order.id)
              .fontSize(12)
              .fontColor('#9E9E9E')
              .margin({ top: 8 })
          }
          .width('100%')
          .padding({ top: 30, bottom: 30 })
          .backgroundColor('#FFFFFF')
          .margin({ top: 12 })

          // 演出信息
          Column() {
            Row() {
              Text('演出名称')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.showName)
                .fontSize(14)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .textAlign(TextAlign.End)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')

            Row() {
            }
            .width('100%')
            .height(12)


            Row() {
              Text('演出时间')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(`${this.order.showDate} ${this.order.showTime}`)
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Row() {
            }
            .width('100%')
            .height(12)

            Row() {
              Text('演出场馆')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.venue)
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Row() {
            }
            .width('100%')
            .height(12)

            Row() {
              Text('座位信息')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.seats.map((s) => s.seatNo).join('、'))
                .fontSize(14)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })

          // 支付方式
          Column() {
            Text('选择支付方式')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .width('100%')
              .margin({ bottom: 12 })

            // 微信支付
            Row() {
              Text('💬')
                .fontSize(24)
              Column() {
                Text('微信支付')
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                Text('推荐')
                  .fontSize(11)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#4CAF50')
                  .borderRadius(4)
                  .padding({
                    left: 4,
                    right: 4,
                    top: 1,
                    bottom: 1
                  })
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Column() {
                Text('')
                  .width(20)
                  .height(20)
                  .border({
                    width: 2,
                    color: this.selectedPayment === 'wechat' ? '#FF9800' : '#CCCCCC',
                    radius: 10
                  })
                  .backgroundColor(this.selectedPayment === 'wechat' ? '#FF9800' : '#FFFFFF')
                  .borderRadius(10)
                  .onClick(() => {
                    this.selectedPayment = 'wechat';
                  })

                if (this.selectedPayment === 'wechat') {
                  Text('✓')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                }
              }
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.selectedPayment = 'wechat';
            })

            Divider().color('#F0F0F0')

            // 支付宝
            Row() {
              Text('💰')
                .fontSize(24)
              Column() {
                Text('支付宝')
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .margin({ left: 12 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Column() {
                Text('')
                  .width(20)
                  .height(20)
                  .border({
                    width: 2,
                    color: this.selectedPayment === 'alipay' ? '#FF9800' : '#CCCCCC',
                    radius: 10
                  })
                  .backgroundColor(this.selectedPayment === 'alipay' ? '#FF9800' : '#FFFFFF')
                  .borderRadius(10)
                  .onClick(() => {
                    this.selectedPayment = 'alipay';
                  })

                if (this.selectedPayment === 'alipay') {
                  Text('✓')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                }
              }
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.selectedPayment = 'alipay';
            })

            Divider().color('#F0F0F0')

            // 银行卡
            Row() {
              Text('🏦')
                .fontSize(24)
              Column() {
                Text('银行卡支付')
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .margin({ left: 12 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Column() {
                Text('')
                  .width(20)
                  .height(20)
                  .border({
                    width: 2,
                    color: this.selectedPayment === 'bank' ? '#FF9800' : '#CCCCCC',
                    radius: 10
                  })
                  .backgroundColor(this.selectedPayment === 'bank' ? '#FF9800' : '#FFFFFF')
                  .borderRadius(10)
                  .onClick(() => {
                    this.selectedPayment = 'bank';
                  })

                if (this.selectedPayment === 'bank') {
                  Text('✓')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                }
              }
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.selectedPayment = 'bank';
            })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })
        }
        .width('100%')
        .layoutWeight(1)

        // 底部支付按钮
        Column() {
          Divider().color('#E8E8E8')
          Row() {
            Button(this.isPaying ? '支付中...' : '确认支付 ¥' + this.order.totalAmount)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor(this.isPaying ? '#FFB74D' : '#FF9800')
              .borderRadius(8)
              .height(48)
              .width('100%')
              .enabled(!this.isPaying)
              .onClick(() => {
                this.handlePay();
              })
          }
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 12
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
