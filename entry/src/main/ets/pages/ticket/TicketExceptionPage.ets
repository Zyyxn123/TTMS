import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { TicketException, ExceptionType, ExceptionStatus, AdminRole, OperationResult, ExceptionFilterItem } from '../../model/DataModel';
import UserService from '../../model/UserService';

@Entry
@Component
export struct TicketExceptionPage {
  @State exceptions: TicketException[] = [];
  @State currentFilter: ExceptionStatus | 'ALL' = 'ALL';
  @State showFilterSheet: boolean = false;
  @State isLoading: boolean = false;
  @State selectedException: TicketException | null = null;
  @State showHandleDialog: boolean = false;
  @State handleResult: string = '';
  @State handleAction: string = '';
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  private readonly filterItems: ExceptionFilterItem[] = [
    { label: '全部', value: 'ALL' },
    { label: '待处理', value: ExceptionStatus.PENDING },
    { label: '处理中', value: ExceptionStatus.HANDLING },
    { label: '已解决', value: ExceptionStatus.RESOLVED },
    { label: '已关闭', value: ExceptionStatus.CLOSED }
  ];

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.exceptions = dataService.getExceptions();
      this.isLoading = false;
    }, 300);
  }

  private getFilteredExceptions(): TicketException[] {
    if (this.currentFilter === 'ALL') {
      return this.exceptions;
    }
    return this.exceptions.filter((e: TicketException): boolean => e.status === this.currentFilter);
  }

  private getStatusText(status: ExceptionStatus): string {
    switch (status) {
      case ExceptionStatus.PENDING: return '待处理';
      case ExceptionStatus.HANDLING: return '处理中';
      case ExceptionStatus.RESOLVED: return '已解决';
      case ExceptionStatus.CLOSED: return '已关闭';
      default: return '未知';
    }
  }

  private getStatusColor(status: ExceptionStatus): string {
    switch (status) {
      case ExceptionStatus.PENDING: return '#F44336';
      case ExceptionStatus.HANDLING: return '#FF9800';
      case ExceptionStatus.RESOLVED: return '#4CAF50';
      case ExceptionStatus.CLOSED: return '#9E9E9E';
      default: return '#9E9E9E';
    }
  }

  private getTypeText(type: ExceptionType): string {
    switch (type) {
      case ExceptionType.OVERSOLD: return '超售';
      case ExceptionType.DATA_ERROR: return '数据错误';
      case ExceptionType.REFUND_DISPUTE: return '退款争议';
      case ExceptionType.PRICE_ERROR: return '价格错误';
      case ExceptionType.OTHER: return '其他';
      default: return '未知';
    }
  }

  private getFilterLabel(): string {
    const item: ExceptionFilterItem | undefined =
      this.filterItems.find((f: ExceptionFilterItem): boolean => f.value === this.currentFilter);
    return item !== undefined ? item.label : '全部';
  }

  private openHandleDialog(exception: TicketException, action: string): void {
    this.selectedException = exception;
    this.handleAction = action;
    this.handleResult = '';
    this.showHandleDialog = true;
  }

  private confirmHandle(): void {
    if (this.selectedException === null) return;
    if (this.handleResult.trim() === '' && this.handleAction === 'resolve') {
      promptAction.showToast({ message: '请填写处理结果', duration: 2000 });
      return;
    }
    const user = UserService.getCurrentUser();
    const operatorName: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;

    let newStatus: ExceptionStatus;
    if (this.handleAction === 'resolve') {
      newStatus = ExceptionStatus.RESOLVED;
    } else if (this.handleAction === 'close') {
      newStatus = ExceptionStatus.CLOSED;
    } else {
      newStatus = ExceptionStatus.HANDLING;
    }

    dataService.updateExceptionStatus(
      this.selectedException.id,
      newStatus,
      operatorName,
      this.handleResult.trim() !== '' ? this.handleResult.trim() : undefined
    );

    UserService.addLog(
      this.handleAction === 'resolve' ? '解决异常' : this.handleAction === 'close' ? '关闭异常' : '开始处理异常',
      operatorName,
      role,
      this.selectedException.showName,
      `异常类型：${this.getTypeText(this.selectedException.type)}，处理：${this.handleResult}`,
      OperationResult.SUCCESS
    );

    this.showHandleDialog = false;
    promptAction.showToast({ message: '处理完成', duration: 2000 });
    this.loadData();
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('异常处理')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('筛选')
          .fontSize(14)
          .fontColor('#1E88E5')
          .onClick(() => { this.showFilterSheet = true; })
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      // 筛选信息栏
      Row() {
        Text(`筛选：${this.getFilterLabel()}  ·  共 ${this.getFilteredExceptions().length} 条`)
          .fontSize(12)
          .fontColor('#666666')
      }
      .width('100%')
      .padding({ left: 16, top: 8, bottom: 4 })
      .backgroundColor('#FFFFFF')

      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color('#1E88E5')
          Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.getFilteredExceptions().length === 0) {
        Column() {
          Text('✅')
            .fontSize(56)
          Text('暂无异常记录')
            .fontSize(16)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.getFilteredExceptions(), (exp: TicketException) => {
            ListItem() {
              this.ExceptionCard(exp)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }

      // 筛选底部弹窗
      if (this.showFilterSheet) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showFilterSheet = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Text('按状态筛选')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 12 })

          ForEach(this.filterItems, (item: ExceptionFilterItem) => {
            Row() {
              Text(item.label)
                .fontSize(15)
                .fontColor(this.currentFilter === item.value ? '#1E88E5' : '#1A1A1A')
              Blank()
              if (this.currentFilter === item.value) {
                Text('✓').fontSize(16).fontColor('#1E88E5')
              }
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 14, bottom: 14 })
            .onClick(() => {
              this.currentFilter = item.value;
              this.showFilterSheet = false;
            })
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 16, topRight: 16 })
        .position({ y: '50%' })
      }

      // 处理弹窗
      if (this.showHandleDialog) {
        Column() {
          Blank()
            .backgroundColor('#66000000')
            .onClick(() => { this.showHandleDialog = false; })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })

        Column() {
          Text(this.handleAction === 'resolve' ? '处理异常' : this.handleAction === 'close' ? '关闭异常' : '开始处理')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ top: 24, bottom: 16 })

          if (this.selectedException !== null) {
            Text(`${this.getTypeText(this.selectedException.type)} - ${this.selectedException.showName}`)
              .fontSize(14)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 16 })
          }

          Column({ space: 4 }) {
            Text('处理结果 / 备注')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
            TextArea({ placeholder: '请填写处理结果' })
              .placeholderColor('#9E9E9E')
              .fontSize(14)
              .fontColor('#1A1A1A')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .height(80)
              .padding(12)
              .onChange((value: string) => { this.handleResult = value; })
          }
          .width('90%')
          .margin({ bottom: 24 })

          Row() {
            Button('取消')
              .fontSize(15)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .layoutWeight(1)
              .height(44)
              .onClick(() => { this.showHandleDialog = false; })
            Text('').width(12)
            Button(this.handleAction === 'resolve' ? '确认解决' : this.handleAction === 'close' ? '确认关闭' : '确认处理')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor(this.handleAction === 'close' ? '#9E9E9E' : '#1E88E5')
              .borderRadius(8)
              .layoutWeight(1)
              .height(44)
              .onClick(() => { this.confirmHandle(); })
          }
          .width('90%')
          .margin({ bottom: 24 })
        }
        .width('85%')
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .position({ x: '7.5%', y: '25%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  ExceptionCard(exp: TicketException) {
    Column() {
      Row() {
        Column() {
          Text(this.getTypeText(exp.type))
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text(exp.showName)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text(this.getStatusText(exp.status))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getStatusColor(exp.status))
          .borderRadius(10)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
      }
      .width('100%')

      Text(exp.description)
        .fontSize(13)
        .fontColor('#666666')
        .width('100%')
        .margin({ top: 6 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)

      Row() {
        Text(`上报时间：${exp.reportTime}`)
          .fontSize(11)
          .fontColor('#9E9E9E')
        if (exp.handler !== undefined) {
          Text(`  处理人：${exp.handler}`)
            .fontSize(11)
            .fontColor('#9E9E9E')
        }
      }
      .width('100%')
      .margin({ top: 6 })

      if (exp.handleResult !== undefined) {
        Text(`处理结果：${exp.handleResult}`)
          .fontSize(12)
          .fontColor('#4CAF50')
          .width('100%')
          .margin({ top: 4 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }

      if (exp.status === ExceptionStatus.PENDING || exp.status === ExceptionStatus.HANDLING) {
        Row({ space: 8 }) {
          Button('开始处理')
            .fontSize(12)
            .fontColor('#1E88E5')
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: '#1E88E5' })
            .borderRadius(4)
            .height(32)
            .layoutWeight(1)
            .onClick(() => { this.openHandleDialog(exp, 'handle'); })

          Button('解决')
            .fontSize(12)
            .fontColor('#4CAF50')
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: '#4CAF50' })
            .borderRadius(4)
            .height(32)
            .layoutWeight(1)
            .onClick(() => { this.openHandleDialog(exp, 'resolve'); })

          Button('关闭')
            .fontSize(12)
            .fontColor('#9E9E9E')
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: '#9E9E9E' })
            .borderRadius(4)
            .height(32)
            .layoutWeight(1)
            .onClick(() => { this.openHandleDialog(exp, 'close'); })
        }
        .width('100%')
        .margin({ top: 10 })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .padding(14)
    .margin({ top: 8, bottom: 4 })
  }
}
