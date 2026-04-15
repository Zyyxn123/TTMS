import { dataService } from '../../model/DataService';
import { SalesStats, OccupancyStats, SalesSummary } from '../../model/DataModel';

interface TimeFilter {
  label: string;
  value: string;
}

@Entry
@Component
export struct StatsHomePage {
  @State summary: SalesSummary =
    { totalTickets: 0, totalRevenue: '¥0', avgOccupancy: '0%', topShow: '' };
  @State salesStats: SalesStats[] = [];
  @State occupancyStats: OccupancyStats[] = [];
  @State isLoading: boolean = false;
  @State currentStatsTab: string = 'sales';
  @State currentTimeFilter: string = 'week';
  @State showTimeFilterSheet: boolean = false;

  private readonly timeFilters: TimeFilter[] = [
    { label: '近7天', value: 'week' },
    { label: '近30天', value: 'month' },
    { label: '本年', value: 'year' },
    { label: '全部', value: 'all' }
  ];

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.summary = dataService.getSalesSummary();
      this.salesStats = dataService.getSalesStats();
      this.occupancyStats = dataService.getOccupancyStats();
      this.isLoading = false;
    }, 300);
  }

  private selectTimeFilter(value: string): void {
    this.currentTimeFilter = value;
    this.showTimeFilterSheet = false;
  }

  private getFilterLabel(): string {
    const item: TimeFilter | undefined =
      this.timeFilters.find((f: TimeFilter): boolean => f.value === this.currentTimeFilter);
    return item !== undefined ? item.label : '近7天';
  }

  private getMaxSales(): number {
    return Math.max(...this.salesStats.map((s: SalesStats): number => s.ticketsSold), 1);
  }

  private getMaxRevenue(): number {
    return Math.max(...this.salesStats.map((s: SalesStats): number => s.revenue), 1);
  }

  private getOccupancyColor(rate: number): string {
    if (rate >= 80) return '#4CAF50';
    if (rate >= 50) return '#FF9800';
    return '#F44336';
  }

  build() {
    Column() {
      // 顶部筛选栏
      Row() {
        Row() {
          Text('📊')
            .fontSize(18)
          Text('数据统计')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })
        }

        Blank()

        Row() {
          Text(this.getFilterLabel())
            .fontSize(13)
            .fontColor('#1E88E5')
          Text(' ▼')
            .fontSize(10)
            .fontColor('#1E88E5')
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor('#E3F2FD')
        .borderRadius(16)
        .onClick(() => {
          this.showTimeFilterSheet = true;
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color('#1E88E5')
          Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 12 }) {
            // 概览卡片
            Row({ space: 8 }) {
              Column() {
                Text(String(this.summary.totalTickets))
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('累计销量 (张)')
                  .fontSize(11)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .height(88)
              .backgroundColor('#1E88E5')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)

              Column() {
                Text(this.summary.totalRevenue)
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('累计营收')
                  .fontSize(11)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .height(88)
              .backgroundColor('#4CAF50')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)

              Column() {
                Text(this.summary.avgOccupancy)
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('平均上座率')
                  .fontSize(11)
                  .fontColor('#FFFFFF')
                  .opacity(0.85)
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .height(88)
              .backgroundColor('#FF9800')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')

            // Tab切换
            Row({ space: 8 }) {
              Button('销量统计')
                .fontSize(13)
                .fontColor(this.currentStatsTab === 'sales' ? '#FFFFFF' : '#1E88E5')
                .backgroundColor(this.currentStatsTab === 'sales' ? '#1E88E5' : '#FFFFFF')
                .border({ width: 1, color: '#1E88E5' })
                .borderRadius(8)
                .height(36)
                .layoutWeight(1)
                .onClick(() => { this.currentStatsTab = 'sales'; })

              Button('上座率')
                .fontSize(13)
                .fontColor(this.currentStatsTab === 'occupancy' ? '#FFFFFF' : '#1E88E5')
                .backgroundColor(this.currentStatsTab === 'occupancy' ? '#1E88E5' : '#FFFFFF')
                .border({ width: 1, color: '#1E88E5' })
                .borderRadius(8)
                .height(36)
                .layoutWeight(1)
                .onClick(() => { this.currentStatsTab = 'occupancy'; })
            }
            .width('100%')

            // 销量统计图表
            if (this.currentStatsTab === 'sales') {
              Column() {
                Row() {
                  Text('近7日销量趋势')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Blank()
                  Row({ space: 4 }) {
                    Text('')
                      .width(10)
                      .height(10)
                      .backgroundColor('#1E88E5')
                      .borderRadius(2)
                    Text('销量')
                      .fontSize(11)
                      .fontColor('#666666')
                      .margin({ left: 2 })
                    Text('')
                      .width(10)
                      .height(10)
                      .backgroundColor('#4CAF50')
                      .borderRadius(2)
                      .margin({ left: 12 })
                    Text('营收')
                      .fontSize(11)
                      .fontColor('#666666')
                      .margin({ left: 2 })
                  }
                }
                .width('100%')
                .margin({ bottom: 16 })

                // 柱状图展示
                this.SalesBarChart()
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .padding(16)
            }

            // 上座率统计
            if (this.currentStatsTab === 'occupancy') {
              Column() {
                Text('各演出上座率')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .alignSelf(ItemAlign.Start)
                  .margin({ bottom: 12 })

                ForEach(this.occupancyStats, (stat: OccupancyStats) => {
                  Column() {
                    Row() {
                      Column() {
                        Text(stat.showName)
                          .fontSize(13)
                          .fontWeight(FontWeight.Medium)
                          .fontColor('#1A1A1A')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                        Text(`${stat.showDate} · ${stat.soldSeats}/${stat.totalSeats}张`)
                          .fontSize(11)
                          .fontColor('#9E9E9E')
                          .margin({ top: 2 })
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)

                      Text(stat.occupancyRate.toFixed(1) + '%')
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(this.getOccupancyColor(stat.occupancyRate))
                    }
                    .width('100%')
                    .margin({ bottom: 8 })

                    Stack() {
                      Column() {
                        Text('')
                          .width('100%')
                          .height(8)
                          .backgroundColor('#F0F0F0')
                          .borderRadius(4)
                      }
                      Column() {
                        Text('')
                          .width(`${stat.occupancyRate}%`)
                          .height(8)
                          .backgroundColor(this.getOccupancyColor(stat.occupancyRate))
                          .borderRadius(4)
                      }
                      .alignItems(HorizontalAlign.Start)
                    }
                    .width('100%')
                  }
                  .width('100%')
                  .margin({ bottom: 12 })
                })
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .padding(16)
            }

            // 热门演出
            Column() {
              Text('热门演出 TOP3')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              ForEach(this.occupancyStats.slice(0, 3), (stat: OccupancyStats, index: number) => {
                Row() {
                  Text(String(index + 1))
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(index === 0 ? '#FFD700' : index === 1 ? '#C0C0C0' : '#CD7F32')
                    .width(24)
                  Column() {
                    Text(stat.showName)
                      .fontSize(13)
                      .fontColor('#1A1A1A')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(`${stat.showDate}`)
                      .fontSize(11)
                      .fontColor('#9E9E9E')
                      .margin({ top: 2 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  Text(`${stat.occupancyRate.toFixed(1)}%`)
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1E88E5')
                }
                .width('100%')
                .padding({ top: 8, bottom: 8 })
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)
          }
          .padding(16)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }

      // 时间筛选弹窗
      if (this.showTimeFilterSheet) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showTimeFilterSheet = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Text('选择时间范围')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 12, left: 20, right: 20 })

          ForEach(this.timeFilters, (item: TimeFilter) => {
            Row() {
              Text(item.label)
                .fontSize(15)
                .fontColor(this.currentTimeFilter === item.value ? '#1E88E5' : '#1A1A1A')
              Blank()
              if (this.currentTimeFilter === item.value) {
                Text('✓')
                  .fontSize(16)
                  .fontColor('#1E88E5')
              }
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 14, bottom: 14 })
            .onClick(() => {
              this.selectTimeFilter(item.value);
            })
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .position({ y: '50%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 柱状图Builder
  @Builder
  SalesBarChart() {
    Row() {
      ForEach(this.salesStats, (stat: SalesStats, index: number) => {
        Column() {
          // 数值显示
          Text(`${stat.ticketsSold}`)
            .fontSize(10)
            .fontColor('#1E88E5')
            .margin({ bottom: 4 })

          // 柱子
          Column() {
            Text('')
              .width('100%')
              .height(Math.max(4, Math.round((stat.ticketsSold / this.getMaxSales()) * 120)))
              .backgroundColor(index === this.salesStats.length - 1 ? '#1E88E5' : '#64B5F6')
              .borderRadius({ topLeft: 4, topRight: 4 })
          }
          .width(28)
          .height(120)
          .justifyContent(FlexAlign.End)

          // 日期
          Text(stat.date.substring(3))
            .fontSize(9)
            .fontColor('#9E9E9E')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .margin({ left: 4, right: 4 })
      })
    }
    .width('100%')
    .height(160)
    .padding({ left: 8, right: 8 })
  }
}
