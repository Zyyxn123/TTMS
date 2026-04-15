import router from '@ohos.router';
import { Show, ShowStatus } from '../model/DataModel';
import { dataService } from '../model/DataService';

// 路由参数接口
interface RouteParams {
  showId: string;
}

// 座位选择路由参数接口
interface SeatRouteParams {
  showId: string;
  showName: string;
  venue: string;
  date: string;
  time: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: SeatRouteParams;
}

// 演出详情页
@Entry
@Component
struct ShowDetailPage {
  @State show: Show | null = null;
  @State showId: string = '';
  @State isLoading: boolean = true;
  @State selectedDateIndex: number = 0;
  @State selectedTimeIndex: number = 0;

  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params && params.showId) {
      this.showId = params.showId;
      this.loadShowDetail();
    }
  }

  loadShowDetail() {
    const foundShow: Show | undefined = dataService.getShowById(this.showId);
    this.show = foundShow !== undefined ? foundShow : null;
    this.isLoading = false;
  }

  getStatusText(status: ShowStatus): string {
    switch (status) {
      case ShowStatus.NOW_SHOWING: return '热卖中';
      case ShowStatus.UPCOMING: return '即将开售';
      case ShowStatus.SOLD_OUT: return '已售罄';
      case ShowStatus.ENDED: return '已结束';
      default: return '未知';
    }
  }

  getStatusColor(status: ShowStatus): string {
    switch (status) {
      case ShowStatus.NOW_SHOWING: return '#FF4D4F';
      case ShowStatus.UPCOMING: return '#1890FF';
      case ShowStatus.SOLD_OUT: return '#999999';
      case ShowStatus.ENDED: return '#666666';
      default: return '#999999';
    }
  }

  goToSeatSelection(): void {
    if (this.show !== null) {
      const routeParams: SeatRouteParams = {
        showId: this.show.id,
        showName: this.show.name,
        venue: this.show.venue,
        date: this.show.date,
        time: this.show.time
      };
      const routerOptions: RouterOptions = {
        url: 'pages/SeatSelection',
        params: routeParams
      };
      router.pushUrl(routerOptions);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#FF4D4F')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else if (this.show !== null) {
        Column() {
          this.buildNavigationBar()
          Scroll() {
            Column() {
              this.buildPosterSection()
              this.buildInfoSection()
              if (this.show !== null && this.show.actors !== null && this.show.actors.length > 0) {
                this.buildActorsSection()
              }
              this.buildDescriptionSection()
              this.buildSeatPreviewSection()
              Column().height(100)
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
          .edgeEffect(EdgeEffect.Spring)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
        this.buildBottomBar()
      } else {
        Column() {
          Text('😢')
            .fontSize(60)
            .margin({ bottom: 16 })
          Text('演出不存在')
            .fontSize(16)
            .fontColor('#666666')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildNavigationBar(): void {
    Row() {
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
        router.back();
      })

      Blank()

      Text('演出详情')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')

      Blank()

      Row() {
        Text('❤️')
          .fontSize(20)
      }
      .width(40)
      .height(40)
      .backgroundColor('#FFFFFF80')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .position({ y: 0 })
  }

  @Builder
  buildPosterSection(): void {
    if (this.show !== null) {
      Column() {
        Stack({ alignContent: Alignment.BottomStart }) {
          Column() {
            Text(this.show.genre === 'concert' ? '🎵' :
              this.show.genre === 'drama' ? '🎭' :
                this.show.genre === 'music' ? '🎻' :
                  this.show.genre === 'dance' ? '💃' :
                    this.show.genre === 'comedy' ? '😄' : '🎠')
              .fontSize(80)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(280)
              .textAlign(TextAlign.Center)
              .backgroundColor('#2A2A2A')
          }
          .width('100%')
          .height(280)

          Column()
            .width('100%')
            .height(80)
            .linearGradient({
              direction: GradientDirection.Bottom,
              colors: [['#00000000', 0.3], ['#CC000000', 0.6]]
            })

          Text(this.getStatusText(this.show.status))
            .fontSize(12)
            .fontColor(Color.White)
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .backgroundColor(this.getStatusColor(this.show.status))
            .borderRadius(14)
            .position({ x: 16, y: 16 })
        }
        .width('100%')
        .height(280)
      }
      .width('100%')
    }
  }

  @Builder
  buildInfoSection(): void {
    if (this.show !== null) {
      Column() {
        Text(this.show.name)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .padding({ left: 16, right: 16, top: 16 })

        Row() {
          Column() {
            Row() {
              Text('📅')
                .fontSize(14)
              Text(this.show.date)
                .fontSize(15)
                .fontColor('#333333')
                .margin({ left: 6 })
            }
            .alignItems(VerticalAlign.Center)
          }

          Column() {
            Row() {
              Text('🕐')
                .fontSize(14)
              Text(this.show.time)
                .fontSize(15)
                .fontColor('#333333')
                .margin({ left: 6 })
            }
            .alignItems(VerticalAlign.Center)
          }
          .margin({ left: 40 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12 })

        Row() {
          Text('🏟️')
            .fontSize(14)
          Text(this.show.venue)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 6 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })

        Row() {
          Text('⏱️')
            .fontSize(14)
          Text('演出时长: ' + this.show.duration)
            .fontSize(13)
            .fontColor('#999999')
            .margin({ left: 6 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 6 })

        if (this.show.tags !== null && this.show.tags.length > 0) {
          Row({ space: 8 }) {
            ForEach(this.show.tags, (tag: string) => {
              Text(tag)
                .fontSize(11)
                .fontColor('#FF4D4F')
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .backgroundColor('#FFF1F0')
                .borderRadius(4)
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12 })
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .margin({ top: 12 })
    }
  }

  @Builder
  buildActorsSection(): void {
    if (this.show !== null) {
      Column() {
        Text('演员阵容')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .padding({ left: 16, top: 16, bottom: 12 })

        Row({ space: 12 }) {
          ForEach(this.show.actors, (actor: string) => {
            Column() {
              Column() {
                Text('👤')
                  .fontSize(30)
              }
              .width(60)
              .height(60)
              .backgroundColor('#F5F5F5')
              .borderRadius(30)

              Text(actor)
                .fontSize(12)
                .fontColor('#333333')
                .margin({ top: 8 })
            }
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .margin({ top: 12 })
    }
  }

  @Builder
  buildDescriptionSection(): void {
    if (this.show !== null) {
      Column() {
        Text('演出介绍')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .padding({ left: 16, top: 16, bottom: 12 })

        Text(this.show.description)
          .fontSize(14)
          .fontColor('#666666')
          .lineHeight(22)
          .padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .margin({ top: 12 })
    }
  }

  @Builder
  buildSeatPreviewSection(): void {
    Column() {
      Text('座位价格')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .padding({ left: 16, top: 16, bottom: 12 })

      Column({ space: 10 }) {
        this.buildPriceRow('VIP区', '¥880', '#FFD700')
        this.buildPriceRow('贵宾区', '¥580', '#FF69B4')
        this.buildPriceRow('普通区', '¥380', '#4CAF50')
        this.buildPriceRow('经济区', '¥180', '#90CAF9')
      }
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12 })
  }

  @Builder
  buildPriceRow(name: string, price: string, color: string): void {
    Row() {
      Column() {
        Text('')
          .width(24)
          .height(24)
          .backgroundColor(color)
          .borderRadius(4)
      }

      Text(name)
        .fontSize(14)
        .fontColor('#333333')
        .margin({ left: 12 })

      Blank()

      Text(price)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FF4D4F')
    }
    .width('100%')
  }

  @Builder
  buildBottomBar(): void {
    if (this.show !== null) {
      Row() {
        Column() {
          Row() {
            Text('¥')
              .fontSize(14)
              .fontColor('#FF4D4F')
            Text(this.show.price.toString())
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF4D4F')
          }

          Text('起')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ left: 2 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Button(this.show.status === ShowStatus.NOW_SHOWING ? '立即购票' : '即将开售')
          .fontSize(16)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.show.status === ShowStatus.NOW_SHOWING ? '#FF4D4F' : '#999999')
          .borderRadius(22)
          .width(140)
          .height(44)
          .enabled(this.show.status === ShowStatus.NOW_SHOWING)
          .onClick(() => {
            if (this.show !== null && this.show.status === ShowStatus.NOW_SHOWING) {
              this.goToSeatSelection();
            }
          })
      }
      .width('100%')
      .height(70)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
      .shadow({
        radius: 10,
        color: '#20000000',
        offsetX: 0,
        offsetY: -2
      })
    }
  }
}
