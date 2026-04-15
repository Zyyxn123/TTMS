import router from '@ohos.router';

/**
 * 数据加载失败提示页
 */
@Entry
@Component
export struct LoadErrorPage {
  @State message: string = '数据加载失败';
  @State subMessage: string = '请检查网络连接后重试';

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params) {
      if (params.message) {
        this.message = params.message;
      }
      if (params.subMessage) {
        this.subMessage = params.subMessage;
      }
    }
  }

  // 重新加载
  private handleRetry(): void {
    router.back();
  }

  // 返回首页
  private goHome(): void {
    router.clear();
    router.pushUrl({ url: 'pages/Index' });
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
        .backgroundColor('#FFFFFF80')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => { router.back(); })

        Text('提示')
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

      Column() {
        Text('📡')
          .fontSize(80)

        Text(this.message)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ top: 20 })

        Text(this.subMessage)
          .fontSize(14)
          .fontColor('#9E9E9E')
          .margin({ top: 8 })

        Button('重新加载')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#FF9800')
          .borderRadius(8)
          .height(44)
          .width(200)
          .margin({ top: 30 })
          .onClick(() => { this.handleRetry(); })

        Button('返回首页')
          .fontSize(15)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .height(44)
          .width(200)
          .margin({ top: 12 })
          .onClick(() => { this.goHome(); })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
