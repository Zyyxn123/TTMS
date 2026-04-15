import router from '@ohos.router';

interface EmptyDataPageParams {
  message?: string;
  showAddButton?: boolean;
  addButtonText?: string;
  onAdd?: () => void;
}

@Entry
@Component
export struct EmptyDataPage {
  @State message: string = '暂无相关数据';
  @State showAddButton: boolean = false;
  @State addButtonText: string = '新增数据';

  aboutToAppear(): void {
    const params: Record<string, string | boolean> = router.getParams() as Record<string, string | boolean> ?? {};
    if (params['message']) {
      this.message = params['message'] as string;
    }
    if (params['showAddButton']) {
      this.showAddButton = params['showAddButton'] as boolean;
    }
    if (params['addButtonText']) {
      this.addButtonText = params['addButtonText'] as string;
    }
  }

  build() {
    Column() {
      Column() {
        Text('📭')
          .fontSize(48)

        Text(this.message)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 16 })
          .textAlign(TextAlign.Center)

        if (this.showAddButton) {
          Button(this.addButtonText)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#1E88E5')
            .borderRadius(8)
            .width(160)
            .height(44)
            .margin({ top: 24 })
            .onClick(() => {
              router.back();
            })
        }
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
