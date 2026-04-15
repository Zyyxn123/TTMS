import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Show, Seat, SeatStatus, SeatSelection } from '../../model/DataModel';

/**
 * 消费端座位选择页
 */
@Entry
@Component
export struct ConsumerSeatSelectPage {
  @State show: Show | null = null;
  @State seats: Seat[][] = [];
  @State selectedSeats: SeatSelection[] = [];
  @State totalAmount: number = 0;
  @State isLoading: boolean = true;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params && params.showId) {
      const showData = dataService.getShowById(params.showId);
      if (showData) {
        this.show = showData;
        this.seats = dataService.getSeats(params.showId);
      }
    }
    this.isLoading = false;
  }

  // 点击座位
  private toggleSeat(seat: Seat): void {
    if (seat.status === SeatStatus.SOLD) {
      return;
    }

    if (seat.status === SeatStatus.SELECTED) {
      // 取消选中
      this.selectedSeats = this.selectedSeats.filter(
        (s: SeatSelection): boolean => !(s.row === seat.row && s.col === seat.col)
      );
      seat.status = SeatStatus.AVAILABLE;
    } else {
      // 选中座位，最多3张
      if (this.selectedSeats.length >= 3) {
        promptAction.showToast({ message: '最多只能选择3个座位', duration: 2000 });
        return;
      }
      this.selectedSeats.push({
        row: seat.row,
        col: seat.col,
        price: seat.price,
        seatNo: this.getSeatNo(seat)
      });
      seat.status = SeatStatus.SELECTED;
    }

    // 重新计算总价
    this.totalAmount = this.selectedSeats.reduce((sum: number, s: SeatSelection): number => sum + s.price, 0);

    // 刷新座位数组
    this.seats = [...this.seats];
  }

  // 获取座位号
  private getSeatNo(seat: Seat): string {
    const rowLetter = String.fromCharCode(65 + seat.row);
    return `${rowLetter}排${seat.col + 1}座`;
  }

  // 获取座位颜色
  private getSeatColor(seat: Seat): string {
    switch (seat.status) {
      case SeatStatus.SOLD:
        return '#E0E0E0';
      case SeatStatus.SELECTED:
        return '#FF9800';
      default:
        return '#FFFFFF';
    }
  }

  // 获取座位边框颜色
  private getSeatBorderColor(seat: Seat): string {
    switch (seat.status) {
      case SeatStatus.SOLD:
        return '#E0E0E0';
      case SeatStatus.SELECTED:
        return '#FF9800';
      default:
        return '#CCCCCC';
    }
  }

  // 点击确认选座
  private handleConfirm(): void {
    if (this.selectedSeats.length === 0) {
      promptAction.showToast({ message: '请选择座位', duration: 2000 });
      return;
    }

    // 跳转到订单确认页
    router.pushUrl({
      url: 'pages/consumer/ConsumerOrderConfirmPage',
      params: {
        showId: this.show?.id || '',
        seats: JSON.stringify(this.selectedSeats)
      }
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
        .onClick(() => {
          router.back();
        })

        Text('选择座位')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(40)
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      if (this.isLoading || !this.show) {
        Column() {
          Text('加载中...').fontSize(14).fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          // 演出信息卡片
          Column() {
            Row() {
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

              Column() {
                Text(`¥${this.show.price}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF9800')
                Text('起')
                  .fontSize(11)
                  .fontColor('#9E9E9E')
              }
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })

          // 座位图例
          Row({ space: 20 }) {
            Row({ space: 4 }) {
              Text('')
                .width(16)
                .height(16)
                .backgroundColor('#E0E0E0')
                .borderRadius(2)
              Text('已售')
                .fontSize(12)
                .fontColor('#9E9E9E')
            }

            Row({ space: 4 }) {
              Text('')
                .width(16)
                .height(16)
                .backgroundColor('#FFFFFF')
                .border({ width: 1, color: '#CCCCCC', radius: 2 })
              Text('可选')
                .fontSize(12)
                .fontColor('#9E9E9E')
            }

            Row({ space: 4 }) {
              Text('')
                .width(16)
                .height(16)
                .backgroundColor('#FF9800')
                .borderRadius(2)
              Text('已选')
                .fontSize(12)
                .fontColor('#9E9E9E')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 12 })

          // 提示文字
          Text('请选择座位（最多3张）')
            .fontSize(13)
            .fontColor('#FF9800')
            .padding({ top: 8 })

          // 舞台区域
          Column() {
            Text('🏛️ 舞台')
              .fontSize(14)
              .fontColor('#999999')
          }
          .width('80%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .borderRadius({ topLeft: 20, topRight: 20 })
          .justifyContent(FlexAlign.Center)
          .margin({ top: 12, left: 16, right: 16 })

          // 座位选择区
          Scroll() {
            Column() {
              ForEach(this.seats, (rowSeats: Seat[], rowIndex: number) => {
                Row({ space: 4 }) {
                  // 行号
                  Text(String.fromCharCode(65 + rowIndex))
                    .fontSize(10)
                    .fontColor('#9E9E9E')
                    .width(20)
                    .textAlign(TextAlign.Center)

                  ForEach(rowSeats, (seat: Seat, colIndex: number) => {
                    Text('')
                      .width(26)
                      .height(26)
                      .backgroundColor(this.getSeatColor(seat))
                      .border({
                        width: 1,
                        color: this.getSeatBorderColor(seat),
                        radius: 4
                      })
                      .borderRadius(4)
                      .onClick(() => {
                        this.toggleSeat(seat);
                      })
                  })
                }
                .justifyContent(FlexAlign.Center)
                .margin({ bottom: 4 })
              })
            }
            .padding({ top: 8, bottom: 20, right: 6 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .width('100%')
          .scrollBar(BarState.Off)

          // 已选座位信息
          if (this.selectedSeats.length > 0) {
            Column() {
              Row() {
                Text('已选座位：')
                  .fontSize(13)
                  .fontColor('#666666')
                ForEach(this.selectedSeats, (seat: SeatSelection) => {
                  Text(seat.seatNo)
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .backgroundColor('#FF9800')
                    .borderRadius(4)
                    .padding({
                      left: 8,
                      right: 8,
                      top: 2,
                      bottom: 2
                    })
                    .margin({ left: 4 })
                })
              }
              .width('100%')

              Row() {
                Text('服务费：')
                  .fontSize(13)
                  .fontColor('#666666')
                Text(`¥${(this.totalAmount * 0.1).toFixed(0)}`)
                  .fontSize(13)
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: 4 })

              Row() {
                Text('总计：')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Text(`¥${(this.totalAmount * 1.1).toFixed(0)}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF9800')
              }
              .width('100%')
              .margin({ top: 4 })
            }
            .width('100%')
            .backgroundColor('#FFF8E1')
            .borderRadius(8)
            .padding(12)
            .margin({ left: 16, right: 16 })
          }

          // 底部确认按钮
          Column() {
            Divider().color('#E8E8E8')
            Row() {
              Button('确认选座')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor(this.selectedSeats.length > 0 ? '#FF9800' : '#CCCCCC')
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .enabled(this.selectedSeats.length > 0)
                .onClick(() => {
                  this.handleConfirm();
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
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#F5F5F5')
  }
}
