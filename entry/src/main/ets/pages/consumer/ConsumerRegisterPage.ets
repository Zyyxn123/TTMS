import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { consumerUserService } from '../../model/ConsumerUserService';

/**
 * 消费端注册页
 */
@Entry
@Component
export struct ConsumerRegisterPage {
  @State phone: string = '';
  @State verifyCode: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isLoading: boolean = false;
  @State countdown: number = 0;
  @State agreedToTerms: boolean = false;

  @State phoneError: string = '';
  @State codeError: string = '';
  @State passwordError: string = '';
  @State confirmError: string = '';

  private countdownTimer: number = -1;

  aboutToDisappear(): void {
    if (this.countdownTimer !== -1) {
      clearInterval(this.countdownTimer);
    }
  }

  private clearErrors(): void {
    this.phoneError = '';
    this.codeError = '';
    this.passwordError = '';
    this.confirmError = '';
  }

  private validatePhone(): boolean {
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (this.phone.trim() === '') {
      this.phoneError = '请输入手机号';
      return false;
    } else if (!phoneRegex.test(this.phone.trim())) {
      this.phoneError = '手机号格式不正确';
      return false;
    }
    return true;
  }

  private handleSendCode(): void {
    if (!this.validatePhone()) {
      return;
    }
    this.countdown = 60;
    consumerUserService.sendVerifyCode(this.phone);
    promptAction.showToast({ message: '验证码已发送', duration: 2000 });
    this.countdownTimer = setInterval(() => {
      this.countdown--;
      if (this.countdown <= 0) {
        clearInterval(this.countdownTimer);
        this.countdownTimer = -1;
      }
    }, 1000) as number;
  }

  private handleRegister(): void {
    this.clearErrors();
    let valid: boolean = true;

    if (!this.validatePhone()) {
      valid = false;
    }

    if (this.verifyCode.trim() === '') {
      this.codeError = '请输入验证码';
      valid = false;
    } else if (this.verifyCode.length !== 6) {
      this.codeError = '验证码为6位数字';
      valid = false;
    }

    if (this.password.trim() === '') {
      this.passwordError = '请输入密码';
      valid = false;
    } else if (this.password.length < 6) {
      this.passwordError = '密码至少6位';
      valid = false;
    }

    if (this.confirmPassword.trim() === '') {
      this.confirmError = '请确认密码';
      valid = false;
    } else if (this.confirmPassword !== this.password) {
      this.confirmError = '两次密码不一致';
      valid = false;
    }

    if (!this.agreedToTerms) {
      promptAction.showToast({ message: '请阅读并同意用户协议', duration: 2000 });
      return;
    }

    if (!valid) {
      return;
    }

    this.isLoading = true;

    setTimeout(() => {
      const user = consumerUserService.register(
        this.phone.trim(),
        this.password.trim(),
        this.verifyCode.trim()
      );

      this.isLoading = false;

      if (user) {
        promptAction.showToast({ message: '注册成功，欢迎加入！', duration: 2000 });
        router.back();
      } else {
        this.phoneError = '该手机号已注册，请直接登录';
      }
    }, 800);
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
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => { router.back(); })

        Text('注册账号')
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
          // 提示文字
          Column() {
            Text('🎫')
              .fontSize(40)
            Text('加入TTMS，开启精彩演出之旅')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 12 })
          }
          .width('100%')
          .padding({ top: 30, bottom: 20 })

          // 手机号
          Column({ space: 6 }) {
            Text('手机号')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            Row() {
              TextInput({ placeholder: '请输入手机号', text: this.phone })
                .placeholderColor('#CCCCCC')
                .fontSize(16)
                .fontColor('#1A1A1A')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .height(44)
                .type(InputType.PhoneNumber)
                .onChange((value: string) => {
                  this.phone = value;
                  if (this.phoneError !== '') this.phoneError = '';
                })

              Button(this.countdown > 0 ? `${this.countdown}s` : '获取验证码')
                .fontSize(13)
                .fontColor('#FF9800')
                .backgroundColor('#FFF3E0')
                .border({ width: 1, color: '#FF9800' })
                .borderRadius(8)
                .height(36)
                .padding({ left: 12, right: 12 })
                .enabled(this.countdown === 0)
                .opacity(this.countdown === 0 ? 1 : 0.6)
                .onClick(() => { this.handleSendCode(); })
            }
            .backgroundColor('#FAFAFA')
            .borderRadius(10)
            .padding({ left: 14, right: 14 })

            if (this.phoneError !== '') {
              Text(this.phoneError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
            }
          }
          .width('100%')

          // 验证码
          Column({ space: 6 }) {
            Text('验证码')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: '请输入6位验证码', text: this.verifyCode })
              .placeholderColor('#CCCCCC')
              .fontSize(16)
              .fontColor('#1A1A1A')
              .backgroundColor('#FAFAFA')
              .borderRadius(10)
              .height(48)
              .padding({ left: 14 })
              .type(InputType.Number)
              .maxLength(6)
              .onChange((value: string) => {
                this.verifyCode = value;
                if (this.codeError !== '') this.codeError = '';
              })

            if (this.codeError !== '') {
              Text(this.codeError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
            }
          }
          .width('100%')

          // 密码
          Column({ space: 6 }) {
            Text('设置密码')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: '请设置密码（至少6位）', text: this.password })
              .placeholderColor('#CCCCCC')
              .fontSize(16)
              .fontColor('#1A1A1A')
              .backgroundColor('#FAFAFA')
              .borderRadius(10)
              .height(48)
              .padding({ left: 14 })
              .type(InputType.Password)
              .onChange((value: string) => {
                this.password = value;
                if (this.passwordError !== '') this.passwordError = '';
              })

            if (this.passwordError !== '') {
              Text(this.passwordError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
            }
          }
          .width('100%')

          // 确认密码
          Column({ space: 6 }) {
            Text('确认密码')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: '请再次输入密码', text: this.confirmPassword })
              .placeholderColor('#CCCCCC')
              .fontSize(16)
              .fontColor('#1A1A1A')
              .backgroundColor('#FAFAFA')
              .borderRadius(10)
              .height(48)
              .padding({ left: 14 })
              .type(InputType.Password)
              .onChange((value: string) => {
                this.confirmPassword = value;
                if (this.confirmError !== '') this.confirmError = '';
              })

            if (this.confirmError !== '') {
              Text(this.confirmError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
            }
          }
          .width('100%')

          // 用户协议
          Row() {
            Checkbox()
              .select(this.agreedToTerms)
              .selectedColor('#FF9800')
              .onChange((value: boolean) => { this.agreedToTerms = value; })
            Text('我已阅读并同意')
              .fontSize(12)
              .fontColor('#666666')
            Text('《用户协议》')
              .fontSize(12)
              .fontColor('#FF9800')
              .onClick(() => {
                promptAction.showToast({ message: '用户协议页面开发中', duration: 2000 });
              })
            Text('和')
              .fontSize(12)
              .fontColor('#666666')
            Text('《隐私政策》')
              .fontSize(12)
              .fontColor('#FF9800')
              .onClick(() => {
                promptAction.showToast({ message: '隐私政策页面开发中', duration: 2000 });
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 8 })

          // 注册按钮
          Button('注册')
            .width('100%')
            .height(50)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(12)
            .enabled(!this.isLoading)
            .opacity(this.isLoading ? 0.7 : 1)
            .margin({ top: 20 })
            .onClick(() => { this.handleRegister(); })

          if (this.isLoading) {
            Row({ space: 8 }) {
              LoadingProgress()
                .width(18)
                .height(18)
                .color('#FFFFFF')
              Text('注册中...')
                .fontSize(14)
                .fontColor('#FFFFFF')
            }
            .margin({ top: 12 })
          }

          // 已有账号
          Row() {
            Text('已有账号？')
              .fontSize(14)
              .fontColor('#999999')
            Text('立即登录')
              .fontSize(14)
              .fontColor('#FF9800')
              .fontWeight(FontWeight.Bold)
              .onClick(() => { router.back(); })
          }
          .margin({ top: 24, bottom: 40 })
        }
        .width('85%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
