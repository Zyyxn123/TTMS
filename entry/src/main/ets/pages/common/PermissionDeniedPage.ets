import router from '@ohos.router';

@Entry
@Component
export struct PermissionDeniedPage {
  build() {
    Column() {
      Column() {
        Text('⚠️')
          .fontSize(48)

        Text('权限不足')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ top: 16 })

        Text('您没有该操作的权限，请联系管理员')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 8 })
          .textAlign(TextAlign.Center)

        Button('返回')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#1E88E5')
          .borderRadius(8)
          .width(120)
          .height(44)
          .margin({ top: 32 })
          .onClick(() => {
            router.back();
          })
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
