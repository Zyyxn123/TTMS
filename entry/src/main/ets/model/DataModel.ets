// 演出数据模型
export interface Show {
  id: string;
  name: string;
  venue: string;
  address: string;
  date: string;
  time: string;
  duration: string;
  poster: ResourceStr;
  price: number;
  description: string;
  genre: string;
  status: ShowStatus;
  availableSeats: number;
  totalSeats: number;
  actors: string[];
  tags: string[];
}

export enum ShowStatus {
  NOW_SHOWING = 'now_showing',
  UPCOMING = 'upcoming',
  SOLD_OUT = 'sold_out',
  ENDED = 'ended'
}

export enum ShowGenre {
  CONCERT = 'concert',
  DRAMA = 'drama',
  MUSIC = 'music',
  DANCE = 'dance',
  OPERA = 'opera',
  COMEDY = 'comedy',
  CHILDREN = 'children'
}

// 座位模型
export interface Seat {
  row: number;
  col: number;
  type: SeatType;
  price: number;
  status: SeatStatus;
}

export enum SeatType {
  VIP = 'vip',
  PREMIUM = 'premium',
  STANDARD = 'standard',
  ECONOMY = 'economy'
}

export enum SeatStatus {
  AVAILABLE = 'available',
  SELECTED = 'selected',
  SOLD = 'sold',
  LOCKED = 'locked'
}

// 订单模型
export interface Order {
  id: string;
  showId: string;
  showName: string;
  showDate: string;
  showTime: string;
  venue: string;
  seats: SeatSelection[];
  totalAmount: number;
  status: OrderStatus;
  createTime: string;
  payTime?: string;
  userName: string;
  phone: string;
}

export interface SeatSelection {
  row: number;
  col: number;
  price: number;
  seatNo: string;
}

export enum OrderStatus {
  PENDING = 'pending',
  PAID = 'paid',
  CANCELLED = 'cancelled',
  REFUNDED = 'refunded',
  USED = 'used'
}

// 用户模型（用户端）
export interface User {
  id: string;
  name: string;
  phone: string;
  email?: string;
  avatar?: ResourceStr;
  memberLevel: MemberLevel;
  points: number;
}

export enum MemberLevel {
  NORMAL = 'normal',
  SILVER = 'silver',
  GOLD = 'gold',
  PLATINUM = 'platinum'
}

// 消费者用户模型
export interface ConsumerUser {
  id: string;
  phone: string;
  password: string;
  name: string;
  avatar?: ResourceStr;
  createTime: string;
  lastLoginTime?: string;
}

// ===================== 管理员端数据模型 =====================

// 管理员角色
export enum AdminRole {
  TICKET_ADMIN = 'TICKET_ADMIN',     // 票务管理员
  OPERATOR_ADMIN = 'OPERATOR_ADMIN' // 运营管理员
}

// 管理员用户
export interface AdminUser {
  id: string;
  username: string;
  password: string;
  name: string;
  role: AdminRole;
  phone: string;
  email?: string;
  avatar?: ResourceStr;
  createTime: string;
  lastLoginTime?: string;
}

// 操作日志
export interface OperationLog {
  id: string;
  time: string;
  action: string;
  operator: string;
  operatorRole: AdminRole;
  target: string;
  detail: string;
  result: OperationResult;
}

export enum OperationResult {
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
  PARTIAL = 'PARTIAL'
}

// 票务状态
export enum TicketStatus {
  AVAILABLE = 'AVAILABLE',       // 可售
  LOW_STOCK = 'LOW_STOCK',       // 库存紧张
  SOLD_OUT = 'SOLD_OUT',         // 售罄
  OFFLINE = 'OFFLINE',           // 下架
  EXCEPTION = 'EXCEPTION'        // 异常
}

// 票务记录
export interface Ticket {
  id: string;
  showId: string;
  showName: string;
  showDate: string;
  showTime: string;
  venue: string;
  totalCount: number;
  soldCount: number;
  remainingCount: number;
  price: number;
  status: TicketStatus;
  saleStartTime: string;
  saleEndTime: string;
  createTime: string;
  creator: string;
  remark?: string;
}

// 票务异常
export interface TicketException {
  id: string;
  ticketId: string;
  showName: string;
  type: ExceptionType;
  description: string;
  status: ExceptionStatus;
  reportTime: string;
  handler?: string;
  handleTime?: string;
  handleResult?: string;
}

export enum ExceptionType {
  OVERSOLD = 'OVERSOLD',           // 超售
  DATA_ERROR = 'DATA_ERROR',       // 数据错误
  REFUND_DISPUTE = 'REFUND_DISPUTE', // 退款争议
  PRICE_ERROR = 'PRICE_ERROR',     // 价格错误
  OTHER = 'OTHER'
}

export enum ExceptionStatus {
  PENDING = 'PENDING',             // 待处理
  HANDLING = 'HANDLING',           // 处理中
  RESOLVED = 'RESOLVED',           // 已解决
  CLOSED = 'CLOSED'                // 已关闭
}

// 库存记录
export interface Inventory {
  id: string;
  showId: string;
  showName: string;
  showDate: string;
  venue: string;
  totalCount: number;
  soldCount: number;
  remainingCount: number;
  warningThreshold: number;
  lastAdjustTime: string;
  lastAdjustBy: string;
}

// 统计数据
export interface SalesStats {
  date: string;
  ticketsSold: number;
  revenue: number;
}

export interface RevenueStats {
  date: string;
  totalRevenue: number;
  ticketRevenue: number;
  otherRevenue: number;
}

export interface OccupancyStats {
  showId: string;
  showName: string;
  showDate: string;
  totalSeats: number;
  soldSeats: number;
  occupancyRate: number;
}

export interface StatsOverview {
  todaySales: number;
  todayRevenue: string;
  currentStock: number;
  pendingExceptions: number;
}

export interface InventoryOverview {
  totalItems: number;
  totalStock: number;
  warningCount: number;
  soldOutCount: number;
}

export interface SalesSummary {
  totalTickets: number;
  totalRevenue: string;
  avgOccupancy: string;
  topShow: string;
}

export interface WarningLevel {
  level: string;
  color: string;
  bgColor: string;
}

export interface FilterOption {
  label: string;
  value: string;
}

export interface SettingsMenuItem {
  id: string;
  icon: string;
  title: string;
  subtitle: string;
}

export interface ExceptionFilterItem {
  label: string;
  value: ExceptionStatus | 'ALL';
}
