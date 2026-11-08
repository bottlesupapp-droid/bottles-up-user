import { useState } from "react"
import { useCityPicker } from "./Home"
import { media } from "../data"
import { useApp, type Screen } from "../store"
import { Button, Icon, TopBar } from "../ui"

/* Explore: big-photo results with details under the photo, visible quick filters,
   a filter sheet that previews counts before you apply, and a cards/list switch.
   Listings are demo data and match the names used in BottlesUp Business. */

type Kind = "Events" | "Venues" | "DJs & services" | "Opportunities"
type When = "Tonight" | "This weekend" | "Later"
type Item = {
  id: string
  kind: Kind
  title: string
  by?: string
  area: string
  when?: When
  dateLabel: string
  soon: number // days from today, for "Soonest"
  pp?: number // entry per person, dollars
  tableMin?: number
  price: string
  rating: number
  reviews: string
  music: string[]
  image: string
  tag?: string
  screen?: Screen
}

const ITEMS: Item[] = [
  { id: "afterglow", kind: "Events", title: "EONICS: Afterglow", by: "Nova Room", area: "King West", when: "Tonight", dateLabel: "Tonight · 10 PM", soon: 0, pp: 35, tableMin: 1000, price: "From $35", rating: 4.8, reviews: "312", music: ["Afro house", "Amapiano"], image: media.hero, tag: "Selling fast", screen: "event" },
  { id: "nova", kind: "Venues", title: "Nova Room", by: "Nightclub", area: "King West", when: "Tonight", dateLabel: "Open tonight · 10 PM–3 AM", soon: 0, pp: 20, tableMin: 1000, price: "$20 entry · tables from $1,000", rating: 4.7, reviews: "1.2k", music: ["Afro house", "Hip-hop"], image: media.venue, tag: "Top venue", screen: "venue" },
  { id: "novasat", kind: "Events", title: "Nova Saturdays", by: "Nova Room · weekly", area: "King West", when: "Later", dateLabel: "Saturdays from Sep 7 · 10 PM", soon: 14, pp: 20, tableMin: 1000, price: "From $20", rating: 4.6, reviews: "540", music: ["Hip-hop", "Afrobeats"], image: media.crowd },
  { id: "sky", kind: "Venues", title: "Sky Room", by: "Rooftop lounge", area: "Harbourfront", when: "Tonight", dateLabel: "Open tonight · 8 PM–2 AM", soon: 0, pp: 25, tableMin: 800, price: "$25 entry · tables from $800", rating: 4.5, reviews: "640", music: ["House", "R&B"], image: media.table },
  { id: "lumen", kind: "Venues", title: "Lumen Lounge", by: "Cocktail lounge", area: "Ossington", when: "Tonight", dateLabel: "Open tonight · 7 PM–2 AM", soon: 0, pp: 0, tableMin: 400, price: "No cover · tables from $400", rating: 4.4, reviews: "410", music: ["R&B", "Hip-hop"], image: media.bottles },
  { id: "basement", kind: "Events", title: "Basement Disco", by: "The Basement", area: "Junction", when: "This weekend", dateLabel: "Sun, Aug 25 · 9 PM", soon: 1, pp: 0, price: "Free RSVP", rating: 4.3, reviews: "88", music: ["Disco", "House"], image: media.friends },
  { id: "neon", kind: "Events", title: "Neon Garden", by: "Midnight Social · Nova Room", area: "King West", when: "Later", dateLabel: "Sat, Aug 31 · 9 PM", soon: 7, pp: 30, tableMin: 1000, price: "From $30", rating: 4.6, reviews: "190", music: ["House", "Disco"], image: media.stage },
  { id: "warehouse", kind: "Events", title: "Warehouse Sessions", by: "Midnight Social · The Warehouse", area: "Junction", when: "Later", dateLabel: "Sat, Sep 28 · 10 PM", soon: 35, pp: 25, price: "From $25", rating: 4.7, reviews: "260", music: ["Techno"], image: media.crowd },
  { id: "summer", kind: "Events", title: "Summer Signal", by: "Midnight Social · Nova Room", area: "King West", when: "Later", dateLabel: "Fri, Oct 11 · 9 PM", soon: 48, pp: 20, tableMin: 1000, price: "From $20", rating: 4.5, reviews: "75", music: ["Afro house", "House"], image: media.stage },
  { id: "amara", kind: "DJs & services", title: "Amara Vale", by: "DJ · Toronto", area: "Toronto", dateLabel: "Open dates in Sep", soon: 99, price: "From $500", rating: 4.9, reviews: "86", music: ["Afro house", "Amapiano"], image: media.dj, tag: "DJ", screen: "professional" },
  { id: "photo", kind: "Opportunities", title: "Event photographer wanted", by: "Nova Room", area: "King West", when: "Tonight", dateLabel: "Tonight · paid $300", soon: 0, price: "Paid · $300", rating: 4.7, reviews: "—", music: [], image: media.photographer, tag: "Opportunity", screen: "venue" },
]

// Music the viewer saves most (demo profile), used for "Best match".
const TASTE = ["Afro house", "Amapiano"]
const KINDS: ("All" | Kind)[] = ["All", "Events", "Venues", "DJs & services", "Opportunities"]
const AREAS = ["King West", "Harbourfront", "Ossington", "Junction"]
const MUSIC = ["Afro house", "Amapiano", "House", "Hip-hop", "R&B", "Afrobeats", "Disco", "Techno"]
const PRICE_MAX = 60 // slider top = "Any"
const BUCKETS = [0, 10, 20, 30, 40, 50] // Free, 1–10 … 50+

type F = { kind: "All" | Kind; when: "Any" | "Tonight" | "This weekend"; max: number; music: string[]; areas: string[]; rating: number; group: number; spend: number; tableFit: boolean }
const EMPTY: F = { kind: "All", when: "Any", max: PRICE_MAX, music: [], areas: [], rating: 0, group: 4, spend: 150, tableFit: false }
type SortKey = "Best match" | "Soonest" | "Price: low to high" | "Top rated"

const tableBudget = (f: F) => f.group * f.spend
const timed = (i: Item) => i.kind === "Events" || i.kind === "Venues"
function matches(i: Item, f: F, q = "") {
  if (f.kind !== "All" && i.kind !== f.kind) return false
  if (f.when === "Tonight" && i.when !== "Tonight") return false
  if (f.when === "This weekend" && i.when !== "Tonight" && i.when !== "This weekend") return false
  if (f.max < PRICE_MAX && timed(i) && (i.pp ?? 0) > f.max) return false
  if (f.music.length && !i.music.some((m) => f.music.includes(m))) return false
  if (f.areas.length && !f.areas.includes(i.area)) return false
  if (f.rating && i.rating < f.rating) return false
  if (f.tableFit && (i.tableMin === undefined || i.tableMin > tableBudget(f))) return false
  if (q && !`${i.title} ${i.by ?? ""} ${i.area} ${i.music.join(" ")} ${i.kind}`.toLowerCase().includes(q)) return false
  return true
}
// Taste first, then sooner nights, then rating.
const score = (i: Item) => i.music.filter((m) => TASTE.includes(m)).length * 2 + (i.when === "Tonight" ? 1 : i.when === "This weekend" ? 0.5 : 0) + i.rating
function sortItems(list: Item[], s: SortKey) {
  const l = [...list]
  if (s === "Soonest") l.sort((a, b) => a.soon - b.soon)
  else if (s === "Price: low to high") l.sort((a, b) => (a.pp ?? 9999) - (b.pp ?? 9999))
  else if (s === "Top rated") l.sort((a, b) => b.rating - a.rating)
  else l.sort((a, b) => score(b) - score(a))
  return l
}
// Which filters are on, with a way to switch each one off. Used for chips and "no results" help.
function activeKeys(f: F): { label: string; clear: (f: F) => F }[] {
  const out: { label: string; clear: (f: F) => F }[] = []
  if (f.kind !== "All") out.push({ label: f.kind, clear: (x) => ({ ...x, kind: "All" }) })
  if (f.when !== "Any") out.push({ label: f.when, clear: (x) => ({ ...x, when: "Any" }) })
  if (f.max < PRICE_MAX) out.push({ label: f.max === 0 ? "Free entry" : `Under $${f.max}`, clear: (x) => ({ ...x, max: PRICE_MAX }) })
  f.music.forEach((m) => out.push({ label: m, clear: (x) => ({ ...x, music: x.music.filter((y) => y !== m) }) }))
  f.areas.forEach((a) => out.push({ label: a, clear: (x) => ({ ...x, areas: x.areas.filter((y) => y !== a) }) }))
  if (f.rating) out.push({ label: `${f.rating}+ rating`, clear: (x) => ({ ...x, rating: 0 }) })
  if (f.tableFit) out.push({ label: `Tables up to $${tableBudget(f).toLocaleString()}`, clear: (x) => ({ ...x, tableFit: false }) })
  return out
}

function readLayout(): "cards" | "list" {
  try {
    return window.localStorage.getItem("bu-explore-layout") === "list" ? "list" : "cards"
  } catch {
    return "cards"
  }
}

export function Explore() {
  const app = useApp()
  const pickCity = useCityPicker()
  const [query, setQuery] = useState("")
  const [f, setF] = useState<F>(() => {
    const legacy = app.state.exploreFilter
    return { ...EMPTY, when: legacy === "Tonight" ? "Tonight" : legacy === "This Weekend" ? "This weekend" : "Any" }
  })
  const [sort, setSort] = useState<SortKey>("Best match")
  const [layout, setLayoutState] = useState<"cards" | "list">(readLayout)
  const setLayout = (l: "cards" | "list") => {
    setLayoutState(l)
    try {
      window.localStorage.setItem("bu-explore-layout", l)
    } catch {
      /* storage unavailable */
    }
  }
  const q = query.trim().toLowerCase()
  const shown = sortItems(
    ITEMS.filter((i) => matches(i, f, q)),
    sort,
  )
  const active = activeKeys(f)
  const sheetCount = active.filter((a) => a.label !== f.kind).length
  const clearAll = () => (setQuery(""), setF(EMPTY))
  const quick = (label: string, on: boolean, toggle: () => void) => (
    <button className={on ? "on" : ""} aria-pressed={on} onClick={toggle}>
      {label}
    </button>
  )
  const openFilters = () =>
    app.openSheet({
      title: "Filters",
      eyebrow: "REFINE",
      body: (close) => <FilterSheet initial={f} q={q} onApply={(n) => (setF(n), close())} />,
    })
  const openSort = () =>
    app.openSheet({
      title: "Sort by",
      eyebrow: `${shown.length} RESULTS`,
      body: (close) => (
        <div className="xp-sort" role="radiogroup">
          {(["Best match", "Soonest", "Price: low to high", "Top rated"] as SortKey[]).map((s) => (
            <button key={s} role="radio" aria-checked={sort === s} className={sort === s ? "on" : ""} onClick={() => (setSort(s), close())}>
              <span>
                <b>{s}</b>
                <small>
                  {s === "Best match" ? `Puts ${TASTE.join(" and ")} first, the music you save most` : s === "Soonest" ? "Tonight first" : s === "Price: low to high" ? "Cheapest way in first" : "Highest guest ratings first"}
                </small>
              </span>
              {sort === s && <Icon name="check" size={18} />}
            </button>
          ))}
        </div>
      ),
    })
  const open = (i: Item) => {
    if (i.screen) return app.go(i.screen)
    app.openSheet({
      title: i.title,
      eyebrow: i.kind.toUpperCase(),
      body: (close) => (
        <div className="xp-look">
          <img src={i.image} alt="" />
          <p className="xp-look-meta">
            {i.by} · {i.area}
          </p>
          <div className="xp-look-grid">
            <span>
              <small>When</small>
              <b>{i.dateLabel}</b>
            </span>
            <span>
              <small>Price</small>
              <b>{i.price}</b>
            </span>
            <span>
              <small>Music</small>
              <b>{i.music.join(", ") || "—"}</b>
            </span>
            <span>
              <small>Rating</small>
              <b>
                ★ {i.rating} · {i.reviews} reviews
              </b>
            </span>
          </div>
          <p className="xp-look-note">Demo listing. In this demo, full pages are available for Nova Room, EONICS: Afterglow and Amara Vale.</p>
          <Button onClick={() => (app.toast(`We'll remind you about ${i.title}`), close())}>Remind me</Button>
        </div>
      ),
    })
  }
  return (
    <div className="screen">
      <TopBar
        action={
          <button className="icon-btn" aria-label="Saved" onClick={() => app.go("saved")}>
            <Icon name="bookmark" />
          </button>
        }
      />
      <main className="padded">
        <div className="explore-top">
          <button className="city-chip" onClick={pickCity} aria-label={`City: ${app.state.city}. Change city`}>
            <Icon name="map" size={14} />
            <span>{app.state.city}</span>
            <span className="city-chip-arrow" aria-hidden="true">
              <Icon name="chevron" size={13} />
            </span>
          </button>
          <label className="searchbox">
            <Icon name="search" size={19} />
            <input id="explore-search" value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Events, venues, DJs or music" aria-label="Search events, venues, DJs or music" />
            {query && (
              <button type="button" aria-label="Clear search" onClick={() => setQuery("")}>
                <Icon name="close" size={16} />
              </button>
            )}
          </label>
        </div>
        <div className="chips scroll-row xp-kinds">
          {KINDS.map((k) => (
            <button key={k} className={f.kind === k ? "chip selected" : "chip"} aria-pressed={f.kind === k} onClick={() => setF({ ...f, kind: k })}>
              {k}
            </button>
          ))}
        </div>
        <div className="xp-quick scroll-row">
          <button className={`xp-filter-btn ${sheetCount ? "on" : ""}`} onClick={openFilters} aria-label={`Filters${sheetCount ? `, ${sheetCount} on` : ""}`}>
            <Icon name="menu" size={15} /> Filters{sheetCount ? <i>{sheetCount}</i> : null}
          </button>
          {quick("Tonight", f.when === "Tonight", () => setF({ ...f, when: f.when === "Tonight" ? "Any" : "Tonight" }))}
          {quick("Under $30", f.max === 30, () => setF({ ...f, max: f.max === 30 ? PRICE_MAX : 30 }))}
          {quick("Afro house", f.music.includes("Afro house"), () => setF({ ...f, music: f.music.includes("Afro house") ? f.music.filter((m) => m !== "Afro house") : [...f.music, "Afro house"] }))}
          {quick("4.7+ rated", f.rating === 4.7, () => setF({ ...f, rating: f.rating === 4.7 ? 0 : 4.7 }))}
          {quick("Free entry", f.max === 0, () => setF({ ...f, max: f.max === 0 ? PRICE_MAX : 0 }))}
        </div>
        {!q && !active.length && (
          <div className="recent-searches">
            <span>Recent</span>
            <button onClick={() => setQuery("Afterglow")}>Afterglow</button>
            <button onClick={() => setQuery("Nova Room")}>Nova Room</button>
          </div>
        )}
        <div className="xp-head">
          <b>
            {shown.length} {shown.length === 1 ? "place" : "places"}
            <small> · {app.state.city}</small>
          </b>
          <span>
            <button className="xp-sort-btn" onClick={openSort} aria-label={`Sort: ${sort}`}>
              {sort} <Icon name="chevron" size={13} />
            </button>
            <span className="xp-layout" role="group" aria-label="Layout">
              <button aria-pressed={layout === "cards"} aria-label="Cards" className={layout === "cards" ? "on" : ""} onClick={() => setLayout("cards")}>
                <Icon name="grid" size={15} />
              </button>
              <button aria-pressed={layout === "list"} aria-label="List" className={layout === "list" ? "on" : ""} onClick={() => setLayout("list")}>
                <Icon name="menu" size={15} />
              </button>
            </span>
          </span>
        </div>
        {(active.length > 0 || q) && (
          <div className="xp-active scroll-row">
            {active.map((a) => (
              <button key={a.label} onClick={() => setF(a.clear(f))} aria-label={`Remove ${a.label}`}>
                {a.label} <Icon name="close" size={12} />
              </button>
            ))}
            <button className="xp-clear" onClick={clearAll}>
              Clear all
            </button>
          </div>
        )}
        <div className={layout === "cards" ? "xp-cards" : "xp-list"}>
          {shown.length === 0 && <NoResults f={f} q={q} setF={setF} clearAll={clearAll} />}
          {shown.map((i, n) => {
            const best = sort === "Best match" && n === 0 && i.music.some((m) => TASTE.includes(m))
            return layout === "cards" ? (
              <button className="xp-card" key={i.id} onClick={() => open(i)}>
                <span className="xp-photo">
                  <img src={i.image} alt="" loading="lazy" />
                  {best ? <em className="xp-best">Best match</em> : i.tag ? <em>{i.tag}</em> : null}
                </span>
                <span className="xp-body">
                  <span className="xp-row">
                    <b>{i.title}</b>
                    <span className="xp-rating">
                      <Icon name="star" size={13} /> {i.rating}
                    </span>
                  </span>
                  <span className="xp-meta">
                    {i.dateLabel} · {i.area}
                  </span>
                  <span className="xp-row">
                    <span className="xp-music">{i.music.slice(0, 2).join(" · ")}</span>
                    <strong>{i.price.split(" · ")[0]}</strong>
                  </span>
                  {best && <span className="xp-why">Plays {i.music.filter((m) => TASTE.includes(m)).join(" and ")}, which you save most</span>}
                </span>
              </button>
            ) : (
              <button className="xp-line" key={i.id} onClick={() => open(i)}>
                <img src={i.image} alt="" loading="lazy" />
                <span>
                  <b>{i.title}</b>
                  <small>
                    {i.dateLabel} · {i.area}
                  </small>
                  <small>
                    <Icon name="star" size={11} /> {i.rating} · {i.music.slice(0, 2).join(", ") || i.kind}
                  </small>
                </span>
                <strong>{i.price.split(" · ")[0]}</strong>
              </button>
            )
          })}
        </div>
        <p className="xp-demo">Demo listings.</p>
      </main>
    </div>
  )
}

function NoResults({ f, q, setF, clearAll }: { f: F; q: string; setF: (f: F) => void; clearAll: () => void }) {
  // Suggest the single change that brings back the most results.
  const best = activeKeys(f)
    .map((a) => ({ a, n: ITEMS.filter((i) => matches(i, a.clear(f), q)).length }))
    .sort((x, y) => y.n - x.n)[0]
  return (
    <div className="empty-state">
      <Icon name="search" />
      <b>Nothing matches all of that</b>
      <small>{best && best.n ? `Remove “${best.a.label}” to see ${best.n} ${best.n === 1 ? "place" : "places"}.` : "Try a different search or clear your filters."}</small>
      {best && best.n ? <Button onClick={() => setF(best.a.clear(f))}>Remove {best.a.label}</Button> : null}
      <Button variant="secondary" onClick={clearAll}>
        Clear all
      </Button>
    </div>
  )
}

function FilterSheet({ initial, q, onApply }: { initial: F; q: string; onApply: (f: F) => void }) {
  const [d, setD] = useState<F>(initial)
  const count = (x: F) => ITEMS.filter((i) => matches(i, x, q)).length
  const n = count(d)
  // Histogram of entry prices for everything that matches the other filters.
  const base = ITEMS.filter((i) => timed(i) && matches(i, { ...d, max: PRICE_MAX }, q))
  const bucketOf = (p: number) => (p === 0 ? 0 : Math.min(BUCKETS.length - 1, Math.ceil(p / 10)))
  const bars = BUCKETS.map((_, k) => base.filter((i) => bucketOf(i.pp ?? 0) === k).length)
  const tallest = Math.max(1, ...bars)
  const fitPrice = base.filter((i) => (i.pp ?? 0) <= d.max).length
  const budget = tableBudget(d)
  const fitN = count({ ...d, tableFit: true })
  const toggle = (k: "music" | "areas", v: string) => setD({ ...d, [k]: d[k].includes(v) ? d[k].filter((x) => x !== v) : [...d[k], v] })
  const opt = (label: string, on: boolean, next: F, onClick: () => void) => {
    const c = count(next)
    return (
      <button key={label} className={on ? "on" : ""} aria-pressed={on} disabled={!on && c === 0} onClick={onClick}>
        {label} <i>{c}</i>
      </button>
    )
  }
  return (
    <div className="xf">
      <section>
        <h3>When</h3>
        <div className="xf-chips">
          {(["Any", "Tonight", "This weekend"] as const).map((w) => opt(w, d.when === w, { ...d, when: w }, () => setD({ ...d, when: w })))}
        </div>
      </section>
      <section>
        <div className="xf-head">
          <h3>Entry per person</h3>
          <span>
            {fitPrice} of {base.length} fit
          </span>
        </div>
        <div className="xf-hist" aria-hidden="true">
          {bars.map((b, k) => (
            <i key={k} className={BUCKETS[k] <= d.max ? "in" : ""} style={{ height: `${Math.max(6, (b / tallest) * 100)}%` }} />
          ))}
        </div>
        <input className="xf-range" type="range" min={0} max={PRICE_MAX} step={5} value={d.max} aria-label="Maximum entry price per person" onChange={(e) => setD({ ...d, max: Number(e.target.value) })} />
        <div className="xf-scale">
          <span>Free</span>
          <label>
            Up to
            <input
              inputMode="numeric"
              value={d.max >= PRICE_MAX ? "" : String(d.max)}
              placeholder="Any"
              onChange={(e) => {
                const v = parseInt(e.target.value.replace(/\D/g, ""))
                setD({ ...d, max: Number.isNaN(v) ? PRICE_MAX : Math.min(PRICE_MAX, v) })
              }}
            />
          </label>
          <span>$60+</span>
        </div>
      </section>
      <section className="xf-table">
        <div className="xf-head">
          <h3>Getting a table?</h3>
          <span>Optional</span>
        </div>
        <p>Tell us your group and what each person wants to spend. We'll show places with a table you can split.</p>
        <div className="xf-sub">Group size</div>
        <div className="xf-chips">
          {[2, 4, 6, 8, 10].map((g) => (
            <button key={g} className={d.group === g ? "on" : ""} aria-pressed={d.group === g} onClick={() => setD({ ...d, group: g })}>
              {g === 10 ? "10+" : g}
            </button>
          ))}
        </div>
        <label className="xf-spend">
          <span>Each person spends</span>
          <span className="xf-money">
            $
            <input inputMode="numeric" value={String(d.spend)} onChange={(e) => setD({ ...d, spend: Math.min(2000, parseInt(e.target.value.replace(/\D/g, "")) || 0) })} />
          </span>
        </label>
        <button className={`xf-fit ${d.tableFit ? "on" : ""}`} aria-pressed={d.tableFit} onClick={() => setD({ ...d, tableFit: !d.tableFit })}>
          <span>
            <b>Tables up to ${budget.toLocaleString()}</b>
            <small>
              {d.group} × ${d.spend} · {fitN} {fitN === 1 ? "place fits" : "places fit"}
            </small>
          </span>
          <span className={d.tableFit ? "toggle on" : "toggle"}>
            <i />
          </span>
        </button>
      </section>
      <section>
        <h3>Music</h3>
        <div className="xf-chips">{MUSIC.map((m) => opt(m, d.music.includes(m), { ...d, music: d.music.includes(m) ? d.music : [...d.music, m] }, () => toggle("music", m)))}</div>
      </section>
      <section>
        <h3>Area</h3>
        <div className="xf-chips">{AREAS.map((a) => opt(a, d.areas.includes(a), { ...d, areas: d.areas.includes(a) ? d.areas : [...d.areas, a] }, () => toggle("areas", a)))}</div>
      </section>
      <section>
        <h3>Guest rating</h3>
        <div className="xf-chips">{[0, 4.5, 4.7].map((r) => opt(r ? `${r}+` : "Any", d.rating === r, { ...d, rating: r }, () => setD({ ...d, rating: r })))}</div>
      </section>
      <p className="xf-note">Date and price apply to events and venues. Demo listings.</p>
      <div className="xf-bar">
        <Button variant="secondary" onClick={() => setD({ ...EMPTY, kind: d.kind })}>
          Reset
        </Button>
        <Button disabled={n === 0} onClick={() => onApply(d)}>
          {n === 0 ? "No matches" : `Show ${n} ${n === 1 ? "place" : "places"}`}
        </Button>
      </div>
    </div>
  )
}

type SavedItem = { id: string; name: string; meta: string; image: string; screen: Screen; type: string }

const savedCatalog: SavedItem[] = [
  { id: "event", name: "EONICS: Afterglow", meta: "Sat, Aug 24 · From $35", image: media.hero, screen: "event", type: "Events" },
  { id: "venue", name: "Nova Room", meta: "King West · Tables from $1,000", image: media.venue, screen: "venue", type: "Venues" },
  { id: "amara", name: "Amara Vale", meta: "DJ · Afro house", image: media.pro, screen: "professional", type: "Professionals" },
  { id: "post-eonics", name: "eonicsmusic", meta: "Post · Nova Room", image: media.hero, screen: "home", type: "Posts" },
  { id: "reel-eonics", name: "EONICS reel", meta: "Reel · 18.2K likes", image: media.crowd, screen: "reel", type: "Posts" },
]

export function Saved() {
  const app = useApp()
  const [tab, setTab] = useState("All")
  const [searching, setSearching] = useState(false)
  const [query, setQuery] = useState("")
  const [managing, setManaging] = useState(false)
  const mine = savedCatalog.filter((i) => app.state.saved.includes(i.id))
  const q = query.trim().toLowerCase()
  const shown = mine.filter((i) => (tab === "All" || i.type === tab) && (!q || `${i.name} ${i.meta}`.toLowerCase().includes(q)))
  return (
    <div className="screen">
      <TopBar
        title="Saved"
        back
        fallback="explore"
        action={
          <button className={searching ? "icon-btn active" : "icon-btn"} aria-label="Search saved" onClick={() => setSearching(!searching)}>
            <Icon name="search" />
          </button>
        }
      />
      <main className="padded">
        {searching && (
          <label className="searchbox">
            <Icon name="search" size={19} />
            <input id="saved-search" autoFocus value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search saved" aria-label="Search saved" />
          </label>
        )}
        <div className="saved-tabs scroll-row">
          {["All", "Events", "Venues", "Posts", "Professionals"].map((item) => (
            <button className={tab === item ? "active" : ""} onClick={() => setTab(item)} key={item}>
              {item}
            </button>
          ))}
        </div>
        <div className="collection-card">
          <span>
            <Icon name="bookmark" />
          </span>
          <div>
            <small>SMART COLLECTION</small>
            <b>{app.state.city} weekends</b>
            <p>
              {mine.length} saved experience{mine.length === 1 ? "" : "s"}
            </p>
          </div>
        </div>
        <div className="section-title">
          <b>{tab}</b>
          {mine.length > 0 && <button onClick={() => setManaging(!managing)}>{managing ? "Done" : "Manage"}</button>}
        </div>
        {shown.length === 0 ? (
          <div className="empty-state">
            <Icon name="bookmark" />
            <b>Nothing saved here yet</b>
            <small>Tap the bookmark on any event, venue or post to keep it here.</small>
          </div>
        ) : (
          <div className="saved-grid">
            {shown.map((item) => (
              <div className="saved-item" key={item.id}>
                <button onClick={() => app.go(item.screen)}>
                  <img src={item.image} alt="" />
                  <span>
                    <b>{item.name}</b>
                    <small>{item.meta}</small>
                  </span>
                </button>
                <button
                  className={managing ? "saved-remove managing" : "saved-remove"}
                  aria-label={`Remove ${item.name} from saved`}
                  onClick={() => app.toggleIn("saved", item.id, item.name)}
                >
                  <Icon name={managing ? "trash" : "bookmark"} filled={!managing} size={16} />
                </button>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  )
}
