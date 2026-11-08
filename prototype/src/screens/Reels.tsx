import { useEffect, useRef, useState } from "react"
import { media } from "../data"
import { useApp, type Screen } from "../store"
import { Avatar, Button, Icon, useComments } from "../ui"

export type ReelItem = {
  id: string
  handle: string
  name: string
  avatar: string
  image: string
  caption: string
  sound: string
  likes: number
  comments: number
  reposts: number
  shares: number
  followId: string
  cta?: { label: string; screen: Screen }
  place?: string
}

export const REELS: ReelItem[] = [
  { id: "reel-eonics", handle: "eonicsmusic", name: "EONICS Music", avatar: media.dj, image: media.crowd, caption: "One more night in Toronto. Meet us under the lights. #Afterglow", sound: "original sound · EONICS", likes: 18200, comments: 284, reposts: 1210, shares: 640, followId: "eonics", cta: { label: "View event", screen: "event" }, place: "Nova Room" },
  { id: "reel-amara", handle: "amaravale", name: "Amara Vale", avatar: media.pro, image: media.stage, caption: "That drop at 1:12 AM. Booking for fall is open.", sound: "Amapiano Sunset Vol. 3 · Amara Vale", likes: 9400, comments: 172, reposts: 830, shares: 410, followId: "amara", cta: { label: "Book Amara", screen: "professional" } },
  { id: "reel-nova", handle: "novaroomto", name: "Nova Room", avatar: media.venue, image: media.venue, caption: "Your booth is waiting. Halo Booth, upper level.", sound: "Deep Afro Sessions · Amara Vale", likes: 6100, comments: 88, reposts: 302, shares: 220, followId: "nova", cta: { label: "Book a table", screen: "table" }, place: "King West" },
  { id: "reel-maya", handle: "maya.chen", name: "Maya Chen", avatar: media.friends, image: media.friends, caption: "Saturday crew is undefeated. See you at Afterglow.", sound: "original sound · maya.chen", likes: 2350, comments: 64, reposts: 41, shares: 18, followId: "maya" },
  { id: "reel-midnight", handle: "midnightsocial", name: "Midnight Social", avatar: media.hero, image: media.hero, caption: "Neon Garden recap. Next one sells out fast.", sound: "Neon Garden mix · Midnight Social", likes: 12800, comments: 233, reposts: 990, shares: 520, followId: "midnight", cta: { label: "View event", screen: "event" } },
  { id: "reel-priya", handle: "lenspriya", name: "Priya Shah", avatar: media.photographer, image: media.dj, caption: "Behind the decks before doors. Shot on film.", sound: "original sound · lenspriya", likes: 4100, comments: 57, reposts: 120, shares: 66, followId: "priya" },
]

const fmt = (n: number) => (n >= 1000 ? `${(n / 1000).toFixed(n >= 10000 ? 0 : 1)}K` : String(n))

function RepostBody({ reel, onRepost, close }: { reel: ReelItem; onRepost: (note: string) => void; close: () => void }) {
  const [note, setNote] = useState("")
  return (
    <div className="repost-sheet">
      <div className="repost-preview">
        <img src={reel.image} alt="" />
        <span>
          <b>@{reel.handle}</b>
          <small>{reel.caption}</small>
        </span>
      </div>
      <label className="repost-note">
        <span>Add a thought (optional)</span>
        <input id={`repost-${reel.id}`} value={note} maxLength={120} onChange={(e) => setNote(e.target.value)} placeholder="Who's coming with me?" />
      </label>
      <Button
        className="full-width"
        icon="repost"
        onClick={() => {
          onRepost(note.trim())
          close()
        }}
      >
        Repost
      </Button>
      <p className="list-count">Reposts appear on your profile and in your followers' feeds.</p>
    </div>
  )
}

function ReelSlide({ reel, active, muted }: { reel: ReelItem; active: boolean; muted: boolean }) {
  const app = useApp()
  const openComments = useComments()
  const liked = app.state.liked.includes(reel.id)
  const saved = app.state.saved.includes(reel.id)
  const following = app.state.following.includes(reel.followId)
  const reposted = app.state.reposts.includes(reel.id)
  const [paused, setPaused] = useState(false)
  const [burst, setBurst] = useState(false)
  const lastTap = useRef(0)
  useEffect(() => {
    if (!active) setPaused(false)
  }, [active])
  const like = () => {
    if (!liked) app.toggleIn("liked", reel.id)
    setBurst(true)
    window.setTimeout(() => setBurst(false), 700)
  }
  const repost = () => {
    if (reposted) {
      app.update((s) => ({ reposts: s.reposts.filter((x) => x !== reel.id) }))
      app.toast("Repost removed")
      return
    }
    app.openSheet({
      title: "Repost",
      eyebrow: "SHARE TO YOUR FOLLOWERS",
      body: (close) => (
        <RepostBody
          reel={reel}
          close={close}
          onRepost={(note) => {
            app.update((s) => ({ reposts: [reel.id, ...s.reposts.filter((x) => x !== reel.id)] }))
            app.toast(note ? "Reposted with your thought" : "Reposted to your profile")
          }}
        />
      ),
    })
  }
  return (
    <section className={`reel-slide ${active && !paused ? "playing" : ""}`} aria-label={`Reel by ${reel.name}`}>
      <button
        className="reel-media"
        aria-label={paused ? "Play" : "Pause"}
        onClick={() => {
          const now = Date.now()
          if (now - lastTap.current < 300) like()
          else window.setTimeout(() => Date.now() - lastTap.current >= 300 && setPaused((p) => !p), 310)
          lastTap.current = now
        }}
      >
        <img src={reel.image} alt="" draggable={false} />
      </button>
      <div className="reel-shade" />
      {paused && (
        <span className="reel-paused" aria-hidden="true">
          <Icon name="play" filled size={34} />
        </span>
      )}
      {burst && (
        <span className="reel-burst" aria-hidden="true">
          <Icon name="heart" filled size={96} />
        </span>
      )}

      <div className="reel-rail">
        <button className="rail-avatar" aria-label={following ? `Unfollow ${reel.name}` : `Follow ${reel.name}`} onClick={() => app.toggleIn("following", reel.followId, reel.name)}>
          <Avatar src={reel.avatar} label={reel.name} />
          <i className={following ? "on" : ""}>{following ? <Icon name="check" size={11} /> : <Icon name="plus" size={11} />}</i>
        </button>
        <button className={liked ? "on" : ""} aria-pressed={liked} aria-label="Like" onClick={() => app.toggleIn("liked", reel.id)}>
          <Icon name="heart" filled={liked} size={30} />
          <small>{fmt(reel.likes + (liked ? 1 : 0))}</small>
        </button>
        <button aria-label="Comments" onClick={() => openComments(reel.id)}>
          <Icon name="comment" size={28} />
          <small>{fmt(reel.comments + (app.state.comments[reel.id]?.length ?? 0))}</small>
        </button>
        <button className={reposted ? "on repost" : "repost"} aria-pressed={reposted} aria-label={reposted ? "Remove repost" : "Repost"} onClick={repost}>
          <Icon name="repost" size={29} />
          <small>{fmt(reel.reposts + (reposted ? 1 : 0))}</small>
        </button>
        <button className={saved ? "on" : ""} aria-pressed={saved} aria-label="Save" onClick={() => app.toggleIn("saved", reel.id, "Reel")}>
          <Icon name="bookmark" filled={saved} size={27} />
          <small>{saved ? "Saved" : "Save"}</small>
        </button>
        <button aria-label="Share" onClick={() => app.share(`${reel.name} reel`)}>
          <Icon name="send" size={27} />
          <small>{fmt(reel.shares)}</small>
        </button>
      </div>

      <div className="reel-info">
        {reposted && (
          <span className="reel-reposted">
            <Icon name="repost" size={13} /> You reposted
          </span>
        )}
        <button className="reel-handle" onClick={() => app.go(reel.followId === "eonics" ? "organizer" : reel.followId === "amara" ? "professional" : reel.followId === "nova" ? "venue" : "explore")}>
          @{reel.handle}
          {reel.place && <small> · {reel.place}</small>}
        </button>
        <p>{reel.caption}</p>
        <span className="reel-sound">
          <Icon name="music" size={13} />
          <span className="reel-sound-text">
            <span>{reel.sound}</span>
          </span>
        </span>
        {reel.cta && (
          <button className="reel-cta" onClick={() => app.go(reel.cta!.screen)}>
            <Icon name="calendar" size={14} /> {reel.cta.label}
          </button>
        )}
      </div>
      <span className={`reel-disc ${active && !paused ? "spin" : ""}`} aria-hidden="true">
        <img src={reel.avatar} alt="" />
      </span>
      {muted && null}
    </section>
  )
}

export function Reels() {
  const app = useApp()
  const feed = useRef<HTMLDivElement>(null)
  const [tab, setTab] = useState<"following" | "foryou">("foryou")
  const [index, setIndex] = useState(app.state.reelStart ?? 0)
  const list = tab === "following" ? REELS.filter((r) => app.state.following.includes(r.followId)) : REELS
  useEffect(() => {
    const el = feed.current
    if (el) el.scrollTo({ top: (app.state.reelStart ?? 0) * el.clientHeight })
    if (app.state.reelStart) app.update({ reelStart: 0 })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])
  const firstTab = useRef(true)
  useEffect(() => {
    if (firstTab.current) {
      firstTab.current = false
      return
    }
    feed.current?.scrollTo({ top: 0 })
    setIndex(0)
  }, [tab])
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const el = feed.current
      if (!el) return
      if (e.key === "ArrowDown") el.scrollBy({ top: el.clientHeight, behavior: "smooth" })
      if (e.key === "ArrowUp") el.scrollBy({ top: -el.clientHeight, behavior: "smooth" })
    }
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  }, [])
  return (
    <div className="screen reels-screen">
      <div className="reels-top">
        <button className="reels-icon" aria-label="Back" onClick={() => app.back("home")}>
          <Icon name="back" size={22} />
        </button>
        <div className="reels-tabs" role="tablist">
          <button role="tab" aria-selected={tab === "following"} className={tab === "following" ? "on" : ""} onClick={() => setTab("following")}>
            Following
          </button>
          <button role="tab" aria-selected={tab === "foryou"} className={tab === "foryou" ? "on" : ""} onClick={() => setTab("foryou")}>
            For You
          </button>
        </div>
        <button className="reels-icon" aria-label="Search" onClick={() => app.go("explore")}>
          <Icon name="search" size={22} />
        </button>
      </div>
      <div
        className="reels-feed"
        ref={feed}
        onScroll={(e) => {
          const el = e.currentTarget
          const n = Math.round(el.scrollTop / el.clientHeight)
          if (n !== index) setIndex(n)
        }}
      >
        {list.length === 0 ? (
          <div className="reels-empty">
            <Icon name="users" size={30} />
            <b>Follow creators to fill this feed</b>
            <small>Tap the + on any reel to follow. Their new reels show up here.</small>
            <Button onClick={() => setTab("foryou")}>Browse For You</Button>
          </div>
        ) : (
          list.map((r, i) => <ReelSlide key={r.id} reel={r} active={i === index} muted />)
        )}
      </div>
    </div>
  )
}
