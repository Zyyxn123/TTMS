import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Ticket, AdminRole, OperationResult } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct TicketRefundPage {
  @State ticket: Ticket | null = null;
  @State ticketId: string = '';
  @State orderNo: string = '';
  @State refundReason: string = '';
  @State refundAmount: string = '';
  @State isSubmitting: boolean = false;
  @State orderFound: boolean = false;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  aboutToAppear(): void {
    const params: Record<string, string> = router.getParams() as Record<string, string> ?? {};
    this.ticketId = params['ticketId'] ?? '';
    if (this.ticketId !== '') {
      const found: Ticket | undefined = dataService.getTicketById(this.ticketId);
      if (found) {
        this.ticket = found;
        this.refundAmount = String(found.price);
      }
    }
  }

  private handleSearch(): void {
    if (this.orderNo.trim() === '') {
      promptAction.showToast({ message: '请输入订单号', duration: 2000 });
      return;
    }
    this.orderFound = true;
    promptAction.showToast({ message: '找到订单，退款处理中...', duration: 2000 });
  }

  private handleSubmit(): void {
    if (!this.orderFound) {
      promptAction.showToast({ message: '请先查询订单', duration: 2000 });
      return;
    }
    if (this.refundReason.trim() === '') {
      promptAction.showToast({ message: '请填写退款原因', duration: 2000 });
      return;
    }
    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;

    this.isSubmitting = true;
    UserService.addLog('退票操作', operatorName, role,
      this.ticket !== null ? this.ticket!.showName : '未知演出',
      `订单号：${this.orderNo}，退款金额：¥${this.refundAmount}，原因：${this.refundReason}`,
      OperationResult.SUCCESS);

    setTimeout(() => {
      if (this.ticket !== null) {
        dataService.updateTicket(this.ticketId, {
          soldCount: Math.max(0, this.ticket!.soldCount - 1),
          remainingCount: this.ticket!.remainingCount + 1
        });
      }
      this.isSubmitting = false;
      promptAction.showToast({ message: '退款成功', duration: 2000 });
      router.back();
    }, 800);
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('退票')
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

      Scroll() {
        Column({ space: 16 }) {
          // 票务信息
          if (this.ticket !== null) {
            Column() {
              Text(this.ticket.showName)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text(`${this.ticket.showDate} ${this.ticket.showTime} · ${this.ticket.venue}`)
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
              Row() {
                Text('票价：')
                  .fontSize(13)
                  .fontColor('#9E9E9E')
                Text(`¥${this.ticket.price}`)
                  .fontSize(13)
                  .fontColor('#1E88E5')
              }
              .width('100%')
              .margin({ top: 4 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
          }

          // 订单查询
          Column({ space: 12 }) {
            Text('订单查询')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .alignSelf(ItemAlign.Start)

            Row() {
              TextInput({ placeholder: '请输入订单号' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .padding({ left: 12 })
                .onChange((value: string) => {
                  this.orderNo = value;
                })
              Button('查询')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#1E88E5')
                .borderRadius(8)
                .height(44)
                .width(80)
                .onClick(() => { this.handleSearch(); })
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          // 退款信息
          Column({ space: 12 }) {
            Text('退款信息')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .alignSelf(ItemAlign.Start)

            Column({ space: 4 }) {
              Text('退款金额 (元)')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入退款金额' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.refundAmount = value;
                })
            }

            Column({ space: 4 }) {
              Text('退款原因 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextArea({ placeholder: '请详细描述退款原因' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(80)
                .padding(12)
                .onChange((value: string) => {
                  this.refundReason = value;
                })
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          // 退款说明
          Column() {
            Text('退款说明')
              .fontSize(14)
              .fontColor('#9E9E9E')
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 8 })
            Text('1. 退款将在1-7个工作日内原路退回\n2. 已过演出时间的订单不可退款\n3. 如有疑问请联系客服')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .lineHeight(18)
          }
          .width('100%')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding(12)
          .margin({ bottom: 8 })

          Button('确认退款')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(8)
            .onClick(() => { this.handleSubmit(); })

          if (this.isSubmitting) {
            LoadingProgress()
              .width(24)
              .height(24)
              .color('#FF9800')
              .margin({ top: 12 })
          }
        }
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
