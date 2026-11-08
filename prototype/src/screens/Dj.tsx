import { useEffect, useRef, useState } from "react"
import { media } from "../data"
import { useApp } from "../store"
import { Avatar, Button, Icon, TopBar, type IconName } from "../ui"
import { PostViewer, StoryViewer, type Highlight, type Owner, type Post } from "./Organizer"

/* ---------------- Data ---------------- */

const AMARA: Owner = { name: "Amara Vale", handle: "amaravale", avatar: media.pro, place: "Toronto" }

export type Package = { id: string; name: string; hours: number; price: number; blurb: string; includes: string[]; popular?: boolean }

export const PACKAGES: Package[] = [
  { id: "warmup", name: "Warm-up set", hours: 2, price: 500, blurb: "Open the night before your headliner.", includes: ["2-hour set", "Soundcheck", "Bring your own decks or use the venue's"] },
  { id: "club", name: "Club set", hours: 4, price: 1200, blurb: "A full peak-time set for club nights.", includes: ["4-hour set", "Soundcheck", "Custom intro edit", "Social post promoting your night"], popular: true },
  { id: "private", name: "Private event", hours: 3, price: 900, blurb: "Birthdays, launches and private parties.", includes: ["3-hour set", "Playlist planning call", "Requests on the night"] },
  { id: "festival", name: "Festival / headline", hours: 1.5, price: 2000, blurb: "Headline or festival stage slot.", includes: ["90-minute set", "Exclusive edits", "Rider-ready tech spec", "2 guest-list spots"] },
]

// Which packages each add-on can go with, as set in the DJ's studio (BottlesUp Business demo data).
const ADDON_FOR: Record<string, string[]> = { gear: ["private", "warmup"], lights: ["private", "club"], mc: ["private", "club", "festival"] }
// Packages priced "From" vary with the brief; the final price comes in the DJ's quote.
const FROM_PRICE = ["private", "festival"]
const ADDONS: { id: string; label: string; detail: string; price: number }[] = [
  { id: "gear", label: "DJ equipment", detail: "2 × CDJ-3000 + DJM-A9 mixer, delivered and set up", price: 300 },
  { id: "lights", label: "Lighting package", detail: "Moving heads, haze and an LED wall wash", price: 350 },
  { id: "mc", label: "MC / hype host", detail: "Host for announcements and crowd energy", price: 200 },
]
const EXTRA_HOUR = 250
const TRAVEL = 150
const TAX = 0.13
const DEPOSIT = 0.3

export function priceFor(pkg: Package, extraHours: number, addons: string[], outsideCity: boolean) {
  const lines: [string, number][] = [[`${pkg.name} · ${pkg.hours} h`, pkg.price]]
  if (extraHours) lines.push([`Extra time · ${extraHours} h × $${EXTRA_HOUR}`, extraHours * EXTRA_HOUR])
  for (const a of ADDONS) if (addons.includes(a.id)) lines.push([a.label, a.price])
  if (outsideCity) lines.push(["Travel outside Toronto", TRAVEL])
  const subtotal = lines.reduce((s, [, v]) => s + v, 0)
  const tax = Math.round(subtotal * TAX * 100) / 100
  const total = subtotal + tax
  const deposit = Math.round(total * DEPOSIT * 100) / 100
  return { lines, subtotal, tax, total, deposit, balance: Math.round((total - deposit) * 100) / 100 }
}

const money = (n: number) => "$" + n.toLocaleString("en-CA", { minimumFractionDigits: n % 1 ? 2 : 0, maximumFractionDigits: 2 })
const money2 = (n: number) => "$" + n.toLocaleString("en-CA", { minimumFractionDigits: 2, maximumFractionDigits: 2 })

const POSTS: Post[] = [
  { id: "dp1", image: media.pro, caption: "Booking for fall is open. Tap Request booking on my profile.", likes: 3120, comments: 141, when: "3 days ago", pinned: true },
  { id: "dp2", image: media.stage, caption: "Afterglow, Aug 24 at Nova Room with EONICS. See you on the floor.", likes: 2210, comments: 96, when: "1 week ago", pinned: true, event: "EONICS: Afterglow" },
  { id: "dp3", image: media.crowd, caption: "Last night's closing track had the whole room singing.", likes: 4480, comments: 230, when: "2 weeks ago", reel: true },
  { id: "dp4", image: media.dj, caption: "New amapiano edit dropping Friday.", likes: 1890, comments: 74, when: "2 weeks ago", reel: true },
  { id: "dp5", image: media.hero, caption: "Toronto, you were loud tonight.", likes: 2760, comments: 112, when: "3 weeks ago" },
  { id: "dp6", image: media.photographer, caption: "Shot by @lenspriya. Studio day.", likes: 1340, comments: 38, when: "1 month ago", tagged: true },
  { id: "dp7", image: media.venue, caption: "Nova Room residency, year two.", likes: 1180, comments: 29, when: "1 month ago" },
  { id: "dp8", image: media.friends, caption: "Private set for a 30th. Best crowd.", likes: 990, comments: 41, when: "6 weeks ago", tagged: true },
  { id: "dp9", image: media.bottles, caption: "Rider essentials.", likes: 870, comments: 23, when: "2 months ago" },
]

const HIGHLIGHTS: Highlight[] = [
  { name: "Live sets", cover: media.crowd, slides: [media.crowd, media.stage, media.hero], captions: ["Nova Room · July", "Afterglow warm-up", "Peak time"] },
  { name: "Studio", cover: media.photographer, slides: [media.photographer, media.dj], captions: ["New edits in progress", "Amapiano Friday"] },
  { name: "Private", cover: media.friends, slides: [media.friends, media.table], captions: ["30th birthday set", "Upper-level booth party"] },
  { name: "Rider", cover: media.bottles, slides: [media.bottles, media.dj], captions: ["Tech: 2 × CDJ-3000, DJM-A9", "Booth monitor required"] },
  { name: "Reviews", cover: media.stage, slides: [media.stage], captions: ["“Packed the floor all night.” · Nova Room"] },
]

const MIXES = [
  { title: "Afterglow Warm-up (Live)", meta: "Recorded at Nova Room · 58 min", plays: "18.2K" },
  { title: "Amapiano Sunset Vol. 3", meta: "Studio mix · 64 min", plays: "41.0K" },
  { title: "Deep Afro Sessions", meta: "Studio mix · 72 min", plays: "26.7K" },
]

const REVIEWS = [
  { name: "Nova Room", role: "Venue", text: "Packed the floor from the first track. Easy to work with and on time.", stars: 5, when: "Jul 27" },
  { name: "Maya C.", role: "Private event", text: "Amara read the room perfectly at my 30th. Everyone asked who the DJ was.", stars: 5, when: "Jun 29" },
  { name: "Midnight Social", role: "Organizer", text: "Professional, great comms, and the set was the highlight of Spring Social.", stars: 5, when: "May 18" },
  { name: "Jordan B.", role: "Corporate", text: "Great energy. Would love a slightly longer setup window next time.", stars: 4, when: "Apr 12" },
]

const GIGS = [
  { title: "EONICS: Afterglow", meta: "SAT, AUG 24 · 10 PM", place: "Nova Room · Warm-up 10–11 PM", image: media.hero, open: true },
  { title: "EONICS × Amara Vale", meta: "SAT, SEP 14 · 10 PM", place: "Nova Room · Headline", image: media.stage, open: false },
]

// Demo "today" is Saturday 10 Aug 2024. Booked or past dates can't be requested.
const TODAY = new Date(2024, 7, 10)
const BOOKED = ["2024-08-17", "2024-08-24", "2024-08-31", "2024-09-14", "2024-09-21", "2024-10-05"]
const key = (d: Date) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`
const longDate = (d: Date) => d.toLocaleDateString("en-CA", { weekday: "long", month: "long", day: "numeric" })
const shortDate = (d: Date) => d.toLocaleDateString("en-CA", { weekday: "short", month: "short", day: "numeric" })

let preselected: string | null = null

/* ---------------- Profile ---------------- */

type DjTab = "grid" | "mixes" | "gigs" | "prices" | "reviews"

const RIDER: [string, string][] = [
  ["Decks", "2 × Pioneer CDJ-3000"],
  ["Mixer", "Pioneer DJM-A9"],
  ["Monitor", "1 booth monitor"],
  ["Load-in", "60 min before set"],
]

export function DjProfile() {
  const app = useApp()
  const following = app.state.following.includes("amara")
  const req = app.state.djRequest
  const [tab, setTab] = useState<DjTab>("grid")
  const [story, setStory] = useState<number | null>(null)
  const [seen, setSeen] = useState<number[]>([])
  const [postIdx, setPostIdx] = useState<number | null>(null)
  const [notify, setNotify] = useState(false)
  const [playing, setPlaying] = useState<number | null>(null)
  const tabsRef = useRef<HTMLDivElement>(null)
  const sorted = [...POSTS].sort((a, b) => Number(!!b.pinned) - Number(!!a.pinned))
  const book = (pkg?: string) => {
    preselected = pkg ?? null
    app.go("djbook")
  }
  const show = (t: DjTab) => {
    setTab(t)
    window.setTimeout(() => tabsRef.current?.scrollIntoView({ behavior: "smooth", block: "start" }), 30)
  }
  const openStory = (i: number) => {
    setStory(i)
    setSeen((s) => (s.includes(i) ? s : [...s, i]))
  }
  const menu = () =>
    app.openSheet({
      title: "Amara Vale",
      eyebrow: "DJ PROFILE",
      body: (close) => (
        <div className="sheet-options">
          {(
            [
              ["Share profile", "share", () => app.share("Amara Vale")],
              ["Copy SoundCloud link", "link", () => app.share("soundcloud.com/amaravale")],
              ["Report profile", "flag", () => app.toast("Report sent. Our safety team will review this profile.")],
            ] as [string, IconName, () => void][]
          ).map(([label, icon, fn]) => (
            <button
              key={label}
              className={icon === "flag" ? "danger" : ""}
              onClick={() => {
                close()
                fn()
              }}
            >
              <Icon name={icon} size={19} />
              <span>
                <b>{label}</b>
              </span>
            </button>
          ))}
        </div>
      ),
    })
  return (
    <div className="screen">
      <TopBar
        title="amaravale"
        back
        fallback="explore"
        action={
          <button className="icon-btn" aria-label="More options" onClick={menu}>
            <span className="dots">•••</span>
          </button>
        }
      />
      <main className="padded org-page dj-page">
        <div className="org-head">
          <button className="org-head-avatar" aria-label="Watch Live sets highlight" onClick={() => openStory(0)}>
            <Avatar src={media.pro} label="Amara Vale" story={!seen.includes(0)} />
          </button>
          <div className="org-counts">
            <button onClick={() => show("grid")}>
              <b>21.4K</b>
              <span>Likes</span>
            </button>
            <div>
              <b>{following ? "12.9K" : "12.8K"}</b>
              <span>Followers</span>
            </div>
            <button onClick={() => show("gigs")}>
              <b>46</b>
              <span>Gigs</span>
            </button>
          </div>
        </div>

        <div className="org-bio-block">
          <div className="profile-name">
            Amara Vale{" "}
            <span className="verified" aria-label="Verified DJ">
              <Icon name="check" size={11} />
            </span>
          </div>
          <span className="org-category">DJ · Afro house, Amapiano · Toronto</span>
          <p>Resident at Nova Room. Clubs, private events and festivals.</p>
          <button className="dj-meta" onClick={() => show("reviews")}>
            <Icon name="star" size={13} filled /> 4.9 <span>(38)</span> · Replies in ~2 h · From $500
          </button>
        </div>

        <div className="dj-actions">
          <Button variant="primary" icon="calendar" className="dj-book-btn" onClick={() => book()}>
            Book
          </Button>
          <Button variant="secondary" className={following ? "is-following" : ""} onClick={() => app.toggleIn("following", "amara", "Amara Vale")}>
            {following ? "Following" : "Follow"}
          </Button>
          <Button variant="secondary" onClick={() => app.openThread("amara")}>
            Message
          </Button>
          <button
            className={`btn btn-secondary org-bell ${notify ? "on" : ""}`}
            aria-label={notify ? "Turn off gig alerts" : "Turn on gig alerts"}
            aria-pressed={notify}
            onClick={() => {
              setNotify(!notify)
              app.toast(notify ? "Gig alerts turned off" : "We'll tell you when Amara announces a gig")
            }}
          >
            <Icon name="bell" size={17} />
          </button>
        </div>

        {req && (
          <button className="dj-status" onClick={() => app.openThread("amara")}>
            <i />
            <span>
              Request {req.status.toLowerCase()} · {req.date} · {money2(req.total)}
            </span>
            <Icon name="chevron" size={15} />
          </button>
        )}

        <div className="highlights org-highlights" aria-label="Highlights">
          {HIGHLIGHTS.map((hl, i) => (
            <button key={hl.name} onClick={() => openStory(i)} className={seen.includes(i) ? "seen" : ""}>
              <span>
                <img src={hl.cover} alt="" />
              </span>
              {hl.name}
            </button>
          ))}
        </div>

        <div className="profile-tabs org-tabs-icons dj-tabs" role="tablist" ref={tabsRef}>
          {(
            [
              ["grid", "grid", "Posts"],
              ["mixes", "play", "Mixes"],
              ["gigs", "ticket", "Gigs"],
              ["prices", "tag", "Prices"],
              ["reviews", "star", "Reviews"],
            ] as [DjTab, IconName, string][]
          ).map(([id, icon, label]) => (
            <button key={id} role="tab" aria-selected={tab === id} className={tab === id ? "active" : ""} onClick={() => setTab(id)}>
              <Icon name={icon} size={19} />
              <small>{label}</small>
            </button>
          ))}
        </div>

        {tab === "grid" && (
          <div className="photo-grid org-grid">
            {sorted.map((p, i) => (
              <button key={p.id} onClick={() => setPostIdx(i)} aria-label={`Open post: ${p.caption}`}>
                <img src={p.image} alt="" />
                {p.pinned && (
                  <span className="pin-badge" aria-label="Pinned">
                    <Icon name="bookmark" size={12} filled />
                  </span>
                )}
                {p.reel && (
                  <span className="reel-badge" aria-hidden="true">
                    <Icon name="play" size={12} filled />
                  </span>
                )}
              </button>
            ))}
          </div>
        )}

        {tab === "mixes" && (
          <div className="dj-list">
            {MIXES.map((m, i) => (
              <div className={`dj-mix ${playing === i ? "playing" : ""}`} key={m.title}>
                <button className="dj-play" aria-label={playing === i ? `Pause ${m.title}` : `Play ${m.title}`} onClick={() => setPlaying(playing === i ? null : i)}>
                  <Icon name={playing === i ? "pause" : "play"} filled size={16} />
                </button>
                <span>
                  <b>{m.title}</b>
                  <small>
                    {m.meta} · {m.plays} plays
                  </small>
                  {playing === i && (
                    <i className="dj-wave" aria-hidden="true">
                      {Array.from({ length: 28 }, (_, k) => (
                        <em key={k} style={{ height: `${30 + ((k * 37 + i * 11) % 70)}%` }} />
                      ))}
                    </i>
                  )}
                </span>
              </div>
            ))}
            <p className="list-count">Previews only in this demo.</p>
          </div>
        )}

        {tab === "gigs" && (
          <div className="dj-list">
            {GIGS.map((g) => {
              const [day, month] = [g.meta.split(", ")[1]?.split(" ")[1], g.meta.split(", ")[1]?.split(" ")[0]]
              const inner = (
                <>
                  <span className="dj-date">
                    <small>{month}</small>
                    <b>{day}</b>
                  </span>
                  <span>
                    <b>{g.title}</b>
                    <small>{g.place}</small>
                  </span>
                </>
              )
              return g.open ? (
                <button className="dj-gig" key={g.title} onClick={() => app.go("event")}>
                  {inner}
                  <Icon name="chevron" size={16} />
                </button>
              ) : (
                <div className="dj-gig" key={g.title}>
                  {inner}
                  <button className="text-action" onClick={() => app.toast("You'll get an alert when tickets go on sale")}>
                    Notify me
                  </button>
                </div>
              )
            })}
            <p className="list-count">Want Amara at your event? Tap Book to check her open dates.</p>
          </div>
        )}

        {tab === "prices" && (
          <div className="dj-list">
            {PACKAGES.map((p) => (
              <button className="dj-price-row" key={p.id} onClick={() => book(p.id)}>
                <span>
                  <b>
                    {p.name}
                    {p.popular && <em>Popular</em>}
                  </b>
                  <small>
                    {p.hours} h · {p.blurb}
                  </small>
                </span>
                <strong>{FROM_PRICE.includes(p.id) ? "From " : ""}{money(p.price)}</strong>
                <Icon name="chevron" size={15} />
              </button>
            ))}
            <div className="dj-rider-card">
              <b>Rider & tech spec</b>
              {RIDER.map(([k, v]) => (
                <p key={k}>
                  <span>{k}</span>
                  <em>{v}</em>
                </p>
              ))}
            </div>
            <p className="list-count">
              Add-ons: equipment +{money(ADDONS[0].price)}, lighting +{money(ADDONS[1].price)}, MC +{money(ADDONS[2].price)}, extra hour +{money(EXTRA_HOUR)}. Prices before 13% HST. 30% deposit only after Amara accepts.
            </p>
          </div>
        )}

        {tab === "reviews" && (
          <div className="dj-list">
            <div className="venue-review">
              <strong>4.9</strong>
              <span>
                <b>From 38 confirmed bookings</b>
                <small>Venues, organizers and private hosts</small>
              </span>
            </div>
            {REVIEWS.map((r) => (
              <div className="org-review" key={r.name}>
                <div>
                  <b>
                    {r.name} <small>· {r.role}</small>
                  </b>
                  <span aria-label={`${r.stars} out of 5 stars`}>
                    {Array.from({ length: 5 }, (_, i) => (
                      <Icon key={i} name="star" size={12} filled={i < r.stars} />
                    ))}
                  </span>
                </div>
                <p>{r.text}</p>
                <small>{r.when}</small>
              </div>
            ))}
          </div>
        )}
      </main>
      {story !== null && <StoryViewer index={story} onClose={() => setStory(null)} highlights={HIGHLIGHTS} owner={AMARA} />}
      {postIdx !== null && (
        <PostViewer
          owner={AMARA}
          post={sorted[postIdx]}
          onClose={() => setPostIdx(null)}
          onPrev={postIdx > 0 ? () => setPostIdx(postIdx - 1) : undefined}
          onNext={postIdx < sorted.length - 1 ? () => setPostIdx(postIdx + 1) : undefined}
        />
      )}
    </div>
  )
}

/* ---------------- Booking request ---------------- */

const EVENT_TYPES = ["Club night", "Private party", "Wedding", "Corporate event", "Festival"]
const STARTS = ["8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 AM"]

function DateGrid({ value, onPick }: { value: Date | null; onPick: (d: Date) => void }) {
  const [m, setM] = useState(value ? value.getMonth() - 7 : 0)
  const first = new Date(2024, 7 + m, 1)
  const offset = first.getDay()
  const days = new Date(2024, 8 + m, 0).getDate()
  return (
    <div className="dj-cal">
      <div className="dj-cal-head">
        <button aria-label="Previous month" disabled={m === 0} onClick={() => setM(m - 1)}>
          <Icon name="back" size={18} />
        </button>
        <b>{first.toLocaleDateString("en-CA", { month: "long", year: "numeric" })}</b>
        <button aria-label="Next month" disabled={m === 2} onClick={() => setM(m + 1)}>
          <Icon name="chevron" size={18} />
        </button>
      </div>
      <div className="dj-cal-grid">
        {["S", "M", "T", "W", "T", "F", "S"].map((d, i) => (
          <span className="wk" key={i}>
            {d}
          </span>
        ))}
        {Array.from({ length: offset }, (_, i) => (
          <span key={"e" + i} />
        ))}
        {Array.from({ length: days }, (_, i) => {
          const d = new Date(2024, 7 + m, i + 1)
          const booked = BOOKED.includes(key(d))
          const past = d <= TODAY
          const selected = value && key(value) === key(d)
          return (
            <button key={i} disabled={booked || past} className={`${selected ? "selected" : ""} ${booked ? "booked" : ""}`} aria-label={`${longDate(d)}${booked ? ", already booked" : past ? ", unavailable" : ""}`} onClick={() => onPick(d)}>
              {i + 1}
            </button>
          )
        })}
      </div>
      <div className="dj-cal-legend">
        <span>
          <i className="free" /> Available
        </span>
        <span>
          <i className="booked" /> Booked
        </span>
      </div>
    </div>
  )
}

export function DjBooking() {
  const app = useApp()
  const [step, setStep] = useState(1)
  const [pkgId, setPkgId] = useState(preselected ?? "club")
  const [date, setDate] = useState<Date | null>(null)
  const [start, setStart] = useState("10:00 PM")
  const [where, setWhere] = useState<"bottlesup" | "other">("bottlesup")
  const [venue, setVenue] = useState("Nova Room · King West")
  const [address, setAddress] = useState("")
  const [outside, setOutside] = useState(false)
  const [type, setType] = useState("Club night")
  const [guests, setGuests] = useState("150")
  const [extra, setExtra] = useState(0)
  const [addons, setAddons] = useState<string[]>([])
  const [note, setNote] = useState("")
  const [name, setName] = useState(app.state.profile.name)
  const [agree, setAgree] = useState(false)
  const [tried, setTried] = useState(false)
  const [sent, setSent] = useState<string | null>(null)
  const top = useRef<HTMLDivElement>(null)
  useEffect(() => {
    preselected = null
  }, [])
  useEffect(() => {
    window.scrollTo({ top: 0 })
  }, [step])
  const pkg = PACKAGES.find((p) => p.id === pkgId)!
  // Drop add-ons that don't go with the chosen package (e.g. after switching packages).
  const q = priceFor(pkg, extra, addons.filter((id) => !ADDON_FOR[id] || ADDON_FOR[id].includes(pkgId)), where === "other" && outside)
  const place = where === "bottlesup" ? venue : address.trim() || "Address to confirm"
  const endTime = (() => {
    const [hm, ap] = start.split(" ")
    let h = parseInt(hm) % 12 + (ap === "PM" ? 12 : 0)
    const mins = Math.round((pkg.hours + extra) * 60)
    const total = h * 60 + mins
    h = Math.floor(total / 60) % 24
    const mm = String(total % 60).padStart(2, "0")
    return `${h % 12 || 12}:${mm} ${h >= 12 ? "PM" : "AM"}`
  })()
  const stepValid = step === 1 ? true : step === 2 ? !!date && (where === "bottlesup" || address.trim().length > 4) : step === 3 ? parseInt(guests) > 0 : agree && name.trim().length > 1
  const next = () => {
    setTried(true)
    if (!stepValid) return
    setTried(false)
    if (step < 4) return setStep(step + 1)
    const ref = "BK-" + String(Math.floor(1000 + Math.random() * 9000))
    const dateLabel = shortDate(date!)
    app.update((s) => ({
      djRequest: { ref, pkg: pkg.name, date: dateLabel, start, venue: place, total: q.total, deposit: q.deposit, status: "Pending" },
    }))
    const text = `Booking request ${ref}: ${pkg.name} on ${dateLabel}, ${start}–${endTime} at ${place}. ${type}, about ${guests} guests. Quoted ${money2(q.total)} incl. HST.${note.trim() ? " Note: " + note.trim() : ""}`
    app.update((st) => ({
      threads: { ...st.threads, amara: { ...st.threads.amara, messages: [...st.threads.amara.messages, { from: "me", text, time: "Now" }] } },
      threadOrder: ["amara", ...st.threadOrder.filter((x) => x !== "amara")],
    }))
    setSent(ref)
  }
  if (sent && date)
    return (
      <div className="screen">
        <TopBar title="Request sent" back fallback="professional" onBack={() => app.back("professional")} />
        <main className="padded dj-done">
          <div className="success-mark">
            <Icon name="check" size={30} />
          </div>
          <span className="eyebrow">BOOKING REQUEST · {sent}</span>
          <div className="display-title">Request sent to Amara</div>
          <p>Nothing has been charged. Amara usually replies within 2 hours.</p>
          <div className="dj-quote card-lite">
            <div className="line">
              <span>{pkg.name}</span>
              <b>{shortDate(date)}</b>
            </div>
            <div className="line">
              <span>Time</span>
              <b>
                {start} – {endTime}
              </b>
            </div>
            <div className="line">
              <span>Where</span>
              <b>{place}</b>
            </div>
            <div className="total-row">
              <span>
                <b>Quoted total</b>
                <small>Including 13% HST</small>
              </span>
              <b>{money2(q.total)}</b>
            </div>
          </div>
          <ol className="dj-steps">
            <li className="done">
              <b>Request sent</b>
              <small>Just now</small>
            </li>
            <li>
              <b>Amara reviews</b>
              <small>Usually within 2 hours</small>
            </li>
            <li>
              <b>Pay 30% deposit · {money2(q.deposit)}</b>
              <small>Only after Amara accepts</small>
            </li>
            <li>
              <b>Balance · {money2(q.balance)}</b>
              <small>Due 7 days before the event</small>
            </li>
          </ol>
          <Button className="full-width" icon="message" onClick={() => app.openThread("amara")}>
            Message Amara
          </Button>
          <Button variant="secondary" className="full-width" onClick={() => app.back("professional")}>
            Back to profile
          </Button>
        </main>
      </div>
    )
  return (
    <div className="screen" ref={top}>
      <TopBar title="Book Amara Vale" back onBack={() => (step > 1 ? setStep(step - 1) : app.back("professional"))} fallback="professional" action={<span className="step-count">{step}/4</span>} />
      <main className="padded checkout dj-book">
        <div className="progress" aria-label={`Step ${step} of 4`}>
          {[1, 2, 3, 4].map((n) => (
            <span key={n} className={n <= step ? "done" : ""} />
          ))}
        </div>

        {step === 1 && (
          <>
            <span className="eyebrow">STEP 1 · PACKAGE</span>
            <div className="display-title">What do you need?</div>
            <div className="dj-list">
              {PACKAGES.map((p) => (
                <button key={p.id} className={`dj-choice ${pkgId === p.id ? "selected-choice" : ""}`} aria-pressed={pkgId === p.id} onClick={() => setPkgId(p.id)}>
                  <span>
                    {p.popular && <em>MOST BOOKED</em>}
                    <b>{p.name}</b>
                    <small>
                      {p.hours} h · {p.includes.slice(1).join(" · ")}
                    </small>
                  </span>
                  <strong>{money(p.price)}</strong>
                </button>
              ))}
            </div>
          </>
        )}

        {step === 2 && (
          <>
            <span className="eyebrow">STEP 2 · DATE & PLACE</span>
            <div className="display-title">When and where?</div>
            <DateGrid value={date} onPick={setDate} />
            {tried && !date && <p className="dj-error">Choose an available date.</p>}
            {date && <p className="dj-picked">{longDate(date)} is open.</p>}
            <div className="field-label">Start time</div>
            <div className="choice-grid dj-times">
              {STARTS.map((t) => (
                <button key={t} className={start === t ? "selected" : ""} aria-pressed={start === t} onClick={() => setStart(t)}>
                  {t}
                </button>
              ))}
            </div>
            <p className="dj-picked">
              Set ends at {endTime} ({pkg.hours + extra} h)
            </p>
            <div className="field-label">Location</div>
            <div className="dj-seg">
              <button className={where === "bottlesup" ? "on" : ""} onClick={() => setWhere("bottlesup")}>
                BottlesUp venue
              </button>
              <button className={where === "other" ? "on" : ""} onClick={() => setWhere("other")}>
                Other address
              </button>
            </div>
            {where === "bottlesup" ? (
              <select className="dj-input" value={venue} onChange={(e) => setVenue(e.target.value)} aria-label="Venue">
                <option>Nova Room · King West</option>
                <option>Active Lounge · Main Street</option>
                <option>Sky Room · Harbour Avenue</option>
              </select>
            ) : (
              <>
                <input className="dj-input" value={address} onChange={(e) => setAddress(e.target.value)} placeholder="Street address and city" aria-label="Event address" />
                {tried && address.trim().length <= 4 && <p className="dj-error">Add the event address.</p>}
                <label className="dj-check">
                  <input type="checkbox" checked={outside} onChange={() => setOutside(!outside)} />
                  <span>
                    Outside Toronto <em>+{money(TRAVEL)} travel</em>
                  </span>
                </label>
              </>
            )}
          </>
        )}

        {step === 3 && (
          <>
            <span className="eyebrow">STEP 3 · DETAILS & ADD-ONS</span>
            <div className="display-title">Tell Amara about it</div>
            <div className="field-label">Event type</div>
            <div className="dj-chips">
              {EVENT_TYPES.map((t) => (
                <button key={t} className={type === t ? "on" : ""} aria-pressed={type === t} onClick={() => setType(t)}>
                  {t}
                </button>
              ))}
            </div>
            <div className="field-label">Expected guests</div>
            <input className="dj-input" type="number" min={1} value={guests} onChange={(e) => setGuests(e.target.value)} aria-label="Expected guests" />
            {tried && !(parseInt(guests) > 0) && <p className="dj-error">Enter how many guests you expect.</p>}
            <div className="field-label">Extra time · {money(EXTRA_HOUR)} per hour</div>
            <div className="counter">
              <button aria-label="Less extra time" disabled={extra === 0} onClick={() => setExtra(extra - 1)}>
                −
              </button>
              <span>
                <b>+{extra} h</b>
                <small>{pkg.hours + extra} h total</small>
              </span>
              <button aria-label="More extra time" disabled={extra === 3} onClick={() => setExtra(extra + 1)}>
                +
              </button>
            </div>
            <div className="field-label">Add-ons</div>
            <div className="dj-list">
              {ADDONS.filter((a) => !ADDON_FOR[a.id] || ADDON_FOR[a.id].includes(pkgId)).map((a) => {
                const on = addons.includes(a.id)
                return (
                  <label className={`dj-addon ${on ? "on" : ""}`} key={a.id}>
                    <input type="checkbox" checked={on} onChange={() => setAddons(on ? addons.filter((x) => x !== a.id) : [...addons, a.id])} />
                    <span>
                      <b>{a.label}</b>
                      <small>{a.detail}</small>
                    </span>
                    <strong>+{money(a.price)}</strong>
                  </label>
                )
              })}
            </div>
            <div className="field-label">Message to Amara (optional)</div>
            <textarea className="dj-input dj-note" value={note} onChange={(e) => setNote(e.target.value)} placeholder="Vibe, must-play tracks, dress code, load-in details…" maxLength={400} />
            <div className="dj-running">
              <span>Estimated total</span>
              <b>{money2(q.total)}</b>
            </div>
          </>
        )}

        {step === 4 && date && (
          <>
            <span className="eyebrow">STEP 4 · REVIEW PRICE</span>
            <div className="display-title">Your quote</div>
            <div className="order-summary">
              <div className="summary-event">
                <img src={media.pro} alt="" />
                <span>
                  <b>Amara Vale · {pkg.name}</b>
                  <small>
                    {shortDate(date)} · {start} – {endTime}
                  </small>
                  <small>
                    {place} · {type} · {guests} guests
                  </small>
                </span>
                <button onClick={() => setStep(1)}>Edit</button>
              </div>
              {q.lines.map(([label, v]) => (
                <div className="line" key={label}>
                  <span>{label}</span>
                  <b>{money2(v)}</b>
                </div>
              ))}
              <div className="line">
                <span>Subtotal</span>
                <b>{money2(q.subtotal)}</b>
              </div>
              <div className="line">
                <span>HST (13%)</span>
                <b>{money2(q.tax)}</b>
              </div>
              <div className="total-row">
                <span>
                  <b>Total</b>
                  <small>Nothing charged today</small>
                </span>
                <b>{money2(q.total)}</b>
              </div>
              <div className="due-venue">
                <Icon name="check" />
                <span>
                  <b>
                    30% deposit {money2(q.deposit)} · balance {money2(q.balance)}
                  </b>
                  <small>The deposit is due only after Amara accepts. The balance is due 7 days before the event.</small>
                </span>
              </div>
            </div>
            <div className="deposit-explainer">
              <Icon name="ticket" />
              <span>
                <b>Cancellation</b>
                <small>Full deposit refund up to 14 days before the event. 50% within 14 days. Amara's rider and tech spec will be shared once accepted.</small>
              </span>
            </div>
            <div className="field-label">Your name</div>
            <input className="dj-input" value={name} onChange={(e) => setName(e.target.value)} aria-label="Your name" />
            <label className="dj-check">
              <input type="checkbox" checked={agree} onChange={() => setAgree(!agree)} />
              <span>I agree to the booking terms and cancellation policy.</span>
            </label>
            {tried && !agree && <p className="dj-error">Please accept the booking terms to send your request.</p>}
            <p className="legal">Demo booking · no real payment or request is sent.</p>
          </>
        )}

        <div className="checkout-footer dj-footer">
          <div className="dj-running inline">
            <span>{step < 4 ? "Estimated total" : "Total incl. HST"}</span>
            <b>{money2(q.total)}</b>
          </div>
          <Button className="full-width" onClick={next}>
            {step === 1 ? `Continue with ${pkg.name.toLowerCase()}` : step === 2 ? "Continue to details" : step === 3 ? "Review price" : "Send booking request"}
          </Button>
          <small>No charge until Amara accepts</small>
        </div>
      </main>
    </div>
  )
}
