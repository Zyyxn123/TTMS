import router from '@ohos.router';

/**
 * 统一登录页 - 支持管理端/消费者/游客三种入口
 */
@Entry
@Component
export struct Index {
  build() {
    Column() {
      // Logo区域
      Column({ space: 12 }) {
        Column() {
          Text('🏛️')
            .fontSize(60)
          Text('TTMS')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E88E5')
            .margin({ top: 12 })
          Text('票务管理系统')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .width('100%')
        .margin({ top: 80, bottom: 40 })

        // 角色选择卡片
        Column({ space: 16 }) {
          Text('请选择登录身份')
            .fontSize(15)
            .fontColor('#666666')
            .margin({ bottom: 8 })

          // 管理端登录卡片
          Column() {
            Row() {
              Text('🔐')
                .fontSize(32)
              Column() {
                Text('管理端登录')
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('票务管理员/运营管理员')
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 2 })
              }
              .margin({ left: 16 })
              .alignItems(HorizontalAlign.Start)
              Blank()
              Text('>')
                .fontSize(20)
                .fontColor('#FFFFFF')
                .opacity(0.7)
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor('#1E88E5')
          .borderRadius(16)
          .padding(20)
          .onClick(() => {
            router.pushUrl({ url: 'pages/LoginPage' });
          })

          // 消费者登录卡片
          Column() {
            Row() {
              Text('🎫')
                .fontSize(32)
              Column() {
                Text('消费者登录')
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('普通用户/购票用户')
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 2 })
              }
              .margin({ left: 16 })
              .alignItems(HorizontalAlign.Start)
              Blank()
              Text('>')
                .fontSize(20)
                .fontColor('#FFFFFF')
                .opacity(0.7)
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor('#FF9800')
          .borderRadius(16)
          .padding(20)
          .onClick(() => {
            router.pushUrl({ url: 'pages/consumer/ConsumerLoginPage' });
          })
        }
        .width('85%')
      }
      .width('100%')
      .layoutWeight(1)

      // 底部游客浏览入口
      Column() {
        Text('— 游客浏览 —')
          .fontSize(13)
          .fontColor('#999999')
          .padding({ left: 20, right: 20, top: 16, bottom: 16 })
        Text('可浏览演出信息，但无法购票')
          .fontSize(12)
          .fontColor('#BBBBBB')
          .margin({ bottom: 40 })
      }
      .width('100%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/consumer/ConsumerHomePage' });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
