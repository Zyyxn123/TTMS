import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

/**
 * 收货地址管理页
 */
@Entry
@Component
export struct ConsumerAddressPage {
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  @State addresses: Address[] = [
    {
      id: '1',
      name: '张三',
      phone: '138****8888',
      province: '北京市',
      city: '北京市',
      district: '朝阳区',
      detail: '建国路88号SOHO现代城',
      isDefault: true
    },
    {
      id: '2',
      name: '李四',
      phone: '139****6666',
      province: '上海市',
      city: '上海市',
      district: '黄浦区',
      detail: '南京东路步行街100号',
      isDefault: false
    }
  ];
  @State showAddDialog: boolean = false;

  // 新增地址表单
  @State newAddress: Address = {
    id: '',
    name: '',
    phone: '',
    province: '北京市',
    city: '北京市',
    district: '',
    detail: '',
    isDefault: false
  };

  private handleAdd(): void {
    if (this.newAddress.name.trim() === '') {
      promptAction.showToast({ message: '请输入收货人姓名', duration: 2000 });
      return;
    }
    if (this.newAddress.phone.trim() === '') {
      promptAction.showToast({ message: '请输入手机号', duration: 2000 });
      return;
    }
    if (this.newAddress.detail.trim() === '') {
      promptAction.showToast({ message: '请输入详细地址', duration: 2000 });
      return;
    }

    const newAddr: Address = {
      id: Date.now().toString(),
      name: this.newAddress.name.trim(),
      phone: this.newAddress.phone.trim(),
      province: this.newAddress.province,
      city: this.newAddress.city,
      district: this.newAddress.district.trim(),
      detail: this.newAddress.detail.trim(),
      isDefault: this.addresses.length === 0
    };

    this.addresses.push(newAddr);
    this.showAddDialog = false;
    promptAction.showToast({ message: '添加成功', duration: 2000 });

    // 重置表单
    this.newAddress = {
      id: '', name: '', phone: '', province: '北京市', city: '北京市', district: '', detail: '', isDefault: false
    };
  }

  private handleDelete(id: string): void {
    this.addresses = this.addresses.filter((a: Address): boolean => a.id !== id);
    promptAction.showToast({ message: '删除成功', duration: 2000 });
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

        Text('收货地址')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('添加')
          .fontSize(15)
          .fontColor('#FF9800')
          .onClick(() => { this.showAddDialog = true; })
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      if (this.addresses.length === 0) {
        Column() {
          Text('📍')
            .fontSize(64)
          Text('暂无收货地址')
            .fontSize(15)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
          Text('点击右上角添加收货地址')
            .fontSize(13)
            .fontColor('#BBBBBB')
            .margin({ top: 4 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            ForEach(this.addresses, (address: Address) => {
              Column() {
                Row() {
                  Column() {
                    Row() {
                      Text(address.name)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                      if (address.isDefault) {
                        Text('默认')
                          .fontSize(10)
                          .fontColor('#FFFFFF')
                          .backgroundColor('#FF9800')
                          .borderRadius(4)
                          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                          .margin({ left: 8 })
                      }
                    }
                    Text(address.phone)
                      .fontSize(13)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                    Text(`${address.province}${address.city}${address.district}${address.detail}`)
                      .fontSize(13)
                      .fontColor('#9E9E9E')
                      .margin({ top: 4 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)

                  Column() {
                    Text('✏️')
                      .fontSize(18)
                      .onClick(() => {
                        promptAction.showToast({ message: '编辑功能开发中', duration: 2000 });
                      })
                    Text('🗑️')
                      .fontSize(18)
                      .margin({ top: 12 })
                      .onClick(() => { this.handleDelete(address.id); })
                  }
                }
                .width('100%')
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .padding(16)
              .margin({ left: 16, right: 16, bottom: 12 })
            })
          }
          .width('100%')
          .padding({ top: 12, bottom: 20 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }

      // 新增地址弹窗
      if (this.showAddDialog) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showAddDialog = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Row() {
            Text('新增地址')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('✕')
              .fontSize(20)
              .fontColor('#999999')
              .onClick(() => { this.showAddDialog = false; })
          }
          .width('100%')
          .padding(20)

          Scroll() {
            Column() {
              Column() {
                Row() {
                  Text('收货人')
                    .fontSize(14)
                    .fontColor('#666666')
                    .width(70)
                  TextInput({ placeholder: '请输入姓名', text: this.newAddress.name })
                    .placeholderColor('#CCCCCC')
                    .fontSize(14)
                    .fontColor('#1A1A1A')
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .onChange((v: string) => { this.newAddress.name = v; })
                }
                .width('100%')
                .padding({ top: 10, bottom: 10 })
                Divider().color('#F0F0F0')
                Row() {
                  Text('手机号')
                    .fontSize(14)
                    .fontColor('#666666')
                    .width(70)
                  TextInput({ placeholder: '请输入手机号', text: this.newAddress.phone })
                    .placeholderColor('#CCCCCC')
                    .fontSize(14)
                    .fontColor('#1A1A1A')
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .type(InputType.PhoneNumber)
                    .onChange((v: string) => { this.newAddress.phone = v; })
                }
                .width('100%')
                .padding({ top: 10, bottom: 10 })
                Divider().color('#F0F0F0')
                Row() {
                  Text('省市区')
                    .fontSize(14)
                    .fontColor('#666666')
                    .width(70)
                  Text('北京市 北京市')
                    .fontSize(14)
                    .fontColor('#1A1A1A')
                    .layoutWeight(1)
                  Text('>')
                    .fontSize(12)
                    .fontColor('#CCCCCC')
                }
                .width('100%')
                .padding({ top: 10, bottom: 10 })
                Divider().color('#F0F0F0')
                Row() {
                  Text('详细地址')
                    .fontSize(14)
                    .fontColor('#666666')
                    .width(70)
                  TextInput({ placeholder: '街道、门牌号等', text: this.newAddress.detail })
                    .placeholderColor('#CCCCCC')
                    .fontSize(14)
                    .fontColor('#1A1A1A')
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .onChange((v: string) => { this.newAddress.detail = v; })
                }
                .width('100%')
                .padding({ top: 10, bottom: 10 })
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .padding({ left: 16, right: 16 })

              Button('保存地址')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#FF9800')
                .borderRadius(8)
                .height(48)
                .width('100%')
                .margin({ top: 30 })
                .onClick(() => { this.handleAdd(); })
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 20 })
          }
        }
        .width('100%')
        .height('70%')
        .backgroundColor('#F5F5F5')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .position({ x: 0, y: '30%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

interface Address {
  id: string;
  name: string;
  phone: string;
  province: string;
  city: string;
  district: string;
  detail: string;
  isDefault: boolean;
}
