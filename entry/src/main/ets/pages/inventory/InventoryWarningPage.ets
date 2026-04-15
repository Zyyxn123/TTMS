import router from '@ohos.router';
import { dataService } from '../../model/DataService';
import { Inventory, WarningLevel } from '../../model/DataModel';

@Entry
@Component
export struct InventoryWarningPage {
  @State warningList: Inventory[] = [];
  @State isLoading: boolean = false;
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.warningList = dataService.getWarningInventory();
      this.isLoading = false;
    }, 300);
  }

  private getWarningLevel(inv: Inventory): WarningLevel {
    const rate: number = inv.totalCount > 0 ? inv.remainingCount / inv.totalCount : 0;
    if (rate < 0.05) {
      return { level: '严重不足', color: '#F44336', bgColor: '#FFEBEE' };
    } else if (rate < 0.1) {
      return { level: '紧急', color: '#FF5722', bgColor: '#FBE9E7' };
    }
    return { level: '预警', color: '#FF9800', bgColor: '#FFF3E0' };
  }

  private getWarnLevel(inv: Inventory): WarningLevel {
    return this.getWarningLevel(inv);
  }


  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('库存预警')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('')
          .width(40)
      }
      .width('100%')
      .height(56 + this.getUIContext().px2vp(this.topRectHeight))
      .padding({ left: 16, right: 16, top: this.getUIContext().px2vp(this.topRectHeight) })
      .backgroundColor('#FFFFFF')

      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color('#1E88E5')
          Text('加载中...').fontSize(14).fontColor('#9E9E9E').margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.warningList.length === 0) {
        Column() {
          Text('🎉')
            .fontSize(64)
          Text('暂无预警数据')
            .fontSize(16)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
          Text('所有演出库存充足')
            .fontSize(13)
            .fontColor('#4CAF50')
            .margin({ top: 6 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 10 }) {
            // 预警统计
            Row() {
              Text('⚠️')
                .fontSize(20)
              Text(`${this.warningList.length} 个演出库存低于预警值`)
                .fontSize(14)
                .fontColor('#FF9800')
                .fontWeight(FontWeight.Bold)
                .layoutWeight(1)
              Text('需关注')
                .fontSize(12)
                .fontColor('#FF9800')
            }
            .width('100%')
            .backgroundColor('#FFF3E0')
            .borderRadius(8)
            .padding({ left: 12, right: 12, top: 10, bottom: 10 })

            ForEach(this.warningList, (inv: Inventory) => {
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

                  Text(this.getWarnLevel(inv).level)
                    .fontSize(12)
                    .fontColor(this.getWarnLevel(inv).color)
                    .backgroundColor(this.getWarnLevel(inv).bgColor)
                    .borderRadius(10)
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                }
                .width('100%')

                // 进度条
                Column() {
                  Row() {
                    Text(`${inv.remainingCount}`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.getWarnLevel(inv).color)
                    Text(` / ${inv.totalCount} 张`)
                      .fontSize(13)
                      .fontColor('#9E9E9E')
                    Blank()
                    Text(`预警阈值: ${inv.warningThreshold}`)
                      .fontSize(11)
                      .fontColor('#9E9E9E')
                  }
                  .width('100%')

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
                        .width(`${inv.totalCount > 0 ? Math.min(100, Math.round((inv.remainingCount / inv.totalCount) * 100)) : 0}%`)
                        .height(8)
                        .backgroundColor(this.getWarnLevel(inv).color)
                        .borderRadius(4)
                    }
                    .alignItems(HorizontalAlign.Start)
                  }
                  .width('100%')
                  .margin({ top: 6 })
                }
                .width('100%')
                .margin({ top: 8 })

                Row() {
                  Text(`最后调整: ${inv.lastAdjustTime} · ${inv.lastAdjustBy}`)
                    .fontSize(11)
                    .fontColor('#9E9E9E')
                }
                .width('100%')
                .margin({ top: 8 })
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .padding(14)
            })
          }
          .padding(16)
          .justifyContent(FlexAlign.Start)
          .layoutWeight(1)
        }
        .alignSelf(ItemAlign.Start)
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true})
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }
}
