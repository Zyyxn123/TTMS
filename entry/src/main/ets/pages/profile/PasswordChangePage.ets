import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import UserService from '../../model/UserService';

@Entry
@Component
export struct PasswordChangePage {
  @State oldPassword: string = '';
  @State newPassword: string = '';
  @State confirmPassword: string = '';
  @State isSubmitting: boolean = false;

  @State oldError: string = '';
  @State newError: string = '';
  @State confirmError: string = '';

  private clearErrors(): void {
    this.oldError = '';
    this.newError = '';
    this.confirmError = '';
  }

  private validate(): boolean {
    this.clearErrors();
    let valid: boolean = true;

    if (this.oldPassword.trim() === '') {
      this.oldError = '请输入原密码';
      valid = false;
    }
    if (this.newPassword.trim() === '') {
      this.newError = '请输入新密码';
      valid = false;
    } else if (this.newPassword.length < 6) {
      this.newError = '新密码不能少于6位';
      valid = false;
    }
    if (this.confirmPassword.trim() === '') {
      this.confirmError = '请确认新密码';
      valid = false;
    } else if (this.confirmPassword !== this.newPassword) {
      this.confirmError = '两次输入的新密码不一致';
      valid = false;
    }
    return valid;
  }

  private handleSubmit(): void {
    if (!this.validate()) {
      return;
    }
    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';

    this.isSubmitting = true;
    setTimeout(() => {
      this.isSubmitting = false;
      promptAction.showToast({ message: '密码修改成功', duration: 2000 });
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
        Text('修改密码')
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
          Column() {
            Column({ space: 4 }) {
              Text('原密码 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入原密码' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.Password)
                .onChange((value: string) => {
                  this.oldPassword = value;
                  if (this.oldError !== '') this.oldError = '';
                })
              if (this.oldError !== '') {
                Text(this.oldError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
              }
            }

            Column({ space: 4 }) {
              Text('新密码 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入新密码（至少6位）' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.Password)
                .onChange((value: string) => {
                  this.newPassword = value;
                  if (this.newError !== '') this.newError = '';
                })
              if (this.newError !== '') {
                Text(this.newError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
              }
            }

            Column({ space: 4 }) {
              Text('确认新密码 *')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请再次输入新密码' })
                .placeholderColor('#9E9E9E')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(44)
                .padding({ left: 12 })
                .type(InputType.Password)
                .onChange((value: string) => {
                  this.confirmPassword = value;
                  if (this.confirmError !== '') this.confirmError = '';
                })
              if (this.confirmError !== '') {
                Text(this.confirmError).fontSize(12).fontColor('#F44336').alignSelf(ItemAlign.Start)
              }
            }
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)

          // 密码规范提示
          Column() {
            Text('密码规范')
              .fontSize(14)
              .fontColor('#666666')
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 8 })
            Text('密码长度至少6位，建议包含字母和数字')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .alignSelf(ItemAlign.Start)
          }
          .width('100%')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding(12)

          Button('确认修改')
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
