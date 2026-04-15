import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Inventory, InventoryOverview, FilterOption } from '../../model/DataModel';
import UserService from '../../model/UserService';


@Entry
@Component
export struct InventoryListPage {
  @State inventoryList: Inventory[] = [];
  @State filteredList: Inventory[] = [];
  @State isLoading: boolean = false;
  @State currentFilter: string = 'ALL';
  @State overview: InventoryOverview =
    { totalItems: 0, totalStock: 0, warningCount: 0, soldOutCount: 0 };

  private readonly filterOptions: FilterOption[] = [
    { label: '全部', value: 'ALL' },
    { label: '正常', value: 'NORMAL' },
    { label: '预警', value: 'WARNING' },
    { label: '售罄', value: 'SOLD_OUT' }
  ];

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.inventoryList = dataService.getInventoryList();
      this.overview = dataService.getInventoryOverview();
      this.applyFilter();
      this.isLoading = false;
    }, 300);
  }

  private applyFilter(): void {
    if (this.currentFilter === 'ALL') {
      this.filteredList = this.inventoryList;
    } else if (this.currentFilter === 'NORMAL') {
      this.filteredList = this.inventoryList.filter(
        (inv: Inventory): boolean => inv.remainingCount >= inv.warningThreshold
      );
    } else if (this.currentFilter === 'WARNING') {
      this.filteredList = this.inventoryList.filter(
        (inv: Inventory): boolean => inv.remainingCount > 0 && inv.remainingCount < inv.warningThreshold
      );
    } else {
      this.filteredList = this.inventoryList.filter(
        (inv: Inventory): boolean => inv.remainingCount === 0
      );
    }
  }

  private selectFilter(value: string): void {
    this.currentFilter = value;
    this.applyFilter();
  }

  private getFilterLabel(): string {
    const item: FilterOption | undefined =
      this.filterOptions.find((f: FilterOption): boolean => f.value === this.currentFilter);
    return item !== undefined ? item.label : '全部';
  }

  private isWarning(inv: Inventory): boolean {
    return inv.remainingCount > 0 && inv.remainingCount < inv.warningThreshold;
  }

  private isSoldOut(inv: Inventory): boolean {
    return inv.remainingCount === 0;
  }

  private navigateToAdjust(inv: Inventory): void {
    router.pushUrl({ url: 'pages/inventory/InventoryAdjustPage', params: { inventoryId: inv.id } });
  }

  private navigateToWarning(): void {
    router.pushUrl({ url: 'pages/inventory/InventoryWarningPage' });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Column() {
          Text('📦')
            .fontSize(18)
          Text('库存管理')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })
        }

        Blank()

        // 预警数量提示
        if (this.overview.warningCount > 0) {
          Row() {
            Text('⚠️')
              .fontSize(14)
            Text(String(this.overview.warningCount))
              .fontSize(12)
              .fontColor('#FFFFFF')
              .backgroundColor('#F44336')
              .borderRadius(10)
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          }
          .backgroundColor('#FFEBEE')
          .borderRadius(16)
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .onClick(() => { this.navigateToWarning(); })
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column({ space: 12 }) {
          // 概览卡片
          Row({ space: 8 }) {
            Column() {
              Text(String(this.overview.totalItems))
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('总票务')
                .fontSize(11)
                .fontColor('#FFFFFF')
                .opacity(0.85)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .height(80)
            .backgroundColor('#1E88E5')
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)

            Column() {
              Text(String(this.overview.totalStock))
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('总库存')
                .fontSize(11)
                .fontColor('#FFFFFF')
                .opacity(0.85)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .height(80)
            .backgroundColor('#4CAF50')
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)

            Column() {
              Text(String(this.overview.warningCount))
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('库存预警')
                .fontSize(11)
                .fontColor('#FFFFFF')
                .opacity(0.85)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .height(80)
            .backgroundColor('#FF9800')
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)

            Column() {
              Text(String(this.overview.soldOutCount))
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('已售罄')
                .fontSize(11)
                .fontColor('#FFFFFF')
                .opacity(0.85)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .height(80)
            .backgroundColor('#F44336')
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')

          // 预警提示
          if (this.overview.warningCount > 0) {
            Row() {
              Text('⚠️')
                .fontSize(16)
              Text(`${this.overview.warningCount} 个演出库存低于预警值`)
                .fontSize(13)
                .fontColor('#FF9800')
                .layoutWeight(1)
              Text('查看 >')
                .fontSize(13)
                .fontColor('#FF9800')
                .onClick(() => { this.navigateToWarning(); })
            }
            .width('100%')
            .backgroundColor('#FFF3E0')
            .borderRadius(8)
            .padding({ left: 12, right: 12, top: 10, bottom: 10 })
          }

          // 筛选Tab
          Row() {
            ForEach(this.filterOptions, (item: FilterOption) => {
              Row() {
                Text(item.label)
                  .fontSize(13)
                  .fontColor(this.currentFilter === item.value ? '#1E88E5' : '#666666')
                  .fontWeight(this.currentFilter === item.value ? FontWeight.Bold : FontWeight.Normal)
              }
              .padding({ left: 10, right: 10, top: 6, bottom: 6 })
              .backgroundColor(this.currentFilter === item.value ? '#E3F2FD' : 'transparent')
              .borderRadius(12)
              .margin({ right: 6 })
              .onClick(() => { this.selectFilter(item.value); })
            })
          }
          .width('100%')
          .padding({ left: 4 })

          // 列表
          if (this.isLoading) {
            Column() {
              LoadingProgress().width(40).height(40).color('#1E88E5')
              Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
          } else if (this.filteredList.length === 0) {
            Column() {
              Text('📦')
                .fontSize(56)
              Text('暂无库存数据')
                .fontSize(16)
                .fontColor('#9E9E9E')
                .margin({ top: 12 })
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
          } else {
            ForEach(this.filteredList, (inv: Inventory) => {
              this.InventoryCard(inv)
            })
          }
        }
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  InventoryCard(inv: Inventory) {
    Column() {
      Row() {
        Column() {
          Text(inv.showName)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${inv.showDate} · ${inv.venue}`)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 3 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column() {
          if (this.isSoldOut(inv)) {
            Text('已售罄')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .backgroundColor('#F44336')
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          } else if (this.isWarning(inv)) {
            Text('库存预警')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .backgroundColor('#FF9800')
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          } else {
            Text('正常')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .backgroundColor('#4CAF50')
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          }
        }
      }
      .width('100%')

      // 进度条
      Row() {
        Text('已售')
          .fontSize(10)
          .fontColor('#9E9E9E')
        Stack() {
          Column() {
            Text('')
              .width('100%')
              .height(4)
              .backgroundColor('#F0F0F0')
              .borderRadius(2)
          }
          Column() {
            Text('')
              .width(`${inv.totalCount > 0 ? Math.round((inv.soldCount / inv.totalCount) * 100) : 0}%`)
              .height(4)
              .backgroundColor(this.isSoldOut(inv) ? '#F44336' : this.isWarning(inv) ? '#FF9800' : '#4CAF50')
              .borderRadius(2)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .margin({ left: 8, right: 8 })
      }
      .width('100%')
      .margin({ top: 8 })
      .alignItems(VerticalAlign.Center)

      Column() {
        Row() {
          Text('剩余')
            .fontSize(11)
            .fontColor('#9E9E9E')
          Text(`${inv.remainingCount}`)
            .fontSize(11)
            .fontColor(this.isWarning(inv) ? '#FF9800' : '#1A1A1A')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 4 })
          Text(`/ ${inv.totalCount}`)
            .fontSize(11)
            .fontColor('#9E9E9E')
          Blank()
          Text(`预警值: ${inv.warningThreshold}`)
            .fontSize(11)
            .fontColor('#9E9E9E')
        }
        .width('100%')
      }
      .width('100%')
      .margin({ top: 6 })

      Row() {
        Text(`最后调整: ${inv.lastAdjustTime} · ${inv.lastAdjustBy}`)
          .fontSize(11)
          .fontColor('#9E9E9E')
        Blank()
        Button('调整')
          .fontSize(12)
          .fontColor('#1E88E5')
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#1E88E5' })
          .borderRadius(6)
          .height(30)
          .padding({ left: 14, right: 14 })
          .onClick(() => { this.navigateToAdjust(inv); })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(14)
    .margin({ bottom: 10 })
  }
}
