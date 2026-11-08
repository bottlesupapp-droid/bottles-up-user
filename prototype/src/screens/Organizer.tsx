import { useEffect, useRef, useState } from "react"
import { media } from "../data"
import { useApp } from "../store"
import { Avatar, Button, Icon, ShareButton, TopBar, useComments, useMoreMenu } from "../ui"

export type Owner = { name: string; handle: string; avatar: string; place: string }
const EONICS: Owner = { name: "EONICS Music", handle: "eonicsmusic", avatar: media.dj, place: "Nova Room, Toronto" }

export type Highlight = { name: string; cover: string; slides: string[]; captions: string[] }
export type Post = { id: string; image: string; caption: string; likes: number; comments: number; when: string; reel?: boolean; pinned?: boolean; tagged?: boolean; event?: string }

export const POSTS: Post[] = [
  { id: "op1", image: media.hero, caption: "Afterglow returns this Saturday. Nova Room, 10 PM. Tables are going fast.", likes: 2848, comments: 112, when: "2 days ago", pinned: true, event: "EONICS: Afterglow" },
  { id: "op2", image: media.crowd, caption: "July was electric. Thank you Toronto.", likes: 4120, comments: 203, when: "4 weeks ago", reel: true },
  { id: "op3", image: media.stage, caption: "Lineup drop: EONICS × Amara Vale, Sep 14.", likes: 1934, comments: 88, when: "1 week ago", pinned: true },
  { id: "op4", image: media.dj, caption: "Behind the decks before doors.", likes: 1510, comments: 41, when: "2 weeks ago", reel: true },
  { id: "op5", image: media.venue, caption: "Our home for three years. Nova Room, King West.", likes: 1288, comments: 37, when: "3 weeks ago" },
  { id: "op6", image: media.friends, caption: "Your photos from Spring Social. Tag us to be featured.", likes: 980, comments: 54, when: "1 month ago", tagged: true },
  { id: "op7", image: media.table, caption: "Halo Booth, upper level. Book through BottlesUp.", likes: 860, comments: 19, when: "1 month ago" },
  { id: "op8", image: media.bottles, caption: "Bottle service menu for Afterglow is live.", likes: 744, comments: 22, when: "5 weeks ago" },
  { id: "op9", image: media.photographer, caption: "Shot by @lenspriya at Rooftop Sessions.", likes: 1102, comments: 30, when: "2 months ago", tagged: true },
]

const HIGHLIGHTS = [
  { name: "Afterglow", cover: media.hero, slides: [media.hero, media.crowd, media.stage], captions: ["Afterglow · Nova Room", "July sold out", "Next: Sat, Aug 24"] },
  { name: "Lineups", cover: media.stage, slides: [media.stage, media.dj], captions: ["EONICS × Amara Vale", "Sep 14 · tickets soon"] },
  { name: "Recaps", cover: media.crowd, slides: [media.crowd, media.friends], captions: ["Rooftop Sessions", "Spring Social crew"] },
  { name: "Venue", cover: media.venue, slides: [media.venue, media.table], captions: ["Nova Room, King West", "Halo Booth, upper level"] },
  { name: "Backstage", cover: media.dj, slides: [media.dj, media.photographer], captions: ["Soundcheck", "Our photo team"] },
]

const upcoming = [
  { title: "EONICS: Afterglow", meta: "SAT, AUG 24 · 10 PM", place: "Nova Room · Afro house · 19+", image: media.hero, open: true },
  { title: "EONICS × Amara Vale", meta: "SAT, SEP 14 · 10 PM", place: "Nova Room · Tickets on sale soon", image: media.stage, open: false },
]
const past = [
  { title: "Afterglow: July", meta: "Sat, Jul 27 · 410 guests" },
  { title: "Rooftop Sessions", meta: "Fri, Jun 21 · 280 guests" },
  { title: "Spring Social", meta: "Sat, May 18 · 316 guests" },
]
const reviews = [
  { name: "Maya C.", text: "Best sound in the city. The night ran on time and the door was quick.", stars: 5, when: "Afterglow: July" },
  { name: "Noah R.", text: "Great lineup and lighting. Tables were exactly as described.", stars: 5, when: "Rooftop Sessions" },
  { name: "Priya S.", text: "Loved it. Bar lines got long after 1 AM.", stars: 4, when: "Spring Social" },
]

const SLIDE_MS = 4000

export function StoryViewer({ index, onClose, highlights = HIGHLIGHTS, owner = EONICS }: { index: number; onClose: () => void; highlights?: Highlight[]; owner?: Owner }) {
  const HL = highlights
  const [h, setH] = useState(index)
  const [s, setS] = useState(0)
  const [paused, setPaused] = useState(false)
  const hl = HL[h]
  const next = () => {
    if (s < hl.slides.length - 1) setS(s + 1)
    else if (h < HL.length - 1) {
      setH(h + 1)
      setS(0)
    } else onClose()
  }
  const prev = () => {
    if (s > 0) setS(s - 1)
    else if (h > 0) {
      setH(h - 1)
      setS(HL[h - 1].slides.length - 1)
    }
  }
  const nextRef = useRef(next)
  nextRef.current = next
  useEffect(() => {
    if (paused) return
    const t = window.setTimeout(() => nextRef.current(), SLIDE_MS)
    return () => window.clearTimeout(t)
  }, [h, s, paused])
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose()
      if (e.key === "ArrowRight") nextRef.current()
      if (e.key === "ArrowLeft") prev()
    }
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  })
  return (
    <div className="story-viewer" role="dialog" aria-modal="true" aria-label={`${hl.name} highlight`}>
      <img src={hl.slides[s]} alt={hl.captions[s]} />
      <div className="story-shade" />
      <div className="story-bars">
        {hl.slides.map((_, i) => (
          <i key={i}>
            <b className={i < s ? "done" : i === s ? (paused ? "active paused" : "active") : ""} style={i === s ? { animationDuration: `${SLIDE_MS}ms` } : undefined} key={`${h}-${s}-${i}`} />
          </i>
        ))}
      </div>
      <div className="story-head">
        <Avatar src={owner.avatar} label={owner.name} />
        <b>{owner.handle}</b>
        <span>{hl.name}</span>
        <button aria-label={paused ? "Play" : "Pause"} onClick={() => setPaused(!paused)}>
          <Icon name={paused ? "play" : "pause"} size={18} />
        </button>
        <button aria-label="Close" onClick={onClose}>
          <Icon name="close" size={20} />
        </button>
      </div>
      <button className="story-tap left" aria-label="Previous" onClick={prev} />
      <button className="story-tap right" aria-label="Next" onClick={next} />
      <p className="story-caption">{hl.captions[s]}</p>
    </div>
  )
}

export function PostViewer({ post, onClose, onPrev, onNext, owner = EONICS }: { post: Post; onClose: () => void; onPrev?: () => void; onNext?: () => void; owner?: Owner }) {
  const app = useApp()
  const openComments = useComments()
  const more = useMoreMenu()
  const liked = app.state.liked.includes(post.id)
  const saved = app.state.saved.includes(post.id)
  const extra = app.state.comments[post.id]?.length ?? 0
  const [burst, setBurst] = useState(false)
  const like = () => app.toggleIn("liked", post.id)
  return (
    <div className="post-viewer" role="dialog" aria-modal="true" aria-label="Post">
      <div className="post-viewer-top">
        <button aria-label="Close post" onClick={onClose}>
          <Icon name="back" />
        </button>
        <b>Posts</b>
        <span />
      </div>
      <article className="post">
        <div className="post-head">
          <div className="profile-line">
            <Avatar src={owner.avatar} label={owner.name} />
            <span>
              <b>{owner.handle}</b>
              <small>
                {post.pinned ? "Pinned · " : ""}
                {owner.place}
              </small>
            </span>
          </div>
          <button className="icon-btn" aria-label="More options" onClick={() => more(`${owner.name} post`)}>
            <span className="dots">•••</span>
          </button>
        </div>
        <div
          className="post-media"
          onDoubleClick={() => {
            if (!liked) like()
            setBurst(true)
            window.setTimeout(() => setBurst(false), 700)
          }}
        >
          <img src={post.image} alt={post.caption} />
          {post.reel && (
            <span className="play-control">
              <Icon name="play" filled />
            </span>
          )}
          {burst && (
            <span className="like-burst" aria-hidden="true">
              <Icon name="heart" filled size={80} />
            </span>
          )}
          {onPrev && <button className="post-nav left" aria-label="Previous post" onClick={onPrev}><Icon name="back" /></button>}
          {onNext && <button className="post-nav right" aria-label="Next post" onClick={onNext}><Icon name="chevron" /></button>}
        </div>
        <div className="post-body">
          <div className="post-actions">
            <div>
              <button className={liked ? "active icon-btn" : "icon-btn"} aria-label={liked ? "Unlike" : "Like"} aria-pressed={liked} onClick={like}>
                <Icon name="heart" filled={liked} />
              </button>
              <button className="icon-btn" aria-label="Comments" onClick={() => openComments(post.id)}>
                <Icon name="comment" />
              </button>
              <button className="icon-btn" aria-label="Share post" onClick={() => app.share(`${owner.name} post`)}>
                <Icon name="send" />
              </button>
            </div>
            <button className={saved ? "active icon-btn" : "icon-btn"} aria-label={saved ? "Remove from saved" : "Save post"} aria-pressed={saved} onClick={() => app.toggleIn("saved", post.id, "Post")}>
              <Icon name="bookmark" filled={saved} />
            </button>
          </div>
          <b>{(post.likes + (liked ? 1 : 0)).toLocaleString("en-CA")} likes</b>
          <p>
            <b>{owner.handle}</b> {post.caption}
          </p>
          <button className="tag-link" onClick={() => openComments(post.id)}>
            View all {post.comments + extra} comments
          </button>
          {post.event && (
            <button className="tag-link" onClick={() => app.go("event")}>
              <Icon name="calendar" size={13} /> {post.event} · View event
            </button>
          )}
          <small className="post-when">{post.when}</small>
        </div>
      </article>
    </div>
  )
}

export const OPPORTUNITIES = [
  {
    id: "o1",
    role: "Photographer",
    event: "EONICS: Afterglow",
    date: "Sat, Aug 24",
    pay: "$250 flat",
    hours: "10 PM – 2 AM",
    requirements: ["Portfolio with at least 3 nightlife events", "Own camera and flash", "Deliver 40 edited photos within 48 hours"],
  },
  {
    id: "o2",
    role: "Warm-up DJ",
    event: "EONICS × Amara Vale",
    date: "Sat, Sep 14",
    pay: "$400",
    hours: "9:30 – 11 PM",
    requirements: ["Afro house or amapiano set", "Bring your own USBs (CDJ-3000 setup)", "Arrive 45 minutes before your set"],
  },
  {
    id: "o3",
    role: "Ambassador",
    event: "EONICS × Amara Vale",
    date: "Sep 1 – 14",
    pay: "10% of referred sales",
    hours: "Flexible",
    requirements: ["Active Toronto nightlife following", "Share your personal link", "Commission paid after the event"],
  },
  {
    id: "o4",
    role: "Host",
    event: "EONICS: Afterglow",
    date: "Sat, Aug 24",
    pay: "",
    hours: "9:30 PM – 1 AM",
    requirements: ["Greet table guests and check names", "Friendly, calm under pressure", "Smart black outfit"],
  },
]

const EVENTS_LIST = [
  { label: "This Saturday", date: "Sat, Aug 24 · 10 PM", title: "EONICS: Afterglow", place: "Nova Room", image: media.hero, onSale: true },
  { label: "In 3 weeks", date: "Sat, Sep 14 · 10 PM", title: "EONICS × Amara Vale", place: "Nova Room", image: media.stage, onSale: false },
  { label: "October", date: "Sat, Oct 26 · 10 PM", title: "Afterglow: Halloween", place: "Sky Room", image: media.crowd, onSale: false },
]

function ApplyBody({ op, close }: { op: (typeof OPPORTUNITIES)[number]; close: () => void }) {
  const app = useApp()
  const [link, setLink] = useState("")
  const [note, setNote] = useState("")
  const [tried, setTried] = useState(false)
  const [sending, setSending] = useState(false)
  return (
    <form
      noValidate
      className="sheet-form apply-form"
      onSubmit={(e) => {
        e.preventDefault()
        setTried(true)
        if (!note.trim() || sending) return
        setSending(true)
        window.setTimeout(() => {
          app.toast("Application sent privately to EONICS")
          close()
        }, 600)
      }}
    >
      <p className="list-count">
        {op.event} · {op.date}
        {op.pay ? ` · ${op.pay}` : ""}
      </p>
      <label htmlFor="apply-link">Portfolio or social link (optional)</label>
      <input id="apply-link" value={link} onChange={(e) => setLink(e.target.value)} placeholder="instagram.com/yourname" />
      <label htmlFor="apply-note">Why you're a good fit</label>
      <textarea id="apply-note" value={note} maxLength={300} onChange={(e) => setNote(e.target.value)} placeholder="A sentence or two about your experience" />
      {tried && !note.trim() && <small className="field-error">Add a short note so the organizer knows who you are.</small>}
      <p className="list-count">Only EONICS can see your application. It never appears on their public profile.</p>
      <Button type="submit" className="full-width" disabled={sending}>
        {sending ? "Sending…" : "Send application"}
      </Button>
    </form>
  )
}

export function OpportunityDetail() {
  const app = useApp()
  const op = OPPORTUNITIES.find((o) => o.id === app.state.opportunity)
  return (
    <div className="screen">
      <TopBar title="Opportunity" back fallback="organizer" />
      {!op ? (
        <main className="padded inbox-state">
          <b>This role is no longer open</b>
          <Button onClick={() => app.back("organizer")}>Back to profile</Button>
        </main>
      ) : (
        <main className="padded op-detail">
          <span className="ev-demo">EONICS MUSIC · HIRING</span>
          <h1 className="ev-title">{op.role}</h1>
          <div className="ev-facts">
            <div>
              <small>Event</small>
              <b>{op.event}</b>
            </div>
            <div>
              <small>Date</small>
              <b>{op.date}</b>
            </div>
            <div>
              <small>Hours</small>
              <b>{op.hours}</b>
            </div>
            <div>
              <small>Pay</small>
              <b>{op.pay || "Discussed after applying"}</b>
            </div>
          </div>
          <h2 className="ev-h2">Requirements</h2>
          <ul className="op-reqs">
            {op.requirements.map((r) => (
              <li key={r}>
                <Icon name="check" size={15} /> {r}
              </li>
            ))}
          </ul>
          <h2 className="ev-h2">How to apply</h2>
          <p className="vv-about">Send a short note and a link to your work. EONICS replies through your BottlesUp inbox. Applications are private.</p>
          <div className="sticky-action ev-bar">
            <div>
              <small>{op.event}</small>
              <b>{op.role}</b>
            </div>
            <Button onClick={() => app.openSheet({ title: `Apply · ${op.role}`, eyebrow: "PRIVATE APPLICATION", body: (close) => <ApplyBody op={op} close={close} /> })}>Apply</Button>
          </div>
        </main>
      )}
    </div>
  )
}

export function OrgMedia() {
  const [tab, setTab] = useState<"all" | "photos" | "videos">("all")
  const [idx, setIdx] = useState<number | null>(null)
  const [ready, setReady] = useState(false)
  useEffect(() => {
    const t = window.setTimeout(() => setReady(true), 350)
    return () => window.clearTimeout(t)
  }, [])
  const list = POSTS.filter((p) => (tab === "all" ? true : tab === "videos" ? p.reel : !p.reel))
  return (
    <div className="screen">
      <TopBar title="Photos & Videos" back fallback="organizer" />
      <main className="padded om-page">
        <div className="inbox-tabs" role="tablist">
          {(["all", "photos", "videos"] as const).map((t) => (
            <button key={t} role="tab" aria-selected={tab === t} className={tab === t ? "active" : ""} onClick={() => setTab(t)}>
              {t === "all" ? "All" : t === "photos" ? "Photos" : "Videos"}
            </button>
          ))}
        </div>
        {!ready ? (
          <div className="om-grid" aria-busy="true">
            {Array.from({ length: 9 }, (_, i) => (
              <span key={i} className="om-skel" />
            ))}
          </div>
        ) : list.length === 0 ? (
          <div className="inbox-state">
            <b>No {tab} yet</b>
            <small>New recaps appear here after each event.</small>
          </div>
        ) : (
          <div className="om-grid">
            {list.map((p, i) => (
              <button key={p.id} onClick={() => setIdx(i)} aria-label={`Open ${p.reel ? "video" : "photo"}: ${p.caption}`}>
                <img src={p.image} alt="" />
                {p.reel && (
                  <span className="reel-badge" aria-hidden="true">
                    <Icon name="play" size={12} filled />
                  </span>
                )}
              </button>
            ))}
          </div>
        )}
      </main>
      {idx !== null && list[idx] && (
        <PostViewer post={list[idx]} onClose={() => setIdx(null)} onPrev={idx > 0 ? () => setIdx(idx - 1) : undefined} onNext={idx < list.length - 1 ? () => setIdx(idx + 1) : undefined} />
      )}
    </div>
  )
}

export function OrganizerProfile() {
  const app = useApp()
  const following = app.state.following.includes("eonics")
  const [story, setStory] = useState<number | null>(null)
  const [seen, setSeen] = useState<number[]>([])
  const [postIdx, setPostIdx] = useState<number | null>(null)
  const [bioOpen, setBioOpen] = useState(false)
  const preview = POSTS.slice(0, 6)
  const openStory = (i: number) => {
    setStory(i)
    setSeen((s) => (s.includes(i) ? s : [...s, i]))
  }
  const bookTable = () => {
    app.update({ tableId: "halo", dateId: "aug24" })
    app.go("table")
  }
  const [featured, ...later] = EVENTS_LIST
  return (
    <div className="screen">
      <TopBar title="eonicsmusic" back fallback="event" action={<ShareButton what="EONICS Music" />} />
      <main className="padded org-page org-v3">
        {/* 1. Identity */}
        <div className="o3-id">
          <button className="org-head-avatar" aria-label="Watch Afterglow recap" onClick={() => openStory(0)}>
            <Avatar src={media.dj} label="EONICS Music" story={!seen.includes(0)} />
          </button>
          <div>
            <div className="profile-name">
              EONICS Music{" "}
              <span className="verified" aria-label="Verified organizer">
                <Icon name="check" size={11} />
              </span>
            </div>
            <span className="org-category">Event organizer · Toronto</span>
          </div>
        </div>
        {/* 2. Stats */}
        <div className="o3-stats">
          <div>
            <b>48.2K</b>
            <span>Likes</span>
          </div>
          <div>
            <b>{following ? "12.9K" : "12.8K"}</b>
            <span>Followers</span>
          </div>
          <div>
            <b>214</b>
            <span>Following</span>
          </div>
        </div>
        {/* 3. Bio */}
        <p className="o3-bio">
          Afro house and late-night sound. Monthly Afterglow nights at Nova Room since 2021.
          {bioOpen && " Ticketing and tables through BottlesUp. Booking and press: message us. We work with local artists, photographers and hosts every month."}{" "}
          <button className="inline-more" onClick={() => setBioOpen(!bioOpen)}>
            {bioOpen ? "Show less" : "Read more"}
          </button>
        </p>
        <button className="org-linkline" onClick={() => app.share("eonicsmusic.com")}>
          <Icon name="link" size={14} /> eonicsmusic.com
        </button>
        {/* 4. Recaps then actions */}
        <div className="highlights o3-recaps" aria-label="Recap highlights">
          {HIGHLIGHTS.map((hl, i) => (
            <button key={hl.name} onClick={() => openStory(i)} className={seen.includes(i) ? "seen" : ""}>
              <span>
                <img src={hl.cover} alt="" />
              </span>
              {hl.name}
            </button>
          ))}
        </div>
        <div className="o3-actions">
          <button className={following ? "" : "primary"} aria-pressed={following} onClick={() => app.toggleIn("following", "eonics", "EONICS Music")}>
            {following ? "Following" : "Follow"}
          </button>
          <button onClick={() => app.openThread("eonics")}>Message</button>
          <button onClick={() => app.share("EONICS Music")}>Share</button>
        </div>
        <small className="demo-stats left">Demo profile · sample numbers</small>

        {/* 5. Featured event */}
        <article className="org-featured">
          <button className="org-featured-img" onClick={() => app.go("event")} aria-label={`Open ${featured.title}`}>
            <img src={featured.image} alt={`${featured.title} flyer`} />
            <span>NEXT EVENT</span>
          </button>
          <div className="org-featured-body">
            <b>{featured.title}</b>
            <small>
              {featured.label} · {featured.date} · {featured.place}
            </small>
            <small>Tickets from $35 · tables from $150 deposit</small>
            <div className="org-featured-actions">
              <Button onClick={() => app.go("event")}>Book Tickets</Button>
              <Button variant="secondary" onClick={bookTable}>
                Book a Table
              </Button>
            </div>
          </div>
        </article>

        {/* 6. Upcoming */}
        <section className="vv-section">
          <h2>Upcoming events</h2>
          <div className="vv-list">
            {later.map((e) => (
              <div className="vv-event" key={e.title}>
                <img src={e.image} alt="" />
                <span>
                  <em>{e.label}</em>
                  <b>{e.title}</b>
                  <small>
                    {e.date} · {e.place}
                  </small>
                </span>
                <button className="org-notify" onClick={() => app.toast("You'll get an alert when tickets go on sale")}>
                  Notify me
                </button>
              </div>
            ))}
          </div>
        </section>

        {/* 7. Photos & Videos */}
        <section className="vv-section">
          <div className="o3-head">
            <h2>Photos & Videos</h2>
            <button onClick={() => app.go("orgmedia")}>View all</button>
          </div>
          <div className="o3-media">
            {preview.map((p, i) => (
              <button key={p.id} onClick={() => setPostIdx(i)} aria-label={`Open ${p.reel ? "video" : "photo"}: ${p.caption}`}>
                <img src={p.image} alt="" />
                {p.reel && (
                  <span className="reel-badge" aria-hidden="true">
                    <Icon name="play" size={11} filled />
                  </span>
                )}
              </button>
            ))}
          </div>
        </section>

        {/* 8. Reviews */}
        <section className="vv-section" id="org-reviews">
          <h2>Rating & Reviews</h2>
          {reviews.length === 0 ? (
            <p className="org-sub">No reviews yet.</p>
          ) : (
            <>
              <div className="vv-rating">
                <strong>4.8</strong>
                <span>
                  <b>214 eligible reviews</b>
                  <small>Only guests with a scanned ticket can review · demo data</small>
                </span>
              </div>
              {reviews.slice(0, 2).map((r) => (
                <div className="org-review" key={r.name}>
                  <div>
                    <b>{r.name}</b>
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
            </>
          )}
        </section>

        {/* 9. Hiring */}
        <section className="vv-section">
          <h2>Hiring opportunities</h2>
          <div className="vv-list">
            {OPPORTUNITIES.map((op) => (
              <div key={op.id} className="vv-event o3-op">
                <button
                  className="o3-op-main"
                  onClick={() => {
                    app.update({ opportunity: op.id })
                    app.go("opportunity")
                  }}
                >
                  <b>{op.role}</b>
                  <small>
                    {op.event} · {op.date}
                    {op.pay ? ` · ${op.pay}` : ""}
                  </small>
                </button>
                <button className="org-apply" onClick={() => app.openSheet({ title: `Apply · ${op.role}`, eyebrow: "PRIVATE APPLICATION", body: (close) => <ApplyBody op={op} close={close} /> })}>
                  Apply
                </button>
              </div>
            ))}
          </div>
        </section>

        <button className="text-link center" onClick={() => app.toast("Report sent. Our safety team will review this organizer.")}>
          Report this organizer
        </button>
      </main>
      {story !== null && <StoryViewer index={story} onClose={() => setStory(null)} />}
      {postIdx !== null && (
        <PostViewer
          post={preview[postIdx]}
          onClose={() => setPostIdx(null)}
          onPrev={postIdx > 0 ? () => setPostIdx(postIdx - 1) : undefined}
          onNext={postIdx < preview.length - 1 ? () => setPostIdx(postIdx + 1) : undefined}
        />
      )}
    </div>
  )
}
