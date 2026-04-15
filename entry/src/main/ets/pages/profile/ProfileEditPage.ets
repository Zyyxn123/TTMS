import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { AdminUser } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct ProfileEditPage {
  @State user: AdminUser | null = null;
  @State name: string = '';
  @State phone: string = '';
  @State email: string = '';
  @State isSubmitting: boolean = false;

  aboutToAppear(): void {
    this.user = UserService.getCurrentUser();
    if (this.user !== null) {
      this.name = this.user.name;
      this.phone = this.user.phone;
      this.email = this.user.email ?? '';
    }
  }

  private handleSubmit(): void {
    if (this.name.trim() === '') {
      promptAction.showToast({ message: '姓名不能为空', duration: 2000 });
      return;
    }
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(this.phone.trim())) {
      promptAction.showToast({ message: '手机号格式不正确', duration: 2000 });
      return;
    }
    this.isSubmitting = true;
    setTimeout(() => {
      this.isSubmitting = false;
      promptAction.showToast({ message: '个人信息已更新', duration: 2000 });
      router.back();
    }, 600);
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('个人信息编辑')
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

      Scroll() {
        Column({ space: 16 }) {
          // 头像区
          Column() {
            Text('👤')
              .fontSize(56)
              .backgroundColor('#E3F2FD')
              .borderRadius(40)
              .width(80)
              .height(80)
              .textAlign(TextAlign.Center)
            Text('点击更换头像')
              .fontSize(12)
              .fontColor('#1E88E5')
              .margin({ top: 8 })
          }
          .width('100%')
          .padding({ top: 24, bottom: 16 })

          // 表单
          Column({ space: 12 }) {
            Column({ space: 4 }) {
              Text('账号')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              Text(this.user?.username ?? '')
                .fontSize(15)
                .fontColor('#9E9E9E')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .width('100%')
            }

            Column({ space: 4 }) {
              Text('姓名 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入姓名', text: this.name })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .onChange((value: string) => { this.name = value; })
            }

            Column({ space: 4 }) {
              Text('手机号 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入手机号', text: this.phone })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.PhoneNumber)
                .onChange((value: string) => { this.phone = value; })
            }

            Column({ space: 4 }) {
              Text('邮箱')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入邮箱', text: this.email })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .onChange((value: string) => { this.email = value; })
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          Button('保存修改')
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
