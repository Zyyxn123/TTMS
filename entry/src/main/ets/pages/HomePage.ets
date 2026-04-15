import router from '@ohos.router';
import { Show } from '../model/DataModel';
import { dataService } from '../model/DataService';
import { ShowCard, ShowCardList, GenreFilter } from '../components/ShowCard';
import { SearchBar } from '../components/Common';

// 路由参数接口
interface RouteParams {
  showId: string;
}

// 路由选项接口
interface RouterOptions {
  url: string;
  params: RouteParams;
}

// 首页
@Entry
@Component
struct HomePage {
  @State shows: Show[] = [];
  @State hotShows: Show[] = [];
  @State upcomingShows: Show[] = [];
  @State selectedGenre: string = 'all';
  @State searchKeyword: string = '';
  @State searchResults: Show[] = [];
  @State isSearching: boolean = false;

  private genres: string[] = ['concert', 'drama', 'music', 'dance', 'comedy', 'children'];

  aboutToAppear(): void {
    this.loadData();
  }

  loadData(): void {
    this.shows = dataService.getShows();
    this.hotShows = dataService.getNowShowingShows();
    this.upcomingShows = dataService.getUpcomingShows();
  }

  filterShows(): Show[] {
    if (this.selectedGenre === 'all') {
      return this.shows;
    }
    return this.shows.filter((show: Show): boolean => show.genre === this.selectedGenre);
  }

  navigateToDetail(showId: string): void {
    const routeParams: RouteParams = {
      showId: showId
    };
    const routerOptions: RouterOptions = {
      url: 'pages/ShowDetail',
      params: routeParams
    };
    router.pushUrl(routerOptions);
  }

  searchShows(keyword: string): void {
    if (keyword.trim() === '') {
      this.searchResults = [];
      this.isSearching = false;
      return;
    }
    this.searchResults = dataService.searchShows(keyword);
    this.isSearching = true;
  }

  handleComponentAction(actionId: string): void {
    if (actionId === 'search') {
      this.searchShows(this.searchKeyword);
    } else if (actionId === 'clear') {
      this.searchResults = [];
      this.isSearching = false;
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        Column() {
          Text('TTMS')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .height(120)
        .backgroundColor('#FF4D4F')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      Column() {
        SearchBar({
          placeholder: '搜索演出、场馆、演员...',
          onAction: (actionId: string): void => {
            this.handleComponentAction(actionId);
          }
        })
          .margin({ left: 16, right: 16, top: 50 })

        if (this.isSearching) {
          this.buildSearchResults()
        } else {
          this.buildHomeContent()
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildSearchResults(): void {
    Column() {
      if (this.searchResults.length > 0) {
        List() {
          ForEach(this.searchResults, (show: Show) => {
            ListItem() {
              ShowCard({ show: show })
                .onClick(() => {
                  this.navigateToDetail(show.id);
                })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ top: 16 })
      } else {
        Column() {
          Text('🔍')
            .fontSize(60)
            .margin({ bottom: 16 })
          Text('未找到相关演出')
            .fontSize(15)
            .fontColor('#666666')
          Text('试试其他关键词')
            .fontSize(13)
            .fontColor('#999999')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildHomeContent(): void {
    Scroll() {
      Column() {
        GenreFilter({
          genres: this.genres,
          selectedGenre: this.selectedGenre,
          onGenreSelect: (genre: string): void => {
            this.selectedGenre = genre;
          }
        })

        if (this.selectedGenre === 'all' && this.hotShows.length > 0) {
          ShowCardList({
            title: '🔥 热门演出',
            shows: this.hotShows,
            onShowClick: (showId: string): void => {
              this.navigateToDetail(showId);
            }
          })

          if (this.upcomingShows.length > 0) {
            ShowCardList({
              title: '📅 即将开售',
              shows: this.upcomingShows,
              onShowClick: (showId: string): void => {
                this.navigateToDetail(showId);
              }
            })
          }
        }

        Column() {
          Row() {
            Text(this.selectedGenre === 'all' ? '📋 全部演出' : '🎭 分类演出')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .padding({ left: 16 })
          }
          .width('100%')
          .padding({ top: 16, bottom: 8 })

          ForEach(this.filterShows(), (show: Show) => {
            ShowCard({ show: show })
              .margin({ left: 16, right: 16, bottom: 12 })
              .onClick(() => {
                this.navigateToDetail(show.id);
              })
          })
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
  }
}
