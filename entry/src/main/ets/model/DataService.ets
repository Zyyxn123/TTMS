import { Show, Seat, Order, User, ShowStatus, SeatStatus, SeatType, OrderStatus, MemberLevel,
  SeatSelection, Ticket, TicketStatus, TicketException, ExceptionType, ExceptionStatus, Inventory,
  SalesStats, RevenueStats, OccupancyStats, StatsOverview, InventoryOverview, SalesSummary } from './DataModel';


// 模拟演出数据
const mockShows: Show[] = [
  {
    id: '1',
    name: '周杰伦2026世界巡回演唱会',
    venue: '国家体育馆',
    address: '北京市朝阳区国家体育场南路1号',
    date: '2026-05-20',
    time: '19:30',
    duration: '约180分钟',
    poster: $r('app.media.layered_image'),// poster_concert
    price: 380,
    description: '华语乐坛天王周杰伦时隔三年再次开启世界巡演，本次演唱会将带来《最伟大的作品》《夜曲》《七里香》等经典曲目，以及多首新专辑歌曲的首唱。周杰伦将携手国际顶级制作团队，为观众呈现一场震撼视听的音乐盛宴。',
    genre: 'concert',
    status: ShowStatus.NOW_SHOWING,
    availableSeats: 1234,
    totalSeats: 5000,
    actors: ['周杰伦'],
    tags: ['热门', '天王级', '万人合唱']
  },
  {
    id: '2',
    name: '莎士比亚经典话剧《哈姆雷特》',
    venue: '北京人民艺术剧院',
    address: '北京市东城区王府井大街22号',
    date: '2026-04-25',
    time: '19:00',
    duration: '约150分钟',
    poster: $r('app.media.layered_image'),// poster_drama
    price: 180,
    description: '英国皇家莎士比亚剧团原版呈现，改编自莎士比亚最著名的悲剧作品。全剧以忧郁的丹麦王子哈姆雷特为父报仇为主线，深刻探讨了人性、复仇、道德等永恒主题。本次演出由国际知名导演亲自执导，演员阵容强大。',
    genre: 'drama',
    status: ShowStatus.NOW_SHOWING,
    availableSeats: 456,
    totalSeats: 800,
    actors: ['王洛勇', '陈道明'],
    tags: ['经典', '名著改编', '深度思考']
  },
  {
    id: '3',
    name: '维也纳交响乐团新年音乐会',
    venue: '国家大剧院',
    address: '北京市西城区西长安街2号',
    date: '2026-06-15',
    time: '20:00',
    duration: '约120分钟',
    poster: $r('app.media.layered_image'),//poster_music
    price: 580,
    description: '维也纳交响乐团成立于1842年，是世界上最著名的交响乐团之一。本次新年音乐会，乐团将演奏贝多芬、莫扎特、施特劳斯等大师的经典作品。届时，观众将欣赏到《命运交响曲》《蓝色多瑙河》等传世名曲。',
    genre: 'music',
    status: ShowStatus.UPCOMING,
    availableSeats: 0,
    totalSeats: 2000,
    actors: ['维也纳交响乐团'],
    tags: ['高雅', '交响乐', '艺术殿堂']
  },
  {
    id: '4',
    name: '芭蕾舞剧《天鹅湖》',
    venue: '上海大剧院',
    address: '上海市黄浦区人民大道300号',
    date: '2026-05-01',
    time: '19:15',
    duration: '约140分钟',
    poster: $r('app.media.layered_image'),//poster_dance
    price: 280,
    description: '柴可夫斯基不朽名作《天鹅湖》再次登上中国舞台。由俄罗斯皇家芭蕾舞团倾情演绎，舞者们将用优美的舞姿诠释这段跨越白天鹅与黑天鹅的爱情传奇。华丽的服装、梦幻的舞美，带您进入童话般的芭蕾世界。',
    genre: 'dance',
    status: ShowStatus.NOW_SHOWING,
    availableSeats: 678,
    totalSeats: 1500,
    actors: ['俄罗斯皇家芭蕾舞团'],
    tags: ['经典芭蕾', '唯美', '亲子推荐']
  },
  {
    id: '5',
    name: '开心麻花爆笑喜剧《乌龙山伯爵》',
    venue: '北京喜剧院',
    address: '北京市朝阳区亮马桥路21号',
    date: '2026-04-18',
    time: '20:00',
    duration: '约120分钟',
    poster: $r('app.media.layered_image'),//poster_comedy
    price: 120,
    description: '开心麻花金牌喜剧《乌龙山伯爵》全国巡演！一个无房、无车、无存款的"三无青年"在一夜之间成为千万富翁的荒诞故事。爆笑的情节、密集的笑点、意想不到的反转，让你笑到肚子疼！',
    genre: 'comedy',
    status: ShowStatus.NOW_SHOWING,
    availableSeats: 234,
    totalSeats: 600,
    actors: ['沈腾', '马丽'],
    tags: ['爆笑', '解压', '周末必看']
  },
  {
    id: '6',
    name: '大型儿童剧《冰雪奇缘》',
    venue: '中国儿童艺术剧院',
    address: '北京市东城区东安门大街82号',
    date: '2026-05-10',
    time: '10:30',
    duration: '约90分钟',
    poster: $r('app.media.layered_image'),//poster_children
    price: 100,
    description: '改编自迪士尼经典动画电影《冰雪奇缘》，艾莎女王和安娜公主将来到现实世界，与小朋友们面对面互动。华丽的舞台效果、经典的电影配乐，让孩子们沉浸在魔法的世界中度过一个难忘的周末！',
    genre: 'children',
    status: ShowStatus.NOW_SHOWING,
    availableSeats: 345,
    totalSeats: 500,
    actors: ['专业儿童剧演员'],
    tags: ['亲子', '互动', '迪士尼正版']
  }
];

// 模拟座位数据（生成座位矩阵）
function generateSeats(showId: string): Seat[][] {
  const rows = 10;
  const cols = 15;
  const seats: Seat[][] = [];

  for (let row = 0; row < rows; row++) {
    const rowSeats: Seat[] = [];
    for (let col = 0; col < cols; col++) {
      // 根据位置确定座位类型和价格
      let type: SeatType;
      let price: number;

      if (row < 2) {
        type = SeatType.VIP;
        price = 880;
      } else if (row < 4) {
        type = SeatType.PREMIUM;
        price = 580;
      } else if (row < 7) {
        type = SeatType.STANDARD;
        price = 380;
      } else {
        type = SeatType.ECONOMY;
        price = 180;
      }

      // 模拟部分座位已售出
      const random = Math.random();
      let status: SeatStatus = SeatStatus.AVAILABLE;
      if (random < 0.3) {
        status = SeatStatus.SOLD;
      }

      const seatItem: Seat = {
        row: row,
        col: col,
        type: type,
        price: price,
        status: status
      };
      rowSeats.push(seatItem);
    }
    seats.push(rowSeats);
  }

  return seats;
}

// 模拟用户数据
const mockUser: User = {
  id: 'user_001',
  name: '张三',
  phone: '138****8888',
  email: 'zhangsan@example.com',
  avatar: $r('app.media.layered_image'),//avatar
  memberLevel: MemberLevel.GOLD,
  points: 5800
};

// 模拟订单数据
const mockOrders: Order[] = [
  {
    id: 'ORD20260401001',
    showId: '1',
    showName: '周杰伦2026世界巡回演唱会',
    showDate: '2026-05-20',
    showTime: '19:30',
    venue: '国家体育馆',
    seats: [
      { row: 3, col: 5, price: 580, seatNo: 'D排6座' },
      { row: 3, col: 6, price: 580, seatNo: 'D排7座' }
    ],
    totalAmount: 1160,
    status: OrderStatus.PAID,
    createTime: '2026-04-01 10:30:00',
    payTime: '2026-04-01 10:35:22',
    userName: '张三',
    phone: '138****8888'
  },
  {
    id: 'ORD20260405002',
    showId: '4',
    showName: '芭蕾舞剧《天鹅湖》',
    showDate: '2026-05-01',
    showTime: '19:15',
    venue: '上海大剧院',
    seats: [
      { row: 5, col: 7, price: 380, seatNo: 'F排8座' }
    ],
    totalAmount: 380,
    status: OrderStatus.PENDING,
    createTime: '2026-04-05 15:20:00',
    userName: '张三',
    phone: '138****8888'
  }
];

// 数据服务类
export class DataService {
  private static instance: DataService;

  private constructor() {}

  public static getInstance(): DataService {
    if (!DataService.instance) {
      DataService.instance = new DataService();
    }
    return DataService.instance;
  }

  // 获取所有演出
  getShows(): Show[] {
    return mockShows;
  }

  // 根据ID获取演出详情
  getShowById(id: string): Show | undefined {
    return mockShows.find(show => show.id === id);
  }

  // 根据类型筛选演出
  getShowsByGenre(genre: string): Show[] {
    return mockShows.filter(show => show.genre === genre);
  }

  // 获取正在热映的演出
  getNowShowingShows(): Show[] {
    return mockShows.filter(show => show.status === ShowStatus.NOW_SHOWING);
  }

  // 获取即将开售的演出
  getUpcomingShows(): Show[] {
    return mockShows.filter(show => show.status === ShowStatus.UPCOMING);
  }

  // 获取座位图
  getSeats(showId: string): Seat[][] {
    return generateSeats(showId);
  }

  // 获取当前用户
  getCurrentUser(): User {
    return mockUser;
  }

  // 获取用户订单
  getOrders(): Order[] {
    return mockOrders;
  }

  // 根据状态获取订单
  getOrdersByStatus(status: OrderStatus): Order[] {
    return mockOrders.filter(order => order.status === status);
  }

  // 创建订单
  createOrder(show: Show, seats: SeatSelection[]): Order {

    const selectedSeats: SeatSelection[] = seats.map((seat: SeatSelection): SeatSelection => {
      return {
        row: seat.row,
        col: seat.col,
        price: seat.price,
        seatNo: seat.seatNo
      };
    });

    const order: Order = {
      id: 'ORD' + Date.now(),
      showId: show.id,
      showName: show.name,
      showDate: show.date,
      showTime: show.time,
      venue: show.venue,
      seats: selectedSeats,
      totalAmount: seats.reduce((sum, seat) => sum + seat.price, 0),
      status: OrderStatus.PENDING,
      createTime: this.formatDate(new Date()),
      userName: mockUser.name,
      phone: mockUser.phone
    };

    mockOrders.unshift(order);
    return order;
  }

  // 支付订单
  payOrder(orderId: string): boolean {
    const order = mockOrders.find(o => o.id === orderId);
    if (order && order.status === OrderStatus.PENDING) {
      order.status = OrderStatus.PAID;
      order.payTime = this.formatDate(new Date());
      return true;
    }
    return false;
  }

  // 取消订单
  cancelOrder(orderId: string): boolean {
    const order = mockOrders.find(o => o.id === orderId);
    if (order && (order.status === OrderStatus.PENDING || order.status === OrderStatus.PAID)) {
      order.status = OrderStatus.CANCELLED;
      return true;
    }
    return false;
  }

  // 格式化日期
  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  // 搜索演出
  searchShows(keyword: string): Show[] {
    const lowerKeyword = keyword.toLowerCase();
    return mockShows.filter(show =>
      show.name.toLowerCase().includes(lowerKeyword) ||
      show.venue.toLowerCase().includes(lowerKeyword) ||
      show.description.toLowerCase().includes(lowerKeyword) ||
      show.actors.some(actor => actor.toLowerCase().includes(lowerKeyword))
    );
  }

  // ===================== 票务管理 =====================

  private mockTickets: Ticket[] = [
    {
      id: 'TKT001',
      showId: '1',
      showName: '周杰伦2026世界巡回演唱会',
      showDate: '2026-05-20',
      showTime: '19:30',
      venue: '国家体育馆',
      totalCount: 5000,
      soldCount: 3766,
      remainingCount: 1234,
      price: 380,
      status: TicketStatus.AVAILABLE,
      saleStartTime: '2026-03-01 10:00:00',
      saleEndTime: '2026-05-20 18:00:00',
      createTime: '2026-02-15 09:00:00',
      creator: '李票务'
    },
    {
      id: 'TKT002',
      showId: '2',
      showName: '莎士比亚经典话剧《哈姆雷特》',
      showDate: '2026-04-25',
      showTime: '19:00',
      venue: '北京人民艺术剧院',
      totalCount: 800,
      soldCount: 344,
      remainingCount: 456,
      price: 180,
      status: TicketStatus.AVAILABLE,
      saleStartTime: '2026-03-10 10:00:00',
      saleEndTime: '2026-04-25 18:00:00',
      createTime: '2026-03-01 09:00:00',
      creator: '李票务'
    },
    {
      id: 'TKT003',
      showId: '3',
      showName: '维也纳交响乐团新年音乐会',
      showDate: '2026-06-15',
      showTime: '20:00',
      venue: '国家大剧院',
      totalCount: 2000,
      soldCount: 2000,
      remainingCount: 0,
      price: 580,
      status: TicketStatus.SOLD_OUT,
      saleStartTime: '2026-04-01 10:00:00',
      saleEndTime: '2026-06-15 18:00:00',
      createTime: '2026-03-15 09:00:00',
      creator: '张运营'
    },
    {
      id: 'TKT004',
      showId: '4',
      showName: '芭蕾舞剧《天鹅湖》',
      showDate: '2026-05-01',
      showTime: '19:15',
      venue: '上海大剧院',
      totalCount: 1500,
      soldCount: 822,
      remainingCount: 678,
      price: 280,
      status: TicketStatus.LOW_STOCK,
      saleStartTime: '2026-03-20 10:00:00',
      saleEndTime: '2026-05-01 18:00:00',
      createTime: '2026-03-10 09:00:00',
      creator: '张运营'
    },
    {
      id: 'TKT005',
      showId: '5',
      showName: '开心麻花爆笑喜剧《乌龙山伯爵》',
      showDate: '2026-04-18',
      showTime: '20:00',
      venue: '北京喜剧院',
      totalCount: 600,
      soldCount: 366,
      remainingCount: 234,
      price: 120,
      status: TicketStatus.AVAILABLE,
      saleStartTime: '2026-03-25 10:00:00',
      saleEndTime: '2026-04-18 19:00:00',
      createTime: '2026-03-18 09:00:00',
      creator: '李票务'
    },
    {
      id: 'TKT006',
      showId: '6',
      showName: '大型儿童剧《冰雪奇缘》',
      showDate: '2026-05-10',
      showTime: '10:30',
      venue: '中国儿童艺术剧院',
      totalCount: 500,
      soldCount: 155,
      remainingCount: 345,
      price: 100,
      status: TicketStatus.AVAILABLE,
      saleStartTime: '2026-04-01 10:00:00',
      saleEndTime: '2026-05-10 09:00:00',
      createTime: '2026-03-20 09:00:00',
      creator: '张运营'
    }
  ];

  private mockExceptions: TicketException[] = [
    {
      id: 'EXP001',
      ticketId: 'TKT001',
      showName: '周杰伦2026世界巡回演唱会',
      type: ExceptionType.OVERSOLD,
      description: '同一座位被重复出售2次，涉及2组观众',
      status: ExceptionStatus.PENDING,
      reportTime: '2026-04-12 14:30:00'
    },
    {
      id: 'EXP002',
      ticketId: 'TKT002',
      showName: '莎士比亚经典话剧《哈姆雷特》',
      type: ExceptionType.PRICE_ERROR,
      description: '系统显示票价与实际购票价格不符',
      status: ExceptionStatus.HANDLING,
      reportTime: '2026-04-11 10:15:00',
      handler: '李票务',
      handleTime: '2026-04-11 11:00:00'
    },
    {
      id: 'EXP003',
      ticketId: 'TKT004',
      showName: '芭蕾舞剧《天鹅湖》',
      type: ExceptionType.REFUND_DISPUTE,
      description: '观众要求退款，平台拒绝后产生争议',
      status: ExceptionStatus.RESOLVED,
      reportTime: '2026-04-10 16:45:00',
      handler: '张运营',
      handleTime: '2026-04-10 17:30:00',
      handleResult: '已退款，扣除相关人员绩效'
    }
  ];

  getTickets(): Ticket[] {
    return this.mockTickets;
  }

  getTicketById(id: string): Ticket | undefined {
    return this.mockTickets.find((t: Ticket): boolean => t.id === id);
  }

  getTicketsByStatus(status: TicketStatus): Ticket[] {
    return this.mockTickets.filter((t: Ticket): boolean => t.status === status);
  }

  addTicket(ticket: Ticket): void {
    this.mockTickets.unshift(ticket);
  }

  updateTicket(id: string, updates: Partial<Ticket>): boolean {
    const index: number = this.mockTickets.findIndex((t: Ticket): boolean => t.id === id);
    if (index !== -1) {
      const existing: Ticket = this.mockTickets[index];
      const updated: Ticket = {
        id: existing.id,
        showId: updates.showId ?? existing.showId,
        showName: updates.showName ?? existing.showName,
        showDate: updates.showDate ?? existing.showDate,
        showTime: updates.showTime ?? existing.showTime,
        venue: updates.venue ?? existing.venue,
        totalCount: updates.totalCount ?? existing.totalCount,
        soldCount: updates.soldCount ?? existing.soldCount,
        remainingCount: updates.remainingCount ?? existing.remainingCount,
        price: updates.price ?? existing.price,
        status: updates.status ?? existing.status,
        saleStartTime: updates.saleStartTime ?? existing.saleStartTime,
        saleEndTime: updates.saleEndTime ?? existing.saleEndTime,
        createTime: existing.createTime,
        creator: existing.creator,
        remark: updates.remark ?? existing.remark
      };
      this.mockTickets[index] = updated;
      return true;
    }
    return false;
  }

  deleteTicket(id: string): boolean {
    const index: number = this.mockTickets.findIndex((t: Ticket): boolean => t.id === id);
    if (index !== -1) {
      this.mockTickets.splice(index, 1);
      return true;
    }
    return false;
  }

  getExceptions(): TicketException[] {
    return this.mockExceptions;
  }

  getExceptionsByStatus(status: ExceptionStatus): TicketException[] {
    return this.mockExceptions.filter((e: TicketException): boolean => e.status === status);
  }

  updateExceptionStatus(id: string, status: ExceptionStatus, handler: string, result?: string): boolean {
    const exp: TicketException | undefined = this.mockExceptions.find((e: TicketException): boolean => e.id === id);
    if (exp) {
      exp.status = status;
      exp.handler = handler;
      exp.handleTime = this.formatDate(new Date());
      if (result) {
        exp.handleResult = result;
      }
      return true;
    }
    return false;
  }

  getStatsOverview(): StatsOverview {
    const pendingCount: number = this.mockExceptions.filter(
      (e: TicketException): boolean => e.status === ExceptionStatus.PENDING || e.status === ExceptionStatus.HANDLING
    ).length;
    return {
      todaySales: this.mockTickets.reduce((sum: number, t: Ticket): number => sum + t.soldCount, 0),
      todayRevenue: '¥' + this.mockTickets.reduce((sum: number, t: Ticket): number => sum + (t.soldCount * t.price), 0).toLocaleString(),
      currentStock: this.mockTickets.reduce((sum: number, t: Ticket): number => sum + t.remainingCount, 0),
      pendingExceptions: pendingCount
    };
  }

  // ===================== 库存管理 =====================

  private mockInventory: Inventory[] = [
    {
      id: 'INV001',
      showId: '1',
      showName: '周杰伦2026世界巡回演唱会',
      showDate: '2026-05-20',
      venue: '国家体育馆',
      totalCount: 5000,
      soldCount: 3766,
      remainingCount: 1234,
      warningThreshold: 500,
      lastAdjustTime: '2026-04-10 14:30:00',
      lastAdjustBy: '李票务'
    },
    {
      id: 'INV002',
      showId: '2',
      showName: '莎士比亚经典话剧《哈姆雷特》',
      showDate: '2026-04-25',
      venue: '北京人民艺术剧院',
      totalCount: 800,
      soldCount: 344,
      remainingCount: 456,
      warningThreshold: 80,
      lastAdjustTime: '2026-04-09 10:00:00',
      lastAdjustBy: '张运营'
    },
    {
      id: 'INV003',
      showId: '3',
      showName: '维也纳交响乐团新年音乐会',
      showDate: '2026-06-15',
      venue: '国家大剧院',
      totalCount: 2000,
      soldCount: 2000,
      remainingCount: 0,
      warningThreshold: 200,
      lastAdjustTime: '2026-04-08 16:00:00',
      lastAdjustBy: '张运营'
    },
    {
      id: 'INV004',
      showId: '4',
      showName: '芭蕾舞剧《天鹅湖》',
      showDate: '2026-05-01',
      venue: '上海大剧院',
      totalCount: 1500,
      soldCount: 1320,
      remainingCount: 180,
      warningThreshold: 150,
      lastAdjustTime: '2026-04-11 09:15:00',
      lastAdjustBy: '李票务'
    },
    {
      id: 'INV005',
      showId: '5',
      showName: '开心麻花爆笑喜剧《乌龙山伯爵》',
      showDate: '2026-04-18',
      venue: '北京喜剧院',
      totalCount: 600,
      soldCount: 366,
      remainingCount: 234,
      warningThreshold: 60,
      lastAdjustTime: '2026-04-10 11:00:00',
      lastAdjustBy: '李票务'
    },
    {
      id: 'INV006',
      showId: '6',
      showName: '大型儿童剧《冰雪奇缘》',
      showDate: '2026-05-10',
      venue: '中国儿童艺术剧院',
      totalCount: 500,
      soldCount: 155,
      remainingCount: 345,
      warningThreshold: 50,
      lastAdjustTime: '2026-04-12 08:45:00',
      lastAdjustBy: '张运营'
    }
  ];

  getInventoryList(): Inventory[] {
    return this.mockInventory;
  }

  getInventoryById(id: string): Inventory | undefined {
    return this.mockInventory.find((inv: Inventory): boolean => inv.id === id);
  }

  adjustInventory(id: string, adjustAmount: number, reason: string, operator: string): boolean {
    const inv: Inventory | undefined = this.mockInventory.find((item: Inventory): boolean => item.id === id);
    if (inv) {
      inv.remainingCount = Math.max(0, inv.remainingCount + adjustAmount);
      inv.soldCount = Math.max(0, inv.totalCount - inv.remainingCount);
      inv.lastAdjustTime = this.formatDate(new Date());
      inv.lastAdjustBy = operator;
      return true;
    }
    return false;
  }

  getWarningInventory(): Inventory[] {
    return this.mockInventory.filter(
      (inv: Inventory): boolean => inv.remainingCount > 0 && inv.remainingCount < inv.warningThreshold
    );
  }

  getCriticalInventory(): Inventory[] {
    return this.mockInventory.filter(
      (inv: Inventory): boolean => inv.remainingCount === 0
    );
  }

  getInventoryOverview(): InventoryOverview {
    return {
      totalItems: this.mockInventory.length,
      totalStock: this.mockInventory.reduce((sum: number, inv: Inventory): number => sum + inv.remainingCount, 0),
      warningCount: this.getWarningInventory().length,
      soldOutCount: this.getCriticalInventory().length
    };
  }

  // ===================== 数据统计 =====================

  private mockSalesStats: SalesStats[] = [
    { date: '04-08', ticketsSold: 856, revenue: 320000 },
    { date: '04-09', ticketsSold: 1203, revenue: 456000 },
    { date: '04-10', ticketsSold: 934, revenue: 378000 },
    { date: '04-11', ticketsSold: 1567, revenue: 589000 },
    { date: '04-12', ticketsSold: 2145, revenue: 812000 },
    { date: '04-13', ticketsSold: 1890, revenue: 701000 },
    { date: '04-14', ticketsSold: 128, revenue: 45600 }
  ];

  private mockRevenueStats: RevenueStats[] = [
    { date: '04-08', totalRevenue: 320000, ticketRevenue: 300000, otherRevenue: 20000 },
    { date: '04-09', totalRevenue: 456000, ticketRevenue: 430000, otherRevenue: 26000 },
    { date: '04-10', totalRevenue: 378000, ticketRevenue: 355000, otherRevenue: 23000 },
    { date: '04-11', totalRevenue: 589000, ticketRevenue: 560000, otherRevenue: 29000 },
    { date: '04-12', totalRevenue: 812000, ticketRevenue: 780000, otherRevenue: 32000 },
    { date: '04-13', totalRevenue: 701000, ticketRevenue: 670000, otherRevenue: 31000 },
    { date: '04-14', totalRevenue: 45600, ticketRevenue: 43000, otherRevenue: 2600 }
  ];

  private mockOccupancyStats: OccupancyStats[] = [
    { showId: '1', showName: '周杰伦2026世界巡回演唱会', showDate: '2026-05-20', totalSeats: 5000, soldSeats: 3766, occupancyRate: 75.3 },
    { showId: '2', showName: '莎士比亚经典话剧《哈姆雷特》', showDate: '2026-04-25', totalSeats: 800, soldSeats: 344, occupancyRate: 43.0 },
    { showId: '3', showName: '维也纳交响乐团新年音乐会', showDate: '2026-06-15', totalSeats: 2000, soldSeats: 2000, occupancyRate: 100.0 },
    { showId: '4', showName: '芭蕾舞剧《天鹅湖》', showDate: '2026-05-01', totalSeats: 1500, soldSeats: 1320, occupancyRate: 88.0 },
    { showId: '5', showName: '开心麻花爆笑喜剧《乌龙山伯爵》', showDate: '2026-04-18', totalSeats: 600, soldSeats: 366, occupancyRate: 61.0 },
    { showId: '6', showName: '大型儿童剧《冰雪奇缘》', showDate: '2026-05-10', totalSeats: 500, soldSeats: 155, occupancyRate: 31.0 }
  ];

  getSalesStats(): SalesStats[] {
    return this.mockSalesStats;
  }

  getRevenueStats(): RevenueStats[] {
    return this.mockRevenueStats;
  }

  getOccupancyStats(): OccupancyStats[] {
    return this.mockOccupancyStats;
  }

  getSalesSummary(): SalesSummary {
    const totalTickets: number = this.mockSalesStats.reduce((sum: number, s: SalesStats): number => sum + s.ticketsSold, 0);
    const totalRev: number = this.mockSalesStats.reduce((sum: number, s: SalesStats): number => sum + s.revenue, 0);
    const avgOccupancy: number = this.mockOccupancyStats.length > 0
      ? this.mockOccupancyStats.reduce((sum: number, o: OccupancyStats): number => sum + o.occupancyRate, 0) / this.mockOccupancyStats.length
      : 0;
    const topShow: OccupancyStats | undefined = this.mockOccupancyStats.reduce((top: OccupancyStats | undefined, o: OccupancyStats): OccupancyStats | undefined => {
      return o.occupancyRate > (top?.occupancyRate ?? 0) ? o : top;
    }, undefined);
    return {
      totalTickets: totalTickets,
      totalRevenue: '¥' + totalRev.toLocaleString(),
      avgOccupancy: avgOccupancy.toFixed(1) + '%',
      topShow: topShow !== undefined ? topShow.showName : '暂无数据'
    };
  }
}

export const dataService = DataService.getInstance();
