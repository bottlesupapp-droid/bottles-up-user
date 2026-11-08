import { useRef, useState, type PointerEvent as RPointerEvent } from "react"
import { media } from "../data"
import { useApp, type Screen } from "../store"
import { Avatar, Button, CommentsBody, Icon, TopBar, useMoreMenu } from "../ui"
import { useOpenFeed } from "./Feed"

/* Feed posts: like, comment, repost, share, save, plus a full post detail view.
   Reposts respect the creator's setting and the original audience: Members Only
   and private posts can never be reposted to a wider audience. Demo content. */

export type FeedPost = {
  id: string
  handle: string
  name: string
  avatar: string
  place: string
  image: string
  alt: string
  caption: string
  mentions: string
  likes: number
  audience: "Public" | "Members Only"
  allowRepost: boolean
  event?: string
  profile: Screen
  cta?: boolean
  when: string
}

export const FEED: FeedPost[] = [
  {
    id: "post-eonics",
    handle: "eonicsmusic",
    name: "EONICS Music",
    avatar: media.dj,
    place: "Nova Room, Toronto",
    image: media.hero,
    alt: "Crowd dancing under warm lights at EONICS",
    caption: "Toronto, you were electric. We're back at Nova Room this Saturday.",
    mentions: "@novaroomto · #EONICS #Afterglow",
    likes: 2848,
    audience: "Public",
    allowRepost: true,
    event: "EONICS: Afterglow",
    profile: "organizer",
    cta: true,
    when: "2h",
  },
  {
    id: "post-maya",
    handle: "maya.chen",
    name: "Maya Chen",
    avatar: media.friends,
    place: "King West, Toronto",
    image: media.friends,
    alt: "Friends smiling at a table",
    caption: "Saturday crew is undefeated. Members, see you at the booth.",
    mentions: "@jordanafterdark · #SaturdayCrew",
    likes: 312,
    audience: "Members Only",
    allowRepost: false,
    profile: "explore",
    when: "5h",
  },
  {
    id: "post-amara",
    handle: "amaravale",
    name: "Amara Vale",
    avatar: media.pro,
    place: "Sky Room, Toronto",
    image: media.stage,
    alt: "DJ booth under purple lights",
    caption: "New mix out Friday. Two hours of deep Afro house.",
    mentions: "@skyroomto · #AmapianoSunset",
    likes: 1290,
    audience: "Public",
    allowRepost: false,
    profile: "professional",
    when: "1d",
  },
]

const LIKERS = [
  { name: "Maya Chen", handle: "maya.chen", image: media.friends },
  { name: "Noah Reid", handle: "noahreid", image: media.dj },
  { name: "Sofia Bell", handle: "sofiabell", image: media.crowd },
  { name: "Amara Vale", handle: "amaravale", image: media.pro },
  { name: "Eli James", handle: "elijames", image: media.photographer },
  { name: "Nova Room", handle: "novaroomto", image: media.venue },
]

const SEED_COMMENTS: Record<string, { who: string; text: string }[]> = {
  "post-eonics": [
    { who: "maya.chen", text: "Saturday can't come soon enough 🔥" },
    { who: "noahreid", text: "That drop at 1 AM though." },
  ],
  "post-amara": [{ who: "sofiabell", text: "Need this for the drive home." }],
}

export const commentTotal = (comments: Record<string, unknown[]>, id: string) => (SEED_COMMENTS[id]?.length ?? 0) + (comments[id]?.length ?? 0)

/** Why a post can't be reposted, or null if it can. */
export const repostBlock = (p: FeedPost) => (p.audience !== "Public" ? `${p.audience} posts can't be reposted` : !p.allowRepost ? `@${p.handle} turned off reposts` : null)

export function usePostActions(p: FeedPost) {
  const app = useApp()
  const liked = app.state.liked.includes(p.id)
  const reposted = app.state.postReposts.includes(p.id)
  const blocked = repostBlock(p)
  const repost = () => {
    if (blocked) return app.toast(blocked)
    app.update((s) => ({ postReposts: reposted ? s.postReposts.filter((x) => x !== p.id) : [p.id, ...s.postReposts] }))
    app.toast(reposted ? "Repost removed" : `Reposted to your profile · credited to @${p.handle}`)
  }
  const likes = () => app.openSheet({ title: "Likes", eyebrow: `${(p.likes + (liked ? 1 : 0)).toLocaleString("en-CA")} LIKES`, body: () => <LikesList post={p} /> })
  const comments = () => app.openSheet({ title: "Comments", eyebrow: `@${p.handle.toUpperCase()}`, body: () => <PostComments id={p.id} /> })
  return { liked, reposted, blocked, repost, likes, comments, like: () => app.toggleIn("liked", p.id) }
}

function LikesList({ post }: { post: FeedPost }) {
  const app = useApp()
  const liked = app.state.liked.includes(post.id)
  const list = liked ? [{ name: app.state.profile.name, handle: app.state.profile.handle, image: media.friends }, ...LIKERS] : LIKERS
  return (
    <div className="likes-list">
      {list.map((l) => (
        <div key={l.handle} className="like-row">
          <Avatar src={l.image} label={l.name} />
          <span>
            <b>{l.handle}</b>
            <small>{l.name}</small>
          </span>
        </div>
      ))}
      <p className="list-count">
        and {(post.likes - LIKERS.length).toLocaleString("en-CA")} others · demo data
      </p>
    </div>
  )
}

export function PostComments({ id }: { id: string }) {
  const seed = SEED_COMMENTS[id] ?? []
  return (
    <>
      {seed.length > 0 && (
        <div className="comment-list seed">
          {seed.map((c) => (
            <p key={c.text}>
              <b>{c.who}</b> {c.text}
            </p>
          ))}
        </div>
      )}
      <CommentsBody postId={id} />
    </>
  )
}

function ActionRow({ p, onComments }: { p: FeedPost; onComments: () => void }) {
  const app = useApp()
  const a = usePostActions(p)
  const saved = app.state.saved.includes(p.id)
  return (
    <div className="post-actions">
      <div>
        <button className={a.liked ? "active icon-btn" : "icon-btn"} aria-label={a.liked ? "Unlike" : "Like"} aria-pressed={a.liked} onClick={a.like}>
          <Icon name="heart" filled={a.liked} />
        </button>
        <button className="icon-btn" aria-label="Comments" onClick={onComments}>
          <Icon name="comment" />
        </button>
        <button
          className={`icon-btn repost-btn ${a.reposted ? "active" : ""} ${a.blocked ? "blocked" : ""}`}
          aria-label={a.blocked ? `Repost unavailable: ${a.blocked}` : a.reposted ? "Undo repost" : "Repost"}
          aria-pressed={a.reposted}
          aria-disabled={!!a.blocked}
          onClick={a.repost}
        >
          <Icon name="repost" />
        </button>
        <button className="icon-btn" aria-label="Share post" onClick={() => app.share(`@${p.handle} post`)}>
          <Icon name="send" />
        </button>
      </div>
      <button className={saved ? "active icon-btn" : "icon-btn"} aria-label={saved ? "Remove from saved" : "Save post"} aria-pressed={saved} onClick={() => app.toggleIn("saved", p.id, "Post")}>
        <Icon name="bookmark" filled={saved} />
      </button>
    </div>
  )
}

export function PostCard({ p }: { p: FeedPost }) {
  const app = useApp()
  const more = useMoreMenu()
  const a = usePostActions(p)
  const count = commentTotal(app.state.comments, p.id)
  const openFeed = useOpenFeed()
  const open = () => openFeed(p.id === "post-eonics" ? "eonics" : p.id === "post-maya" ? "maya" : "amara", 0)
  return (
    <article className="post">
      {a.reposted && (
        <span className="repost-note">
          <Icon name="repost" size={13} /> You reposted
        </span>
      )}
      <div className="post-head">
        <button className="profile-line plain" onClick={() => app.go(p.profile)} aria-label={`View ${p.name}`}>
          <Avatar src={p.avatar} label={p.name} />
          <span>
            <b>{p.handle}</b>
            <small>
              <Icon name="map" size={12} /> {p.place}
            </small>
          </span>
        </button>
        {p.audience === "Members Only" && <span className="members-chip">Members</span>}
        <button className="icon-btn" aria-label="More options" onClick={() => more(`@${p.handle} post`)}>
          <span className="dots">•••</span>
        </button>
      </div>
      <button className="post-media" aria-label={`Open post by ${p.handle}`} onClick={open}>
        <img src={p.image} alt={p.alt} />
        <span className="demo-label">DEMO CONTENT</span>
        {p.event && (
          <span className="event-tag">
            <Icon name="calendar" size={14} /> {p.event.toUpperCase()}
          </span>
        )}
      </button>
      <div className="post-body pb2">
        <ActionRow p={p} onComments={a.comments} />
        <button className="pb2-likes" onClick={a.likes}>
          {(p.likes + (a.liked ? 1 : 0)).toLocaleString("en-CA")} likes
        </button>
        <p className="pb2-caption">
          <b>{p.handle}</b> {p.caption}
        </p>
        <button className="pb2-mentions" onClick={() => app.go(p.event ? "venue" : p.profile)}>
          {p.mentions}
        </button>
        {count > 0 ? (
          <button className="pb2-view" onClick={a.comments}>
            View {count === 1 ? "1 comment" : `all ${count} comments`}
          </button>
        ) : (
          <button className="pb2-view" onClick={a.comments}>
            Add a comment
          </button>
        )}
        <small className="pb2-when">{p.when} ago</small>
        {p.cta && (
          <div className="inline-actions">
            <Button variant="secondary" onClick={() => app.go("event")}>
              View event
            </Button>
            <Button
              onClick={() => {
                app.update({ tableId: "halo", dateId: "aug24" })
                app.go("table")
              }}
            >
              Book a table
            </Button>
          </div>
        )}
      </div>
    </article>
  )
}

export function PostDetail() {
  const app = useApp()
  const p = FEED.find((x) => x.id === app.state.activePost)
  const [panel, setPanel] = useState<null | "likes" | "comments">(null)
  const start = useRef<number | null>(null)
  if (!p)
    return (
      <div className="screen">
        <TopBar title="Post" back />
        <main className="padded inbox-state">
          <b>This post isn't available</b>
          <small>It may have been removed or its audience changed.</small>
        </main>
      </div>
    )
  const a = { liked: app.state.liked.includes(p.id), reposted: app.state.postReposts.includes(p.id) }
  const count = commentTotal(app.state.comments, p.id)
  const onDown = (e: RPointerEvent) => {
    start.current = e.clientY
    // Keep receiving moves after the finger leaves the dock, but not when a button was pressed.
    if (!(e.target as HTMLElement).closest("button")) (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId)
  }
  const onMove = (e: RPointerEvent) => {
    if (start.current !== null && start.current - e.clientY > 40) {
      start.current = null
      setPanel("comments")
    }
  }
  return (
    <div className="screen pd-screen">
      <TopBar title="Post" back />
      <main className="pd-main">
        <div className="post-head padded-x">
          <button className="profile-line plain" onClick={() => app.go(p.profile)}>
            <Avatar src={p.avatar} label={p.name} />
            <span>
              <b>{p.handle}</b>
              <small>
                <Icon name="map" size={12} /> {p.place}
              </small>
            </span>
          </button>
          {p.audience === "Members Only" && <span className="members-chip">Members</span>}
        </div>
        <img className="pd-media" src={p.image} alt={p.alt} />
        <div className="padded pd-text">
          {a.reposted && (
            <span className="repost-note">
              <Icon name="repost" size={13} /> You reposted · original by @{p.handle}
            </span>
          )}
          <p className="pb2-caption">
            <b>{p.handle}</b> {p.caption}
          </p>
          <button className="pb2-mentions" onClick={() => app.go(p.event ? "venue" : p.profile)}>
            {p.mentions}
          </button>
          {p.event && (
            <button className="pd-tag" onClick={() => app.go("event")}>
              <Icon name="calendar" size={14} /> {p.event} · {p.place}
            </button>
          )}
          <small className="pb2-when">{p.when} ago · {p.audience}</small>
        </div>
      </main>
      <div className="pd-dock" onPointerDown={onDown} onPointerMove={onMove} onPointerUp={() => (start.current = null)}>
        <button className="pd-grab" aria-label="Show likes and comments" onClick={() => setPanel("comments")}>
          <i />
          <span>Swipe up or tap for likes and comments</span>
        </button>
        <ActionRow p={p} onComments={() => setPanel("comments")} />
        <div className="pd-counts">
          <button onClick={() => setPanel("likes")}>{(p.likes + (a.liked ? 1 : 0)).toLocaleString("en-CA")} likes</button>
          <button onClick={() => setPanel("comments")}>{count} comments</button>
        </div>
      </div>
      {panel && (
        <div className="pd-sheet-wrap" onClick={() => setPanel(null)}>
          <div className="pd-sheet" role="dialog" aria-modal="true" aria-label="Likes and comments" onClick={(e) => e.stopPropagation()}>
            <div className="pd-sheet-head">
              <div className="inbox-tabs" role="tablist">
                <button role="tab" aria-selected={panel === "likes"} className={panel === "likes" ? "active" : ""} onClick={() => setPanel("likes")}>
                  Likes
                </button>
                <button role="tab" aria-selected={panel === "comments"} className={panel === "comments" ? "active" : ""} onClick={() => setPanel("comments")}>
                  Comments
                </button>
              </div>
              <button className="icon-btn" aria-label="Close" onClick={() => setPanel(null)}>
                <Icon name="close" />
              </button>
            </div>
            <div className="pd-sheet-body">{panel === "likes" ? <LikesList post={p} /> : <PostComments id={p.id} />}</div>
          </div>
        </div>
      )}
    </div>
  )
}

