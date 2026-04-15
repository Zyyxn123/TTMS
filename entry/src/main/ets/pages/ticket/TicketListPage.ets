import router from '@ohos.router';
import { dataService } from '../../model/DataService';
import { Ticket, TicketStatus } from '../../model/DataModel';

interface FilterItem {
  label: string;
  value: TicketStatus | 'ALL';
}


@Entry
@Component
export struct TicketListPage {
  @State tickets: Ticket[] = [];
  @State filteredTickets: Ticket[] = [];
  @State currentFilter: TicketStatus | 'ALL' = 'ALL';
  @State showFilterSheet: boolean = false;
  @State searchKeyword: string = '';
  @State isLoading: boolean = false;
  private readonly filterItems: FilterItem[] = [
    { label: '全部', value: 'ALL' },
    { label: '可售', value: TicketStatus.AVAILABLE },
    { label: '库存紧张', value: TicketStatus.LOW_STOCK },
    { label: '已售罄', value: TicketStatus.SOLD_OUT },
    { label: '已下架', value: TicketStatus.OFFLINE }
  ]

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.tickets = dataService.getTickets();
      this.applyFilter();
      this.isLoading = false;
    }, 300);
  }

  private applyFilter(): void {
    if (this.currentFilter === 'ALL') {
      if (this.searchKeyword.trim() === '') {
        this.filteredTickets = this.tickets;
      } else {
        const keyword: string = this.searchKeyword.toLowerCase();
        this.filteredTickets = this.tickets.filter(
          (t: Ticket): boolean =>
          t.showName.toLowerCase().includes(keyword) ||
          t.venue.toLowerCase().includes(keyword)
        );
      }
    } else {
      const filtered: Ticket[] = this.tickets.filter((t: Ticket): boolean => t.status === this.currentFilter);
      if (this.searchKeyword.trim() === '') {
        this.filteredTickets = filtered;
      } else {
        const keyword: string = this.searchKeyword.toLowerCase();
        this.filteredTickets = filtered.filter(
          (t: Ticket): boolean =>
          t.showName.toLowerCase().includes(keyword) ||
          t.venue.toLowerCase().includes(keyword)
        );
      }
    }
  }

  private selectFilter(value: TicketStatus | 'ALL'): void {
    this.currentFilter = value;
    this.applyFilter();
    this.showFilterSheet = false;
  }

  private getStatusText(status: TicketStatus): string {
    switch (status) {
      case TicketStatus.AVAILABLE:
        return '可售';
      case TicketStatus.LOW_STOCK:
        return '库存紧张';
      case TicketStatus.SOLD_OUT:
        return '已售罄';
      case TicketStatus.OFFLINE:
        return '已下架';
      case TicketStatus.EXCEPTION:
        return '异常';
      default:
        return '未知';
    }
  }

  private getStatusColor(status: TicketStatus): string {
    switch (status) {
      case TicketStatus.AVAILABLE:
        return '#4CAF50';
      case TicketStatus.LOW_STOCK:
        return '#FF9800';
      case TicketStatus.SOLD_OUT:
        return '#F44336';
      case TicketStatus.OFFLINE:
        return '#9E9E9E';
      case TicketStatus.EXCEPTION:
        return '#E91E63';
      default:
        return '#9E9E9E';
    }
  }

  private getFilterLabel(): string {
    const item: FilterItem | undefined =
      this.filterItems.find((f: FilterItem): boolean => f.value === this.currentFilter);
    return item !== undefined ? item.label : '全部';
  }

  private navigateToDetail(ticket: Ticket): void {
    router.pushUrl({ url: 'pages/ticket/TicketDetailPage', params: { ticketId: ticket.id } });
  }

  private navigateToAdd(): void {
    router.pushUrl({ url: 'pages/ticket/TicketAddPage' });
  }

  private navigateToException(): void {
    router.pushUrl({ url: 'pages/ticket/TicketExceptionPage' });
  }

  build() {
    Column() {
      // ===== 顶部导航栏 =====
      Row() {
        // ===== 搜索栏 =====
        Row() {
          Row() {
            Text('🔍')
              .fontSize(16)
              .margin({ left: 12 })
            TextInput({ placeholder: '搜索演出名称或场馆' })
              .placeholderColor('#9E9E9E')
              .placeholderFont({ size: 14 })
              .fontSize(14)
              .fontColor('#1A1A1A')
              .backgroundColor(Color.Transparent)
              .layoutWeight(1)
              .height(36)
              .onChange((value: string) => {
                this.searchKeyword = value;
                this.applyFilter();
              })
          }
          .backgroundColor('#F5F5F5')
          .borderRadius(18)
          .height(36)
          .padding({ right: 8 })
        }
        .layoutWeight(1)
        .margin({ right: 6 })

        Text('筛选')
          .fontSize(13)
          .fontColor('#1E88E5')
          .padding({
            left: 12,
            right: 12,
            top: 6,
            bottom: 6
          })
          .backgroundColor('#E3F2FD')
          .borderRadius(16)
          .onClick(() => {
            this.showFilterSheet = true;
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // ===== 操作栏 =====
      Row({ space: 12 }) {
        Button('异常处理')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FF9800')
          .backgroundColor('#FFF3E0')
          .border({ width: 1, color: '#FF9800' })
          .borderRadius(8)
          .height(44)
          .layoutWeight(1)
          .onClick(() => {
            this.navigateToException();
          })

        Button('新增票务')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#1E88E5')
          .borderRadius(8)
          .height(44)
          .layoutWeight(1)
          .onClick(() => {
            this.navigateToAdd();
          })
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 12
      })
      .backgroundColor('#FFFFFF')

      // ===== 快速筛选Tab =====
      Scroll() {
        Row({ space: 8 }) {
          ForEach(this.filterItems, (item: FilterItem) => {
            Text(item.label)
              .fontSize(13)
              .fontColor(this.currentFilter === item.value ? '#FFFFFF' : '#1E88E5')
              .fontWeight(this.currentFilter === item.value ? FontWeight.Bold : FontWeight.Normal)
              .padding({
                left: 14,
                right: 14,
                top: 6,
                bottom: 6
              })
              .backgroundColor(this.currentFilter === item.value ? '#1E88E5' : '#E3F2FD')
              .borderRadius(16)
              .onClick(() => {
                this.selectFilter(item.value);
              })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .height(44)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)

      // 当前筛选标签
      Row() {
        Text(`共 ${this.filteredTickets.length} 条`)
          .fontSize(12)
          .fontColor('#666666')
        if (this.currentFilter !== 'ALL') {
          Text(` · ${this.getFilterLabel()}`)
            .fontSize(12)
            .fontColor('#1E88E5')
        }
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 4,
        bottom: 8
      })
      .alignItems(VerticalAlign.Center)

      // ===== 列表内容 =====
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#1E88E5')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#9E9E9E')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.filteredTickets.length === 0) {
        Column() {
          Text('📋')
            .fontSize(56)
          Text('暂无票务数据')
            .fontSize(16)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
          Button('新增票务')
            .fontSize(14)
            .fontColor('#FFFFFF')
            .backgroundColor('#1E88E5')
            .borderRadius(8)
            .height(40)
            .width(120)
            .margin({ top: 16 })
            .onClick(() => {
              this.navigateToAdd();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ForEach(this.filteredTickets, (ticket: Ticket) => {
            ListItem() {
              this.TicketCard(ticket)
            }
          })

          ListItem()
            .height(80)
            .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
        .divider({
          strokeWidth: 1,
          color: '#F0F0F0',
          startMargin: 0,
          endMargin: 0
        })
      }

      // // ===== 筛选底部弹窗 =====
      // if (this.showFilterSheet) {
      //   Column() {
      //     Blank()
      //       .backgroundColor('#66000000')
      //       .onClick(() => {
      //         this.showFilterSheet = false;
      //       })
      //   }
      //   .width('100%')
      //   .height('100%')
      //   .position({ x: 0, y: 0 })
      //
      //   Column() {
      //     Text('按状态筛选')
      //       .fontSize(16)
      //       .fontWeight(FontWeight.Bold)
      //       .fontColor('#1A1A1A')
      //       .padding({
      //         top: 20,
      //         bottom: 16,
      //         left: 20,
      //         right: 20
      //       })
      //
      //     ForEach(this.filterItems, (item: FilterItem) => {
      //       Column() {
      //         Row() {
      //           Text(item.label)
      //             .fontSize(15)
      //             .fontColor(this.currentFilter === item.value ? '#1E88E5' : '#1A1A1A')
      //           Blank()
      //           if (this.currentFilter === item.value) {
      //             Text('✓')
      //               .fontSize(16)
      //               .fontColor('#1E88E5')
      //           }
      //         }
      //         .width('100%')
      //         .padding({
      //           left: 20,
      //           right: 20,
      //           top: 14,
      //           bottom: 14
      //         })
      //         .onClick(() => {
      //           this.selectFilter(item.value);
      //         })
      //       }
      //     })
      //   }
      //   .width('100%')
      //   .backgroundColor('#FFFFFF')
      //   .borderRadius({ topLeft: 16, topRight: 16 })
      //   .position({ y: '55%' })
      // }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  TicketCard(ticket: Ticket) {
    Column() {
      Row() {
        Column() {
          Text(ticket.showName)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${ticket.showDate} ${ticket.showTime}`)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
          Text(ticket.venue)
            .fontSize(12)
            .fontColor('#9E9E9E')
            .margin({ top: 2 })
        }
        .layoutWeight(1)

        Column() {
          Text(this.getStatusText(ticket.status))
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getStatusColor(ticket.status))
            .borderRadius(10)
            .padding({
              left: 8,
              right: 8,
              top: 2,
              bottom: 2
            })
        }
      }
      .width('100%')

      // 进度条
      Row() {
        Text('已售')
          .fontSize(11)
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
              .width(`${ticket.totalCount > 0 ? Math.round((ticket.soldCount / ticket.totalCount) * 100) : 0}%`)
              .height(4)
              .backgroundColor(this.getStatusColor(ticket.status))
              .borderRadius(2)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .margin({ left: 8, right: 8 })
      }
      .width('100%')
      .margin({ top: 10 })
      .alignItems(VerticalAlign.Center)

      Row() {
        Row() {
          Text('票价:')
            .fontSize(12)
            .fontColor('#9E9E9E')
          Text(`¥${ticket.price}`)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1E88E5')
            .margin({ left: 4 })
        }

        Row() {
          Text('剩余:')
            .fontSize(12)
            .fontColor('#9E9E9E')
          Text(`${ticket.remainingCount}/${ticket.totalCount}`)
            .fontSize(13)
            .fontColor(ticket.status === TicketStatus.LOW_STOCK ? '#FF9800' : '#1A1A1A')
            .margin({ left: 4 })
        }
        .margin({ left: 16 })

        Blank()

        Text('查看详情 >')
          .fontSize(12)
          .fontColor('#1E88E5')
      }
      .width('100%')
      .margin({ top: 8 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(14)
    .margin({ top: 8, bottom: 4 })
    .onClick(() => {
      this.navigateToDetail(ticket);
    })
  }
}
