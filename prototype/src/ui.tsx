import QRCode from "qrcode"
import { useState, type ReactNode } from "react"
import { useApp, nowTime, type Message } from "./store"

export type IconName = "home" | "search" | "plus" | "message" | "user" | "bell" | "calendar" | "heart" | "comment" | "send" | "bookmark" | "map" | "chevron" | "back" | "share" | "users" | "clock" | "check" | "ticket" | "bottle" | "spark" | "close" | "menu" | "camera" | "grid" | "play" | "tag" | "compass" | "sun" | "moon" | "settings" | "star" | "trash" | "link" | "flag" | "pause" | "repost" | "music" | "reels" | "edit" | "flash" | "flashOff" | "flip" | "wallet" | "qr" | "copy" | "help"

const iconPaths: Record<IconName, ReactNode> = {
  home: (
    <>
      <path d="m3 10 9-7 9 7" />
      <path d="M5 9v11h14V9" />
      <path d="M9 20v-6h6v6" />
    </>
  ),
  search: (
    <>
      <circle cx="11" cy="11" r="7" />
      <path d="m20 20-4-4" />
    </>
  ),
  plus: (
    <>
      <path d="M12 5v14M5 12h14" />
    </>
  ),
  message: (
    <>
      <path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z" />
    </>
  ),
  user: (
    <>
      <circle cx="12" cy="8" r="4" />
      <path d="M4 21a8 8 0 0 1 16 0" />
    </>
  ),
  bell: (
    <>
      <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9" />
      <path d="M10 21h4" />
    </>
  ),
  calendar: (
    <>
      <rect x="3" y="5" width="18" height="16" rx="3" />
      <path d="M8 3v4m8-4v4M3 10h18" />
    </>
  ),
  heart: (
    <path d="M20.8 5.8a5.5 5.5 0 0 0-7.8 0L12 6.9l-1.1-1.1a5.5 5.5 0 0 0-7.8 7.8L12 22l8.8-8.4a5.5 5.5 0 0 0 0-7.8z" />
  ),
  comment: (
    <>
      <path d="M21 12a8 8 0 0 1-8 8H6l-4 2 2-5a8 8 0 1 1 17-5z" />
    </>
  ),
  send: (
    <>
      <path d="m22 2-7 20-4-9-9-4z" />
      <path d="M22 2 11 13" />
    </>
  ),
  bookmark: <path d="M5 3h14v19l-7-5-7 5z" />,
  map: (
    <>
      <path d="m3 6 6-3 6 3 6-3v15l-6 3-6-3-6 3z" />
      <path d="M9 3v15m6-12v15" />
    </>
  ),
  chevron: <path d="m9 18 6-6-6-6" />,
  back: (
    <>
      <path d="m15 18-6-6 6-6" />
    </>
  ),
  share: (
    <>
      <circle cx="18" cy="5" r="3" />
      <circle cx="6" cy="12" r="3" />
      <circle cx="18" cy="19" r="3" />
      <path d="m8.6 10.5 6.8-4m-6.8 7 6.8 4" />
    </>
  ),
  users: (
    <>
      <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
      <circle cx="8.5" cy="7" r="4" />
      <path d="M17 11a4 4 0 0 0 0-8m6 18v-2a4 4 0 0 0-3-3.9" />
    </>
  ),
  clock: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v6l4 2" />
    </>
  ),
  check: <path d="m5 12 4 4L19 6" />,
  ticket: (
    <>
      <path d="M3 7a2 2 0 0 0 0 4v6h18v-6a2 2 0 0 0 0-4V5H3z" />
      <path d="M13 5v12" />
    </>
  ),
  bottle: (
    <>
      <path d="M9 3h6v4l2 3v10a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V10l2-3z" />
      <path d="M9 6h6m-8 8h10" />
    </>
  ),
  spark: (
    <>
      <path d="m12 3 1.2 4.8L18 9l-4.8 1.2L12 15l-1.2-4.8L6 9l4.8-1.2z" />
      <path d="m19 15 .6 2.4L22 18l-2.4.6L19 21l-.6-2.4L16 18l2.4-.6z" />
    </>
  ),
  close: <path d="m6 6 12 12M18 6 6 18" />,
  menu: <path d="M4 7h16M4 12h16M4 17h16" />,
  camera: (
    <>
      <path d="M14.5 5 13 3h-2L9.5 5H5a3 3 0 0 0-3 3v10a3 3 0 0 0 3 3h14a3 3 0 0 0 3-3V8a3 3 0 0 0-3-3z" />
      <circle cx="12" cy="13" r="4" />
    </>
  ),
  grid: (
    <>
      <rect x="3" y="3" width="7" height="7" rx="1" />
      <rect x="14" y="3" width="7" height="7" rx="1" />
      <rect x="3" y="14" width="7" height="7" rx="1" />
      <rect x="14" y="14" width="7" height="7" rx="1" />
    </>
  ),
  play: <path d="m8 5 11 7-11 7z" />,
  tag: (
    <>
      <path d="M20 13 11 22l-9-9V2h11z" />
      <circle cx="7" cy="7" r="1" />
    </>
  ),
  compass: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="m15 9-2 4-4 2 2-4z" />
    </>
  ),
  sun: (
    <>
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2m0 16v2M4.9 4.9l1.4 1.4m11.4 11.4 1.4 1.4M2 12h2m16 0h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" />
    </>
  ),
  wallet: <path d="M4 7.5A2.5 2.5 0 0 1 6.5 5h11A2.5 2.5 0 0 1 20 7.5v9a2.5 2.5 0 0 1-2.5 2.5h-11A2.5 2.5 0 0 1 4 16.5v-9ZM4 9h16M15.5 13.5h1.5" />,
  qr: <path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h2v2h-2zM18 18h2v2h-2zM14 18h2M18 14h2" />,
  copy: <path d="M9 9h10v11H9zM5 15V4h10" />,
  help: <path d="M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.6.3-1 .9-1 1.6v.6M12 17h.01" />,
  flash: <path d="M13 2 5 13h6l-1 9 8-11h-6l1-9Z" />,
  flashOff: <path d="M13 2 9.5 7M7.6 9.8 5 13h6l-1 9 3.4-4.7M15.6 13.4 18 11h-4.4M3 3l18 18" />,
  flip: <path d="M4 9a8 8 0 0 1 14.5-3.5L20 7M20 3v4h-4M20 15a8 8 0 0 1-14.5 3.5L4 17M4 21v-4h4" />,
  edit: <path d="M4 20h4L19 9a2.8 2.8 0 0 0-4-4L4 16v4ZM13.5 6.5l4 4" />,
  moon: <path d="M20 15.5A8 8 0 0 1 8.5 4 8.5 8.5 0 1 0 20 15.5z" />,
  star: <path d="m12 3 2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1-4.4-4.3 6.1-.9z" />,
  pause: <path d="M8 5v14M16 5v14" />,
  repost: (
    <>
      <path d="M17 2.5 20.5 6 17 9.5" />
      <path d="M3.5 11.5V10a4 4 0 0 1 4-4h13" />
      <path d="M7 21.5 3.5 18 7 14.5" />
      <path d="M20.5 12.5V14a4 4 0 0 1-4 4h-13" />
    </>
  ),
  reels: (
    <>
      <rect x="3" y="3" width="18" height="18" rx="5" />
      <path d="M10 8.8v6.4l5.2-3.2z" />
    </>
  ),
  music: (
    <>
      <path d="M9 18V5l12-2v13" />
      <circle cx="6" cy="18" r="3" />
      <circle cx="18" cy="16" r="3" />
    </>
  ),
  trash: (
    <>
      <path d="M4 7h16M9 7V4h6v3m-8 0 1 13h8l1-13" />
    </>
  ),
  link: (
    <>
      <path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1" />
      <path d="M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1" />
    </>
  ),
  flag: (
    <>
      <path d="M5 21V4m0 0h11l-2 4 2 4H5" />
    </>
  ),
  settings: (
    <>
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1-2.8 2.8-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.6v.2h-4V21a1.7 1.7 0 0 0-1-1.6 1.7 1.7 0 0 0-1.9.3l-.1.1L4.2 17l.1-.1a1.7 1.7 0 0 0 .3-1.9A1.7 1.7 0 0 0 3 14H2.8v-4H3a1.7 1.7 0 0 0 1.6-1 1.7 1.7 0 0 0-.3-1.9L4.2 7 7 4.2l.1.1a1.7 1.7 0 0 0 1.9.3A1.7 1.7 0 0 0 10 3V2.8h4V3a1.7 1.7 0 0 0 1 1.6 1.7 1.7 0 0 0 1.9-.3l.1-.1L19.8 7l-.1.1a1.7 1.7 0 0 0-.3 1.9 1.7 1.7 0 0 0 1.6 1h.2v4H21a1.7 1.7 0 0 0-1.6 1z" />
    </>
  ),
}

export function Icon({
  name,
  size = 21,
  filled = false,
}: {
  name: IconName
  size?: number
  filled?: boolean
}) {
  return (
    <svg
      aria-hidden="true"
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill={filled ? "currentColor" : "none"}
      stroke="currentColor"
      strokeWidth="1.8"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      {iconPaths[name]}
    </svg>
  )
}

export function Button({
  children,
  variant = "primary",
  icon,
  onClick,
  className = "",
  disabled = false,
  type = "button",
}: {
  children: ReactNode
  variant?: "primary" | "secondary" | "ghost"
  icon?: IconName
  onClick?: () => void
  className?: string
  disabled?: boolean
  type?: "button" | "submit"
}) {
  return (
    <button type={type} className={`btn btn-${variant} ${className}`} onClick={onClick} disabled={disabled}>
      {icon && <Icon name={icon} size={18} />}
      <span>{children}</span>
    </button>
  )
}

export function Brand() {
  return (
    <div className="brand" role="img" aria-label="BottlesUp">
      <img className="brand-bottle" src="/launch/bottle.svg" alt="" />
      <img className="brand-word wordmark-dark" src="/launch/wordmark-dark.svg" alt="" />
      <img className="brand-word wordmark-light" src="/launch/wordmark-light.svg" alt="" />
    </div>
  )
}

export function Avatar({ src, label, story = false }: { src: string; label: string; story?: boolean }) {
  return (
    <div className={`avatar ${story ? "story-ring" : ""}`}>
      <img src={src} alt={label} />
    </div>
  )
}

export function TopBar({
  title,
  back,
  fallback = "home",
  middle,
  action,
  onBack,
}: {
  title?: string
  back?: boolean
  fallback?: Parameters<ReturnType<typeof useApp>["back"]>[0]
  middle?: ReactNode
  action?: ReactNode
  onBack?: () => void
}) {
  const app = useApp()
  return (
    <header className="topbar">
      <div className="topbar-leading">
        {back ? (
          <button className="icon-btn" aria-label="Go back" onClick={onBack ?? (() => app.back(fallback))}>
            <Icon name="back" />
          </button>
        ) : (
          <Brand />
        )}
      </div>
      <div className="topbar-middle">{middle || (title && <span className="topbar-title">{title}</span>)}</div>
      <div className="topbar-action">{action}</div>
    </header>
  )
}

export function ShareButton({ what, className = "icon-btn" }: { what: string; className?: string }) {
  const app = useApp()
  return (
    <button className={className} aria-label={`Share ${what}`} onClick={() => app.share(what)}>
      <Icon name="share" />
    </button>
  )
}

export function BackGlass({ fallback }: { fallback: Parameters<ReturnType<typeof useApp>["back"]>[0] }) {
  const app = useApp()
  return (
    <button className="glass-btn" aria-label="Go back" onClick={() => app.back(fallback)}>
      <Icon name="back" />
    </button>
  )
}

export type SheetOption = { label: string; detail?: string; icon?: IconName; danger?: boolean; disabled?: boolean; onSelect?: () => void }

export function OptionList({ options, close }: { options: SheetOption[]; close: () => void }) {
  return (
    <div className="sheet-options">
      {options.map((o) => (
        <button
          key={o.label}
          className={o.danger ? "danger" : ""}
          disabled={o.disabled}
          onClick={() => {
            close()
            o.onSelect?.()
          }}
        >
          {o.icon && <Icon name={o.icon} size={19} />}
          <span>
            <b>{o.label}</b>
            {o.detail && <small>{o.detail}</small>}
          </span>
        </button>
      ))}
    </div>
  )
}

export function useMoreMenu() {
  const app = useApp()
  return (what: string) =>
    app.openSheet({
      title: what,
      eyebrow: "MORE",
      body: (close) => (
        <OptionList
          close={close}
          options={[
            { label: "Copy link", icon: "link", onSelect: () => app.share(what) },
            { label: "Not interested", detail: "See fewer posts like this", icon: "close", onSelect: () => app.toast("You'll see fewer posts like this") },
            { label: "Report", detail: "Our safety team reviews every report", icon: "flag", danger: true, onSelect: () => app.toast("Report sent. Thanks for keeping BottlesUp safe.") },
          ]}
        />
      ),
    })
}

export function CommentsBody({ postId }: { postId: string }) {
  const app = useApp()
  const [draft, setDraft] = useState("")
  const list: Message[] = app.state.comments[postId] ?? []
  const add = () => {
    const text = draft.trim()
    if (!text) return
    app.update((s) => ({
      comments: { ...s.comments, [postId]: [...(s.comments[postId] ?? []), { from: "me", who: s.profile.handle, text, time: nowTime() }] },
    }))
    setDraft("")
  }
  return (
    <div className="comments">
      <div className="comment-list">
        {list.length === 0 && <p className="empty-note">No comments yet. Start the conversation.</p>}
        {list.map((c, i) => (
          <p key={i}>
            <b>{c.who}</b> {c.text}
            <small>{c.time}</small>
          </p>
        ))}
      </div>
      <form
        className="inline-compose"
        onSubmit={(e) => {
          e.preventDefault()
          add()
        }}
      >
        <input id={`comment-${postId}`} value={draft} onChange={(e) => setDraft(e.target.value)} placeholder="Add a comment…" aria-label="Add a comment" />
        <button type="submit" aria-label="Post comment" disabled={!draft.trim()}>
          <Icon name="send" size={18} />
        </button>
      </form>
    </div>
  )
}

export function useComments() {
  const app = useApp()
  return (postId: string) => app.openSheet({ title: "Comments", eyebrow: "CONVERSATION", body: () => <CommentsBody postId={postId} /> })
}

/** Small outline sun / moon button: sun in dark mode (switch to light), moon in light mode. */
export function ThemeIcon({ dark, onChange }: { dark: boolean; onChange: (dark: boolean) => void }) {
  return (
    <button type="button" className="theme-icon" onClick={() => onChange(!dark)} aria-label={dark ? "Switch to light mode" : "Switch to dark mode"} title={dark ? "Light mode" : "Dark mode"}>
      <Icon name={dark ? "sun" : "moon"} size={22} />
    </button>
  )
}

/** Animated sun/moon switch between light and dark. */
export function ThemeSwitch({ dark, onChange, size = "md" }: { dark: boolean; onChange: (dark: boolean) => void; size?: "sm" | "md" }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={dark}
      aria-label={dark ? "Dark mode on. Switch to light mode" : "Light mode on. Switch to dark mode"}
      className={`theme-switch ${size} ${dark ? "is-dark" : "is-light"}`}
      onClick={() => onChange(!dark)}
    >
      <span className="ts-night" aria-hidden="true">
        <i className="ts-star s1" />
        <i className="ts-star s2" />
        <i className="ts-star s3" />
        <i className="ts-star s4" />
        <i className="ts-star s5" />
      </span>
      <span className="ts-clouds" aria-hidden="true">
        <i />
        <i />
        <i />
      </span>
      <span className="ts-knob" aria-hidden="true">
        <i className="ts-crater c1" />
        <i className="ts-crater c2" />
        <i className="ts-crater c3" />
      </span>
    </button>
  )
}

/** Scannable QR code rendered as SVG (no network needed). */
export function QR({ value, size = 168, label }: { value: string; size?: number; label: string }) {
  const qr = QRCode.create(value, { errorCorrectionLevel: "M" })
  const n = qr.modules.size
  let d = ""
  for (let y = 0; y < n; y++) for (let x = 0; x < n; x++) if (qr.modules.get(x, y)) d += `M${x + 2} ${y + 2}h1v1h-1z`
  return (
    <svg className="qr" width={size} height={size} viewBox={`0 0 ${n + 4} ${n + 4}`} role="img" aria-label={label} shapeRendering="crispEdges">
      <rect width={n + 4} height={n + 4} fill="#fff" />
      <path d={d} fill="#000" />
    </svg>
  )
}
