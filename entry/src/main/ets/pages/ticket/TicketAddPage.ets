import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { dataService } from '../../model/DataService';
import { Ticket, TicketStatus, AdminRole, OperationResult, Show } from '../../model/DataModel';
import UserService from '../../model/UserService';

interface GenreOption {
  label: string;
  value: string;
}

@Entry
@Component
export struct TicketAddPage {
  @State showName: string = '';
  @State showDate: string = '';
  @State showTime: string = '19:30';
  @State venue: string = '';
  @State price: string = '';
  @State totalCount: string = '';
  @State saleStartTime: string = '';
  @State saleEndTime: string = '';
  @State remark: string = '';
  @State selectedGenre: string = '演唱会';
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  @State showNameError: string = '';
  @State venueError: string = '';
  @State priceError: string = '';
  @State countError: string = '';
  @State isSubmitting: boolean = false;
  @State showGenreSheet: boolean = false;
  @State showDateSheet: boolean = false;
  @State showVenueSheet: boolean = false;
  @State showSuggestions: Show[] = [];
  @State isFormFocused: boolean = false;

  private readonly genreOptions: GenreOption[] = [
    { label: '演唱会', value: '演唱会' },
    { label: '话剧', value: '话剧' },
    { label: '音乐会', value: '音乐会' },
    { label: '舞蹈', value: '舞蹈' },
    { label: '歌剧', value: '歌剧' },
    { label: '喜剧', value: '喜剧' },
    { label: '儿童剧', value: '儿童剧' }
  ];

  private readonly venues: string[] = [
    '国家大剧院', '北京人民艺术剧院', '上海大剧院', '广州大剧院',
    '深圳保利剧院', '北京天桥艺术中心', '上海东方艺术中心', '武汉琴台大剧院'
  ];

  aboutToAppear(): void {
    const today: Date = new Date();
    this.saleStartTime = this.formatDate(today);
    const allShows: Show[] = dataService.getShows();
    if (allShows.length > 0) {
      this.showSuggestions = allShows.slice(0, 6);
    }
  }

  private formatDate(date: Date): string {
    const year: number = date.getFullYear();
    const month: string = String(date.getMonth() + 1).padStart(2, '0');
    const day: string = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  private clearErrors(): void {
    this.showNameError = '';
    this.venueError = '';
    this.priceError = '';
    this.countError = '';
  }

  private validate(): boolean {
    this.clearErrors();
    let valid: boolean = true;

    if (this.showName.trim() === '') {
      this.showNameError = '请输入或选择演出名称';
      valid = false;
    }
    if (this.showDate.trim() === '') {
      promptAction.showToast({ message: '请选择演出日期', duration: 2000 });
      valid = false;
    }
    if (this.venue.trim() === '') {
      this.venueError = '请输入或选择场馆名称';
      valid = false;
    }
    const priceNum: number = Number(this.price);
    if (this.price.trim() === '' || isNaN(priceNum) || priceNum <= 0) {
      this.priceError = '请输入有效票价';
      valid = false;
    }
    const countNum: number = Number(this.totalCount);
    if (this.totalCount.trim() === '' || isNaN(countNum) || countNum <= 0) {
      this.countError = '请输入有效票数';
      valid = false;
    }
    return valid;
  }

  private selectShow(show: Show): void {
    this.showName = show.name;
    this.venue = show.venue;
    this.price = String(show.price);
  }

  private selectGenre(genre: string): void {
    this.selectedGenre = genre;
    this.showGenreSheet = false;
  }

  private selectVenue(venue: string): void {
    this.venue = venue;
    this.showVenueSheet = false;
  }

  private selectDate(): void {
    this.showDateSheet = false;
  }

  private handleSubmit(): void {
    if (!this.validate()) {
      return;
    }
    const user = UserService.getCurrentUser();
    const creator: string = user !== null ? user.name : '未知';
    const role: AdminRole = user !== null ? user.role : AdminRole.TICKET_ADMIN;

    const newTicket: Ticket = {
      id: 'TKT' + String(Date.now()).slice(-6),
      showId: 'SHOW' + String(Date.now()).slice(-6),
      showName: this.showName.trim(),
      showDate: this.showDate,
      showTime: this.showTime,
      venue: this.venue.trim(),
      totalCount: Number(this.totalCount),
      soldCount: 0,
      remainingCount: Number(this.totalCount),
      price: Number(this.price),
      status: TicketStatus.AVAILABLE,
      saleStartTime: this.saleStartTime + ' 10:00:00',
      saleEndTime: this.saleEndTime !== '' ? this.saleEndTime + ' 18:00:00' : this.showDate + ' 18:00:00',
      createTime: this.formatDate(new Date()) + ' ' + this.getCurrentTime(),
      creator: creator,
      remark: this.remark.trim() !== '' ? this.remark.trim() : undefined
    };

    this.isSubmitting = true;
    UserService.addLog('录入票务', creator, role, newTicket.showName,
      `新增票务：${newTicket.showName}，票价¥${newTicket.price}，数量${newTicket.totalCount}`,
      OperationResult.SUCCESS);

    setTimeout(() => {
      dataService.addTicket(newTicket);
      this.isSubmitting = false;
      promptAction.showToast({ message: '票务录入成功', duration: 2000 });
      router.back();
    }, 600);
  }

  private getCurrentTime(): string {
    const now: Date = new Date();
    const hour: string = String(now.getHours()).padStart(2, '0');
    const minute: string = String(now.getMinutes()).padStart(2, '0');
    const second: string = String(now.getSeconds()).padStart(2, '0');
    return `${hour}:${minute}:${second}`;
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
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          router.back();
        })

        Text('新增票务')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('保存')
          .fontSize(15)
          .fontColor('#1E88E5')
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.handleSubmit();
          })
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column({ space: 12 }) {
          // ===== 演出选择推荐 =====
          if (this.showSuggestions.length > 0 && this.showName === '') {
            Column({ space: 8 }) {
              Text('从已有演出选择（快速录入）')
                .fontSize(12)
                .fontColor('#9E9E9E')
                .alignSelf(ItemAlign.Start)
                .margin({ left: 4, bottom: 4 })

              Scroll() {
                Row({ space: 10 }) {
                  ForEach(this.showSuggestions, (show: Show) => {
                    Column() {
                      Text(show.name)
                        .fontSize(13)
                        .fontColor('#1A1A1A')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(show.venue)
                        .fontSize(11)
                        .fontColor('#9E9E9E')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .width(120)
                    .height(56)
                    .backgroundColor('#E3F2FD')
                    .borderRadius(8)
                    .padding(8)
                    .justifyContent(FlexAlign.Center)
                    .onClick(() => {
                      this.selectShow(show);
                    })
                  })
                }
              }
              .width('100%')
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .padding(12)
          }

          // ===== 演出名称 =====
          Column({ space: 6 }) {
            Row() {
              Text('演出名称')
                .fontSize(13)
                .fontColor('#666666')
              Text('*')
                .fontSize(13)
                .fontColor('#F44336')
                .margin({ left: 2 })
            }
            .alignItems(VerticalAlign.Center)
            .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: '请输入或选择演出名称', text: this.showName })
              .placeholderColor('#CCCCCC')
              .fontSize(15)
              .fontColor('#1A1A1A')
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
              .height(46)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.showName = value;
                if (this.showNameError !== '') this.showNameError = '';
              })

            if (this.showNameError !== '') {
              Text(this.showNameError)
                .fontSize(12)
                .fontColor('#F44336')
                .alignSelf(ItemAlign.Start)
                .margin({ left: 4 })
            }
          }
          .width('100%')

          // ===== 演出类型 & 日期 =====
          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Row() {
                Text('演出类型')
                  .fontSize(13)
                  .fontColor('#666666')
              }
              .alignItems(VerticalAlign.Center)
              .alignSelf(ItemAlign.Start)

              Row() {
                Text(this.selectedGenre)
                  .fontSize(15)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)
                Text('▼')
                  .fontSize(10)
                  .fontColor('#9E9E9E')
              }
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
              .height(46)
              .padding({ left: 14, right: 14 })
              .onClick(() => {
                this.showGenreSheet = true;
              })
            }
            .layoutWeight(1)

            Column({ space: 6 }) {
              Row() {
                Text('演出日期')
                  .fontSize(13)
                  .fontColor('#666666')
                Text('*')
                  .fontSize(13)
                  .fontColor('#F44336')
                  .margin({ left: 2 })
              }
              .alignItems(VerticalAlign.Center)
              .alignSelf(ItemAlign.Start)

              Row() {
                Text(this.showDate !== '' ? this.showDate : '选择日期')
                  .fontSize(15)
                  .fontColor(this.showDate !== '' ? '#1A1A1A' : '#CCCCCC')
                  .layoutWeight(1)
                Text('📅')
                  .fontSize(16)
              }
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
              .height(46)
              .padding({ left: 14, right: 14 })
              .onClick(() => {
                this.showDateSheet = true;
              })
            }
            .layoutWeight(1)
          }
          .width('100%')

          // ===== 演出时间 & 场馆 =====
          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Text('演出时间')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: '19:30', text: this.showTime })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F8F8F8')
                .borderRadius(10)
                .height(46)
                .padding({ left: 14, right: 14 })
                .onChange((value: string) => {
                  this.showTime = value;
                })
            }
            .layoutWeight(1)

            Column({ space: 6 }) {
              Row() {
                Text('场馆名称')
                  .fontSize(13)
                  .fontColor('#666666')
                Text('*')
                  .fontSize(13)
                  .fontColor('#F44336')
                  .margin({ left: 2 })
              }
              .alignItems(VerticalAlign.Center)
              .alignSelf(ItemAlign.Start)

              Row() {
                Text(this.venue !== '' ? this.venue : '选择场馆')
                  .fontSize(15)
                  .fontColor(this.venue !== '' ? '#1A1A1A' : '#CCCCCC')
                  .layoutWeight(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text('▼')
                  .fontSize(10)
                  .fontColor('#9E9E9E')
              }
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
              .height(46)
              .padding({ left: 14, right: 14 })
              .onClick(() => {
                this.showVenueSheet = true;
              })
            }
            .layoutWeight(1)
          }
          .width('100%')

          if (this.venueError !== '') {
            Text(this.venueError)
              .fontSize(12)
              .fontColor('#F44336')
              .alignSelf(ItemAlign.Start)
              .margin({ left: 4 })
          }

          // ===== 票价 & 票数 =====
          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Row() {
                Text('票价 (元)')
                  .fontSize(13)
                  .fontColor('#666666')
                Text('*')
                  .fontSize(13)
                  .fontColor('#F44336')
                  .margin({ left: 2 })
              }
              .alignItems(VerticalAlign.Center)
              .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: '0' })
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1E88E5')
                .backgroundColor('#F8F8F8')
                .borderRadius(10)
                .height(46)
                .padding({ left: 14, right: 14 })
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.price = value;
                  if (this.priceError !== '') this.priceError = '';
                })

              if (this.priceError !== '') {
                Text(this.priceError)
                  .fontSize(12)
                  .fontColor('#F44336')
                  .alignSelf(ItemAlign.Start)
                  .margin({ left: 4 })
              }
            }
            .layoutWeight(1)

            Column({ space: 6 }) {
              Row() {
                Text('总票数')
                  .fontSize(13)
                  .fontColor('#666666')
                Text('*')
                  .fontSize(13)
                  .fontColor('#F44336')
                  .margin({ left: 2 })
              }
              .alignItems(VerticalAlign.Center)
              .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: '0' })
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .backgroundColor('#F8F8F8')
                .borderRadius(10)
                .height(46)
                .padding({ left: 14, right: 14 })
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.totalCount = value;
                  if (this.countError !== '') this.countError = '';
                })

              if (this.countError !== '') {
                Text(this.countError)
                  .fontSize(12)
                  .fontColor('#F44336')
                  .alignSelf(ItemAlign.Start)
                  .margin({ left: 4 })
              }
            }
            .layoutWeight(1)
          }
          .width('100%')

          // ===== 售票时间 =====
          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Text('售票开始')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: this.saleStartTime })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F8F8F8')
                .borderRadius(10)
                .height(46)
                .padding({ left: 14, right: 14 })
                .onChange((value: string) => {
                  this.saleStartTime = value;
                })
            }
            .layoutWeight(1)

            Column({ space: 6 }) {
              Text('售票结束')
                .fontSize(13)
                .fontColor('#666666')
                .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: '演出前' })
                .fontSize(15)
                .fontColor('#1A1A1A')
                .backgroundColor('#F8F8F8')
                .borderRadius(10)
                .height(46)
                .padding({ left: 14, right: 14 })
                .onChange((value: string) => {
                  this.saleEndTime = value;
                })
            }
            .layoutWeight(1)
          }
          .width('100%')

          // ===== 备注 =====
          Column({ space: 6 }) {
            Text('备注')
              .fontSize(13)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)

            TextArea({ placeholder: '选填，可添加备注信息（如：VIP专场、儿童免费等）' })
              .placeholderColor('#CCCCCC')
              .fontSize(15)
              .fontColor('#1A1A1A')
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
              .height(80)
              .padding(14)
              .onChange((value: string) => {
                this.remark = value;
              })
          }
          .width('100%')

          // 提交按钮
          Column() {
            Button('提交录入')
              .width('100%')
              .height(50)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#1E88E5')
              .borderRadius(12)
              .enabled(!this.isSubmitting)
              .opacity(this.isSubmitting ? 0.7 : 1)
              .onClick(() => {
                this.handleSubmit();
              })

            if (this.isSubmitting) {
              Row({ space: 8 }) {
                LoadingProgress()
                  .width(18)
                  .height(18)
                  .color('#FFFFFF')
                Text('提交中...')
                  .fontSize(14)
                  .fontColor('#1E88E5')
              }
              .margin({ top: 8 })
            }
          }
          .width('100%')
          .margin({ top: 8, bottom: 20 })
        }
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // ===== 演出类型选择弹窗 =====
      if (this.showGenreSheet) {
        this.SheetOverlay(() => {
          this.showGenreSheet = false;
        })

        Column() {
          Text('选择演出类型')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 12, left: 20, right: 20 })

          ForEach(this.genreOptions, (item: GenreOption) => {
            Row() {
              Text(item.label)
                .fontSize(15)
                .fontColor(this.selectedGenre === item.value ? '#1E88E5' : '#1A1A1A')
              Blank()
              if (this.selectedGenre === item.value) {
                Text('✓')
                  .fontSize(16)
                  .fontColor('#1E88E5')
              }
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 14, bottom: 14 })
            .onClick(() => {
              this.selectGenre(item.value);
            })
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .position({ y: '45%' })
      }

      // ===== 日期选择弹窗 =====
      if (this.showDateSheet) {
        this.SheetOverlay(() => {
          this.showDateSheet = false;
        })

        Column() {
          Text('选择演出日期')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 12, left: 20, right: 20 })

          Column() {
            Text('日期格式示例：2026-05-20')
              .fontSize(12)
              .fontColor('#9E9E9E')
              .alignSelf(ItemAlign.Start)
              .margin({ left: 20, bottom: 8 })

            TextInput({ placeholder: '请输入日期，如 2026-05-20' })
              .fontSize(15)
              .fontColor('#1A1A1A')
              .backgroundColor('#F5F5F5')
              .borderRadius(10)
              .height(46)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.showDate = value;
              })
          }
          .width('100%')

          Row({ space: 12 }) {
            Button('取消')
              .fontSize(15)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .borderRadius(10)
              .height(44)
              .layoutWeight(1)
              .onClick(() => {
                this.showDateSheet = false;
              })

            Button('确认')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor('#1E88E5')
              .borderRadius(10)
              .height(44)
              .layoutWeight(1)
              .onClick(() => {
                this.selectDate();
              })
          }
          .width('90%')
          .margin({ top: 16, bottom: 20 })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .position({ y: '40%' })
      }

      // ===== 场馆选择弹窗 =====
      if (this.showVenueSheet) {
        this.SheetOverlay(() => {
          this.showVenueSheet = false;
        })

        Column() {
          Text('选择场馆')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .padding({ top: 20, bottom: 12, left: 20, right: 20 })

          Scroll() {
            Column() {
              ForEach(this.venues, (venue: string) => {
                Row() {
                  Text(venue)
                    .fontSize(15)
                    .fontColor(this.venue === venue ? '#1E88E5' : '#1A1A1A')
                  Blank()
                  if (this.venue === venue) {
                    Text('✓')
                      .fontSize(16)
                      .fontColor('#1E88E5')
                  }
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 14, bottom: 14 })
                .onClick(() => {
                  this.selectVenue(venue);
                })
              })
            }
          }
          .width('100%')
          .constraintSize({ maxHeight: 400 })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .position({ y: '30%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  SheetOverlay(onClose: () => void) {
    Column() {
      Blank()
        .backgroundColor('#66000000')
        .onClick(onClose)
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }
}
