import router from '@ohos.router';
import { dataService } from '../../model/DataService';
import { Show } from '../../model/DataModel';

/**
 * 消费端搜索页
 */
@Entry
@Component
export struct ConsumerSearchPage {
  @State searchKeyword: string = '';
  @State searchResults: Show[] = [];
  @State isSearching: boolean = false;
  @State showHistory: boolean = true;
  @State recentSearches: string[] = ['周杰伦', '演唱会', '芭蕾'];

  private searchDebounce: number = -1;

  aboutToAppear(): void {
    // 加载搜索历史
    const history = AppStorage.get<string>('consumer_search_history');
    if (history) {
      try {
        this.recentSearches = JSON.parse(history);
      } catch (e) {}
    }
  }

  // 搜索
  private handleSearch(): void {
    if (this.searchKeyword.trim() === '') {
      return;
    }

    // 添加到搜索历史
    if (!this.recentSearches.includes(this.searchKeyword.trim())) {
      this.recentSearches.unshift(this.searchKeyword.trim());
      if (this.recentSearches.length > 10) {
        this.recentSearches.pop();
      }
      AppStorage.setOrCreate('consumer_search_history', JSON.stringify(this.recentSearches));
    }

    this.showHistory = false;
    this.isSearching = true;

    setTimeout(() => {
      this.searchResults = dataService.searchShows(this.searchKeyword.trim());
      this.isSearching = false;
    }, 300);
  }

  // 点击历史搜索
  private handleHistoryClick(keyword: string): void {
    this.searchKeyword = keyword;
    this.handleSearch();
  }

  // 清空搜索历史
  private clearHistory(): void {
    this.recentSearches = [];
    AppStorage.delete('consumer_search_history');
  }

  // 清空搜索
  private clearSearch(): void {
    this.searchKeyword = '';
    this.searchResults = [];
    this.showHistory = true;
  }

  build() {
    Column() {
      // 顶部搜索栏
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

        Row() {
          Text('🔍')
            .fontSize(16)
            .margin({ left: 12 })

          TextInput({ placeholder: '搜索演出名称、场馆、演员', text: this.searchKeyword })
            .placeholderColor('#CCCCCC')
            .fontSize(15)
            .fontColor('#1A1A1A')
            .backgroundColor(Color.Transparent)
            .layoutWeight(1)
            .height(40)
            .onChange((value: string) => {
              this.searchKeyword = value;
              if (this.searchDebounce !== -1) {
                clearTimeout(this.searchDebounce);
              }
              this.searchDebounce = setTimeout(() => {
                if (value.trim() !== '') {
                  this.handleSearch();
                }
              }, 500) as number;
            })
            .onSubmit(() => { this.handleSearch(); })

          if (this.searchKeyword !== '') {
            Text('✕')
              .fontSize(14)
              .fontColor('#999999')
              .onClick(() => { this.clearSearch(); })
          }
        }
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .padding({ left: 8, right: 8 })
        .layoutWeight(1)
        .margin({ left: 8 })

        Text('搜索')
          .fontSize(15)
          .fontColor('#FF9800')
          .padding({ left: 12 })
          .onClick(() => { this.handleSearch(); })
      }
      .width('100%')
      .height(56)
      .padding({ left: 12, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.showHistory) {
        // 搜索历史
        Column() {
          Row() {
            Text('搜索历史')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Blank()
            Text('清空')
              .fontSize(13)
              .fontColor('#9E9E9E')
              .onClick(() => { this.clearHistory(); })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 12 })

          Column() {
            ForEach(this.recentSearches, (keyword: string) => {
              this.SearchTag(keyword)
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          Divider().color('#F0F0F0').margin({ top: 16 })

          // 热门搜索
          Row() {
            Text('热门搜索')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 12 })

          Column() {
            this.HotSearchItem('🔥', '周杰伦2026世界巡回演唱会')
            this.HotSearchItem('🎭', '开心麻花爆笑喜剧')
            this.HotSearchItem('🦢', '芭蕾舞剧《天鹅湖》')
            this.HotSearchItem('🎻', '维也纳交响乐团音乐会')
            this.HotSearchItem('👶', '儿童剧《冰雪奇缘》')
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        // 搜索结果
        Scroll() {
          Column() {
            if (this.isSearching) {
              Column() {
                LoadingProgress().width(36).height(36).color('#FF9800')
                Text('搜索中...').fontSize(13).fontColor('#9E9E9E').margin({ top: 8 })
              }
              .width('100%')
              .padding({ top: 40 })
            } else if (this.searchResults.length === 0) {
              Column() {
                Text('🔍')
                  .fontSize(64)
                Text('未找到相关演出')
                  .fontSize(15)
                  .fontColor('#9E9E9E')
                  .margin({ top: 12 })
                Text('换个关键词试试吧')
                  .fontSize(13)
                  .fontColor('#BBBBBB')
                  .margin({ top: 4 })
              }
              .width('100%')
              .padding({ top: 60 })
            } else {
              Row() {
                Text(`找到 ${this.searchResults.length} 个演出`)
                  .fontSize(13)
                  .fontColor('#9E9E9E')
              }
              .width('100%')
              .padding({ left: 16, top: 12, bottom: 8 })

              ForEach(this.searchResults, (show: Show) => {
                this.SearchResultCard(show)
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  HotSearchItem(icon: string, name: string) {
    Row() {
      Text(icon)
        .fontSize(14)
      Text(name)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
      Text('>')
        .fontSize(12)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .onClick(() => {
      this.searchKeyword = name.replace(/[🔥🎭🦢🎻👶]\s*/, '');
      this.handleSearch();
    })
  }

  @Builder
  SearchTag(keyword: string) {
    Row() {
      Text(keyword)
        .fontSize(13)
        .fontColor('#666666')
        .backgroundColor('#F5F5F5')
        .borderRadius(16)
        .padding({ left: 14, right: 14, top: 6, bottom: 6 })
    }
    .width('33.33%')
    .padding(4)
    .onClick(() => { this.handleHistoryClick(keyword); })
  }

  @Builder
  SearchResultCard(show: Show) {
    Column() {
      Row() {
        Column() {
          Text('🎬')
            .fontSize(40)
            .backgroundColor('#FFF3E0')
            .borderRadius(8)
            .padding(8)
        }
        .width(70)

        Column() {
          Text(show.name)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${show.date} ${show.time}`)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
          Text(show.venue)
            .fontSize(12)
            .fontColor('#9E9E9E')
            .margin({ top: 2 })
          Row() {
            Text(`¥${show.price}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF9800')
            Text('起')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .margin({ left: 2 })
          }
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor('#FAFAFA')
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 8 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/consumer/ConsumerShowDetailPage',
        params: { showId: show.id }
      });
    })
  }
}
