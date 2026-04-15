import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { consumerUserService } from '../../model/ConsumerUserService';
import { ConsumerUser } from '../../model/DataModel';

/**
 * 消费端登录页
 */
@Entry
@Component
export struct ConsumerLoginPage {
  @State phone: string = '';
  @State password: string = '';
  @State verifyCode: string = '';
  @State rememberPassword: boolean = false;
  @State isLoading: boolean = false;
  @State loginType: string = 'password'; // password | code
  @State phoneError: string = '';
  @State passwordError: string = '';
  @State countdown: number = 0;

  private countdownTimer: number = -1;

  aboutToAppear(): void {
    // 检查是否记住密码
    this.rememberPassword = consumerUserService.getIsRemembered();
    if (this.rememberPassword) {
      const user = consumerUserService.getCurrentUser();
      if (user) {
        this.phone = user.phone;
      }
    }
  }

  aboutToDisappear(): void {
    if (this.countdownTimer !== -1) {
      clearInterval(this.countdownTimer);
    }
  }

  private clearErrors(): void {
    this.phoneError = '';
    this.passwordError = '';
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

  private handleLogin(): void {
    this.clearErrors();
    if (!this.validatePhone()) {
      return;
    }
    if (this.loginType === 'password' && this.password.trim() === '') {
      this.passwordError = '请输入密码';
      return;
    }
    if (this.loginType === 'code' && this.verifyCode.trim() === '') {
      this.passwordError = '请输入验证码';
      return;
    }

    this.isLoading = true;

    setTimeout(() => {
      let user: ConsumerUser | null = null;

      if (this.loginType === 'password') {
        user = consumerUserService.login(this.phone.trim(), this.password.trim());
      } else {
        user = consumerUserService.loginWithCode(this.phone.trim(), this.verifyCode.trim());
      }

      this.isLoading = false;

      if (user) {
        consumerUserService.setRemembered(this.rememberPassword);
        promptAction.showToast({ message: `欢迎，${user.name}！`, duration: 2000 });
        router.replaceUrl({ url: 'pages/consumer/ConsumerMainPage' });
      } else {
        if (this.loginType === 'password') {
          this.passwordError = '手机号或密码错误';
        } else {
          this.passwordError = '验证码错误';
        }
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

        Text('用户登录')
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
        Column({ space: 20 }) {
          // Logo区域
          Column({ space: 8 }) {
            Text('🎫')
              .fontSize(48)
            Text('TTMS')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
            Text('便捷购票，轻松享受精彩演出')
              .fontSize(13)
              .fontColor('#999999')
              .margin({ top: 4 })
          }
          .width('100%')
          .margin({ top: 40, bottom: 20 })

          // 登录方式切换
          Row({ space: 20 }) {
            Text('密码登录')
              .fontSize(14)
              .fontColor(this.loginType === 'password' ? '#FF9800' : '#999999')
              .fontWeight(this.loginType === 'password' ? FontWeight.Bold : FontWeight.Normal)
              .onClick(() => { this.loginType = 'password'; })

            Text('|')
              .fontSize(14)
              .fontColor('#DDDDDD')

            Text('验证码登录')
              .fontSize(14)
              .fontColor(this.loginType === 'code' ? '#FF9800' : '#999999')
              .fontWeight(this.loginType === 'code' ? FontWeight.Bold : FontWeight.Normal)
              .onClick(() => { this.loginType = 'code'; })
          }
          .margin({ bottom: 10 })

          // 手机号输入
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

              if (this.loginType === 'code') {
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

          // 密码/验证码输入
          Column({ space: 6 }) {
            Text(this.loginType === 'password' ? '密码' : '验证码')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            Row() {
              TextInput({
                placeholder: this.loginType === 'password' ? '请输入密码' : '请输入验证码',
                text: this.loginType === 'password' ? this.password : this.verifyCode
              })
                .placeholderColor('#CCCCCC')
                .fontSize(16)
                .fontColor('#1A1A1A')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .height(44)
                .type(this.loginType === 'password' ? InputType.Password : InputType.Number)
                .onChange((value: string) => {
                  if (this.loginType === 'password') {
                    this.password = value;
                  } else {
                    this.verifyCode = value;
                  }
                  if (this.passwordError !== '') this.passwordError = '';
                })

              if (this.loginType === 'password') {
                Text('🔐')
                  .fontSize(18)
                  .opacity(0.5)
              }
            }
            .backgroundColor('#FAFAFA')
            .borderRadius(10)
            .padding({ left: 14, right: 14 })

            if (this.passwordError !== '') {
              Text(this.passwordError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
            }
          }
          .width('100%')

          // 记住密码 & 忘记密码
          Row() {
            Checkbox()
              .select(this.rememberPassword)
              .selectedColor('#FF9800')
              .onChange((value: boolean) => { this.rememberPassword = value; })
            Text('记住密码')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 8 })
            Blank()
            Text('忘记密码？')
              .fontSize(14)
              .fontColor('#FF9800')
              .onClick(() => {
                promptAction.showToast({ message: '请联系客服找回密码', duration: 2000 });
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 8 })

          // 登录按钮
          Button('登录')
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
            .onClick(() => { this.handleLogin(); })

          if (this.isLoading) {
            Row({ space: 8 }) {
              LoadingProgress()
                .width(18)
                .height(18)
                .color('#FF9800')
              Text('登录中...')
                .fontSize(14)
                .fontColor('#FF9800')
            }
            .margin({ top: 12 })
          }

          // 第三方登录
          Column({ space: 12 }) {
            Text('其他登录方式')
              .fontSize(12)
              .fontColor('#BBBBBB')
              .margin({ top: 30, bottom: 4 })

            Row({ space: 40 }) {
              Column() {
                Text('💬')
                  .fontSize(32)
                Text('微信')
                  .fontSize(11)
                  .fontColor('#666666')
                  .margin({ top: 4 })
              }
              Column() {
                Text('💰')
                  .fontSize(32)
                Text('支付宝')
                  .fontSize(11)
                  .fontColor('#666666')
                  .margin({ top: 4 })
              }
            }
          }
          .margin({ top: 20 })

          // 注册入口
          Row() {
            Text('还没有账号？')
              .fontSize(14)
              .fontColor('#999999')
            Text('立即注册')
              .fontSize(14)
              .fontColor('#FF9800')
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                router.pushUrl({ url: 'pages/consumer/ConsumerRegisterPage' });
              })
          }
          .margin({ top: 30, bottom: 40 })
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
