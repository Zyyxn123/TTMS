import { Show, ShowStatus } from '../model/DataModel';

export type CardActionCallback = (showId: string) => void;
export type GenreActionCallback = (genre: string) => void;

// 演出卡片组件
@Component
export struct ShowCard {
  @Prop show: Show;

  getStatusColor(status: ShowStatus): string {
    switch (status) {
      case ShowStatus.NOW_SHOWING: return '#FF4D4F';
      case ShowStatus.UPCOMING: return '#1890FF';
      case ShowStatus.SOLD_OUT: return '#999999';
      case ShowStatus.ENDED: return '#666666';
      default: return '#999999';
    }
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

  getGenreIcon(genre: string): string {
    switch (genre) {
      case 'concert': return '🎵';
      case 'drama': return '🎭';
      case 'music': return '🎻';
      case 'dance': return '💃';
      case 'opera': return '🎼';
      case 'comedy': return '😄';
      case 'children': return '🎠';
      default: return '🎪';
    }
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            Text(this.getGenreIcon(this.show.genre))
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .width(100)
              .height(140)
              .textAlign(TextAlign.Center)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
          }
          .width(100)
          .height(140)

          Text(this.getStatusText(this.show.status))
            .fontSize(10)
            .fontColor(Color.White)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(this.getStatusColor(this.show.status))
            .borderRadius({ topLeft: 8, bottomRight: 8 })
        }
        .width(100)
        .height(140)

        Column() {
          Text(this.show.name)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')

          Blank()

          Row() {
            Text('🏟️').fontSize(12)
            Text(this.show.venue).fontSize(12).fontColor('#666666')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Row() {
            Text('📅').fontSize(12)
            Text(this.show.date + ' ' + this.show.time).fontSize(12).fontColor('#666666')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 4 })

          Row() {
            Text() {
              Span('¥').fontSize(12).fontColor('#FF4D4F')
              Span(this.show.price.toString()).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FF4D4F')
            }
            Blank()
            if (this.show.availableSeats > 0) {
              Text('余票 ' + this.show.availableSeats).fontSize(11).fontColor('#666666')
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .height(140)
        .padding({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}

// 横向列表
@Component
export struct ShowCardList {
  @Prop title: string = '';
  @Prop shows: Show[] = [];
  @Prop showMore: boolean = false;
  onShowClick: CardActionCallback = () => {};

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      List({ space: 12 }) {
        ForEach(this.shows, (show: Show) => {
          ListItem() {
            HorizontalShowCard({
              show: show,
              onShowClick: this.onShowClick
            })
          }
        })
      }
      .listDirection(Axis.Horizontal)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
  }
}

// 横向卡片
@Component
export struct HorizontalShowCard {
  @Prop show: Show;
  onShowClick: CardActionCallback = () => {};

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Text(this.show.genre === 'concert' ? '🎵' :
            this.show.genre === 'drama' ? '🎭' :
              this.show.genre === 'music' ? '🎻' :
                this.show.genre === 'dance' ? '💃' :
                  this.show.genre === 'comedy' ? '😄' : '🎠')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .width(140)
            .height(180)
            .textAlign(TextAlign.Center)
            .backgroundColor('#F8F8F8')
            .borderRadius(8)
        }
        .width(140)
        .height(180)

        Row() {
          Text('¥' + this.show.price)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .backgroundColor('#FF4D4F')
        .borderRadius({ topLeft: 8, bottomRight: 8 })
      }
      .width(140)
      .height(180)

      Text(this.show.name)
        .fontSize(13)
        .fontColor('#1A1A1A')
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(140)
        .margin({ top: 8 })

      Text(this.show.date)
        .fontSize(11)
        .fontColor('#999999')
        .width(140)
        .margin({ top: 2 })
    }
    .width(140)
    .onClick(() => {
      this.onShowClick(this.show.id);
    })
  }
}

// 分类筛选
@Component
export struct GenreFilter {
  @Prop genres: string[] = [];
  @Prop selectedGenre: string = '';
  onGenreSelect: GenreActionCallback = () => {};

  private genreNames: Record<string, string> = {
    'all': '全部',
    'concert': '演唱会',
    'drama': '话剧',
    'music': '音乐会',
    'dance': '舞蹈',
    'comedy': '喜剧',
    'children': '儿童剧'
  };

  build() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(['all', ...this.genres], (genre: string) => {
          Text(this.genreNames[genre] || genre)
            .fontSize(13)
            .fontColor(this.selectedGenre === genre ? Color.White : '#666666')
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .backgroundColor(this.selectedGenre === genre ? '#FF4D4F' : '#F5F5F5')
            .borderRadius(16)
            .onClick(() => {
              this.onGenreSelect(genre);
            })
        })
      }
      .padding({ left: 16, right: 16 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
  }
}
