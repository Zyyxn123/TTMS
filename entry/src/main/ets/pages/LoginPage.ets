import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import UserService from '../model/UserService';

@Entry
@Component
export struct LoginPage {
  @State account: string = '';
  @State password: string = '';
  @State rememberPassword: boolean = false;
  @State isLoading: boolean = false;
  @State accountError: string = '';
  @State passwordError: string = '';
  @State isAccountFocused: boolean = false;
  @State isPasswordFocused: boolean = false;

  private readonly STORAGE_KEY_REMEMBER: string = 'admin_remember';
  private readonly STORAGE_KEY_ACCOUNT: string = 'admin_account';
  private readonly STORAGE_KEY_PASSWORD: string = 'admin_password';

  aboutToAppear(): void {
    const remembered: boolean = UserService.getIsRemembered();
    if (remembered) {
      const storedAccount: string = AppStorage.get<string>(this.STORAGE_KEY_ACCOUNT) ?? '';
      const storedPassword: string = AppStorage.get<string>(this.STORAGE_KEY_PASSWORD) ?? '';
      this.account = storedAccount;
      this.password = storedPassword;
      this.rememberPassword = true;
    }
  }

  aboutToDisappear(): void {
    this.clearErrors();
  }

  private clearErrors(): void {
    this.accountError = '';
    this.passwordError = '';
  }

  private validateInputs(): boolean {
    this.clearErrors();
    let valid: boolean = true;
    if (this.account.trim() === '') {
      this.accountError = '请输入账号';
      valid = false;
    }
    if (this.password.trim() === '') {
      this.passwordError = '请输入密码';
      valid = false;
    }
    return valid;
  }

  private handleLogin(): void {
    if (!this.validateInputs()) {
      return;
    }
    this.isLoading = true;
    setTimeout(() => {
      const user = UserService.login(this.account.trim(), this.password.trim());
      this.isLoading = false;
      if (user) {
        UserService.setRemembered(this.rememberPassword);
        if (this.rememberPassword) {
          AppStorage.setOrCreate<string>(this.STORAGE_KEY_ACCOUNT, this.account.trim());
          AppStorage.setOrCreate<string>(this.STORAGE_KEY_PASSWORD, this.password.trim());
        } else {
          AppStorage.delete(this.STORAGE_KEY_ACCOUNT);
          AppStorage.delete(this.STORAGE_KEY_PASSWORD);
        }
        promptAction.showToast({ message: `欢迎，${user?.name}`, duration: 2000 });
        router.replaceUrl({ url: 'pages/MainTabPage' });
      } else {
        this.passwordError = '账号或密码错误';
      }
    }, 800);
  }

  private handleBiometricLogin(): void {
    promptAction.showToast({ message: '生物识别登录功能演示中，请使用账号密码登录', duration: 2000 });
  }

  private handleForgetPassword(): void {
    promptAction.showToast({ message: '请联系管理员重置密码', duration: 2000 });
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 0 }) {
          // ===== Logo 区域 =====
          Column({ space: 8 }) {
            Row() {
              Text('TT')
                .fontSize(40)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#1E88E5')
                .borderRadius(12)
                .padding({ left: 10, right: 10, top: 8, bottom: 8 })

              Column({ space: 2 }) {
                Text('MS')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1E88E5')
              }
            }

            Text('TTMS')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1E88E5')
              .margin({ top: 16 })

            Text('票务管理系统')
              .fontSize(14)
              .fontColor('#9E9E9E')
              .margin({ top: 4 })

            Text(' Theater Ticket Management System')
              .fontSize(10)
              .fontColor('#CCCCCC')
              .margin({ top: 2 })
          }
          .width('100%')
          .margin({ top: 60, bottom: 40 })

          // ===== 表单区域 =====
          Column({ space: 16 }) {
            // 账号输入
            Column({ space: 6 }) {
              Text('账号')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)

              Row() {
                Text('👤')
                  .fontSize(16)
                  .margin({ left: 12 })
                  .opacity(0.6)

                TextInput({ placeholder: '请输入账号', text: this.account })
                  .placeholderColor('#CCCCCC')
                  .placeholderFont({ size: 15 })
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .backgroundColor(Color.Transparent)
                  .layoutWeight(1)
                  .height(44)
                  .onFocus(() => { this.isAccountFocused = true; })
                  .onBlur(() => { this.isAccountFocused = false; })
                  .onChange((value: string) => {
                    this.account = value;
                    if (this.accountError !== '') {
                      this.accountError = '';
                    }
                  })

                if (this.account.length > 0) {
                  Text('✕')
                    .fontSize(12)
                    .fontColor('#CCCCCC')
                    .backgroundColor('#EEEEEE')
                    .borderRadius(10)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .onClick(() => {
                      this.account = '';
                    })
                }
              }
              .backgroundColor('#FAFAFA')
              .borderRadius(12)
              .padding({ left: 8, right: 12 })
              .border({
                width: 2,
                color: this.isAccountFocused ? '#1E88E5' : (this.accountError !== '' ? '#F44336' : '#EEEEEE'),
                radius: 12
              })
              .height(50)

              if (this.accountError !== '') {
                Text(this.accountError)
                  .fontSize(12)
                  .fontColor('#F44336')
                  .alignSelf(ItemAlign.Start)
                  .margin({ left: 4 })
              }
            }

            // 密码输入
            Column({ space: 6 }) {
              Text('密码')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)

              Row() {
                Text('🔒')
                  .fontSize(16)
                  .margin({ left: 12 })
                  .opacity(0.6)

                TextInput({ placeholder: '请输入密码', text: this.password })
                  .placeholderColor('#CCCCCC')
                  .placeholderFont({ size: 15 })
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .backgroundColor(Color.Transparent)
                  .layoutWeight(1)
                  .height(44)
                  .type(InputType.Password)
                  .onFocus(() => { this.isPasswordFocused = true; })
                  .onBlur(() => { this.isPasswordFocused = false; })
                  .onChange((value: string) => {
                    this.password = value;
                    if (this.passwordError !== '') {
                      this.passwordError = '';
                    }
                  })

                Text('🔐')
                  .fontSize(16)
                  .margin({ right: 8 })
                  .opacity(0.6)
                  .onClick(() => {
                    this.handleBiometricLogin();
                  })
              }
              .backgroundColor('#FAFAFA')
              .borderRadius(12)
              .padding({ left: 8, right: 8 })
              .border({
                width: 2,
                color: this.isPasswordFocused ? '#1E88E5' : (this.passwordError !== '' ? '#F44336' : '#EEEEEE'),
                radius: 12
              })
              .height(50)

              if (this.passwordError !== '') {
                Text(this.passwordError)
                  .fontSize(12)
                  .fontColor('#F44336')
                  .alignSelf(ItemAlign.Start)
                  .margin({ left: 4 })
              }
            }

            // 记住密码
            Row() {
              Checkbox()
                .select(this.rememberPassword)
                .selectedColor('#1E88E5')
                .onChange((value: boolean) => {
                  this.rememberPassword = value;
                })
              Text('记住密码')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ left: 8 })
              Blank()
              Text('忘记密码')
                .fontSize(14)
                .fontColor('#1E88E5')
                .onClick(() => {
                  this.handleForgetPassword();
                })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .margin({ top: 4, bottom: 8 })

            // 登录按钮
            Column() {
              Button('登录')
                .width('100%')
                .height(50)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#1E88E5')
                .borderRadius(12)
                .enabled(!this.isLoading)
                .opacity(this.isLoading ? 0.7 : 1)
                .onClick(() => {
                  this.handleLogin();
                })

              if (this.isLoading) {
                Row({ space: 8 }) {
                  LoadingProgress()
                    .width(18)
                    .height(18)
                    .color('#FFFFFF')
                  Text('登录中...')
                    .fontSize(14)
                    .fontColor('#1E88E5')
                }
                .margin({ top: 12 })
              }
            }
            .width('100%')
          }
          .width('88%')
          .padding({ top: 24, bottom: 24 })

          // ===== 底部账号提示 =====
          Column({ space: 8 }) {
            Text('测试账号')
              .fontSize(12)
              .fontColor('#CCCCCC')
              .margin({ bottom: 4 })
            Row({ space: 16 }) {
              Text('admin / admin123')
                .fontSize(12)
                .fontColor('#9E9E9E')
              Text('|')
                .fontSize(12)
                .fontColor('#EEEEEE')
              Text('ticket / ticket123')
                .fontSize(12)
                .fontColor('#9E9E9E')
            }
          }
          .width('100%')
          .padding({ bottom: 40 })
        }
        .width('100%')
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
