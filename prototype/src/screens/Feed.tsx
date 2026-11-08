import { useEffect, useRef, useState } from "react"
import { media } from "../data"
import { nowTime, useApp, type Screen } from "../store"
import { Avatar, Icon } from "../ui"
import { POSTS as EONICS_POSTS } from "./Organizer"

/* Night Feed: a full-screen post viewer. Scroll down through one profile's posts;
   swipe sideways to the next profile. Each post shows likes, caption, tags,
   the latest comments, an inline comment box and "Who was there". Demo content. */

type FPost = { id: string; image: string; caption: string; likes: number; when: string; event?: string; place: string; members?: boolean; reel?: boolean; canRepost: boolean; there: string[] }
type FProfile = { id: string; handle: string; name: string; avatar: string; screen: Screen; posts: FPost[] }

const FRIENDS: Record<string, string> = { Maya: media.friends, Noah: media.dj, Sofia: media.crowd, Eli: media.photographer, Priya: media.pro }
const SEED: Record<string, { who: string; text: string }[]> = {
  op1: [
    { who: "maya.chen", text: "Saturday can't come soon enough" },
    { who: "noahreid", text: "Booth booked 🙌" },
  ],
  "me-0": [{ who: "maya.chen", text: "Best night of the summer" }],
  "maya-0": [{ who: "jordanafterdark", text: "Undefeated crew" }],
}
const MY_CAPTIONS = ["Saturday at Nova. Halo Booth views.", "Afterglow crowd was unreal.", "Members night, as always.", "Shot on the rooftop.", "Golden hour before doors.", "Back to King West."]

export function useFeedProfiles(): FProfile[] {
  const app = useApp()
  const me: FProfile = {
    id: "me",
    handle: app.state.profile.handle,
    name: app.state.profile.name,
    avatar: media.friends,
    screen: "profile",
    posts: app.state.posts.map((p, i) => ({
      id: "me-" + i,
      image: p.image,
      caption: MY_CAPTIONS[i % MY_CAPTIONS.length],
      likes: 120 + ((i * 37) % 180),
      when: `${i + 1}d`,
      place: "Toronto",
      members: p.members,
      reel: p.reel,
      canRepost: false,
      there: ["Maya", "Noah"].slice(0, 1 + (i % 2)),
    })),
  }
  const eonics: FProfile = {
    id: "eonics",
    handle: "eonicsmusic",
    name: "EONICS Music",
    avatar: media.dj,
    screen: "organizer",
    posts: EONICS_POSTS.map((p, i) => ({ id: p.id, image: p.image, caption: p.caption, likes: p.likes, when: p.when, event: p.event, place: "Nova Room, Toronto", reel: p.reel, canRepost: true, there: i % 2 ? ["Sofia"] : ["Maya", "Noah", "Eli"] })),
  }
  const maya: FProfile = {
    id: "maya",
    handle: "maya.chen",
    name: "Maya Chen",
    avatar: media.friends,
    screen: "explore",
    posts: [
      { id: "maya-0", image: media.friends, caption: "Saturday crew is undefeated.", likes: 312, when: "5h", place: "King West, Toronto", members: true, canRepost: false, there: ["Noah", "Sofia"] },
      { id: "maya-1", image: media.table, caption: "Halo Booth, round two.", likes: 204, when: "1w", place: "Nova Room, Toronto", event: "EONICS: Afterglow", canRepost: true, there: ["Priya"] },
    ],
  }
  const amara: FProfile = {
    id: "amara",
    handle: "amaravale",
    name: "Amara Vale",
    avatar: media.pro,
    screen: "professional",
    posts: [
      { id: "amara-0", image: media.stage, caption: "New mix out Friday. Two hours of deep Afro house.", likes: 1290, when: "1d", place: "Sky Room, Toronto", canRepost: false, there: ["Eli"] },
      { id: "amara-1", image: media.dj, caption: "Warm-up set at Nova Room.", likes: 860, when: "6d", place: "Nova Room, Toronto", canRepost: true, there: ["Maya", "Sofia"] },
    ],
  }
  return [me, eonics, maya, amara].filter((p) => p.posts.length)
}

/** Open the feed at a profile and post. */
export function useOpenFeed() {
  const app = useApp()
  return (profile: string, index = 0) => {
    app.update({ viewerProfile: profile, viewerIndex: index })
    app.go("feed")
  }
}

function FeedPost({ p, owner }: { p: FPost; owner: FProfile }) {
  const app = useApp()
  const liked = app.state.liked.includes(p.id)
  const saved = app.state.saved.includes(p.id)
  const reposted = app.state.postReposts.includes(p.id)
  const [draft, setDraft] = useState("")
  const [burst, setBurst] = useState(false)
  const mine = app.state.comments[p.id] ?? []
  const all = [...(SEED[p.id] ?? []), ...mine.map((c) => ({ who: c.who ?? "you", text: c.text }))]
  const like = () => app.toggleIn("liked", p.id)
  const add = () => {
    const text = draft.trim()
    if (!text) return
    app.update((s) => ({ comments: { ...s.comments, [p.id]: [...(s.comments[p.id] ?? []), { from: "me", who: s.profile.handle, text, time: nowTime() }] } }))
    setDraft("")
  }
  const repost = () => {
    if (owner.id === "me") return app.toast("This is your own post")
    if (p.members) return app.toast("Members Only posts can't be reposted")
    if (!p.canRepost) return app.toast(`@${owner.handle} turned off reposts`)
    app.update((s) => ({ postReposts: reposted ? s.postReposts.filter((x) => x !== p.id) : [p.id, ...s.postReposts] }))
    app.toast(reposted ? "Repost removed" : `Reposted · credited to @${owner.handle}`)
  }
  return (
    <article className="nf-post" aria-label={`Post by ${owner.handle}`}>
      <div className="nf-head">
        <button className="nf-who" onClick={() => app.go(owner.screen)}>
          <Avatar src={owner.avatar} label={owner.name} />
          <span>
            <b>{owner.handle}</b>
            <small>
              <Icon name="map" size={11} /> {p.place}
            </small>
          </span>
        </button>
        {p.members && <span className="members-chip">Members</span>}
      </div>
      <div
        className="nf-media"
        onDoubleClick={() => {
          if (!liked) like()
          setBurst(true)
          window.setTimeout(() => setBurst(false), 700)
        }}
      >
        <img src={p.image} alt={p.caption} />
        {p.reel && (
          <button className="nf-play" aria-label="Play reel" onClick={() => app.go("reel")}>
            <Icon name="play" filled />
          </button>
        )}
        {burst && (
          <span className="like-burst" aria-hidden="true">
            <Icon name="heart" filled size={80} />
          </span>
        )}
      </div>
      <div className="nf-body">
        <div className="post-actions">
          <div>
            <button className={liked ? "active icon-btn" : "icon-btn"} aria-label={liked ? "Unlike" : "Like"} aria-pressed={liked} onClick={like}>
              <Icon name="heart" filled={liked} />
            </button>
            <button className="icon-btn" aria-label="Comment" onClick={() => document.getElementById(`nf-c-${p.id}`)?.focus()}>
              <Icon name="comment" />
            </button>
            <button className={`icon-btn repost-btn ${reposted ? "active" : ""} ${owner.id === "me" || p.members || !p.canRepost ? "blocked" : ""}`} aria-label={reposted ? "Undo repost" : "Repost"} aria-pressed={reposted} onClick={repost}>
              <Icon name="repost" />
            </button>
            <button className="icon-btn" aria-label="Share post" onClick={() => app.share(`@${owner.handle} post`)}>
              <Icon name="send" />
            </button>
          </div>
          <button className={saved ? "active icon-btn" : "icon-btn"} aria-label={saved ? "Remove from saved" : "Save post"} aria-pressed={saved} onClick={() => app.toggleIn("saved", p.id, "Post")}>
            <Icon name="bookmark" filled={saved} />
          </button>
        </div>
        <b className="nf-likes">{(p.likes + (liked ? 1 : 0)).toLocaleString("en-CA")} likes</b>
        <p className="nf-caption">
          <b>{owner.handle}</b> {p.caption}
        </p>
        {p.event && (
          <button className="pd-tag" onClick={() => app.go("event")}>
            <Icon name="calendar" size={13} /> {p.event}
          </button>
        )}
        {p.there.length > 0 && (
          <button className="nf-there" onClick={() => app.go(p.event ? "event" : "venue")}>
            <span className="nf-faces">
              {p.there.map((n) => (
                <img key={n} src={FRIENDS[n]} alt="" />
              ))}
            </span>
            <span>
              <b>{p.there.join(", ")}</b> {p.there.length === 1 ? "was" : "were"} there
            </span>
          </button>
        )}
        <div className="nf-comments">
          {all.length === 0 ? (
            <small className="nf-muted">No comments yet. Be the first.</small>
          ) : (
            all.slice(-3).map((c, i) => (
              <p key={i}>
                <b>{c.who}</b> {c.text}
              </p>
            ))
          )}
          {all.length > 3 && <small className="nf-muted">{all.length - 3} earlier comments</small>}
        </div>
        <form
          className="nf-compose"
          onSubmit={(e) => {
            e.preventDefault()
            add()
          }}
        >
          <Avatar src={media.friends} label="You" />
          <input id={`nf-c-${p.id}`} value={draft} onChange={(e) => setDraft(e.target.value)} placeholder="Add a comment…" aria-label={`Comment on ${owner.handle}'s post`} />
          <button type="submit" disabled={!draft.trim()}>
            Post
          </button>
        </form>
        <small className="nf-muted">{p.when} ago</small>
      </div>
    </article>
  )
}

export function Feed() {
  const app = useApp()
  const profiles = useFeedProfiles()
  const start = Math.max(0, profiles.findIndex((p) => p.id === app.state.viewerProfile))
  const [active, setActive] = useState(start)
  const track = useRef<HTMLDivElement>(null)
  const panels = useRef<(HTMLDivElement | null)[]>([])
  useEffect(() => {
    const t = track.current
    if (t) t.scrollTo({ left: start * t.clientWidth })
    const target = panels.current[start]?.querySelectorAll(".nf-post")[app.state.viewerIndex] as HTMLElement | undefined
    const panel = panels.current[start]
    if (target && panel) panel.scrollTop += target.getBoundingClientRect().top - panel.getBoundingClientRect().top
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])
  const goTo = (i: number) => {
    const t = track.current
    if (!t) return
    t.scrollTo({ left: i * t.clientWidth, behavior: "smooth" })
  }
  return (
    <div className="screen nf-screen">
      <div className="nf-top">
        <button className="icon-btn" aria-label="Go back" onClick={() => app.back("home")}>
          <Icon name="back" />
        </button>
        <div className="nf-strip" role="tablist" aria-label="Profiles">
          {profiles.map((p, i) => (
            <button key={p.id} role="tab" aria-selected={i === active} aria-label={`${p.handle} posts`} className={i === active ? "on" : ""} onClick={() => goTo(i)}>
              <img src={p.avatar} alt="" />
            </button>
          ))}
        </div>
        <span className="nf-title">
          {profiles[active]?.id === "me" ? "Your posts" : `@${profiles[active]?.handle}`}
          {active < profiles.length - 1 && <em> · swipe for next profile</em>}
        </span>
      </div>
      <div
        className="nf-track"
        ref={track}
        onScroll={(e) => {
          const t = e.currentTarget
          const i = Math.round(t.scrollLeft / t.clientWidth)
          if (i !== active) {
            setActive(i)
            app.update({ viewerProfile: profiles[i].id, viewerIndex: 0 })
          }
        }}
      >
        {profiles.map((pr, i) => (
          <div className="nf-panel" key={pr.id} ref={(el) => void (panels.current[i] = el)} aria-label={`${pr.name} posts`}>
            {pr.posts.map((p) => (
              <FeedPost key={p.id} p={p} owner={pr} />
            ))}
            {i < profiles.length - 1 ? (
              <button className="nf-next" onClick={() => goTo(i + 1)}>
                Next: @{profiles[i + 1].handle} <Icon name="chevron" size={14} />
              </button>
            ) : (
              <p className="nf-end">You're all caught up</p>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
