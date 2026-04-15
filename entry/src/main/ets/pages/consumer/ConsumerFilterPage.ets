import router from '@ohos.router';
import { dataService } from '../../model/DataService';
import { Show, ShowGenre } from '../../model/DataModel';

/**
 * 消费端筛选页
 */
@Entry
@Component
export struct ConsumerFilterPage {
  @State selectedGenre: string = '';
  @State selectedTime: string = '';
  @State selectedVenue: string = '';
  @State filteredShows: Show[] = [];
  @State isFiltered: boolean = false;

  // 演出类型选项
  private readonly genres: FilterOption[] = [
    { value: '', label: '全部' },
    { value: 'concert', label: '演唱会' },
    { value: 'drama', label: '话剧' },
    { value: 'music', label: '音乐会' },
    { value: 'dance', label: '舞蹈' },
    { value: 'opera', label: '歌剧' },
    { value: 'comedy', label: '喜剧' },
    { value: 'children', label: '儿童剧' }
  ];

  // 时间选项
  private readonly timeOptions: FilterOption[] = [
    { value: '', label: '全部时间' },
    { value: 'today', label: '今天' },
    { value: 'this_week', label: '本周' },
    { value: 'this_month', label: '本月' },
    { value: 'upcoming', label: '即将开售' }
  ];

  // 场馆选项
  private readonly venues: FilterOption[] = [
    { value: '', label: '全部场馆' },
    { value: '国家体育馆', label: '国家体育馆' },
    { value: '国家大剧院', label: '国家大剧院' },
    { value: '北京人民艺术剧院', label: '北京人民艺术剧院' },
    { value: '上海大剧院', label: '上海大剧院' },
    { value: '北京喜剧院', label: '北京喜剧院' },
    { value: '中国儿童艺术剧院', label: '中国儿童艺术剧院' }
  ];

  private currentShows: Show[] = [];

  aboutToAppear(): void {
    // 接收传入的筛选条件
    const params = router.getParams() as Record<string, string>;
    if (params) {
      this.selectedGenre = params.genre || '';
      this.selectedTime = params.time || '';
      this.selectedVenue = params.venue || '';
    }

    this.applyFilter();
  }

  // 应用筛选
  private applyFilter(): void {
    this.currentShows = dataService.getShows();

    if (this.selectedGenre !== '') {
      this.currentShows = this.currentShows.filter((s: Show): boolean => s.genre === this.selectedGenre);
    }

    if (this.selectedVenue !== '') {
      this.currentShows = this.currentShows.filter((s: Show): boolean => s.venue.includes(this.selectedVenue));
    }

    // 时间筛选
    if (this.selectedTime !== '') {
      const today = new Date();
      this.currentShows = this.currentShows.filter((s: Show): boolean => {
        const showDate = new Date(s.date);
        switch (this.selectedTime) {
          case 'today':
            return showDate.toDateString() === today.toDateString();
          case 'this_week':
            const weekEnd = new Date(today);
            weekEnd.setDate(weekEnd.getDate() + 7);
            return showDate >= today && showDate <= weekEnd;
          case 'this_month':
            return showDate.getMonth() === today.getMonth() && showDate.getFullYear() === today.getFullYear();
          case 'upcoming':
            return s.status === 'upcoming';
          default:
            return true;
        }
      });
    }

    this.filteredShows = this.currentShows;
    this.isFiltered = this.selectedGenre !== '' || this.selectedTime !== '' || this.selectedVenue !== '';
  }

  // 重置筛选
  private resetFilter(): void {
    this.selectedGenre = '';
    this.selectedTime = '';
    this.selectedVenue = '';
    this.applyFilter();
  }

  // 确认筛选并返回
  private confirmFilter(): void {
    // 返回筛选结果
    router.back();
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
        .justifyContent(FlexAlign.Center)
        .onClick(() => { router.back(); })

        Text('筛选')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('重置')
          .fontSize(14)
          .fontColor('#FF9800')
          .onClick(() => { this.resetFilter(); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Row() {
        // 左侧筛选条件列表
        Column() {
          // 演出类型
          this.FilterCategory('🎭', '演出类型', this.getGenreLabel(this.selectedGenre), () => {
            this.showGenrePicker = true;
          })

          Divider().color('#F0F0F0').margin({ left: 16 })

          // 时间
          this.FilterCategory('📅', '演出时间', this.getTimeLabel(this.selectedTime), () => {
            this.showTimePicker = true;
          })

          Divider().color('#F0F0F0').margin({ left: 16 })

          // 场馆
          this.FilterCategory('🏛️', '演出场馆', this.selectedVenue === '' ? '全部场馆' : this.selectedVenue, () => {
            this.showVenuePicker = true;
          })
        }
        .width('35%')
        .backgroundColor('#FAFAFA')
        .height('100%')

        // 右侧筛选选项
        Scroll() {
          Column() {
            if (this.showGenrePicker) {
              this.FilterOptions('演出类型', this.genres, this.selectedGenre, (value: string) => {
                this.selectedGenre = value;
                this.showGenrePicker = false;
              })
            }

            if (this.showTimePicker) {
              this.FilterOptions('演出时间', this.timeOptions, this.selectedTime, (value: string) => {
                this.selectedTime = value;
                this.showTimePicker = false;
              })
            }

            if (this.showVenuePicker) {
              this.FilterOptions('演出场馆', this.venues, this.selectedVenue, (value: string) => {
                this.selectedVenue = value;
                this.showVenuePicker = false;
              })
            }

            // 筛选结果预览
            if (!this.showGenrePicker && !this.showTimePicker && !this.showVenuePicker) {
              Column() {
                Text('筛选结果')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .width('100%')
                  .padding({ bottom: 12 })

                if (this.filteredShows.length === 0) {
                  Text('暂无符合条件的演出')
                    .fontSize(13)
                    .fontColor('#9E9E9E')
                    .padding({ top: 20, bottom: 20 })
                } else {
                  ForEach(this.filteredShows.slice(0, 5), (show: Show) => {
                    this.ResultPreview(show)
                  })

                  if (this.filteredShows.length > 5) {
                    Text(`还有 ${this.filteredShows.length - 5} 个演出...`)
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                      .padding({ top: 8 })
                  }
                }
              }
              .width('100%')
              .padding(16)
            }
          }
          .width('100%')
        }
        .width('65%')
        .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)

      // 底部确认按钮
      Column() {
        Divider().color('#E8E8E8')
        Row() {
          Button('取消')
            .fontSize(15)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .height(44)
            .layoutWeight(1)
            .margin({ right: 8 })
            .onClick(() => { router.back(); })

          Button(`查看 ${this.filteredShows.length} 个演出`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF9800')
            .borderRadius(8)
            .height(44)
            .layoutWeight(1)
            .onClick(() => { this.confirmFilter(); })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')

      // 筛选选项弹窗
      if (this.showGenrePicker || this.showTimePicker || this.showVenuePicker) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showGenrePicker = false;
              this.showTimePicker = false;
              this.showVenuePicker = false;
            })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @State showGenrePicker: boolean = false;
  @State showTimePicker: boolean = false;
  @State showVenuePicker: boolean = false;

  @Builder
  FilterCategory(icon: string, title: string, value: string, onClick: () => void) {
    Row() {
      Column() {
        Text(icon)
          .fontSize(16)
        Text(title)
          .fontSize(12)
          .fontColor('#9E9E9E')
          .margin({ top: 4 })
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .onClick(onClick)

      Column() {
        Text('>')
          .fontSize(12)
          .fontColor('#CCCCCC')
      }
      .width(30)
    }
    .width('100%')
    .padding({ left: 16, right: 8 })
    .backgroundColor(this.isCategoryActive(title) ? '#FFF3E0' : 'transparent')
  }

  @Builder
  FilterOptions(title: string, options: FilterOption[], selected: string, onSelect: (value: string) => void) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .padding({ bottom: 12 })

      Column() {
        ForEach(options, (option: FilterOption) => {
          this.FilterOptionItem(option, selected, onSelect)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .padding({ top: 16 })
  }

  @Builder
  FilterOptionItem(option: FilterOption, selected: string, onSelect: (value: string) => void) {
    Row() {
      Text(option.label)
        .fontSize(13)
        .fontColor(selected === option.value ? '#FFFFFF' : '#666666')
        .backgroundColor(selected === option.value ? '#FF9800' : '#F5F5F5')
        .borderRadius(16)
        .padding({ left: 14, right: 14, top: 6, bottom: 6 })
        .onClick(() => { onSelect(option.value); })
    }
    .width('50%')
    .padding(4)
  }

  @Builder
  ResultPreview(show: Show) {
    Row() {
      Text(show.name)
        .fontSize(13)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(`¥${show.price}`)
        .fontSize(13)
        .fontColor('#FF9800')
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  private isCategoryActive(title: string): boolean {
    switch (title) {
      case '演出类型': return this.selectedGenre !== '';
      case '演出时间': return this.selectedTime !== '';
      case '演出场馆': return this.selectedVenue !== '';
      default: return false;
    }
  }

  private getGenreLabel(value: string): string {
    if (value === '') return '全部';
    const genre = this.genres.find((g: FilterOption): boolean => g.value === value);
    return genre ? genre.label : '全部';
  }

  private getTimeLabel(value: string): string {
    if (value === '') return '全部时间';
    const time = this.timeOptions.find((t: FilterOption): boolean => t.value === value);
    return time ? time.label : '全部时间';
  }
}

interface FilterOption {
  value: string;
  label: string;
}
