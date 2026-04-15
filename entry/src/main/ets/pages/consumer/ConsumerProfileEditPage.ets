import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { consumerUserService } from '../../model/ConsumerUserService';
import { ConsumerUser } from '../../model/DataModel';

/**
 * 个人信息编辑页
 */
@Entry
@Component
export struct ConsumerProfileEditPage {
  @State userName: string = '';
  @State phone: string = '';
  @State email: string = '';
  @State isLoading: boolean = false;
  @State isSaved: boolean = false;

  aboutToAppear(): void {
    const user = consumerUserService.getCurrentUser();
    if (user) {
      this.userName = user.name;
      this.phone = user.phone;
    }
  }

  private handleSave(): void {
    if (this.userName.trim() === '') {
      promptAction.showToast({ message: '请输入昵称', duration: 2000 });
      return;
    }

    this.isLoading = true;

    setTimeout(() => {
      const newName: string = this.userName.trim();
      const updateData: ConsumerUserUpdateData = {
        name: newName
      };
      const success: boolean = consumerUserService.updateUser(updateData);

      this.isLoading = false;

      if (success) {
        promptAction.showToast({ message: '保存成功', duration: 2000 });
        router.back();
      } else {
        promptAction.showToast({ message: '保存失败', duration: 2000 });
      }
    }, 500);
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

        Text('编辑个人信息')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('保存')
          .fontSize(15)
          .fontColor('#FF9800')
          .onClick(() => { this.handleSave(); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 头像区域
          Column() {
            Column() {
              Text('👤')
                .fontSize(48)
            }
            .width(80)
            .height(80)
            .backgroundColor('#FFF3E0')
            .borderRadius(40)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              promptAction.showToast({ message: '头像修改功能开发中', duration: 2000 });
            })

            Text('点击更换头像')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .margin({ top: 8 })
          }
          .width('100%')
          .padding({ top: 30, bottom: 20 })

          // 信息表单
          Column() {
            // 昵称
            Row() {
              Text('昵称')
                .fontSize(15)
                .fontColor('#666666')
                .width(70)
              TextInput({ placeholder: '请输入昵称', text: this.userName })
                .placeholderColor('#CCCCCC')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onChange((value: string) => { this.userName = value; })
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })

            Divider().color('#F0F0F0')

            // 手机号（不可修改）
            Row() {
              Text('手机号')
                .fontSize(15)
                .fontColor('#666666')
                .width(70)
              Text(this.phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2'))
                .fontSize(15)
                .fontColor('#9E9E9E')
                .layoutWeight(1)
              Text('')
                .fontSize(12)
                .fontColor('#CCCCCC')
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })

            Divider().color('#F0F0F0')

            // 邮箱
            Row() {
              Text('邮箱')
                .fontSize(15)
                .fontColor('#666666')
                .width(70)
              TextInput({ placeholder: '请输入邮箱（选填）', text: this.email })
                .placeholderColor('#CCCCCC')
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .type(InputType.Email)
                .onChange((value: string) => { this.email = value; })
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding({ left: 16, right: 16 })
          .margin({ left: 16, right: 16 })
        }
        .width('100%')
        .padding({ bottom: 30 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      if (this.isLoading) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          LoadingProgress().width(40).height(40).color('#FF9800')
          Text('保存中...').fontSize(14).fontColor('#FFFFFF').margin({ top: 8 })
        }
        .width(120)
        .height(100)
        .backgroundColor('#99000000')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .position({ x: '37%', y: '45%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

interface ConsumerUserUpdateData {
  name: string;
}
