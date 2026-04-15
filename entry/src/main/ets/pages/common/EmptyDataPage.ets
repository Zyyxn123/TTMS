import router from '@ohos.router';

/**
 * 空数据提示页
 */
@Entry
@Component
export struct EmptyDataPage {
  @State title: string = '暂无数据';
  @State message: string = '这里还没有任何内容';
  @State buttonText: string = '';
  @State buttonUrl: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params) {
      if (params.title) {
        this.title = params.title;
      }
      if (params.message) {
        this.message = params.message;
      }
      if (params.buttonText) {
        this.buttonText = params.buttonText;
      }
      if (params.buttonUrl) {
        this.buttonUrl = params.buttonUrl;
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
        Text('📭')
          .fontSize(80)

        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ top: 20 })

        Text(this.message)
          .fontSize(14)
          .fontColor('#9E9E9E')
          .margin({ top: 8 })

        if (this.buttonText !== '' && this.buttonUrl !== '') {
          Button(this.buttonText)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(8)
            .height(44)
            .width(200)
            .margin({ top: 30 })
            .onClick(() => {
              if (this.buttonUrl === 'back') {
                router.back();
              } else {
                router.pushUrl({ url: this.buttonUrl });
              }
            })
        }

        Button('返回上一页')
          .fontSize(15)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .height(44)
          .width(200)
          .margin({ top: 12 })
          .onClick(() => { router.back(); })
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
