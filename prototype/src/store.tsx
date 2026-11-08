import { createContext, useContext, type ReactNode } from "react"
import type { BottleSign, TableId } from "./data"

export type Screen =
  | "home" | "explore" | "venue" | "table" | "checkout" | "confirmation" | "night" | "inbox"
  | "profile" | "reel" | "settings" | "event" | "saved" | "professional" | "notifications"
  | "chat" | "guests" | "receipt" | "review" | "support" | "composer" | "organizer" | "djbook" | "camera" | "createpreview" | "orgmedia" | "opportunity" | "post" | "ticket" | "feed"

export type Appearance = "system" | "light" | "dark"
export type PaymentState = "ready" | "processing" | "declined" | "cancelled" | "expired"
export type ThreadId = string
export type ComposeMode = "Recap" | "Post" | "Reel" | "Story" | "Update"

export type Message = { from: "me" | "them"; text: string; who?: string; time: string }

export type Booking = {
  ref: string
  tableId: TableId
  dateId: string
  arrival: string
  guests: number
  bottles: Record<string, number>
  sign?: BottleSign | null
}

export type DjRequest = {
  ref: string
  pkg: string
  date: string
  start: string
  venue: string
  total: number
  deposit: number
  status: "Pending" | "Accepted"
}

/** Owner-chosen background for the profile header only (never the whole app). */
export type ProfileStyle = { kind: "none" | "color" | "gradient" | "image"; value: string; posY: number }

export type CaptureMode = "Post" | "Story" | "Reel"
export type CaptureDraft = {
  mode: CaptureMode
  src: string
  kind: "image" | "video"
  aspect: "1:1" | "4:5" | "9:16"
  x: number
  y: number
  zoom: number
  trimStart: number
  trimEnd: number
  duration: number
  caption: string
  tag: string
  audience: "Public" | "Followers" | "Close friends" | "Members Only"
}

export type AppState = {
  city: string
  exploreFilter: string
  venueSection: string
  tableId: TableId
  dateId: string | null
  checkoutStep: number
  arrival: string
  guests: number
  bottles: Record<string, number>
  paymentState: PaymentState
  holdUntil: number | null
  booking: Booking
  invited: string[]
  gaTickets: number
  saved: string[]
  following: string[]
  liked: string[]
  comments: Record<string, Message[]>
  threads: Record<ThreadId, { title: string; image: string; messages: Message[] }>
  threadOrder: ThreadId[]
  unread: ThreadId[]
  requests: { id: string; name: string; image: string; text: string }[]
  activeThread: ThreadId
  notificationsRead: boolean
  profile: { name: string; handle: string; bio: string }
  profileStyle: ProfileStyle
  capture: CaptureDraft | null
  inboxTab: "messages" | "requests"
  inboxQuery: string
  opportunity: string
  cameraMode: CaptureMode
  activePost: string
  postReposts: string[]
  activePass: string
  wallet: Record<string, "added" | "failed">
  viewerProfile: string
  viewerIndex: number
  sign: BottleSign | null
  demo: { failUpload: boolean; failWallet: boolean }
  posts: { image: string; members: boolean; reel: boolean; tagged: boolean }[]
  composeMode: ComposeMode
  composeMembers: boolean
  djRequest: DjRequest | null
  ticketOrders: { ref: string; qty: number; total: number; date: string }[] // cents
  reposts: string[]
  reelStart: number
  guestPhotos: { src: string; caption: string; tag: "Guest photos"; by?: string }[]
}

export type Sheet = { title: string; eyebrow?: string; body: (close: () => void) => ReactNode }

export type AppApi = {
  state: AppState
  update: (patch: Partial<AppState> | ((s: AppState) => Partial<AppState>)) => void
  go: (screen: Screen, opts?: { reset?: boolean }) => void
  back: (fallback?: Screen) => void
  toast: (message: string) => void
  openSheet: (sheet: Sheet) => void
  closeSheet: () => void
  share: (what: string) => void
  openThread: (id: ThreadId, firstMessage?: string) => void
  toggleIn: (key: "saved" | "following" | "liked", id: string, label?: string) => void
  signOut: () => void
}

export const AppContext = createContext<AppApi | null>(null)

export function useApp() {
  const api = useContext(AppContext)
  if (!api) throw new Error("useApp must be used inside AppContext")
  return api
}

export const nowTime = () =>
  new Date().toLocaleTimeString("en-CA", { hour: "numeric", minute: "2-digit" }).replace(/\./g, "").toUpperCase()

export const STATE_KEY = "bottlesup-state-v1"
export function resetDemoData() {
  try {
    window.localStorage.removeItem(STATE_KEY)
  } catch {
    /* storage blocked */
  }
}

export const safeStorage = {
  get(key: string) {
    try {
      return window.localStorage.getItem(key)
    } catch {
      return null
    }
  },
  set(key: string, value: string) {
    try {
      window.localStorage.setItem(key, value)
    } catch {
      /* storage blocked: keep going without it */
    }
  },
}
