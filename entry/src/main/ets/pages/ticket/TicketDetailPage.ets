import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Ticket, TicketStatus, AdminRole, OperationResult } from '../../model/DataModel';
import UserService from '../../model/UserService';


@Entry
@Component
export struct TicketDetailPage {
  @State ticket: Ticket | null = null;
  @State ticketId: string = '';

  aboutToAppear(): void {
    const params: Record<string, string> = router.getParams() as Record<string, string> ?? {};
    this.ticketId = params['ticketId'] ?? '';
    this.loadData();
  }

  private loadData(): void {
    if (this.ticketId !== '') {
      const found: Ticket | undefined = dataService.getTicketById(this.ticketId);
      if (found) {
        this.ticket = found;
      }
    }
  }

  private getStatusText(status: TicketStatus): string {
    switch (status) {
      case TicketStatus.AVAILABLE: return '可售';
      case TicketStatus.LOW_STOCK: return '库存紧张';
      case TicketStatus.SOLD_OUT: return '已售罄';
      case TicketStatus.OFFLINE: return '已下架';
      case TicketStatus.EXCEPTION: return '异常';
      default: return '未知';
    }
  }

  private getStatusColor(status: TicketStatus): string {
    switch (status) {
      case TicketStatus.AVAILABLE: return '#4CAF50';
      case TicketStatus.LOW_STOCK: return '#FF9800';
      case TicketStatus.SOLD_OUT: return '#F44336';
      case TicketStatus.OFFLINE: return '#9E9E9E';
      case TicketStatus.EXCEPTION: return '#E91E63';
      default: return '#9E9E9E';
    }
  }

  private getOccupancyRate(): string {
    if (this.ticket === null) return '0%';
    const rate: number = this.ticket.totalCount > 0
      ? Math.round((this.ticket.soldCount / this.ticket.totalCount) * 100)
      : 0;
    return rate + '%';
  }

  private handleAction(action: string): void {
    switch (action) {
      case 'out':
        router.pushUrl({ url: 'pages/ticket/TicketOutPage', params: { ticketId: this.ticketId } });
        break;
      case 'refund':
        router.pushUrl({ url: 'pages/ticket/TicketRefundPage', params: { ticketId: this.ticketId } });
        break;
      case 'reschedule':
        router.pushUrl({ url: 'pages/ticket/TicketReschedulePage', params: { ticketId: this.ticketId } });
        break;
      case 'exception':
        router.pushUrl({ url: 'pages/ticket/TicketExceptionPage', params: { ticketId: this.ticketId } });
        break;
    }
  }

  private handleOffline(): void {
    if (this.ticket === null) return;
    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;

    dataService.updateTicket(this.ticketId, { status: TicketStatus.OFFLINE });
    UserService.addLog('下架票务', operatorName, role, this.ticket!.showName,
      '将票务状态改为下架', OperationResult.SUCCESS);

    promptAction.showToast({ message: '票务已下架', duration: 2000 });
    this.loadData();
  }

  private confirmOffline(): void {
    promptAction.showToast({ message: '确认下架该票务？', duration: 2000 });
    this.handleOffline();
  }

  build() {
    Column() {
      if (this.ticket === null) {
        Column() {
          Text('票务不存在')
            .fontSize(16)
            .fontColor('#9E9E9E')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 12 }) {
            Column() {
              Row() {
                Column() {
                  Text(this.ticket.showName)
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text(`${this.ticket.showDate} ${this.ticket.showTime}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                  Text(this.ticket.venue)
                    .fontSize(13)
                    .fontColor('#9E9E9E')
                    .margin({ top: 2 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Text(this.getStatusText(this.ticket.status))
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .backgroundColor(this.getStatusColor(this.ticket.status))
                    .borderRadius(12)
                    .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                }
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            Column() {
              Text('销售数据')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Row() {
                Column() {
                  Text(this.ticket.totalCount.toString())
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('总票数')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text(this.ticket.soldCount.toString())
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1E88E5')
                  Text('已售')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text(this.ticket.remainingCount.toString())
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(this.ticket.status === TicketStatus.LOW_STOCK ? '#FF9800' : '#4CAF50')
                  Text('剩余')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text(this.getOccupancyRate())
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#666666')
                  Text('上座率')
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
              }
              .width('100%')
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            Column() {
              Text('详细信息')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              this.DetailRow('票价', `¥${this.ticket.price}`)
              this.DetailRow('总票房', `¥${(this.ticket.soldCount * this.ticket.price).toLocaleString()}`)
              this.DetailRow('售票开始', this.ticket.saleStartTime)
              this.DetailRow('售票结束', this.ticket.saleEndTime)
              this.DetailRow('创建时间', this.ticket.createTime)
              this.DetailRow('创建人', this.ticket.creator)
              if (this.ticket.remark !== undefined) {
                this.DetailRow('备注', this.ticket.remark)
              }
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            Column() {
              Text('快捷操作')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              Grid() {
                GridItem() {
                  this.ActionButton('出票', '🎟️')
                }
                GridItem() {
                  this.ActionButton('退票', '💰')
                }
                GridItem() {
                  this.ActionButton('改签', '🔄')
                }
                GridItem() {
                  this.ActionButton('异常', '⚠️')
                }
              }
              .columnsTemplate('1fr 1fr 1fr 1fr')
              .rowsTemplate('1fr')
              .columnsGap(8)
              .rowsGap(8)
              .width('100%')
              .height(80)
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(16)

            if (this.ticket.status !== TicketStatus.OFFLINE) {
              Button('下架该票务')
                .width('100%')
                .height(44)
                .fontSize(15)
                .fontColor('#F44336')
                .backgroundColor('#FFFFFF')
                .border({ width: 1, color: '#F44336' })
                .borderRadius(8)
                .margin({ top: 8, bottom: 20 })
                .onClick(() => {
                  this.confirmOffline();
                })
            }
          }
          .padding(16)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  DetailRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#9E9E9E')
        .width(80)
      Text(value)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  @Builder
  ActionButton(title: string, icon: string) {
    Column() {
      Text(icon)
        .fontSize(24)
      Text(title)
        .fontSize(12)
        .fontColor('#1A1A1A')
        .margin({ top: 4 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      let action: string = '';
      switch (title) {
        case '出票': action = 'out'; break;
        case '退票': action = 'refund'; break;
        case '改签': action = 'reschedule'; break;
        case '异常': action = 'exception'; break;
      }
      this.handleAction(action);
    })
  }
}
