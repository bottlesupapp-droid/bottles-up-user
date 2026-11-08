import { useEffect, useRef, useState } from "react"
import { media } from "../data"
import { useApp } from "../store"
import { Icon } from "../ui"

export type VenuePhoto = { src: string; caption: string; tag: "Space" | "Tables" | "Nights" | "Guest photos"; by?: string }

export const VENUE_PHOTOS: VenuePhoto[] = [
  { src: media.venue, caption: "Main room", tag: "Space" },
  { src: media.stage, caption: "Stage and lights", tag: "Space" },
  { src: media.table, caption: "Halo Booth · upper level", tag: "Tables" },
  { src: media.crowd, caption: "Dance floor on a Saturday", tag: "Nights" },
  { src: media.bottles, caption: "Bar and bottle service", tag: "Tables" },
  { src: media.hero, caption: "EONICS: Afterglow", tag: "Nights" },
  { src: media.dj, caption: "DJ booth", tag: "Space" },
  { src: media.friends, caption: "Guests at Spring Social", tag: "Guest photos", by: "maya.chen" },
]

export function useVenuePhotos() {
  const { state } = useApp()
  return [...VENUE_PHOTOS, ...state.guestPhotos]
}

/** Full-screen swipeable gallery with thumbnails. */
export function GalleryViewer({ photos, start, onClose }: { photos: VenuePhoto[]; start: number; onClose: () => void }) {
  const track = useRef<HTMLDivElement>(null)
  const [i, setI] = useState(start)
  const go = (n: number) => {
    const k = Math.max(0, Math.min(photos.length - 1, n))
    track.current?.scrollTo({ left: k * (track.current?.clientWidth ?? 0), behavior: "smooth" })
  }
  useEffect(() => {
    track.current?.scrollTo({ left: start * (track.current?.clientWidth ?? 0) })
  }, [start])
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose()
      if (e.key === "ArrowRight") go(i + 1)
      if (e.key === "ArrowLeft") go(i - 1)
    }
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  })
  const p = photos[i]
  return (
    <div className="gallery-viewer" role="dialog" aria-modal="true" aria-label="Venue photos">
      <div className="gv-top">
        <button aria-label="Close photos" onClick={onClose}>
          <Icon name="close" size={20} />
        </button>
        <span>
          {i + 1} / {photos.length}
        </span>
        <span />
      </div>
      <div
        className="gv-track"
        ref={track}
        onScroll={(e) => {
          const el = e.currentTarget
          const n = Math.round(el.scrollLeft / el.clientWidth)
          if (n !== i) setI(n)
        }}
      >
        {photos.map((ph, k) => (
          <figure key={k}>
            <img src={ph.src} alt={ph.caption} draggable={false} />
          </figure>
        ))}
      </div>
      {i > 0 && (
        <button className="gv-nav left" aria-label="Previous photo" onClick={() => go(i - 1)}>
          <Icon name="back" />
        </button>
      )}
      {i < photos.length - 1 && (
        <button className="gv-nav right" aria-label="Next photo" onClick={() => go(i + 1)}>
          <Icon name="chevron" />
        </button>
      )}
      <div className="gv-caption">
        <b>{p.caption}</b>
        <small>
          {p.tag}
          {p.by ? ` · Shared by ${p.by}` : " · Nova Room"}
        </small>
      </div>
      <div className="gv-thumbs">
        {photos.map((ph, k) => (
          <button key={k} className={k === i ? "on" : ""} aria-label={`Photo ${k + 1}: ${ph.caption}`} onClick={() => go(k)}>
            <img src={ph.src} alt="" />
          </button>
        ))}
      </div>
    </div>
  )
}

/** The swipeable photo header on the venue page. */
export function HeroCarousel({ photos, onOpen }: { photos: VenuePhoto[]; onOpen: (i: number) => void }) {
  const [i, setI] = useState(0)
  const track = useRef<HTMLDivElement>(null)
  const hero = photos.filter((p) => p.tag !== "Guest photos")
  return (
    <>
      <div
        className="vh-track"
        ref={track}
        onScroll={(e) => {
          const el = e.currentTarget
          const n = Math.round(el.scrollLeft / el.clientWidth)
          if (n !== i) setI(n)
        }}
      >
        {hero.map((p, k) => (
          <button key={k} className="vh-slide" onClick={() => onOpen(photos.indexOf(p))} aria-label={`Open photo: ${p.caption}`}>
            <img src={p.src} alt={p.caption} draggable={false} />
          </button>
        ))}
      </div>
      <span className="vh-count">
        <Icon name="camera" size={13} /> {i + 1} / {hero.length} · {hero[i]?.caption}
      </span>
      <div className="vh-dots" aria-hidden="true">
        {hero.map((_, k) => (
          <i key={k} className={k === i ? "on" : ""} />
        ))}
      </div>
    </>
  )
}

const FILTERS = ["All", "Space", "Tables", "Nights", "Guest photos"] as const

/** Photos section: filter chips, a scrollable strip, and an add-photo button. */
export function PhotoSection({ onOpen }: { onOpen: (photos: VenuePhoto[], i: number) => void }) {
  const app = useApp()
  const all = useVenuePhotos()
  const [filter, setFilter] = useState<(typeof FILTERS)[number]>("All")
  const input = useRef<HTMLInputElement>(null)
  const shown = filter === "All" ? all : all.filter((p) => p.tag === filter)
  const add = (files: FileList | null) => {
    if (!files?.length) return
    const list = Array.from(files).filter((f) => f.type.startsWith("image/")).slice(0, 6)
    if (!list.length) return app.toast("Choose a photo file (JPG, PNG or HEIC)")
    const big = list.find((f) => f.size > 15 * 1024 * 1024)
    if (big) return app.toast("That photo is over 15 MB. Try a smaller one.")
    Promise.all(
      list.map(
        (f) =>
          new Promise<VenuePhoto & { tag: "Guest photos" }>((resolve) => {
            const r = new FileReader()
            r.onload = () => resolve({ src: String(r.result), caption: "Your photo", tag: "Guest photos", by: app.state.profile.handle })
            r.readAsDataURL(f)
          }),
      ),
    ).then((added) => {
      app.update((s) => ({ guestPhotos: [...s.guestPhotos, ...added] }))
      setFilter("Guest photos")
      app.toast(`${added.length} photo${added.length === 1 ? "" : "s"} added to Nova Room`)
    })
  }
  return (
    <section className="vp-section">
      <div className="section-title">
        <b>Photos · {all.length}</b>
        <button onClick={() => onOpen(all, 0)}>See all</button>
      </div>
      <div className="vp-filters">
        {FILTERS.map((f) => (
          <button key={f} className={filter === f ? "on" : ""} aria-pressed={filter === f} onClick={() => setFilter(f)}>
            {f}
          </button>
        ))}
      </div>
      <div className="vp-strip">
        <button className="vp-add" onClick={() => input.current?.click()} aria-label="Add your photos of Nova Room">
          <Icon name="camera" size={22} />
          <b>Add photo</b>
          <small>Share your night</small>
        </button>
        {shown.map((p) => (
          <button key={p.src + p.caption} className="vp-tile" onClick={() => onOpen(shown, shown.indexOf(p))}>
            <img src={p.src} alt={p.caption} />
            <span>{p.caption}</span>
          </button>
        ))}
        {shown.length === 0 && <p className="vp-empty">No {filter.toLowerCase()} yet. Be the first to add one.</p>}
      </div>
      <input ref={input} id="venue-photo-upload" type="file" accept="image/*" multiple hidden onChange={(e) => add(e.target.files)} />
      <p className="list-count">Photos you add appear under Guest photos. Keep them about the venue and your night.</p>
    </section>
  )
}
