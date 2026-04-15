import router from '@ohos.router';
import { dataService } from '../../model/DataService';
import { Order } from '../../model/DataModel';

/**
 * 消费端购票成功页
 */
@Entry
@Component
export struct ConsumerPaySuccessPage {
  @State order: Order | null = null;
  @State isLoading: boolean = true;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params && params.orderId) {
      const orders = dataService.getOrders();
      this.order = orders.find((o: Order): boolean => o.id === params.orderId) || null;
    }
    this.isLoading = false;
  }

  // 返回首页
  private goHome(): void {
    router.replaceUrl({ url: 'pages/consumer/ConsumerMainPage' });
  }

  // 查看订单
  private viewOrder(): void {
    router.replaceUrl({
      url: 'pages/consumer/ConsumerOrdersPage',
      params: { fromSuccess: 'true' }
    });
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('支付成功')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
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
          // 成功图标和文字
          Column() {
            Column() {
              Text('✓')
                .fontSize(48)
                .fontColor('#FFFFFF')
            }
            .width(80)
            .height(80)
            .backgroundColor('#4CAF50')
            .borderRadius(40)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)

            Text('支付成功')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 16 })

            Text(`¥${this.order.totalAmount}`)
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
              .margin({ top: 8 })
          }
          .width('100%')
          .padding({ top: 40, bottom: 30 })
          .backgroundColor('#FFFFFF')
          .margin({ top: 12 })

          // 订单信息卡片
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

            Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

            Row() {
              Text('演出时间')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(`${this.order.showDate} ${this.order.showTime}`)
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

            Row() {
              Text('演出场馆')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.venue)
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

            Row() {
              Text('座位信息')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.seats.map((s) => s.seatNo).join('、'))
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

            Row() {
              Text('订单编号')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.id)
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')

            Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

            Row() {
              Text('支付时间')
                .fontSize(14)
                .fontColor('#9E9E9E')
              Text(this.order.payTime || '')
                .fontSize(14)
                .fontColor('#1A1A1A')
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })

          // 提示信息
          Column() {
            Text('🎫 取票方式')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .width('100%')
              .margin({ bottom: 8 })

            Text('请凭购票成功后收到的电子凭证或订单号到剧院票房窗口取票')
              .fontSize(13)
              .fontColor('#666666')
              .width('100%')

            Text('建议提前30分钟到达剧院')
              .fontSize(13)
              .fontColor('#FF9800')
              .width('100%')
              .margin({ top: 8 })
          }
          .width('100%')
          .backgroundColor('#FFF3E0')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })
        }
        .width('100%')
        .layoutWeight(1)

        // 底部按钮
        Column() {
          Divider().color('#E8E8E8')

          Row() {
            Button('返回首页')
              .fontSize(15)
              .fontColor('#FF9800')
              .backgroundColor('#FFFFFF')
              .border({ width: 1, color: '#FF9800' })
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .margin({ right: 8 })
              .onClick(() => { this.goHome(); })

            Button('查看订单')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#FF9800')
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .onClick(() => { this.viewOrder(); })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
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
