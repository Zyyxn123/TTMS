import router from '@ohos.router';
import { Seat, SeatType, SeatStatus, SeatSelection } from '../model/DataModel';
import { dataService } from '../model/DataService';
import { SeatMap, SeatSelectionConfirm } from '../components/SeatMap';

// 路由参数接口
interface RouteParams {
  showId: string;
  showName: string;
  venue: string;
  date: string;
  time: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: RouteConfirmParams;
}

// 订单确认路由参数
interface RouteConfirmParams {
  showId: string;
  showName: string;
  venue: string;
  date: string;
  time: string;
  seats: string;
  totalAmount: string;
}

// 选座页面
@Entry
@Component
struct SeatSelectionPage {
  @State showId: string = '';
  @State showName: string = '';
  @State venue: string = '';
  @State date: string = '';
  @State time: string = '';
  @State seats: Seat[][] = [];
  @State selectedSeats: Seat[] = [];
  @State totalAmount: number = 0;
  @State isLoading: boolean = true;
  @State showConfirm: boolean = false;
  @Prop maxSelect: number = 4;

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    if (params) {
      this.showId = params.showId || '';
      this.showName = params.showName || '';
      this.venue = params.venue || '';
      this.date = params.date || '';
      this.time = params.time || '';
    }
    this.loadSeats();
  }

  loadSeats(): void {
    this.seats = dataService.getSeats(this.showId);
    this.isLoading = false;
  }

  calculateTotal(): void {
    this.totalAmount = this.selectedSeats.reduce((sum: number, seat: Seat): number => sum + seat.price, 0);
  }

  clearSelection(): void {
    const copySeats: Seat[] = [...this.selectedSeats];
    copySeats.forEach((selected: Seat): void => {
      const seat: Seat = this.seats[selected.row][selected.col];
      if (seat !== null) {
        seat.status = SeatStatus.AVAILABLE;
      }
    });
    this.selectedSeats = [];
    this.totalAmount = 0;
  }

  confirmOrder(): void {
    if (this.selectedSeats.length === 0) {
      return;
    }

    const seatInfo: SeatSelection[] = this.selectedSeats.map((seat: Seat): SeatSelection => {
      const selection: SeatSelection = {
        row: seat.row,
        col: seat.col,
        price: seat.price,
        seatNo: String.fromCharCode(65 + seat.row) + '排' + (seat.col + 1) + '座'
      };
      return selection;
    });

    const routeParams: RouteConfirmParams = {
      showId: this.showId,
      showName: this.showName,
      venue: this.venue,
      date: this.date,
      time: this.time,
      seats: JSON.stringify(seatInfo),
      totalAmount: this.totalAmount.toString()
    };

    const routerOptions: RouterOptions = {
      url: 'pages/OrderConfirm',
      params: routeParams
    };

    router.pushUrl(routerOptions);
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.buildNavigationBar()
        this.buildShowInfo()

        if (this.isLoading) {
          Column() {
            LoadingProgress()
              .width(48)
              .height(48)
              .color('#FF4D4F')
            Text('加载座位图...')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          Column() {
            Text('选择座位')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .padding({ top: 16, bottom: 8 })
            Scroll() {
              Column() {
                SeatMap({
                  seats: this.seats,
                  selectedSeats: $selectedSeats,
                  maxSelect: this.maxSelect
                })
              }
              .padding({
                left: 16,
                right: 16,
                top: 16,
                bottom: 20
              })
            }
            .width('100%')
            .layoutWeight(1)
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor(Color.White)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      SeatSelectionConfirm({
        selectedSeats: this.selectedSeats,
        totalAmount: this.totalAmount,
        onConfirm: (): void => {
          this.confirmOrder();
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildNavigationBar(): void {
    Row() {
      Row() {
        Text('<')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
      }
      .width(40)
      .height(40)
      .backgroundColor('#FFFFFF80')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        router.back();
      })

      Blank()

      Text('选择座位')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')

      Blank()

      Text('')
        .width(40)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  @Builder
  buildShowInfo(): void {
    Row() {
      Column() {
        Text('🎭')
          .fontSize(24)
      }
      .width(50)
      .height(65)
      .backgroundColor('#F8F8F8')
      .borderRadius(6)

      Column() {
        Text(this.showName)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .maxLines(1)
        Text(this.date + ' ' + this.time)
          .fontSize(13)
          .fontColor('#666')
          .margin({ top: 4 })
        Text(this.venue)
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .padding({ left: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
  }
}
