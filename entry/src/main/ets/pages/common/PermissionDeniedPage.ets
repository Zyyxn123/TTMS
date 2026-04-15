import router from '@ohos.router';

/**
 * 权限不足提示页
 */
@Entry
@Component
export struct PermissionDeniedPage {
  @State message: string = '您没有权限访问此功能';
  @State subMessage: string = '如有疑问，请联系管理员';

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
        Text('🚫')
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

        Button('返回上一页')
          .fontSize(15)
          .fontColor('#FFFFFF')
          .backgroundColor('#FF9800')
          .borderRadius(8)
          .height(44)
          .width(200)
          .margin({ top: 30 })
          .onClick(() => { router.back(); })

        Button('返回首页')
          .fontSize(15)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .height(44)
          .width(200)
          .margin({ top: 12 })
          .onClick(() => {
            router.clear();
            router.pushUrl({ url: 'pages/Index' });
          })
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
