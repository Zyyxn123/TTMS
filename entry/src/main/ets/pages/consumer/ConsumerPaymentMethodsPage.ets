import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

/**
 * 支付方式管理页
 */
@Entry
@Component
export struct ConsumerPaymentMethodsPage {
  @State paymentMethods: PaymentMethod[] = [
    {
      id: '1',
      type: 'wechat',
      name: '微信支付',
      icon: '💬',
      isDefault: true
    },
    {
      id: '2',
      type: 'alipay',
      name: '支付宝',
      icon: '💰',
      isDefault: false
    },
    {
      id: '3',
      type: 'bank',
      name: '中国工商银行储蓄卡',
      icon: '🏦',
      cardNo: '**** **** **** 8888',
      isDefault: false
    }
  ];

  private handleSetDefault(id: string): void {
    const updatedMethods: PaymentMethod[] = [];
    for (let i: number = 0; i < this.paymentMethods.length; i++) {
      const p: PaymentMethod = this.paymentMethods[i];
      const newDefault: boolean = p.id === id;
      if (p.isDefault !== newDefault || p.id === id) {
        updatedMethods.push({
          id: p.id,
          type: p.type,
          name: p.name,
          icon: p.icon,
          cardNo: p.cardNo,
          isDefault: newDefault
        });
      } else {
        updatedMethods.push(p);
      }
    }
    this.paymentMethods = updatedMethods;
    promptAction.showToast({ message: '已设置为默认支付方式', duration: 2000 });
  }

  private handleDelete(id: string): void {
    const method = this.paymentMethods.find((p: PaymentMethod): boolean => p.id === id);
    if (method?.isDefault) {
      promptAction.showToast({ message: '默认支付方式无法删除', duration: 2000 });
      return;
    }
    this.paymentMethods = this.paymentMethods.filter((p: PaymentMethod): boolean => p.id !== id);
    promptAction.showToast({ message: '已删除', duration: 2000 });
  }

  private handleAdd(): void {
    promptAction.showToast({ message: '添加支付方式功能开发中', duration: 2000 });
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

        Text('支付方式')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('添加')
          .fontSize(15)
          .fontColor('#FF9800')
          .onClick(() => { this.handleAdd(); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 说明
          Row() {
            Text('💳')
              .fontSize(14)
            Text('已绑定的支付方式，可用于购票付款')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .margin({ left: 8 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 8 })

          // 支付方式列表
          Column() {
            ForEach(this.paymentMethods, (method: PaymentMethod) => {
              Column() {
                Row() {
                  Text(method.icon)
                    .fontSize(24)

                  Column() {
                    Row() {
                      Text(method.name)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                      if (method.isDefault) {
                        Text('默认')
                          .fontSize(10)
                          .fontColor('#FFFFFF')
                          .backgroundColor('#4CAF50')
                          .borderRadius(4)
                          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                          .margin({ left: 8 })
                      }
                    }
                    if (method.cardNo) {
                      Text(method.cardNo)
                        .fontSize(12)
                        .fontColor('#9E9E9E')
                        .margin({ top: 4 })
                    }
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })
                  .alignItems(HorizontalAlign.Start)

                  if (!method.isDefault) {
                    Text('设为默认')
                      .fontSize(12)
                      .fontColor('#FF9800')
                      .onClick(() => { this.handleSetDefault(method.id); })
                  }
                }
                .width('100%')
              }
              .width('100%')
              .padding(16)

              if (method.id !== this.paymentMethods[this.paymentMethods.length - 1].id) {
                Divider().color('#F0F0F0').margin({ left: 52 })
              }
            })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16 })

          // 安全提示
          Column() {
            Row() {
              Text('🔒')
                .fontSize(14)
              Text('资金安全')
                .fontSize(13)
                .fontColor('#1A1A1A')
                .margin({ left: 8 })
            }
            .width('100%')

            Text('您的支付信息受到银行级安全保护，请放心使用')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .margin({ top: 8 })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding(16)
          .margin({ left: 16, right: 16, top: 12 })
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

interface PaymentMethod {
  id: string;
  type: string;
  name: string;
  icon: string;
  cardNo?: string;
  isDefault: boolean;
}
