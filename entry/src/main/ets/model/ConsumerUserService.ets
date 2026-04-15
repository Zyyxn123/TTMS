import { ConsumerUser } from '../model/DataModel';

/**
 * 消费者用户服务
 * 负责消费者用户的注册、登录、状态管理
 */

// 存储键名
const STORAGE_KEY_CURRENT_USER = 'consumer_current_user';
const STORAGE_KEY_USER_LIST = 'consumer_user_list';
const STORAGE_KEY_IS_REMEMBERED = 'consumer_is_remembered';

export class ConsumerUserService {
  private static instance: ConsumerUserService;
  private currentUser: ConsumerUser | null = null;
  private userList: ConsumerUser[] = [];

  private constructor() {
    this.loadUserList();
    this.loadCurrentUser();
  }

  public static getInstance(): ConsumerUserService {
    if (!ConsumerUserService.instance) {
      ConsumerUserService.instance = new ConsumerUserService();
    }
    return ConsumerUserService.instance;
  }

  // 加载用户列表（模拟数据库）
  private loadUserList(): void {
    const stored = AppStorage.get<string>(STORAGE_KEY_USER_LIST);
    if (stored) {
      try {
        this.userList = JSON.parse(stored);
      } catch {
        this.userList = [];
      }
    } else {
      // 初始化一些测试用户
      this.userList = [
        {
          id: 'C001',
          phone: '13800138001',
          password: '123456',
          name: '张三',
          avatar: undefined,
          createTime: '2026-01-01',
          lastLoginTime: undefined
        },
        {
          id: 'C002',
          phone: '13800138002',
          password: '123456',
          name: '李四',
          avatar: undefined,
          createTime: '2026-01-15',
          lastLoginTime: undefined
        }
      ];
      this.saveUserList();
    }
  }

  // 保存用户列表
  private saveUserList(): void {
    AppStorage.setOrCreate(STORAGE_KEY_USER_LIST, JSON.stringify(this.userList));
  }

  // 加载当前用户
  private loadCurrentUser(): void {
    const stored = AppStorage.get<string>(STORAGE_KEY_CURRENT_USER);
    if (stored) {
      try {
        this.currentUser = JSON.parse(stored);
      } catch {
        this.currentUser = null;
      }
    }
  }

  // 保存当前用户
  private saveCurrentUser(): void {
    if (this.currentUser) {
      AppStorage.setOrCreate(STORAGE_KEY_CURRENT_USER, JSON.stringify(this.currentUser));
    } else {
      AppStorage.delete(STORAGE_KEY_CURRENT_USER);
    }
  }

  // 获取当前用户
  public getCurrentUser(): ConsumerUser | null {
    return this.currentUser;
  }

  // 是否已登录
  public isLoggedIn(): boolean {
    return this.currentUser !== null;
  }

  // 发送验证码（模拟）
  public sendVerifyCode(phone: string): boolean {
    // 验证手机号格式
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
      return false;
    }
    // 模拟发送验证码
    console.info(`[ConsumerUserService] 验证码已发送至 ${phone}`);
    return true;
  }

  // 注册
  public register(phone: string, password: string, verifyCode: string, name: string = ''): ConsumerUser | null {
    // 验证手机号格式
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
      return null;
    }

    // 验证验证码（模拟：任何6位数字都可以）
    if (verifyCode.length !== 6) {
      return null;
    }

    // 验证密码
    if (password.length < 6) {
      return null;
    }

    // 检查手机号是否已注册
    const existingUser = this.userList.find((u: ConsumerUser): boolean => u.phone === phone);
    if (existingUser) {
      return null;
    }

    // 创建新用户
    const newUser: ConsumerUser = {
      id: 'C' + Date.now().toString().slice(-6),
      phone: phone,
      password: password,
      name: name !== '' ? name : `用户${phone.slice(-4)}`,
      avatar: undefined,
      createTime: this.formatDate(new Date()),
      lastLoginTime: undefined
    };

    this.userList.push(newUser);
    this.saveUserList();

    // 自动登录
    this.currentUser = newUser;
    this.saveCurrentUser();

    return newUser;
  }

  // 登录
  public login(phone: string, password: string): ConsumerUser | null {
    // 验证手机号格式
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
      return null;
    }

    // 查找用户
    const user = this.userList.find((u: ConsumerUser): boolean => u.phone === phone && u.password === password);
    if (!user) {
      return null;
    }

    // 更新最后登录时间
    user.lastLoginTime = this.formatDate(new Date());
    this.saveUserList();

    // 设置当前用户
    this.currentUser = user;
    this.saveCurrentUser();

    return user;
  }

  // 验证码登录
  public loginWithCode(phone: string, verifyCode: string): ConsumerUser | null {
    // 验证手机号格式
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
      return null;
    }

    // 验证验证码（模拟：任何6位数字都可以）
    if (verifyCode.length !== 6) {
      return null;
    }

    // 查找或创建用户
    let user = this.userList.find((u: ConsumerUser): boolean => u.phone === phone);
    if (!user) {
      // 自动注册
      user = {
        id: 'C' + Date.now().toString().slice(-6),
        phone: phone,
        password: '',
        name: `用户${phone.slice(-4)}`,
        avatar: undefined,
        createTime: this.formatDate(new Date()),
        lastLoginTime: undefined
      };
      this.userList.push(user);
      this.saveUserList();
    }

    // 更新最后登录时间
    user.lastLoginTime = this.formatDate(new Date());
    this.saveUserList();

    // 设置当前用户
    this.currentUser = user;
    this.saveCurrentUser();

    return user;
  }

  // 更新用户信息
  public updateUser(user: Partial<ConsumerUser>): boolean {
    if (!this.currentUser) {
      return false;
    }

    const index = this.userList.findIndex((u: ConsumerUser): boolean => u.id === this.currentUser!.id);
    if (index === -1) {
      return false;
    }

    this.currentUser = this.currentUser;
    this.userList[index] = this.currentUser;
    this.saveUserList();
    this.saveCurrentUser();

    return true;
  }

  // 修改密码
  public changePassword(oldPassword: string, newPassword: string): boolean {
    if (!this.currentUser) {
      return false;
    }

    if (this.currentUser.password !== '' && this.currentUser.password !== oldPassword) {
      return false;
    }

    if (newPassword.length < 6) {
      return false;
    }

    return this.updateUser({ password: newPassword });
  }

  // 退出登录
  public logout(): void {
    this.currentUser = null;
    this.saveCurrentUser();
  }

  // 获取是否记住密码
  public getIsRemembered(): boolean {
    return AppStorage.get<boolean>(STORAGE_KEY_IS_REMEMBERED) ?? false;
  }

  // 设置是否记住密码
  public setRemembered(remembered: boolean): void {
    AppStorage.setOrCreate(STORAGE_KEY_IS_REMEMBERED, remembered);
  }

  // 格式化日期
  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = String(date.getHours()).padStart(2, '0');
    const minute = String(date.getMinutes()).padStart(2, '0');
    const second = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
  }
}

export const consumerUserService = ConsumerUserService.getInstance();
