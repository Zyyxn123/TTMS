import router from '@ohos.router';

/**
 * 消息通知页
 */
@Entry
@Component
export struct ConsumerMessagesPage {
  @State messages: Message[] = [
    {
      id: '1',
      type: 'order',
      icon: '🎫',
      title: '订单支付成功',
      content: '您的订单 ORD20260401001 已支付成功，请按时前往观看演出',
      time: '2026-04-01 10:35',
      isRead: false
    },
    {
      id: '2',
      type: 'show',
      icon: '🎭',
      title: '新演出上架',
      content: '周杰伦2026世界巡回演唱会现已开售，快来抢购吧！',
      time: '2026-03-28 09:00',
      isRead: true
    },
    {
      id: '3',
      type: 'system',
      icon: '🔔',
      title: '系统通知',
      content: 'TTMS票务系统已完成版本更新，修复了若干问题',
      time: '2026-03-20 14:00',
      isRead: true
    },
    {
      id: '4',
      type: 'activity',
      icon: '🎁',
      title: '活动提醒',
      content: '新用户首单立减50元，快去挑选心仪的演出吧！',
      time: '2026-03-15 10:00',
      isRead: true
    }
  ];
  @State currentTab: string = 'all';

  private readonly tabs: MessageTab[] = [
    { key: 'all', label: '全部' },
    { key: 'order', label: '订单' },
    { key: 'show', label: '演出' },
    { key: 'system', label: '系统' }
  ];

  private getFilteredMessages(): Message[] {
    if (this.currentTab === 'all') {
      return this.messages;
    }
    return this.messages.filter((m: Message): boolean => m.type === this.currentTab);
  }

  private getUnreadCount(): number {
    return this.messages.filter((m: Message): boolean => !m.isRead).length;
  }

  private markAsRead(id: string): void {
    const newMessages: Message[] = [];
    for (let i: number = 0; i < this.messages.length; i++) {
      const m: Message = this.messages[i];
      if (m.id === id) {
        const readMsg: Message = {
          id: m.id,
          type: m.type,
          icon: m.icon,
          title: m.title,
          content: m.content,
          time: m.time,
          isRead: true
        };
        newMessages.push(readMsg);
      } else {
        newMessages.push(m);
      }
    }
    this.messages = newMessages;
  }

  private handleMessageClick(message: Message): void {
    if (!message.isRead) {
      this.markAsRead(message.id);
    }

    switch (message.type) {
      case 'order':
        router.pushUrl({
          url: 'pages/consumer/ConsumerOrdersPage'
        });
        break;
      default:
        break;
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

        Text('消息通知')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        if (this.getUnreadCount() > 0) {
          Text('全部已读')
            .fontSize(13)
            .fontColor('#FF9800')
            .onClick(() => {
              const newMessages: Message[] = [];
              for (let i: number = 0; i < this.messages.length; i++) {
                const m: Message = this.messages[i];
                const readMsg: Message = {
                  id: m.id,
                  type: m.type,
                  icon: m.icon,
                  title: m.title,
                  content: m.content,
                  time: m.time,
                  isRead: true
                };
                newMessages.push(readMsg);
              }
              this.messages = newMessages;
            })
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // Tab切换
      Row({ space: 8 }) {
        ForEach(this.tabs, (tab: MessageTab) => {
          Text(tab.label)
            .fontSize(13)
            .fontColor(this.currentTab === tab.key ? '#FFFFFF' : '#FF9800')
            .fontWeight(this.currentTab === tab.key ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .backgroundColor(this.currentTab === tab.key ? '#FF9800' : '#FFF3E0')
            .borderRadius(16)
            .onClick(() => {
              this.currentTab = tab.key;
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      Scroll() {
        Column() {
          if (this.getFilteredMessages().length === 0) {
            Column() {
              Text('🔔')
                .fontSize(64)
              Text('暂无消息')
                .fontSize(15)
                .fontColor('#9E9E9E')
                .margin({ top: 12 })
            }
            .width('100%')
            .padding({ top: 80 })
          } else {
            ForEach(this.getFilteredMessages(), (message: Message) => {
              Column() {
                Row() {
                  Column() {
                    Text(message.icon)
                      .fontSize(24)
                    if (!message.isRead) {
                      Text('')
                        .width(8)
                        .height(8)
                        .backgroundColor('#F44336')
                        .borderRadius(4)
                        .position({ x: 30, y: -2 })
                    }
                  }
                  .width(40)

                  Column() {
                    Row() {
                      Text(message.title)
                        .fontSize(15)
                        .fontColor('#1A1A1A')
                        .fontWeight(message.isRead ? FontWeight.Normal : FontWeight.Bold)
                      Blank()
                      Text(message.time)
                        .fontSize(11)
                        .fontColor('#9E9E9E')
                    }
                    .width('100%')

                    Text(message.content)
                      .fontSize(13)
                      .fontColor('#666666')
                      .margin({ top: 6 })
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
              }
              .width('100%')
              .backgroundColor(message.isRead ? '#FFFFFF' : '#FFF8E1')
              .borderRadius(12)
              .padding(16)
              .margin({ left: 16, right: 16, bottom: 8 })
              .onClick(() => { this.handleMessageClick(message); })
            })
          }
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

interface Message {
  id: string;
  type: string;
  icon: string;
  title: string;
  content: string;
  time: string;
  isRead: boolean;
}

interface MessageTab {
  key: string;
  label: string;
}
