import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { friends, media } from "./data"
import { AppContext, STATE_KEY, safeStorage, useApp as useAppFromContext, type AppApi, type AppState, type Appearance, type Screen, type Sheet } from "./store"
import { Brand, Icon, type IconName } from "./ui"
import { DeviceFrame, deviceScrollTop } from "./device"
import { ConnectionError, DelayedSignIn, LaunchScreen, SignIn } from "./screens/Launch"
import { Home } from "./screens/Home"
import { Explore, Saved } from "./screens/Explore"
import { Venue } from "./screens/Venue"
import { Checkout, Confirmation, TableDetail } from "./screens/Booking"
import { Guests, MyNight, Receipt, Review, Support, Ticket } from "./screens/Night"
import { Chat, Composer, Inbox, Notifications } from "./screens/Social"
import { Reels } from "./screens/Reels"
import { EventDetail, Profile, Settings } from "./screens/Profile"
import { Camera, CreatePreview } from "./screens/Camera"
import { PostDetail } from "./screens/Posts"
import { Feed } from "./screens/Feed"
import { OrganizerProfile, OrgMedia, OpportunityDetail } from "./screens/Organizer"
import { DjBooking, DjProfile } from "./screens/Dj"

const rootScreens: Screen[] = ["home", "inbox", "explore", "profile"]

const initialState: AppState = {
  city: "Toronto",
  exploreFilter: "What’s Hot",
  venueSection: "Overview",
  tableId: "halo",
  dateId: null,
  checkoutStep: 1,
  arrival: "12:30 AM",
  guests: 6,
  bottles: { donjulio: 1 },
  paymentState: "ready",
  holdUntil: null,
  booking: { ref: "NR-2841", tableId: "halo", dateId: "aug24", arrival: "12:30 AM", guests: 6, bottles: { donjulio: 1 }, sign: { style: "led", text: "Happy 30th Jordan", bottleId: "donjulio", timing: "At midnight" } },
  invited: [],
  gaTickets: 0,
  saved: ["event", "venue", "amara"],
  following: [],
  liked: [],
  comments: {
    "post-eonics": [
      { from: "them", who: "maya.chen", text: "Best night of the summer.", time: "2h" },
      { from: "them", who: "noahreid", text: "Saturday crew is ready.", time: "1h" },
    ],
  },
  threads: {
    crew: {
      title: "Saturday Crew",
      image: media.friends,
      messages: [
        { from: "them", who: "Maya", text: "Are we doing the Halo Booth? The view looks perfect.", time: "7:42 PM" },
        { from: "me", text: "Booked. Arrival is Sunday at 12:30 AM. Sending passes now.", time: "7:44 PM" },
      ],
    },
    nova: { title: "Nova Room", image: media.venue, messages: [{ from: "them", who: "Alex", text: "Your host Alex is ready to help.", time: "18m" }] },
    amara: { title: "Amara Vale", image: media.pro, messages: [{ from: "them", text: "Sent an event: Afterglow", time: "1h" }] },
    eonics: { title: "EONICS Music", image: media.dj, messages: [{ from: "them", text: "Thanks for coming to Afterglow! Ask us anything about Saturday.", time: "2d" }] },
    support: { title: "BottlesUp Support", image: media.bottles, messages: [{ from: "them", text: "Your booking details are ready.", time: "1d" }] },
  },
  threadOrder: ["crew", "nova", "amara", "support"],
  unread: ["crew", "nova"],
  requests: [
    { id: "req-priya", name: "Priya Shah", image: media.pro, text: "Hey! Are there any passes left for Saturday?" },
    { id: "req-marcus", name: "Marcus Lee", image: media.stage, text: "Saw your recap. Which table was that?" },
    { id: "req-afterdark", name: "Afterdark Events", image: media.crowd, text: "We'd love to feature your night on our page." },
  ],
  activeThread: "crew",
  notificationsRead: false,
  profile: { name: "Jordan Ellis", handle: "jordanafterdark", bio: "Toronto · good music, better people." },
  profileStyle: { kind: "none", value: "", posY: 50 },
  capture: null,
  inboxTab: "messages",
  inboxQuery: "",
  opportunity: "o1",
  cameraMode: "Post",
  activePost: "post-eonics",
  postReposts: [],
  activePass: "p-you",
  wallet: {},
  viewerProfile: "me",
  viewerIndex: 0,
  sign: null,
  demo: { failUpload: false, failWallet: false },
  posts: [
    { image: media.hero, members: false, reel: true, tagged: true },
    { image: media.friends, members: true, reel: false, tagged: false },
    { image: media.table, members: false, reel: false, tagged: true },
    { image: media.dj, members: false, reel: true, tagged: false },
    { image: media.stage, members: false, reel: false, tagged: false },
    { image: media.venue, members: false, reel: false, tagged: true },
  ],
  composeMode: "Recap",
  composeMembers: false,
  // Same request the DJ sees in BottlesUp Business (BK-7559): Private event 3 h + 1 extra hour + DJ equipment, 13% HST, 30% deposit.
  ticketOrders: [],
  djRequest: { ref: "BK-7559", pkg: "Private event", date: "Sat, Sep 7", start: "9:00 PM", venue: "Private loft · Liberty Village", total: 1638.5, deposit: 491.55, status: "Pending" },
  reposts: [],
  reelStart: 0,
  guestPhotos: [],
}

/* Demo data saved in this browser so bookings, tickets, messages and profile edits
   survive a reload. Screen-by-screen state (checkout step, camera drafts) is not kept. */
const DURABLE = ["city", "booking", "invited", "gaTickets", "saved", "following", "liked", "comments", "threads", "threadOrder", "unread", "requests", "notificationsRead", "profile", "profileStyle", "posts", "postReposts", "wallet", "sign", "djRequest", "ticketOrders"] as const
function loadState(): AppState {
  try {
    const raw = safeStorage.get(STATE_KEY)
    if (!raw) return initialState
    const saved = JSON.parse(raw) as Partial<AppState>
    const next = { ...initialState }
    for (const k of DURABLE) if (saved[k] !== undefined) (next as Record<string, unknown>)[k] = saved[k]
    return next
  } catch {
    return initialState
  }
}
export default function App() {
  const [state, setState] = useState<AppState>(loadState)
  useEffect(() => {
    const pick: Partial<Record<string, unknown>> = {}
    for (const k of DURABLE) pick[k] = state[k]
    safeStorage.set(STATE_KEY, JSON.stringify(pick))
  }, [state])
  const [stack, setStack] = useState<Screen[]>(["home"])
  const screen = stack[stack.length - 1]
  const [sheet, setSheet] = useState<Sheet | null>(null)
  const [toastMsg, setToastMsg] = useState<string | null>(null)
  const toastTimer = useRef<number | null>(null)
  const phoneRef = useRef<HTMLDivElement>(null)
  const scrollPositions = useRef<Partial<Record<string, number>>>({})

  const [appearance, setAppearance] = useState<Appearance>(() => {
    const saved = safeStorage.get("bottlesup-appearance")
    return saved === "light" || saved === "dark" || saved === "system" ? saved : "system"
  })
  const [systemTheme, setSystemTheme] = useState<"light" | "dark">(() =>
    window.matchMedia?.("(prefers-color-scheme: light)").matches ? "light" : "dark",
  )
  useEffect(() => {
    const mq = window.matchMedia?.("(prefers-color-scheme: light)")
    if (!mq) return
    const onChange = (e: MediaQueryListEvent) => setSystemTheme(e.matches ? "light" : "dark")
    mq.addEventListener("change", onChange)
    return () => mq.removeEventListener("change", onChange)
  }, [])
  useEffect(() => {
    safeStorage.set("bottlesup-appearance", appearance)
  }, [appearance])
  const resolvedTheme = appearance === "system" ? systemTheme : appearance

  // Launch → (delayed | offline) → Sign In or Home, per the Figma motion spec.
  type Phase = "launch" | "delayed" | "offline" | "signin" | "app"
  const [signedIn, setSignedIn] = useState(() => safeStorage.get("bottlesup-signed-in") === "1")
  const [phase, setPhase] = useState<Phase>("launch")
  const launchTimers = useRef<number[]>([])
  const clearLaunch = () => {
    launchTimers.current.forEach((t) => window.clearTimeout(t))
    launchTimers.current = []
  }
  const after = (ms: number, fn: () => void) => launchTimers.current.push(window.setTimeout(fn, ms))
  const runLaunch = (kind: "normal" | "slow" | "offline", destination: Phase = signedIn ? "app" : "signin") => {
    clearLaunch()
    setPhase("launch")
    if (kind === "normal") after(2100, () => setPhase(destination))
    if (kind === "slow") {
      after(2100, () => setPhase("delayed"))
      after(5000, () => setPhase(destination))
    }
    if (kind === "offline") after(2100, () => setPhase("offline"))
  }
  useEffect(() => {
    runLaunch("normal")
    return clearLaunch
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const update = useCallback<AppApi["update"]>((patch) => {
    setState((s) => ({ ...s, ...(typeof patch === "function" ? patch(s) : patch) }))
  }, [])

  const toast = useCallback((message: string) => {
    setToastMsg(message)
    if (toastTimer.current) window.clearTimeout(toastTimer.current)
    toastTimer.current = window.setTimeout(() => setToastMsg(null), 2400)
  }, [])

  const scrollTo = (top: number) =>
    requestAnimationFrame(() => {
      phoneRef.current?.scrollTo({ top })
      window.scrollTo({ top })
    })

  const rememberScroll = () => {
    scrollPositions.current[stack.join(">")] = deviceScrollTop() || phoneRef.current?.scrollTop || window.scrollY
  }

  const go = useCallback<AppApi["go"]>(
    (next, opts) => {
      rememberScroll()
      setSheet(null)
      setStack((s) => {
        if (rootScreens.includes(next)) return [next]
        if (opts?.reset) return ["home", next]
        if (s[s.length - 1] === next) return s
        return [...s, next]
      })
      scrollTo(0)
    },
    [stack],
  )

  const back = useCallback<AppApi["back"]>(
    (fallback = "home") => {
      setSheet(null)
      const next = stack.length > 1 ? stack.slice(0, -1) : [fallback]
      setStack(next)
      scrollTo(scrollPositions.current[next.join(">")] ?? 0)
    },
    [stack],
  )

  const share = useCallback(
    (what: string) => {
      const text = `${what} on BottlesUp`
      const done = () => toast("Copied to clipboard")
      const fail = () => toast("Copying isn't available here")
      try {
        navigator.clipboard?.writeText(text).then(done, fail) ?? fail()
      } catch {
        fail()
      }
    },
    [toast],
  )

  const openThread = useCallback<AppApi["openThread"]>(
    (id, firstMessage) => {
      update((s) => {
        const threads = { ...s.threads }
        if (!threads[id]) {
          const f = friends.find((x) => "dm-" + x.name.split(" ")[0].toLowerCase() === id)
          threads[id] = { title: f?.name ?? "Conversation", image: f?.image ?? media.friends, messages: [] }
        }
        if (firstMessage) {
          const time = new Date().toLocaleTimeString("en-CA", { hour: "numeric", minute: "2-digit" }).replace(/\./g, "").toUpperCase()
          threads[id] = { ...threads[id], messages: [...threads[id].messages, { from: "me", text: firstMessage, time }] }
        }
        return {
          threads,
          activeThread: id,
          unread: s.unread.filter((x) => x !== id),
          threadOrder: s.threadOrder.includes(id) && !firstMessage ? s.threadOrder : [id, ...s.threadOrder.filter((x) => x !== id)],
        }
      })
      go("chat")
    },
    [go, update],
  )

  const toggleIn = useCallback<AppApi["toggleIn"]>(
    (key, id, label) => {
      const has = state[key].includes(id)
      update((s) => ({ [key]: s[key].includes(id) ? s[key].filter((x) => x !== id) : [...s[key], id] }))
      if (key === "saved") toast(has ? `${label ?? "Item"} removed from saved` : `${label ?? "Item"} saved`)
      if (key === "following") toast(has ? `Unfollowed ${label}` : `Following ${label}`)
    },
    [state, update, toast],
  )

  const signOut = () => {
    safeStorage.set("bottlesup-signed-in", "0")
    setSignedIn(false)
    setSheet(null)
    setStack(["home"])
    setPhase("signin")
  }

  const api: AppApi = {
    state,
    update,
    go,
    back,
    toast,
    openSheet: setSheet,
    closeSheet: () => setSheet(null),
    share,
    openThread,
    toggleIn,
    signOut,
  }

  useEffect(() => {
    if (!sheet) return
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setSheet(null)
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  }, [sheet])

  const view = useMemo(() => {
    switch (screen) {
      case "home": return <Home />
      case "explore": return <Explore />
      case "venue": return <Venue />
      case "table": return <TableDetail />
      case "checkout": return <Checkout />
      case "confirmation": return <Confirmation />
      case "night": return <MyNight />
      case "inbox": return <Inbox />
      case "profile": return <Profile theme={resolvedTheme} appearance={appearance} setAppearance={setAppearance} />
      case "reel": return <Reels />
      case "settings": return <Settings appearance={appearance} setAppearance={setAppearance} resolvedTheme={resolvedTheme} />
      case "event": return <EventDetail />
      case "saved": return <Saved />
      case "professional": return <DjProfile />
      case "djbook": return <DjBooking />
      case "notifications": return <Notifications />
      case "chat": return <Chat />
      case "guests": return <Guests />
      case "receipt": return <Receipt />
      case "review": return <Review />
      case "support": return <Support />
      case "composer": return <Composer />
      case "camera": return <Camera />
      case "post": return <PostDetail />
      case "feed": return <Feed />
      case "ticket": return <Ticket />
      case "createpreview": return <CreatePreview />
      case "orgmedia": return <OrgMedia />
      case "opportunity": return <OpportunityDetail />
      case "organizer": return <OrganizerProfile />
    }
  }, [screen, resolvedTheme, appearance])

  return (
    <AppContext.Provider value={api}>
      <DeviceFrame dark={resolvedTheme === "dark" || (phase === "app" && screen === "camera")} surface={phase === "app" ? (screen === "camera" ? "#000" : undefined) : resolvedTheme === "dark" ? "#0b0b0b" : "#f9fafb"}>
      {phase !== "app" ? (
        <div className={`bu-root ${resolvedTheme}`} key={phase}>
          {phase === "launch" && <LaunchScreen dark={resolvedTheme === "dark"} />}
          {phase === "delayed" && <DelayedSignIn dark={resolvedTheme === "dark"} />}
          {phase === "offline" && (
            <ConnectionError
              dark={resolvedTheme === "dark"}
              onRetry={() =>
                new Promise((resolve) =>
                  window.setTimeout(() => {
                    resolve()
                    setPhase(signedIn ? "app" : "signin")
                  }, 1200),
                )
              }
            />
          )}
          {phase === "signin" && (
            <SignIn
              dark={resolvedTheme === "dark"}
              onDemo={(kind) => runLaunch(kind, "signin")}
              onSignedIn={(name) => {
                safeStorage.set("bottlesup-signed-in", "1")
                setSignedIn(true)
                // A new account gets its own name, handle and empty bio. The sample bookings stay so the demo
                // has something to explore, and the welcome message says so. Real accounts need the backend.
                if (name)
                  setState((s) => ({
                    ...s,
                    profile: { name, handle: name.toLowerCase().replace(/[^a-z0-9]+/g, ".").replace(/^\.|\.$/g, "") || "you", bio: "" },
                  }))
                setStack(["home"])
                setPhase("app")
                toast(name ? `Welcome, ${name.split(" ")[0]}. Sample bookings are loaded so you can explore.` : "Welcome back")
              }}
            />
          )}
        </div>
      ) : (
      <div className="app-stage" data-theme={resolvedTheme}>
        <div className="ambient ambient-one" />
        <div className="ambient ambient-two" />
        <div className="phone-shell" ref={phoneRef} data-screen={screen}>
          <div key={stack.join(">")} className="screen-host">
            {view}
          </div>
          {rootScreens.includes(screen) && <BottomNav active={screen} />}
          {sheet && (
            <div className="sheet-wrap" onClick={() => setSheet(null)}>
              <div className="sheet" role="dialog" aria-modal="true" aria-label={sheet.title} onClick={(e) => e.stopPropagation()}>
                <div className="sheet-handle" />
                <div className="sheet-head">
                  <div>
                    {sheet.eyebrow && <span className="eyebrow">{sheet.eyebrow}</span>}
                    <div className="display-title">{sheet.title}</div>
                  </div>
                  <button className="icon-btn" aria-label="Close" onClick={() => setSheet(null)}>
                    <Icon name="close" />
                  </button>
                </div>
                {sheet.body(() => setSheet(null))}
              </div>
            </div>
          )}
          {toastMsg && (
            <div className="toast" role="status" aria-live="polite">
              {toastMsg}
            </div>
          )}
        </div>
        <div className="desktop-note">
          <Brand />
          <p>Premium nights, all in one place.</p>
          <span>Interactive mobile prototype · 390 × 844</span>
        </div>
      </div>
      )}
      </DeviceFrame>
    </AppContext.Provider>
  )
}

function BottomNav({ active }: { active: Screen }) {
  const app = useAppFromContext()
  const unread = app.state.unread.length + app.state.requests.length
  const items: { label: string; screen: Screen; icon?: IconName }[] = [
    { label: "Home", screen: "home", icon: "home" },
    { label: "Explore", screen: "explore", icon: "search" },
    { label: "Create", screen: "camera", icon: "plus" },
    { label: "Inbox", screen: "inbox", icon: "message" },
    { label: "Profile", screen: "profile" },
  ]
  return (
    <nav className="bottom-nav dock tabbar" aria-label="Main">
      {items.map((item) => {
        const on = item.screen === active
        if (item.label === "Create")
          return (
            <button key="create" className="tab-create" aria-label="Create" onClick={() => (app.update({ cameraMode: "Post" }), app.go("camera"))}>
              <span>
                <Icon name="plus" size={24} />
              </span>
            </button>
          )
        return (
          <button key={item.label} aria-current={on ? "page" : undefined} className={on ? "active" : ""} onClick={() => app.go(item.screen)}>
            <span className="dock-icon">
              {item.icon ? <Icon name={item.icon} size={24} filled={on && item.icon === "home"} /> : <img className="dock-avatar" src={media.friends} alt="" />}
              {item.label === "Inbox" && unread > 0 && <i className="tab-badge" aria-label={`${unread} unread`}>{unread}</i>}
              {item.label === "Profile" && !app.state.notificationsRead && <i className="dock-dot" />}
            </span>
            <small>{item.label}</small>
          </button>
        )
      })}
    </nav>
  )
}

