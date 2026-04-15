import { Seat, SeatType, SeatStatus } from '../model/DataModel';

export type ConfirmActionCallback = () => void;

// 座位图
@Component
export struct SeatMap {
  @Prop seats: Seat[][] = [];
  @Link selectedSeats: Seat[];
  @Prop maxSelect: number = 4;

  getSeatColor(seat: Seat): string {
    switch (seat.status) {
      case SeatStatus.SOLD: return '#E0E0E0';
      case SeatStatus.SELECTED: return '#FF4D4F';
      case SeatStatus.LOCKED: return '#FFE4B5';
      default:
        switch (seat.type) {
          case SeatType.VIP: return '#FFD700';
          case SeatType.PREMIUM: return '#FF69B4';
          case SeatType.STANDARD: return '#4CAF50';
          case SeatType.ECONOMY: return '#90CAF9';
          default: return '#4CAF50';
        }
    }
  }

  getSeatLabel(row: number, col: number): string {
    return String.fromCharCode(65 + row) + (col + 1).toString();
  }

  private handleSeatClick(seat: Seat): void {
    if (seat.status === SeatStatus.SOLD || seat.status === SeatStatus.LOCKED) {
      return;
    }
    if (seat.status === SeatStatus.SELECTED) {
      seat.status = SeatStatus.AVAILABLE;
      const filtered: Seat[] = this.selectedSeats.filter((s: Seat): boolean =>
        !(s.row === seat.row && s.col === seat.col)
      );
      this.selectedSeats = filtered;
    } else {
      if (this.selectedSeats.length >= this.maxSelect) {
        return;
      }
      seat.status = SeatStatus.SELECTED;
      const updated: Seat[] = [...this.selectedSeats, seat];
      this.selectedSeats = updated;
    }
  }

  build() {
    Column({ space: 8 }) {
      Column() {
        Text('舞 台')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#999')
      }
      .width('80%')
      .height(40)
      .backgroundColor('#F0F0F0')
      .borderRadius({ topLeft: 100, topRight: 100 })
      .margin({ bottom: 20 })

      Column({ space: 6 }) {
        ForEach(this.seats, (rowSeats: Seat[], rowIndex: number) => {
          Row({ space: 4 }) {
            Text(String.fromCharCode(65 + rowIndex))
              .fontSize(10)
              .fontColor('#999')
              .width(20)
              .textAlign(TextAlign.Center)

            ForEach(rowSeats, (seat: Seat) => {
              Column() {
                Text(this.getSeatLabel(rowIndex, seat.col))
                  .fontSize(8)
                  .fontColor(seat.status === SeatStatus.SELECTED ? Color.White : '#666')
              }
              .width(24)
              .height(24)
              .backgroundColor(this.getSeatColor(seat))
              .borderRadius(4)
              .onClick(() => {
                this.handleSeatClick(seat);
              })
            })
          }
          .width('100%')
        })
      }
      .width('100%')

      Row({ space: 16 }) {
        this.buildLegend('#FFD700', 'VIP ¥880')
        this.buildLegend('#FF69B4', '贵宾 ¥580')
        this.buildLegend('#4CAF50', '普通 ¥380')
        this.buildLegend('#90CAF9', '经济 ¥180')
      }
      .margin({ top: 20 })
      .justifyContent(FlexAlign.Center)

      Row({ space: 16 }) {
        this.buildLegend('#E0E0E0', '已售')
        this.buildLegend('#FF4D4F', '已选')
      }
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
  }

  @Builder
  buildLegend(color: string, label: string): void {
    Row() {
      Column()
        .width(16)
        .height(16)
        .backgroundColor(color)
        .borderRadius(2)
      Text(label)
        .fontSize(11)
        .fontColor('#666')
        .margin({ left: 4 })
    }
  }
}

// 底部确认栏
@Component
export struct SeatSelectionConfirm {
  @Prop selectedSeats: Seat[] = [];
  @Prop totalAmount: number = 0;
  onConfirm: ConfirmActionCallback = () => {};

  build() {
    Column() {
      if (this.selectedSeats.length > 0) {
        Row() {
          Column() {
            Text('已选座位')
              .fontSize(13)
              .fontColor('#666')
            Text(this.selectedSeats.length + '张')
              .fontSize(12)
              .fontColor('#999')
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)

          Blank()
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12 })

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.selectedSeats, (seat: Seat) => {
            Text(String.fromCharCode(65 + seat.row) + '排' + (seat.col + 1) + '座')
              .fontSize(12)
              .fontColor('#FF4D4F')
              .padding(6)
              .backgroundColor('#FFF1F0')
              .borderRadius(4)
          })
        }
        .padding({ left: 16, right: 16, top: 8 })

        Divider()
          .color('#F0F0F0')
          .margin({ top: 12 })
      }

      Row() {
        Column() {
          Text('合计: ')
            .fontSize(14)
            .fontColor('#666')
          Text('¥' + this.totalAmount)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF4D4F')
        }

        Blank()

        Button('确认购票')
          .fontSize(15)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.selectedSeats.length > 0 ? '#FF4D4F' : '#CCC')
          .borderRadius(20)
          .width(120)
          .height(40)
          .enabled(this.selectedSeats.length > 0)
          .onClick(() => {
            this.onConfirm();
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
}
