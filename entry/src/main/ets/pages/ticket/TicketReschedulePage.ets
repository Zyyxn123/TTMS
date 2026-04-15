import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Ticket, AdminRole, OperationResult } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct TicketReschedulePage {
  @State ticket: Ticket | null = null;
  @State ticketId: string = '';
  @State customerName: string = '';
  @State customerPhone: string = '';
  @State originalShowDate: string = '';
  @State newShowDate: string = '';
  @State newShowTime: string = '';
  @State rescheduleFee: string = '0';
  @State isSubmitting: boolean = false;
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
        this.originalShowDate = found.showDate;
      }
    }
  }

  private handleSubmit(): void {
    if (this.customerName.trim() === '') {
      promptAction.showToast({ message: '请输入观众姓名', duration: 2000 });
      return;
    }
    if (this.customerPhone.trim() === '') {
      promptAction.showToast({ message: '请输入手机号', duration: 2000 });
      return;
    }
    if (this.newShowDate.trim() === '') {
      promptAction.showToast({ message: '请选择新的演出日期', duration: 2000 });
      return;
    }

    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;

    this.isSubmitting = true;
    UserService.addLog('改签操作', operatorName, role,
      this.ticket !== null ? this.ticket!.showName : '未知演出',
      `观众：${this.customerName}，原日期：${this.originalShowDate}，新日期：${this.newShowDate}，改签费：¥${this.rescheduleFee}`,
      OperationResult.SUCCESS);

    setTimeout(() => {
      this.isSubmitting = false;
      promptAction.showToast({ message: '改签成功', duration: 2000 });
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
        Text('改签')
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
          if (this.ticket !== null) {
            Column() {
              Text(this.ticket.showName)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text(`${this.ticket.venue}`)
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
          }

          // 观众信息
          Column({ space: 12 }) {
            Text('观众信息')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .alignSelf(ItemAlign.Start)

            Column({ space: 4 }) {
              Text('观众姓名')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入观众姓名' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .onChange((value: string) => { this.customerName = value; })
            }

            Column({ space: 4 }) {
              Text('手机号码')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入手机号码' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.PhoneNumber)
                .onChange((value: string) => { this.customerPhone = value; })
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          // 改签信息
          Column({ space: 12 }) {
            Text('改签信息')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .alignSelf(ItemAlign.Start)

            Row() {
              Text('原演出日期')
                .fontSize(14)
                .fontColor('#666666')
              Text(this.originalShowDate)
                .fontSize(14)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ top: 8, bottom: 8 })

            Divider()

            Column({ space: 4 }) {
              Text('新演出日期 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入新演出日期，如 2026-05-25' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .onChange((value: string) => { this.newShowDate = value; })
            }

            Column({ space: 4 }) {
              Text('新演出时间')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入新演出时间，如 20:00' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .onChange((value: string) => { this.newShowTime = value; })
            }

            Column({ space: 4 }) {
              Text('改签手续费 (元)')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '0' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.Number)
                .onChange((value: string) => { this.rescheduleFee = value; })
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          Button('确认改签')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#1E88E5')
            .borderRadius(8)
            .onClick(() => { this.handleSubmit(); })

          if (this.isSubmitting) {
            LoadingProgress()
              .width(24)
              .height(24)
              .color('#1E88E5')
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
