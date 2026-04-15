import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Order, OrderStatus, SeatSelection, Show } from '../model/DataModel';
import { dataService } from '../model/DataService';

// 路由参数接口
interface RouteParams {
  showId: string;
  showName: string;
  venue: string;
  date: string;
  time: string;
  seats: string;
  totalAmount: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: RouteParams;
}

// 订单确认页
@Entry
@Component
struct OrderConfirmPage {
  @State showId: string = '';
  @State showName: string = '';
  @State venue: string = '';
  @State date: string = '';
  @State time: string = '';
  @State seats: SeatSelection[] = [];
  @State totalAmount: number = 0;
  @State userName: string = '';
  @State phone: string = '';
  @State isSubmitting: boolean = false;

  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params) {
      this.showId = params.showId || '';
      this.showName = params.showName || '';
      this.venue = params.venue || '';
      this.date = params.date || '';
      this.time = params.time || '';
      const parsedSeats = params.seats ? JSON.parse(params.seats) as SeatSelection[] : [];
      this.seats = parsedSeats;
      const parsedAmount = parseFloat(params.totalAmount);
      this.totalAmount = isNaN(parsedAmount) ? 0 : parsedAmount;
    }

    const user = dataService.getCurrentUser();
    this.userName = user.name;
    this.phone = user.phone;
  }

  submitOrder(): void {
    const trimmedName = this.userName.trim();
    if (!trimmedName) {
      promptAction.showToast({ message: '请输入取票人姓名' });
      return;
    }
    const phoneRegex = /^1[3-9]\d{9}$/;
    if (!this.phone.trim() || !phoneRegex.test(this.phone.trim())) {
      promptAction.showToast({ message: '请输入正确的手机号' });
      return;
    }

    this.isSubmitting = true;

    const show: Show | undefined = dataService.getShowById(this.showId);
    if (!show) {
      promptAction.showToast({ message: '演出信息不存在' });
      this.isSubmitting = false;
      return;
    }

    const order: Order = dataService.createOrder(show, this.seats);
    order.userName = this.userName;
    order.phone = this.phone;

    const paymentParams: RouteParams = {
      showId: order.id,
      showName: order.totalAmount.toString(),
      venue: '',
      date: '',
      time: '',
      seats: '',
      totalAmount: ''
    };
    const routerOptions: RouterOptions = {
      url: 'pages/PaymentPage',
      params: paymentParams
    };
    router.replaceUrl(routerOptions);
  }

  build() {
    Column() {
      this.buildNavigationBar()

      Scroll() {
        Column() {
          this.buildOrderInfo()
          this.buildSeatsInfo()
          this.buildContactInfo()
          Column().height(100)
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
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
        router.back();
      })

      Blank()

      Text('订单确认')
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
  buildOrderInfo(): void {
    Column() {
      Text('演出信息')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .padding({ left: 16, top: 16, bottom: 12 })

      Row() {
        Column() {
          Text('🎭')
            .fontSize(30)
        }
        .width(70)
        .height(90)
        .backgroundColor('#F8F8F8')
        .borderRadius(8)

        Column() {
          Text(this.showName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.date + ' ' + this.time)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 6 })

          Text(this.venue)
            .fontSize(13)
            .fontColor('#999999')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .height(90)
        .padding({ left: 14 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12 })
  }

  @Builder
  buildSeatsInfo(): void {
    Column() {
      Text('座位信息')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .padding({ left: 16, top: 16, bottom: 12 })

      Column({ space: 10 }) {
        ForEach(this.seats, (seat: SeatSelection) => {
          Row() {
            Text(seat.seatNo)
              .fontSize(15)
              .fontColor('#333333')

            Blank()

            Text('¥' + seat.price)
              .fontSize(15)
              .fontColor('#FF4D4F')
          }
          .width('100%')
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })

      Divider()
        .color('#F0F0F0')
        .margin({ left: 16, right: 16 })

      Row() {
        Text('订单总额')
          .fontSize(15)
          .fontColor('#333333')

        Blank()

        Text() {
          Span('¥')
            .fontSize(14)
            .fontColor('#FF4D4F')
          Span(this.totalAmount.toString())
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF4D4F')
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12 })
  }

  @Builder
  buildContactInfo(): void {
    Column() {
      Text('取票人信息')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .padding({ left: 16, top: 16, bottom: 12 })

      Row() {
        Text('姓名')
          .fontSize(15)
          .fontColor('#333333')
          .width(60)

        TextInput({ placeholder: '请输入取票人姓名', text: this.userName })
          .placeholderColor('#BBBBBB')
          .fontSize(15)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.userName = value;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      Divider()
        .color('#F0F0F0')
        .margin({ left: 16, right: 16, top: 14 })

      Row() {
        Text('手机号')
          .fontSize(15)
          .fontColor('#333333')
          .width(60)

        TextInput({ placeholder: '请输入手机号', text: this.phone })
          .placeholderColor('#BBBBBB')
          .fontSize(15)
          .type(InputType.PhoneNumber)
          .maxLength(11)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.phone = value;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12 })
  }

  @Builder
  buildBottomBar(): void {
    Row() {
      Button('提交订单')
        .fontSize(16)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#FF4D4F')
        .borderRadius(22)
        .width('100%')
        .height(44)
        .onClick(() => {
          this.submitOrder();
        })
    }
    .width('100%')
    .height(70)
    .padding({ left: 20, right: 20 })
    .backgroundColor(Color.White)
  }
}
