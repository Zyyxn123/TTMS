// 通用回调类型：接收 actionId 并执行对应逻辑
export type ActionCallback = (actionId: string) => void;

// 顶部导航栏组件
@Component
export struct TopNavigation {
  @Prop title: string = '';
  @Prop showBack: boolean = false;
  @Prop showMore: boolean = false;
  onBackId: string = 'back';
  onMoreId: string = 'more';
  onAction: ActionCallback = () => {};

  build() {
    Row() {
      if (this.showBack) {
        Row() {
          Text('<')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width(40)
        .height(40)
        .backgroundColor('#FFFFFF80')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onAction(this.onBackId);
        })
      }

      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(this.showBack ? TextAlign.Start : TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (this.showMore) {
        Row() {
          Image($r('app.media.layered_image'))
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
        }
        .width(40)
        .height(40)
        .backgroundColor('#FFFFFF80')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onAction(this.onMoreId);
        })
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .shadow({
      radius: 4,
      color: '#0D000000',
      offsetX: 0,
      offsetY: 1
    })
  }
}

// 底部标签栏组件
@Component
export struct BottomTabBar {
  @Prop currentTab: string = 'home';
  onTabId: string = 'tab';
  onAction: ActionCallback = () => {};

  private tabs: TabItem[] = [
    { key: 'home', label: '首页', icon: '🏠' },
    { key: 'order', label: '订单', icon: '📋' },
    { key: 'profile', label: '我的', icon: '👤' }
  ];

  build() {
    Row() {
      ForEach(this.tabs, (tab: TabItem) => {
        Column() {
          Text(tab.icon)
            .fontSize(22)
            .fontWeight(this.currentTab === tab.key ? FontWeight.Bold : FontWeight.Normal)

          Text(tab.label)
            .fontSize(11)
            .fontColor(this.currentTab === tab.key ? '#1E88E5' : '#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .onClick(() => {
          this.onAction(tab.key);
        })
      })
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: -2
    })
  }
}

interface TabItem {
  key: string;
  label: string;
  icon: string;
}

// 空状态组件
@Component
export struct EmptyState {
  @Prop icon: string = '📭';
  @Prop title: string = '暂无数据';
  @Prop message: string = '';
  @Prop actionText: string = '';
  @Prop actionId: string = '';
  onAction: ActionCallback = () => {};

  build() {
    Column() {
      Text(this.icon)
        .fontSize(64)
        .margin({ bottom: 16 })

      Text(this.title)
        .fontSize(16)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)

      if (this.message) {
        Text(this.message)
          .fontSize(13)
          .fontColor('#999999')
          .margin({ top: 8 })
          .textAlign(TextAlign.Center)
          .padding({ left: 32, right: 32 })
      }

      if (this.actionText) {
        Button(this.actionText)
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor('#1E88E5')
          .borderRadius(8)
          .height(40)
          .padding({ left: 24, right: 24 })
          .margin({ top: 20 })
          .onClick(() => {
            this.onAction(this.actionId);
          })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

// 加载状态组件
@Component
export struct LoadingView {
  @Prop message: string = '加载中...';
  @Prop icon: string = '🔄';

  build() {
    Column() {
      Text(this.icon)
        .fontSize(36)
        .margin({ bottom: 12 })

      LoadingProgress()
        .width(32)
        .height(32)
        .color('#1E88E5')

      Text(this.message)
        .fontSize(13)
        .fontColor('#999999')
        .margin({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

// 加载失败组件
@Component
export struct LoadErrorState {
  @Prop message: string = '数据加载失败，请检查网络后重试';
  @Prop retryText: string = '重新加载';
  @Prop onRetry: () => void = () => {};
  @Prop onBackHome: () => void = () => {};

  build() {
    Column() {
      Text('📡')
        .fontSize(48)
        .margin({ bottom: 16 })

      Text('加载失败')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')

      Text(this.message)
        .fontSize(13)
        .fontColor('#666666')
        .margin({ top: 8 })
        .textAlign(TextAlign.Center)
        .padding({ left: 32, right: 32 })

      Row({ space: 16 }) {
        Button(this.retryText)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#1E88E5')
          .borderRadius(8)
          .width(120)
          .height(40)
          .onClick(() => {
            this.onRetry();
          })

        Button('返回首页')
          .fontSize(14)
          .fontColor('#1E88E5')
          .backgroundColor(Color.White)
          .border({ width: 1, color: '#1E88E5' })
          .borderRadius(8)
          .width(120)
          .height(40)
          .onClick(() => {
            this.onBackHome();
          })
      }
      .margin({ top: 24 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

// 权限拒绝组件
@Component
export struct PermissionDeniedState {
  @Prop onBack: () => void = () => {};

  build() {
    Column() {
      Text('⚠️')
        .fontSize(48)
        .margin({ bottom: 16 })

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
        .padding({ left: 32, right: 32 })

      Button('返回')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#1E88E5')
        .borderRadius(8)
        .width(120)
        .height(44)
        .margin({ top: 32 })
        .onClick(() => {
          this.onBack();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

// 搜索栏组件
@Component
export struct SearchBar {
  @Prop placeholder: string = '搜索演出、场馆...';
  @State inputValue: string = '';
  @Prop showClear: boolean = true;
  onSearchId: string = 'search';
  onClearId: string = 'clear';
  onAction: ActionCallback = () => {};

  build() {
    Row() {
      Text('🔍')
        .fontSize(16)
        .margin({ left: 12 })

      TextInput({ placeholder: this.placeholder, text: this.inputValue })
        .placeholderColor('#BBBBBB')
        .placeholderFont({ size: 14 })
        .fontSize(14)
        .fontColor('#1A1A1A')
        .backgroundColor(Color.Transparent)
        .layoutWeight(1)
        .height('100%')
        .margin({ left: 8, right: 8 })
        .onChange((value: string) => {
          this.inputValue = value;
          this.onAction(this.onSearchId);
        })

      if (this.inputValue.length > 0 && this.showClear) {
        Row() {
          Text('✕')
            .fontSize(12)
            .fontColor('#999999')
        }
        .width(24)
        .height(24)
        .backgroundColor('#CCCCCC')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .margin({ right: 8 })
        .onClick(() => {
          this.inputValue = '';
          this.onAction(this.onClearId);
        })
      }
    }
    .width('100%')
    .height(40)
    .backgroundColor('#F5F5F5')
    .borderRadius(20)
  }
}

// 分割线组件
@Component
export struct DividerLine {
  @Prop edgeMargin: number = 0;

  build() {
    Divider()
      .color('#F0F0F0')
      .margin({ left: this.edgeMargin, right: this.edgeMargin })
  }
}

// 列表项组件
@Component
export struct CustomListItem {
  @Prop icon: string = '';
  @Prop title: string = '';
  @Prop subtitle: string = '';
  @Prop showArrow: boolean = true;
  @Prop badge: string = '';
  @Prop badgeColor: string = '#F44336';
  @Prop itemId: string = '';
  onItemId: string = 'item';
  onAction: ActionCallback = () => {};

  build() {
    Row() {
      if (this.icon) {
        Text(this.icon)
          .fontSize(20)
          .margin({ right: 12 })
      }

      Column() {
        Text(this.title)
          .fontSize(15)
          .fontColor('#1A1A1A')

        if (this.subtitle) {
          Text(this.subtitle)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (this.badge) {
        Text(this.badge)
          .fontSize(11)
          .fontColor(Color.White)
          .backgroundColor(this.badgeColor)
          .borderRadius(10)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
      }

      if (this.showArrow) {
        Text('>')
          .fontSize(14)
          .fontColor('#CCCCCC')
          .margin({ left: 8 })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Color.White)
    .onClick(() => {
      this.onAction(this.itemId || this.onItemId);
    })
  }
}

// 操作按钮组组件
@Component
export struct ActionButtonGroup {
  @Prop primaryText: string = '确定';
  @Prop secondaryText: string = '取消';
  @Prop showSecondary: boolean = true;
  @Prop primaryLoading: boolean = false;
  onPrimaryClick: () => void = () => {};
  onSecondaryClick: () => void = () => {};

  build() {
    Row({ space: 12 }) {
      if (this.showSecondary) {
        Button(this.secondaryText)
          .fontSize(15)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .height(44)
          .layoutWeight(1)
          .onClick(() => {
            this.onSecondaryClick();
          })
      }

      Button(this.primaryText)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#1E88E5')
        .borderRadius(8)
        .height(44)
        .layoutWeight(1)
        .enabled(!this.primaryLoading)
        .opacity(this.primaryLoading ? 0.6 : 1)
        .onClick(() => {
          this.onPrimaryClick();
        })
    }
    .width('100%')
  }
}

// 统计卡片组件
@Component
export struct StatCard {
  @Prop title: string = '';
  @Prop value: string = '';
  @Prop unit: string = '';
  @Prop color: string = '#1E88E5';
  @Prop icon: string = '';

  build() {
    Column() {
      if (this.icon) {
        Text(this.icon)
          .fontSize(20)
          .margin({ bottom: 6 })
      }
      Text(this.value)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
      Text(this.title)
        .fontSize(11)
        .fontColor('#FFFFFF')
        .opacity(0.85)
        .margin({ top: 4 })
      if (this.unit) {
        Text(this.unit)
          .fontSize(10)
          .fontColor('#FFFFFF')
          .opacity(0.7)
          .margin({ top: 2 })
      }
    }
    .width('100%')
    .height(90)
    .backgroundColor(this.color)
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

// 进度条组件
@Component
export struct ProgressBar {
  @Prop value: number = 0;
  @Prop max: number = 100;
  @Prop myHeight: number = 8;
  @Prop bgColor: string = '#F0F0F0';
  @Prop fillColor: string = '#1E88E5';
  @Prop showLabel: boolean = false;

  build() {
    Column() {
      Stack() {
        Column() {
          Text('')
            .width('100%')
            .height(this.height)
            .backgroundColor(this.bgColor)
            .borderRadius(this.myHeight / 2)
        }

        Column() {
          Text('')
            .width(`${this.max > 0 ? Math.min(100, Math.round((this.value / this.max) * 100)) : 0}%`)
            .height(this.myHeight)
            .backgroundColor(this.fillColor)
            .borderRadius(this.myHeight / 2)
        }
        .alignItems(HorizontalAlign.Start)
      }

      if (this.showLabel) {
        Text(`${this.value}/${this.max}`)
          .fontSize(11)
          .fontColor('#9E9E9E')
          .margin({ top: 4 })
      }
    }
    .width('100%')
  }
}

// 状态标签组件
@Component
export struct StatusBadge {
  @Prop text: string = '';
  @Prop color: string = '#1E88E5';

  build() {
    Text(this.text)
      .fontSize(12)
      .fontColor(Color.White)
      .backgroundColor(this.color)
      .borderRadius(10)
      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
  }
}

// 确认弹窗组件
@Component
export struct ConfirmDialog {
  @Prop title: string = '提示';
  @Prop message: string = '';
  @Prop confirmText: string = '确定';
  @Prop cancelText: string = '取消';
  @Prop isDangerous: boolean = false;
  onConfirm: () => void = () => {};
  onCancel: () => void = () => {};

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ top: 24, bottom: 12 })

      Text(this.message)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 24 })
        .textAlign(TextAlign.Center)
        .padding({ left: 16, right: 16 })

      Row() {
        Button(this.cancelText)
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .layoutWeight(1)
          .onClick(() => {
            this.onCancel();
          })

        Text('')
          .width(1)
          .height(40)
          .backgroundColor('#F0F0F0')

        Button(this.confirmText)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(this.isDangerous ? '#F44336' : '#1E88E5')
          .borderRadius(8)
          .layoutWeight(1)
          .onClick(() => {
            this.onConfirm();
          })
      }
      .width('100%')
      .height(48)
    }
    .width('80%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }
}

// 底部弹窗组件
@Component
export struct BottomSheet {
  @Prop title: string = '';
  @Prop show: boolean = false;
  onClose: () => void = () => {};

  build() {
    if (this.show) {
      Column() {
        Blank()
          .backgroundColor('#66000000')
          .onClick(() => {
            this.onClose();
          })

        Column() {
          Row() {
            Text(this.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')

            Blank()

            Text('✕')
              .fontSize(18)
              .fontColor('#9E9E9E')
              .onClick(() => {
                this.onClose();
              })
          }
          .width('100%')
          .padding({ top: 20, bottom: 16, left: 20, right: 20 })

          if (this.title) {
            Divider()
              .color('#F0F0F0')
          }
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 16, topRight: 16 })
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
    }
  }
}
