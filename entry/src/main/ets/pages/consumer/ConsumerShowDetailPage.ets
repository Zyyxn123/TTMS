import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Show, ShowGenre } from '../../model/DataModel';

/**
 * 消费端演出详情页
 */
@Entry
@Component
export struct ConsumerShowDetailPage {
  @State show: Show | null = null;
  @State selectedSession: number = 0;
  @State showDescription: boolean = false;
  @State isLoading: boolean = true;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params && params.showId) {
      const showData = dataService.getShowById(params.showId);
      if (showData) {
        this.show = showData;
      }
    }
    this.isLoading = false;
  }

  // 获取演出类型标签
  private getGenreLabel(genre: string): string {
    const labels: Record<string, string> = {
      'concert': '演唱会',
      'drama': '话剧',
      'music': '音乐会',
      'dance': '舞蹈',
      'opera': '歌剧',
      'comedy': '喜剧',
      'children': '儿童剧'
    };
    return labels[genre] || '演出';
  }

  // 获取状态文本
  private getStatusText(): string {
    if (!this.show) {
      return '';
    }
    switch (this.show.status) {
      case 'now_showing':
        return '热售中';
      case 'upcoming':
        return '即将开售';
      case 'sold_out':
        return '已售罄';
      case 'ended':
        return '已结束';
      default:
        return '';
    }
  }

  // 获取状态颜色
  private getStatusColor(): string {
    if (!this.show) {
      return '#FF9800';
    }
    switch (this.show.status) {
      case 'now_showing':
        return '#FF9800';
      case 'upcoming':
        return '#2196F3';
      case 'sold_out':
        return '#9E9E9E';
      case 'ended':
        return '#9E9E9E';
      default:
        return '#FF9800';
    }
  }

  // 点击购票
  private handleBuyTicket(): void {
    if (!this.show) {
      return;
    }

    if (this.show.status === 'sold_out') {
      promptAction.showToast({ message: '该演出已售罄', duration: 2000 });
      return;
    }
    if (this.show.status === 'upcoming') {
      promptAction.showToast({ message: '该演出尚未开售', duration: 2000 });
      return;
    }

    // 跳转到座位选择页
    router.pushUrl({
      url: 'pages/consumer/ConsumerSeatSelectPage',
      params: { showId: this.show.id }
    });
  }

  build() {
    if (this.isLoading || !this.show) {
      Column() {
        if (this.isLoading) {
          LoadingProgress().width(40).height(40).color('#FF9800')
          Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
        } else {
          Text('未找到演出信息').fontSize(14).fontColor('#9E9E9E')
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
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
          .onClick(() => {
            router.back();
          })

          Text('演出详情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Text('分享')
            .fontSize(14)
            .fontColor('#FF9800')
            .padding({
              left: 12,
              right: 12,
              top: 6,
              bottom: 6
            })
            .backgroundColor('#FFF3E0')
            .borderRadius(12)
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column() {
            // 演出海报区域
            Stack({ alignContent: Alignment.BottomStart }) {
              Column() {
                Text('🎬')
                  .fontSize(80)
                  .width('100%')
                  .height(220)
                  .backgroundColor('#FFF3E0')
                  .textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(220)

              // 状态标签
              Row() {
                Text(this.getStatusText())
                  .fontSize(12)
                  .fontColor('#FFFFFF')
                  .backgroundColor(this.getStatusColor())
                  .borderRadius({ topRight: 8, bottomRight: 8 })
                  .padding({
                    left: 12,
                    right: 12,
                    top: 4,
                    bottom: 4
                  })
              }
              .margin({ left: 16, bottom: 12 })
            }
            .width('100%')

            // 演出信息区域
            Column() {
              // 演出名称
              Text(this.show.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .width('100%')
                .margin({ top: 16 })

              // 演出基本信息
              Row({ space: 16 }) {
                Text(this.getGenreLabel(this.show.genre))
                  .fontSize(12)
                  .fontColor('#FF9800')
                  .backgroundColor('#FFF3E0')
                  .borderRadius(4)
                  .padding({
                    left: 8,
                    right: 8,
                    top: 2,
                    bottom: 2
                  })

                Text(this.show.duration)
                  .fontSize(12)
                  .fontColor('#9E9E9E')

                Text(this.show.venue)
                  .fontSize(12)
                  .fontColor('#9E9E9E')
              }
              .margin({ top: 8 })
              .width('100%')

              Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

              // 演出详情
              Column() {
                Row() {
                  Text('📅')
                    .fontSize(16)
                    .margin({ right: 8 })
                  Column() {
                    Text('演出时间')
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                    Text(`${this.show.date} ${this.show.time}`)
                      .fontSize(15)
                      .fontColor('#1A1A1A')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')

                Row() {
                }
                .width('100%')
                .height(12)

                Row() {
                  Text('📍')
                    .fontSize(16)
                    .margin({ right: 8 })
                  Column() {
                    Text('演出场馆')
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                    Text(this.show.venue)
                      .fontSize(15)
                      .fontColor('#1A1A1A')
                      .margin({ top: 2 })
                    Text(this.show.address)
                      .fontSize(12)
                      .fontColor('#BBBBBB')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')

                Row() {

                }
                .width('100%')
                .height(12)


                Row() {
                  Text('🎤')
                    .fontSize(16)
                    .margin({ right: 8 })
                  Column() {
                    Text('主演/演出团体')
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                    Text(this.show.actors.join(' / '))
                      .fontSize(15)
                      .fontColor('#1A1A1A')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
              }
              .width('100%')

              Divider().color('#F0F0F0').margin({ top: 12, bottom: 12 })

              // 座位/余票信息
              Row() {
                Column() {
                  Text('剩余座位')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                  Text(`${this.show.availableSeats} / ${this.show.totalSeats}`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FF9800')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Column() {
                  Text('票价')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                  Row() {
                    Text(`¥${this.show.price}`)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#FF9800')
                    Text(' 起')
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                  }
                  .margin({ top: 2 })
                }
              }
              .width('100%')

              // 标签
              if (this.show.tags && this.show.tags.length > 0) {
                Row({ space: 8 }) {
                  ForEach(this.show.tags, (tag: string) => {
                    Text(tag)
                      .fontSize(11)
                      .fontColor('#666666')
                      .backgroundColor('#F5F5F5')
                      .borderRadius(4)
                      .padding({
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4
                      })
                  })
                }
                .margin({ top: 12 })
                .width('100%')
              }
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })

            // 演出介绍
            Column() {
              Row() {
                Text('演出介绍')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
                Text(this.showDescription ? '收起' : '展开')
                  .fontSize(13)
                  .fontColor('#FF9800')
                  .onClick(() => {
                    this.showDescription = !this.showDescription;
                  })
              }
              .width('100%')
              .margin({ bottom: 8 })

              Text(this.show.description)
                .fontSize(14)
                .fontColor('#666666')
                .lineHeight(22)
                .maxLines(this.showDescription ? 100 : 4)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
            .margin({ left: 16, right: 16, top: 12 })

            // 用户评价入口
            Row() {
              Text('用户评价')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Blank()
              Text('查看全部 >')
                .fontSize(13)
                .fontColor('#FF9800')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16, top: 12 })

            // 底部占位
            Row() {
            }
            .margin({ top: 12 })
            .width('100%')
            .height(80)
          }
          .width('100%')
          .padding({ bottom: 20 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 底部购票按钮
        Column() {
          Divider().color('#E8E8E8')
          Row() {
            Column() {
              Text('¥' + this.show.price)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF9800')
              Text('最低价')
                .fontSize(11)
                .fontColor('#9E9E9E')
            }

            Button(this.show.status === 'upcoming' ? '即将开售' :
              (this.show.status === 'sold_out' ? '已售罄' : '立即购买'))
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor(this.show.status === 'sold_out' ? '#9E9E9E' : '#FF9800')
              .borderRadius(8)
              .height(44)
              .layoutWeight(1)
              .margin({ left: 16 })
              .enabled(this.show.status === 'now_showing')
              .onClick(() => {
                this.handleBuyTicket();
              })
          }
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 12
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
  }
}
