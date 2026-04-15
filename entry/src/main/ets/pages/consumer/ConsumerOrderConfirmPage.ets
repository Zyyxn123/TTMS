import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Show, SeatSelection } from '../../model/DataModel';
import { consumerUserService } from '../../model/ConsumerUserService';

/**
 * 消费端订单确认页
 */
@Entry
@Component
export struct ConsumerOrderConfirmPage {
  @State show: Show | null = null;
  @State selectedSeats: SeatSelection[] = [];
  @State ticketCount: number = 0;
  @State serviceFee: number = 0;
  @State totalAmount: number = 0;
  @State isLoading: boolean = true;
  @State showConfirmDialog: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params && params.showId) {
      const showData = dataService.getShowById(params.showId);
      if (showData) {
        this.show = showData;
      }
      if (params.seats) {
        try {
          this.selectedSeats = JSON.parse(params.seats);
          this.ticketCount = this.selectedSeats.length;
          const seatTotal = this.selectedSeats.reduce((sum: number, s: SeatSelection): number => sum + s.price, 0);
          this.serviceFee = Math.round(seatTotal * 0.1);
          this.totalAmount = seatTotal + this.serviceFee;
        } catch (e) {
          console.error('解析座位信息失败');
        }
      }
    }
    this.isLoading = false;
  }

  // 点击立即支付
  private handlePay(): void {
    // 检查登录状态
    if (!consumerUserService.isLoggedIn()) {
      promptAction.showToast({ message: '请先登录', duration: 2000 });
      router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
      return;
    }

    // 显示确认对话框
    this.showConfirmDialog = true;
  }

  // 确认下单
  private confirmOrder(): void {
    if (!this.show) return;

    this.showConfirmDialog = false;

    // 创建订单
    const order = dataService.createOrder(this.show, this.selectedSeats);

    // 跳转到支付页
    router.replaceUrl({
      url: 'pages/consumer/ConsumerPaymentPage',
      params: { orderId: order.id }
    });
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

        Text('确认订单')
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

      if (this.isLoading || !this.show) {
        Column() {
          Text('加载中...').fontSize(14).fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 演出信息卡片
            Column() {
              Row() {
                Column() {
                  Text('🎬')
                    .fontSize(48)
                    .backgroundColor('#FFF3E0')
                    .borderRadius(8)
                    .padding(8)
                }
                .width(70)

                Column() {
                  Text(this.show.name)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(`${this.show.date} ${this.show.time}`)
                    .fontSize(13)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                  Text(this.show.venue)
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .margin({ top: 2 })
                }
                .layoutWeight(1)
                .margin({ left: 12 })
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })

            // 座位信息
            Column() {
              Row() {
                Text('座位信息')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
              }
              .width('100%')
              .margin({ bottom: 12 })

              ForEach(this.selectedSeats, (seat: SeatSelection) => {
                Row() {
                  Text(seat.seatNo)
                    .fontSize(14)
                    .fontColor('#666666')
                  Blank()
                  Text(`¥${seat.price}`)
                    .fontSize(14)
                    .fontColor('#1A1A1A')
                }
                .width('100%')
                .padding({ top: 6, bottom: 6 })
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })

            // 费用明细
            Column() {
              Row() {
                Text('费用明细')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
              }
              .width('100%')
              .margin({ bottom: 12 })

              Row() {
                Text('票款（' + this.ticketCount + '张）')
                  .fontSize(14)
                  .fontColor('#666666')
                Blank()
                Text(`¥${this.totalAmount - this.serviceFee}`)
                  .fontSize(14)
                  .fontColor('#1A1A1A')
              }
              .width('100%')

              Row() {
                Text('服务费')
                  .fontSize(14)
                  .fontColor('#666666')
                Blank()
                Text(`¥${this.serviceFee}`)
                  .fontSize(14)
                  .fontColor('#1A1A1A')
              }
              .width('100%')
              .margin({ top: 8 })

              Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

              Row() {
                Text('应付金额')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
                Text(`¥${this.totalAmount}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF9800')
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })

            // 购票须知
            Column() {
              Row() {
                Text('购票须知')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
              }
              .width('100%')
              .margin({ bottom: 8 })

              Text('1. 演出票一经售出，概不退换，请合理安排时间')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .margin({ top: 4 })
              Text('2. 请提前30分钟入场，演出开始后禁止入场')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .margin({ top: 4 })
              Text('3. 1.2米以下儿童需在成人陪同下入场')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .margin({ top: 4 })
              Text('4. 场馆内禁止吸烟，禁止携带易燃易爆物品')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .margin({ top: 4 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })
          }
          .width('100%')
          .padding({ bottom: 100 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 底部支付按钮
        Column() {
          Divider().color('#E8E8E8')
          Row() {
            Column() {
              Text('合计')
                .fontSize(12)
                .fontColor('#9E9E9E')
              Text(`¥${this.totalAmount}`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF9800')
            }

            Button('立即支付')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#FF9800')
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .margin({ left: 16 })
              .onClick(() => { this.handlePay(); })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')

        // 确认下单对话框
        if (this.showConfirmDialog) {
          Column() {
            Blank()
              .backgroundColor('#66000000')
              .onClick(() => { this.showConfirmDialog = false; })
          }
          .width('100%')
          .height('100%')
          .position({ x: 0, y: 0 })

          Column() {
            Text('确认下单')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .padding({ top: 20, bottom: 16 })

            Text(`确认购买 ${this.ticketCount} 张演出票？`)
              .fontSize(15)
              .fontColor('#666666')
              .padding({ left: 20, right: 20 })

            Text(`共计 ¥${this.totalAmount}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
              .margin({ top: 8 })

            Row() {
              Button('取消')
                .fontSize(15)
                .fontColor('#666666')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .margin({ right: 8 })
                .onClick(() => { this.showConfirmDialog = false; })

              Button('确认')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#FF9800')
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .onClick(() => { this.confirmOrder(); })
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
