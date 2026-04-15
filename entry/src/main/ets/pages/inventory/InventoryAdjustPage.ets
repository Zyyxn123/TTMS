import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Inventory, AdminRole, OperationResult } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct InventoryAdjustPage {
  @State inventory: Inventory | null = null;
  @State inventoryId: string = '';
  @State adjustType: string = 'add';
  @State adjustAmount: string = '';
  @State adjustReason: string = '';
  @State isSubmitting: boolean = false;

  aboutToAppear(): void {
    const params: Record<string, string> = router.getParams() as Record<string, string> ?? {};
    this.inventoryId = params['inventoryId'] ?? '';
    if (this.inventoryId !== '') {
      const found: Inventory | undefined = dataService.getInventoryById(this.inventoryId);
      if (found) {
        this.inventory = found;
      }
    }
  }

  private handleSubmit(): void {
    if (this.adjustAmount.trim() === '') {
      promptAction.showToast({ message: '请输入调整数量', duration: 2000 });
      return;
    }
    if (this.adjustReason.trim() === '') {
      promptAction.showToast({ message: '请填写调整原因', duration: 2000 });
      return;
    }

    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;
    const amount: number = Number(this.adjustAmount);
    const finalAmount: number = this.adjustType === 'add' ? amount : -amount;

    dataService.adjustInventory(this.inventoryId, finalAmount, this.adjustReason.trim(), operatorName);

    UserService.addLog('库存调整', operatorName, role,
      this.inventory !== null ? this.inventory!.showName : '未知',
      `调整类型：${this.adjustType === 'add' ? '增加' : '减少'}，数量：${amount}，原因：${this.adjustReason}`,
      OperationResult.SUCCESS);

    this.isSubmitting = true;
    setTimeout(() => {
      this.isSubmitting = false;
      promptAction.showToast({ message: '库存调整成功', duration: 2000 });
      router.back();
    }, 600);
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('库存调整')
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

      if (this.inventory === null) {
        Column() {
          Text('库存信息不存在')
            .fontSize(16)
            .fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 16 }) {
            // 票务信息
            Column() {
              Text(this.inventory.showName)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text(`${this.inventory.showDate} · ${this.inventory.venue}`)
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
              Row() {
                Text('当前剩余: ')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`${this.inventory.remainingCount} 张`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1E88E5')
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 调整类型
            Column() {
              Text('调整类型')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Row({ space: 12 }) {
                Column() {
                  Row() {
                    Radio({ value: 'add', group: 'adjustType' })
                      .checked(this.adjustType === 'add')
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.adjustType = 'add';
                        }
                      })
                    Text('增加库存')
                      .fontSize(14)
                      .fontColor('#1A1A1A')
                      .margin({ left: 6 })
                  }
                }
                .layoutWeight(1)

                Column() {
                  Row() {
                    Radio({ value: 'subtract', group: 'adjustType' })
                      .checked(this.adjustType === 'subtract')
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.adjustType = 'subtract';
                        }
                      })
                    Text('减少库存')
                      .fontSize(14)
                      .fontColor('#1A1A1A')
                      .margin({ left: 6 })
                  }
                }
                .layoutWeight(1)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 调整数量
            Column() {
              Text('调整数量')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Row() {
                Text(this.adjustType === 'add' ? '+' : '-')
                  .fontSize(20)
                  .fontColor(this.adjustType === 'add' ? '#4CAF50' : '#F44336')
                  .fontWeight(FontWeight.Bold)
                TextInput({ placeholder: '0' })
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .backgroundColor(Color.Transparent)
                  .layoutWeight(1)
                  .height(40)
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    this.adjustAmount = value;
                  })
                Text('张')
                  .fontSize(16)
                  .fontColor('#666666')
              }
              .width('100%')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 调整原因
            Column() {
              Text('调整原因 *')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              TextArea({ placeholder: '请详细填写调整原因，如：追加放票、取消座位等' })
                .placeholderColor('#9E9E9E')
                .fontSize(14)
                .fontColor('#1A1A1A')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .height(80)
                .padding(12)
                .onChange((value: string) => {
                  this.adjustReason = value;
                })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            // 预估结果
            Column() {
              Text('预估结果')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Row() {
                Text('调整前剩余')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`${this.inventory.remainingCount} 张`)
                  .fontSize(14)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                Text('调整数量')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`${this.adjustType === 'add' ? '+' : '-'}${this.adjustAmount || 0} 张`)
                  .fontSize(14)
                  .fontColor(this.adjustType === 'add' ? '#4CAF50' : '#F44336')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 8 })

              Divider()
                .margin({ bottom: 8 })

              Row() {
                Text('调整后剩余')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(`${Math.max(0, this.inventory.remainingCount + (this.adjustType === 'add' ? (Number(this.adjustAmount) || 0) : -(Number(this.adjustAmount) || 0)))} 张`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1E88E5')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            Button('确认调整')
              .width('100%')
              .height(48)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#1E88E5')
              .borderRadius(8)
              .onClick(() => { this.handleSubmit(); })

            if (this.isSubmitting) {
              LoadingProgress()
                .width(24)
                .height(24)
                .color('#1E88E5')
                .margin({ top: 12 })
            }
          }
          .padding(16)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
