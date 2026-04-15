import router from '@ohos.router';
import UserService from '../../model/UserService';
import { OperationLog, AdminRole } from '../../model/DataModel';

@Entry
@Component
export struct OperationLogPage {
  @State logs: OperationLog[] = [];
  @State isLoading: boolean = false;

  aboutToAppear(): void {
    this.loadData();
  }

  private loadData(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.logs = UserService.getLogs();
      this.isLoading = false;
    }, 300);
  }

  private getResultColor(result: string): string {
    return result === 'SUCCESS' ? '#4CAF50' : result === 'FAILED' ? '#F44336' : '#FF9800';
  }

  private getResultText(result: string): string {
    return result === 'SUCCESS' ? '成功' : result === 'FAILED' ? '失败' : '部分成功';
  }

  private getRoleText(role: AdminRole): string {
    return role === AdminRole.OPERATOR_ADMIN ? '运营管理员' : '票务管理员';
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1A1A1A')
          .onClick(() => { router.back(); })
        Text('操作日志')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('')
          .width(40)
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
      } else if (this.logs.length === 0) {
        Column() {
          Text('📋')
            .fontSize(64)
          Text('暂无操作记录')
            .fontSize(16)
            .fontColor('#9E9E9E')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.logs, (log: OperationLog) => {
            ListItem() {
              Column() {
                Row() {
                  Column() {
                    Text(log.action)
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                    Text(`${log.operator} · ${this.getRoleText(log.operatorRole)}`)
                      .fontSize(12)
                      .fontColor('#9E9E9E')
                      .margin({ top: 2 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)

                  Text(this.getResultText(log.result))
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .backgroundColor(this.getResultColor(log.result))
                    .borderRadius(10)
                    .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                }
                .width('100%')

                if (log.target !== '') {
                  Text(`对象: ${log.target}`)
                    .fontSize(13)
                    .fontColor('#666666')
                    .width('100%')
                    .margin({ top: 4 })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                }

                if (log.detail !== '') {
                  Text(log.detail)
                    .fontSize(12)
                    .fontColor('#9E9E9E')
                    .width('100%')
                    .margin({ top: 2 })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                }

                Text(log.time)
                  .fontSize(11)
                  .fontColor('#9E9E9E')
                  .width('100%')
                  .margin({ top: 4 })
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .padding(14)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
