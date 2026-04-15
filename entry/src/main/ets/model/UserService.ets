import { AdminUser, AdminRole, OperationLog, OperationResult } from './DataModel';

const MOCK_ADMINS: AdminUser[] = [
  {
    id: 'admin_001',
    username: 'admin',
    password: 'admin123',
    name: '张运营',
    role: AdminRole.OPERATOR_ADMIN,
    phone: '13800138000',
    email: 'operator@ttms.com',
    createTime: '2024-01-01 08:00:00',
    lastLoginTime: ''
  },
  {
    id: 'admin_002',
    username: 'ticket',
    password: 'ticket123',
    name: '李票务',
    role: AdminRole.TICKET_ADMIN,
    phone: '13800138001',
    email: 'ticket@ttms.com',
    createTime: '2024-01-15 08:00:00',
    lastLoginTime: ''
  }
];

class UserServiceClass {
  private currentUser: AdminUser | null = null;
  private isRemembered: boolean = false;
  private operationLogs: OperationLog[] = [];

  login(username: string, password: string): AdminUser | null {
    const trimmedUsername: string = username.trim();
    const trimmedPassword: string = password.trim();

    for (let i: number = 0; i < MOCK_ADMINS.length; i++) {
      const admin: AdminUser = MOCK_ADMINS[i];
      if (admin.username === trimmedUsername && admin.password === trimmedPassword) {
        this.currentUser = {
          id: admin.id,
          username: admin.username,
          password: admin.password,
          name: admin.name,
          role: admin.role,
          phone: admin.phone,
          email: admin.email,
          createTime: admin.createTime,
          lastLoginTime: ''
        };
        this.addLog('登录系统', admin.name, admin.role, '账号登录', '登录成功', OperationResult.SUCCESS);
        return this.currentUser;
      }
    }
    return null;
  }

  logout(): void {
    if (this.currentUser !== null) {
      this.addLog('退出系统', this.currentUser.name, this.currentUser.role, '账号退出', '退出成功', OperationResult.SUCCESS);
    }
    this.currentUser = null;
  }

  getCurrentUser(): AdminUser | null {
    return this.currentUser;
  }

  isLoggedIn(): boolean {
    return this.currentUser !== null;
  }

  isOperatorAdmin(): boolean {
    return this.currentUser?.role === AdminRole.OPERATOR_ADMIN;
  }

  hasPermission(action: string): boolean {
    if (!this.currentUser) {
      return false;
    }
    if (this.currentUser.role === AdminRole.OPERATOR_ADMIN) {
      return true;
    }
    const ticketAdminPermissions: string[] = [
      'ticket_view', 'ticket_add', 'ticket_out', 'ticket_refund',
      'ticket_reschedule', 'exception_view', 'exception_handle',
      'stats_view'
    ];
    return ticketAdminPermissions.includes(action);
  }

  setRemembered(remembered: boolean): void {
    this.isRemembered = remembered;
  }

  getIsRemembered(): boolean {
    return this.isRemembered;
  }

  addLog(action: string, operator: string, role: AdminRole, target: string, detail: string, result: OperationResult): void {
    const log: OperationLog = {
      id: 'log_' + Date.now().toString(),
      time: this.formatTime(new Date()),
      action: action,
      operator: operator,
      operatorRole: role,
      target: target,
      detail: detail,
      result: result
    };
    this.operationLogs.unshift(log);
  }

  getLogs(): OperationLog[] {
    return this.operationLogs;
  }

  getLogsByPage(page: number, pageSize: number): OperationLog[] {
    const start: number = (page - 1) * pageSize;
    return this.operationLogs.slice(start, start + pageSize);
  }

  private formatTime(date: Date): string {
    const year: number = date.getFullYear();
    const month: string = (date.getMonth() + 1).toString().padStart(2, '0');
    const day: number = Number(date.getDate().toString().padStart(2));
    const hour: string = date.getHours().toString().padStart(2, '0');
    const minute: string = date.getMinutes().toString().padStart(2, '0');
    const second: string = date.getSeconds().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
  }
}

const userServiceInstance: UserServiceClass = new UserServiceClass();
export default userServiceInstance;
