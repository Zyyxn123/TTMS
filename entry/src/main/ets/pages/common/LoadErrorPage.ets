import router from '@ohos.router';

@Entry
@Component
export struct LoadErrorPage {
  @State message: string = '数据加载失败，请检查网络后重试';
  @State onRetryCallback: string = '';
  @State onBackHomeCallback: string = '';

  aboutToAppear(): void {
    const params: Record<string, string> = router.getParams() as Record<string, string> ?? {};
    if (params['message']) {
      this.message = params['message'];
    }
    if (params['onRetry']) {
      this.onRetryCallback = params['onRetry'];
    }
    if (params['onBackHome']) {
      this.onBackHomeCallback = params['onBackHome'];
    }
  }

  private handleRetry(): void {
    if (this.onRetryCallback !== '') {
      router.back();
    } else {
      router.back();
    }
  }

  private handleBackHome(): void {
    if (this.onBackHomeCallback !== '') {
      router.clear();
    }
    router.replaceUrl({ url: 'pages/MainTabPage' });
  }

  build() {
    Column() {
      Column() {
        Text('📡')
          .fontSize(56)
          .margin({ bottom: 16 })

        Text('加载失败')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ top: 8 })

        Text(this.message)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 8 })
          .textAlign(TextAlign.Center)
          .padding({ left: 32, right: 32 })

        Row({ space: 16 }) {
          Button('重新加载')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#1E88E5')
            .borderRadius(10)
            .width(120)
            .height(44)
            .onClick(() => {
              this.handleRetry();
            })

          Button('返回首页')
            .fontSize(14)
            .fontColor('#1E88E5')
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: '#1E88E5' })
            .borderRadius(10)
            .width(120)
            .height(44)
            .onClick(() => {
              this.handleBackHome();
            })
        }
        .margin({ top: 28 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
