import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Ticket, AdminRole, OperationResult } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct TicketOutPage {
  @State ticket: Ticket | null = null;
  @State ticketId: string = '';
  @State customerName: string = '';
  @State customerPhone: string = '';
  @State seatInfo: string = '';
  @State seatCount: string = '1';
  @State selectedPrice: string = '';
  @State isSubmitting: boolean = false;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  @State nameError: string = '';
  @State phoneError: string = '';
  @State seatError: string = '';

  aboutToAppear(): void {
    const params: Record<string, string> = router.getParams() as Record<string, string> ?? {};
    this.ticketId = params['ticketId'] ?? '';
    this.loadData();
  }

  private loadData(): void {
    if (this.ticketId !== '') {
      const found: Ticket | undefined = dataService.getTicketById(this.ticketId);
      if (found) {
        this.ticket = found;
        this.selectedPrice = String(found.price);
      }
    }
  }

  private clearErrors(): void {
    this.nameError = '';
    this.phoneError = '';
    this.seatError = '';
  }

  private validate(): boolean {
    this.clearErrors();
    let valid: boolean = true;
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;

    if (this.customerName.trim() === '') {
      this.nameError = '请输入观众姓名';
      valid = false;
    }
    if (this.customerPhone.trim() === '') {
      this.phoneError = '请输入手机号';
      valid = false;
    } else if (!phoneRegex.test(this.customerPhone.trim())) {
      this.phoneError = '手机号格式不正确';
      valid = false;
    }
    if (this.seatCount.trim() === '' || Number(this.seatCount) <= 0) {
      this.seatError = '请输入出票数量';
      valid = false;
    }
    return valid;
  }

  private handleSubmit(): void {
    if (!this.validate()) {
      return;
    }
    if (this.ticket === null) return;

    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;
    const count: number = Number(this.seatCount);
    const newSoldCount: number = this.ticket.soldCount + count;
    const newRemaining: number = this.ticket.remainingCount - count;

    this.isSubmitting = true;
    UserService.addLog('出票操作', operatorName, role, this.ticket.showName,
      `观众：${this.customerName}，数量：${count}张，票价：¥${this.selectedPrice}，联系方式：${this.customerPhone}`,
      OperationResult.SUCCESS);

    setTimeout(() => {
      dataService.updateTicket(this.ticketId, {
        soldCount: newSoldCount,
        remainingCount: newRemaining > 0 ? newRemaining : 0
      });
      this.isSubmitting = false;
      promptAction.showToast({ message: '出票成功', duration: 2000 });
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
        Text('出票')
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

      if (this.ticket === null) {
        Column() {
          Text('票务信息不存在')
            .fontSize(16)
            .fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 16 }) {
            // 票务信息
            Column() {
              Row() {
                Text(this.ticket.showName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)
                Text(`${this.ticket.remainingCount}张可售`)
                  .fontSize(12)
                  .fontColor(this.ticket.remainingCount > 0 ? '#4CAF50' : '#F44336')
              }
              Row() {
                Text(`${this.ticket.showDate} ${this.ticket.showTime}`)
                  .fontSize(13)
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: 4 })
              Row() {
                Text(this.ticket.venue)
                  .fontSize(13)
                  .fontColor('#9E9E9E')
              }
              .width('100%')
              .margin({ top: 2 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 观众信息表单
            Column({ space: 12 }) {
              Text('观众信息')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)

              Column({ space: 4 }) {
                Text('观众姓名 *')
                  .fontSize(13)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)
                TextInput({ placeholder: '请输入观众姓名' })
                  .placeholderColor('#9E9E9E')
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .backgroundColor('#F5F5F5')
                  .borderRadius(8)
                  .height(44)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.customerName = value;
                    if (this.nameError !== '') this.nameError = '';
                  })
                if (this.nameError !== '') {
                  Text(this.nameError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
                }
              }

              Column({ space: 4 }) {
                Text('手机号码 *')
                  .fontSize(13)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)
                TextInput({ placeholder: '请输入手机号码' })
                  .placeholderColor('#9E9E9E')
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .backgroundColor('#F5F5F5')
                  .borderRadius(8)
                  .height(44)
                  .padding({ left: 12, right: 12 })
                  .type(InputType.PhoneNumber)
                  .onChange((value: string) => {
                    this.customerPhone = value;
                    if (this.phoneError !== '') this.phoneError = '';
                  })
                if (this.phoneError !== '') {
                  Text(this.phoneError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
                }
              }

              Row({ space: 12 }) {
                Column({ space: 4 }) {
                  Text('出票数量 *')
                    .fontSize(13)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)
                  TextInput({ placeholder: '1', text: this.seatCount })
                    .placeholderColor('#9E9E9E')
                    .fontSize(15)
                    .fontColor('#1A1A1A')
                    .backgroundColor('#F5F5F5')
                    .borderRadius(8)
                    .height(44)
                    .padding({ left: 12, right: 12 })
                    .type(InputType.Number)
                    .onChange((value: string) => {
                      this.seatCount = value;
                      if (this.seatError !== '') this.seatError = '';
                    })
                  if (this.seatError !== '') {
                    Text(this.seatError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
                  }
                }
                .layoutWeight(1)

                Column({ space: 4 }) {
                  Text('单价 (元)')
                    .fontSize(13)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)
                  TextInput({ placeholder: String(this.ticket.price), text: this.selectedPrice !== '' ? this.selectedPrice : String(this.ticket.price) })
                    .fontSize(15)
                    .fontColor('#1A1A1A')
                    .backgroundColor('#F5F5F5')
                    .borderRadius(8)
                    .height(44)
                    .padding({ left: 12, right: 12 })
                    .type(InputType.Number)
                    .onChange((value: string) => {
                      this.selectedPrice = value;
                    })
                }
                .layoutWeight(1)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 费用汇总
            Column() {
              Text('费用汇总')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Row() {
                Text('票数')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`${this.seatCount || 0} 张`)
                  .fontSize(14)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                Text('单价')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`¥${this.selectedPrice || 0}`)
                  .fontSize(14)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 8 })

              Divider()
                .margin({ bottom: 8 })

              Row() {
                Text('合计')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Text(`¥${((Number(this.seatCount) || 0) * (Number(this.selectedPrice) || 0)).toLocaleString()}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1E88E5')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            Button('确认出票')
              .width('100%')
              .height(48)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#4CAF50')
              .borderRadius(8)
              .onClick(() => { this.handleSubmit(); })

            if (this.isSubmitting) {
              LoadingProgress()
                .width(24)
                .height(24)
                .color('#4CAF50')
                .margin({ top: 12 })
            }
          }
          .padding(16)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
