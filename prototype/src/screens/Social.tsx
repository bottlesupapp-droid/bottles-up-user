import { useEffect, useRef, useState } from "react"
import { dateById, friends, guestCounts, media, money, quote, tables } from "../data"
import { nowTime, useApp, type ComposeMode, type Screen } from "../store"
import { Avatar, Button, Icon, OptionList, TopBar, useComments, type IconName } from "../ui"

export function useCreateSheet() {
  const app = useApp()
  const start = (mode: ComposeMode, members = false) => {
    app.update({ composeMode: mode, composeMembers: members })
    app.go("composer")
  }
  return () =>
    app.openSheet({
      title: "Share the night.",
      eyebrow: "CREATE",
      body: (close) => (
        <>
          <div className="create-grid">
            {(
              [
                ["Post", "camera", "Photo or carousel"],
                ["Reel", "play", "Short video"],
                ["Story", "spark", "Share for 24 hours"],
                ["Update", "message", "Post a quick thought"],
              ] as [ComposeMode, IconName, string][]
            ).map(([mode, icon, detail]) => (
              <button
                key={mode}
                onClick={() => {
                  close()
                  start(mode)
                }}
              >
                <Icon name={icon} />
                <span>
                  <b>{mode}</b>
                  <small>{detail}</small>
                </span>
              </button>
            ))}
          </div>
          <button
            className="members-callout"
            onClick={() => {
              close()
              start("Post", true)
            }}
          >
            <span className="members-icon">
              <Icon name="spark" />
            </span>
            <span>
              <b>Members Only</b>
              <small>Share privately with your selected circle. Always free.</small>
            </span>
            <Icon name="chevron" />
          </button>
        </>
      ),
    })
}

export function Reel() {
  const app = useApp()
  const liked = app.state.liked.includes("reel-eonics")
  const saved = app.state.saved.includes("reel-eonics")
  const following = app.state.following.includes("eonics")
  const openComments = useComments()
  const create = useCreateSheet()
  const comments = 284 + (app.state.comments["reel-eonics"]?.length ?? 0)
  return (
    <div className="screen reel-screen">
      <img src={media.crowd} className="reel-bg" alt="EONICS live performance" />
      <div className="reel-gradient" />
      <div className="reel-top">
        <button aria-label="Go back" onClick={() => app.back("home")}>
          <Icon name="back" />
        </button>
        <b>Reels</b>
        <button aria-label="Create" onClick={create}>
          <Icon name="camera" />
        </button>
      </div>
      <div className="reel-side">
        <button aria-label={following ? "Unfollow EONICS" : "Follow EONICS"} onClick={() => app.toggleIn("following", "eonics", "EONICS")}>
          <Avatar src={media.dj} label="EONICS" />
          <i>{following ? "✓" : "+"}</i>
        </button>
        <button className={liked ? "active" : ""} aria-pressed={liked} aria-label="Like" onClick={() => app.toggleIn("liked", "reel-eonics")}>
          <Icon name="heart" filled={liked} />
          <small>{liked ? "18.3K" : "18.2K"}</small>
        </button>
        <button aria-label="Comments" onClick={() => openComments("reel-eonics")}>
          <Icon name="comment" />
          <small>{comments}</small>
        </button>
        <button aria-label="Share reel" onClick={() => app.share("EONICS reel")}>
          <Icon name="send" />
          <small>Share</small>
        </button>
        <button className={saved ? "active" : ""} aria-pressed={saved} aria-label="Save reel" onClick={() => app.toggleIn("saved", "reel-eonics", "Reel")}>
          <Icon name="bookmark" filled={saved} />
        </button>
      </div>
      <div className="reel-copy">
        <button className="reel-handle" onClick={() => app.go("organizer")}>
          @eonicsmusic
        </button>
        <p>One more night in Toronto. Meet us under the lights.</p>
        <button onClick={() => app.go("event")}>
          <Icon name="calendar" size={15} /> EONICS: Afterglow · View event
        </button>
        <Button onClick={() => app.go("event")}>Explore this night</Button>
      </div>
    </div>
  )
}

const PEOPLE = [
  { id: "dm-maya", name: "Maya Chen", handle: "maya.chen", image: media.friends },
  { id: "dm-noah", name: "Noah Reid", handle: "noahreid", image: media.dj },
  { id: "dm-sofia", name: "Sofia Bell", handle: "sofiabell", image: media.crowd },
  { id: "dm-eli", name: "Eli James", handle: "elijames", image: media.photographer },
  { id: "amara", name: "Amara Vale", handle: "amaravale", image: media.pro },
  { id: "eonics", name: "EONICS Music", handle: "eonicsmusic", image: media.dj },
  { id: "nova", name: "Nova Room", handle: "novaroomto", image: media.venue },
]
const GROUPS = new Set(["crew"])

function RequestPreview({ id, close }: { id: string; close: () => void }) {
  const app = useApp()
  const r = app.state.requests.find((x) => x.id === id)
  if (!r) return <p className="list-count">This request is no longer here.</p>
  const remove = (msg: string) => {
    app.update((s) => ({ requests: s.requests.filter((x) => x.id !== id) }))
    app.toast(msg)
    close()
  }
  return (
    <div className="req-preview">
      <div className="req-from">
        <Avatar src={r.image} label={r.name} />
        <span>
          <b>{r.name}</b>
          <small>Not in your followers</small>
        </span>
      </div>
      <p className="req-bubble">{r.text}</p>
      <p className="list-count">They won't see that you've read this unless you accept.</p>
      <div className="req-actions">
        <Button variant="secondary" onClick={() => remove("Request declined")}>
          Decline
        </Button>
        <Button
          onClick={() => {
            app.update((s) => ({
              requests: s.requests.filter((x) => x.id !== id),
              threads: { ...s.threads, [id]: { title: r.name, image: r.image, messages: [{ from: "them", who: r.name, text: r.text, time: "1h" }] } },
              threadOrder: [id, ...s.threadOrder],
            }))
            close()
            app.openThread(id)
          }}
        >
          Accept
        </Button>
      </div>
      <div className="req-safety">
        <button onClick={() => remove(`${r.name} blocked. They can't message you.`)}>Block</button>
        <button onClick={() => remove("Reported. Thanks for keeping BottlesUp safe.")}>Report</button>
      </div>
    </div>
  )
}

export function Inbox() {
  const app = useApp()
  const { state } = app
  const tab = state.inboxTab
  const setTab = (inboxTab: "messages" | "requests") => app.update({ inboxTab })
  const query = state.inboxQuery
  const setQuery = (inboxQuery: string) => app.update({ inboxQuery })
  const [search, setSearch] = useState<"idle" | "loading" | "ready" | "error">("idle")
  const counts = guestCounts(state.booking.guests, state.invited)
  useEffect(() => {
    if (!query.trim()) return setSearch("idle")
    setSearch("loading")
    const t = window.setTimeout(() => setSearch(navigator.onLine === false ? "error" : "ready"), 250)
    return () => window.clearTimeout(t)
  }, [query])
  const q = query.trim().toLowerCase()
  // Search covers your conversations and people you can message. Message requests stay in Requests.
  const convoHits = q
    ? state.threadOrder.filter((id) => {
        const t = state.threads[id]
        return t.title.toLowerCase().includes(q) || t.messages.some((m) => m.text.toLowerCase().includes(q))
      })
    : []
  const peopleHits = q ? PEOPLE.filter((p) => !convoHits.includes(p.id) && (p.name.toLowerCase().includes(q) || p.handle.includes(q.replace(/^@/, "")))) : []
  const newMessage = () =>
    app.openSheet({
      title: "New message",
      eyebrow: "INBOX",
      body: (close) => (
        <OptionList
          close={close}
          options={PEOPLE.slice(0, 5).map((f) => ({
            label: f.name,
            detail: "@" + f.handle,
            icon: "user",
            onSelect: () => app.openThread(f.id),
          }))}
        />
      ),
    })
  const row = (id: string) => {
    const t = state.threads[id]
    const last = t.messages[t.messages.length - 1]
    const unread = state.unread.includes(id)
    return (
      <button className={`message-row ${unread ? "unread" : ""}`} key={id} onClick={() => app.openThread(id)}>
        <Avatar src={t.image} label={t.title} />
        <span>
          <b>
            {t.title}
            {GROUPS.has(id) && <em className="group-tag">Group</em>}
          </b>
          <small>{last ? `${last.from === "me" ? "You" : last.who ?? t.title}: ${last.text}` : "Say hello"}</small>
        </span>
        <i>
          {last?.time ?? ""}
          {unread && <em aria-label="Unread" />}
        </i>
      </button>
    )
  }
  return (
    <div className="screen">
      <header className="topbar inbox-head">
        <h1>Inbox</h1>
        <button className="icon-btn compose-btn" aria-label="New message" onClick={newMessage}>
          <Icon name="edit" />
        </button>
      </header>
      <main className="padded inbox">
        <label className="inbox-search">
          <Icon name="search" size={17} />
          <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search names or messages" aria-label="Search names or messages" />
          {query && (
            <button aria-label="Clear search" onClick={() => setQuery("")}>
              <Icon name="close" size={14} />
            </button>
          )}
        </label>
        {q ? (
          search === "loading" ? (
            <p className="inbox-state">Searching…</p>
          ) : search === "error" ? (
            <div className="inbox-state">
              <b>Couldn't search right now</b>
              <small>Check your connection.</small>
              <Button variant="secondary" onClick={() => setQuery(query + " ")}>
                Retry
              </Button>
            </div>
          ) : convoHits.length + peopleHits.length === 0 ? (
            <div className="inbox-state">
              <b>No results for “{query.trim()}”</b>
              <small>Try a name, @username or a word from a message.</small>
            </div>
          ) : (
            <>
              {convoHits.length > 0 && <p className="inbox-label">Conversations</p>}
              <div className="messages">{convoHits.map(row)}</div>
              {peopleHits.length > 0 && <p className="inbox-label">People</p>}
              <div className="messages">
                {peopleHits.map((p) => (
                  <button className="message-row" key={p.id} onClick={() => app.openThread(p.id)}>
                    <Avatar src={p.image} label={p.name} />
                    <span>
                      <b>{p.name}</b>
                      <small>@{p.handle}</small>
                    </span>
                    <i />
                  </button>
                ))}
              </div>
            </>
          )
        ) : (
          <>
            <div className="inbox-tabs" role="tablist">
              <button role="tab" aria-selected={tab === "messages"} className={tab === "messages" ? "active" : ""} onClick={() => setTab("messages")}>
                Messages
              </button>
              <button role="tab" aria-selected={tab === "requests"} className={tab === "requests" ? "active" : ""} onClick={() => setTab("requests")}>
                Requests {state.requests.length > 0 && <span>{state.requests.length}</span>}
              </button>
            </div>
            {tab === "messages" ? (
              <>
                {counts.joined < state.booking.guests && (
                  <button className="inbox-plan" onClick={() => app.go("guests")}>
                    <Icon name="users" size={18} />
                    <span>
                      <b>{dateById(state.booking.dateId).weekday} at Nova</b> · {state.booking.guests - counts.joined} still to join
                    </span>
                    <Icon name="chevron" size={15} />
                  </button>
                )}
                <div className="messages">{state.threadOrder.map(row)}</div>
              </>
            ) : (
              <div className="messages">
                {state.requests.length === 0 ? (
                  <div className="inbox-state">
                    <b>No message requests</b>
                    <small>Messages from people you don't follow arrive here first.</small>
                  </div>
                ) : (
                  <>
                    <p className="list-count">Open a request to read it. Senders can't see you've read it until you accept.</p>
                    {state.requests.map((r) => (
                      <button className="message-row" key={r.id} onClick={() => app.openSheet({ title: "Message request", eyebrow: "PREVIEW", body: (close) => <RequestPreview id={r.id} close={close} /> })}>
                        <Avatar src={r.image} label={r.name} />
                        <span>
                          <b>{r.name}</b>
                          <small>{r.text}</small>
                        </span>
                        <Icon name="chevron" size={16} />
                      </button>
                    ))}
                  </>
                )}
              </div>
            )}
          </>
        )}
      </main>
    </div>
  )
}

const replies: Record<string, string> = {
  crew: "Sounds good. See you there!",
  nova: "Thanks for reaching out. Alex from Nova Room will reply in a moment.",
  support: "Thanks. A support specialist has your booking and will reply shortly.",
  amara: "Thanks! I'll check my calendar and send a quote.",
}

export function Chat() {
  const app = useApp()
  const { state } = app
  const id = state.activeThread
  const thread = state.threads[id]
  const [draft, setDraft] = useState("")
  const [splitOpen, setSplitOpen] = useState(false)
  const endRef = useRef<HTMLDivElement>(null)
  const replyTimer = useRef<number | null>(null)
  const b = state.booking
  const total = quote(tables[b.tableId], b.bottles, b.sign).total
  const share = Math.round(total / b.guests)
  useEffect(() => {
    endRef.current?.scrollIntoView({ block: "end" })
  }, [thread?.messages.length])
  useEffect(() => () => {
    if (replyTimer.current) window.clearTimeout(replyTimer.current)
  }, [])
  if (!thread) return null
  const send = (text: string) => {
    const clean = text.trim()
    if (!clean) return
    app.update((s) => ({
      threads: { ...s.threads, [id]: { ...s.threads[id], messages: [...s.threads[id].messages, { from: "me", text: clean, time: nowTime() }] } },
      threadOrder: [id, ...s.threadOrder.filter((x) => x !== id)],
    }))
    setDraft("")
    const reply = replies[id] ?? "Sounds good!"
    const who = id === "crew" ? "Maya" : thread.title
    if (replyTimer.current) window.clearTimeout(replyTimer.current)
    replyTimer.current = window.setTimeout(() => {
      app.update((s) => ({
        threads: { ...s.threads, [id]: { ...s.threads[id], messages: [...s.threads[id].messages, { from: "them", who, text: reply, time: nowTime() }] } },
      }))
    }, 1400)
  }
  const attach = () =>
    app.openSheet({
      title: "Share in chat",
      eyebrow: "ATTACH",
      body: (close) => (
        <OptionList
          close={close}
          options={[
            { label: "Share the event", detail: "EONICS: Afterglow", icon: "calendar", onSelect: () => send(`Shared an event: EONICS: Afterglow · Nova Room · Sat, Aug 24`) },
            { label: "Share My Night", detail: `${tables[b.tableId].name} · ${b.arrival}`, icon: "ticket", onSelect: () => send(`My Night: ${tables[b.tableId].name} at Nova Room, arriving ${b.arrival}.`) },
            { label: "Share location", detail: "Nova Room, 19 Mercer St", icon: "map", onSelect: () => send("Meet at Nova Room, 19 Mercer St. Rideshare zone is on Blue Jays Way.") },
          ]}
        />
      ),
    })
  return (
    <div className="screen chat-screen">
      <TopBar
        title={thread.title}
        back
        fallback="inbox"
        action={
          id === "crew" ? (
            <button className="icon-btn" aria-label="Guests and passes" onClick={() => app.go("guests")}>
              <Icon name="users" />
            </button>
          ) : undefined
        }
      />
      <main className="chat-body">
        <div className="chat-date">{id === "crew" ? "SATURDAY PLANNING · DEMO" : "DEMO CONVERSATION"}</div>
        {id === "crew" && (
          <>
            <div className="shared-experience">
              <img src={media.hero} alt="" />
              <span>
                <small>SHARED EVENT</small>
                <b>EONICS: Afterglow</b>
                <em>Nova Room · Sat, Aug 24</em>
                <Button variant="secondary" onClick={() => app.go("event")}>
                  View event
                </Button>
              </span>
            </div>
          </>
        )}
        {thread.messages.map((m, i) => (
          <div key={i}>
            <div className={`bubble ${m.from === "me" ? "outgoing" : "incoming"}`}>
              {m.text}
              <small>
                {m.from === "me" ? "You" : m.who ?? thread.title} · {m.time}
              </small>
            </div>
            {id === "crew" && i === 1 && (
              <div className="contribution-card">
                <Icon name="users" />
                <span>
                  <small>REIMBURSEMENT REQUEST</small>
                  <b>{money(share)} each</b>
                  <em>You paid the confirmed booking. Splitting is optional.</em>
                  {splitOpen && (
                    <span className="split-list">
                      {friends.slice(0, Math.min(3, b.guests - 1)).map((f, j) => (
                        <span key={f.name}>
                          {f.name.split(" ")[0]} <b>{j === 1 ? "Paid" : "Pending"}</b>
                        </span>
                      ))}
                    </span>
                  )}
                </span>
                <button onClick={() => setSplitOpen(!splitOpen)}>{splitOpen ? "Hide" : "Review"}</button>
              </div>
            )}
          </div>
        ))}
        <div ref={endRef} />
      </main>
      <form
        className="chat-compose"
        onSubmit={(e) => {
          e.preventDefault()
          send(draft)
        }}
      >
        <button type="button" aria-label="Attach" onClick={attach}>
          <Icon name="plus" />
        </button>
        <input id={`chat-${id}`} value={draft} onChange={(e) => setDraft(e.target.value)} placeholder={`Message ${thread.title}`} aria-label={`Message ${thread.title}`} />
        <button type="submit" aria-label="Send" disabled={!draft.trim()}>
          <Icon name="send" />
        </button>
      </form>
    </div>
  )
}

type Notice = { icon: IconName; title: string; copy: string; time: string; screen: Screen; kind: "Social" | "Bookings" }

export function Notifications() {
  const app = useApp()
  const { state } = app
  const [filter, setFilter] = useState<"All" | "Social" | "Bookings">("All")
  const b = state.booking
  const counts = guestCounts(b.guests, state.invited)
  const items: Notice[] = [
    { icon: "ticket", title: "Your table is confirmed", copy: `${tables[b.tableId].name} at Nova Room · ${dateById(b.dateId).short}`, time: "Now", screen: "night", kind: "Bookings" },
    { icon: "users", title: "Maya accepted your pass", copy: `${counts.joined} of ${b.guests} guests are in`, time: "12m", screen: "guests", kind: "Bookings" },
    { icon: "heart", title: "Amara Vale liked your post", copy: "Your Afterglow recap", time: "1h", screen: "feed", kind: "Social" },
    { icon: "calendar", title: "Afterglow is nearly sold out", copy: "Tables are still available", time: "3h", screen: "event", kind: "Social" },
  ]
  const shown = items.filter((i) => filter === "All" || i.kind === filter)
  return (
    <div className="screen">
      <TopBar
        title="Notifications"
        back
        action={
          <button className="text-action" disabled={state.notificationsRead} onClick={() => app.update({ notificationsRead: true })}>
            {state.notificationsRead ? "All read" : "Read all"}
          </button>
        }
      />
      <main className="padded">
        <div className="notice-filter">
          {(["All", "Social", "Bookings"] as const).map((f) => (
            <button key={f} className={filter === f ? "active" : ""} onClick={() => setFilter(f)}>
              {f}
            </button>
          ))}
        </div>
        <div className="notification-list">
          {shown.map((item, i) => (
            <button key={item.title} onClick={() => (item.screen === "feed" ? (app.update({ viewerProfile: "me", viewerIndex: 1 }), app.go("feed")) : app.go(item.screen))} className={!state.notificationsRead && i < 2 ? "unread" : ""}>
              <span className="notice-icon">
                <Icon name={item.icon} />
              </span>
              <span>
                <b>{item.title}</b>
                <small>{item.copy}</small>
              </span>
              <em>{item.time}</em>
            </button>
          ))}
        </div>
      </main>
    </div>
  )
}

const photoChoices = [media.friends, media.hero, media.crowd, media.stage, media.venue]

export function Composer() {
  const app = useApp()
  const { state } = app
  const mode = state.composeMode
  const members = state.composeMembers
  const [published, setPublished] = useState(false)
  const [photo, setPhoto] = useState(0)
  const [tagged, setTagged] = useState(true)
  const [caption, setCaption] = useState(mode === "Recap" ? "Afterglow with the best crew. Same time next weekend?" : "")
  const [circle, setCircle] = useState<string[]>(friends.slice(0, 4).map((f) => f.name))
  const publish = () => {
    app.update((s) => ({
      posts: [{ image: photoChoices[photo], members, reel: mode === "Reel", tagged }, ...s.posts],
    }))
    setPublished(true)
  }
  const manageCircle = () =>
    app.openSheet({
      title: "Members circle",
      eyebrow: "MEMBERS ONLY",
      body: () => <CircleEditor initial={circle} onChange={setCircle} />,
    })
  const titles: Record<ComposeMode, string> = { Recap: "New recap", Post: "New post", Reel: "New reel", Story: "New story", Update: "New update" }
  return (
    <div className="screen">
      <TopBar
        title={titles[mode]}
        back
        action={
          !published && (
            <button className="text-action" onClick={publish}>
              Share
            </button>
          )
        }
      />
      <main className="padded composer-body">
        {published ? (
          <div className="publish-success">
            <span>
              <Icon name="check" />
            </span>
            <div className="display-title">{mode === "Story" ? "Story shared." : `${mode} shared.`}</div>
            <p>{members ? `Only your ${circle.length} Members Only people can see it.` : "Your night is now part of your BottlesUp story."}</p>
            <Button onClick={() => app.go("profile", { reset: true })}>View on profile</Button>
          </div>
        ) : (
          <>
            {mode !== "Update" && (
              <div className="composer-photo">
                <img src={photoChoices[photo]} alt="Selected photo" />
                <span className="demo-label">DEMO {mode.toUpperCase()}</span>
                <button onClick={() => setPhoto((photo + 1) % photoChoices.length)}>
                  <Icon name="camera" /> Change photo
                </button>
              </div>
            )}
            <textarea
              id="composer-caption"
              className="caption-field"
              value={caption}
              onChange={(e) => setCaption(e.target.value)}
              placeholder={mode === "Update" ? "What's happening tonight?" : "Write a caption…"}
              aria-label="Caption"
            />
            <button className="composer-row" aria-pressed={tagged} onClick={() => setTagged(!tagged)}>
              <Icon name="tag" />
              <span>
                <b>Tag experience</b>
                <small>{tagged ? "EONICS: Afterglow · Nova Room" : "Not tagged"}</small>
              </span>
              <span className={tagged ? "toggle on" : "toggle"}>
                <i />
              </span>
            </button>
            <button className="composer-row" aria-pressed={members} onClick={() => app.update({ composeMembers: !members })}>
              <Icon name="users" />
              <span>
                <b>Audience</b>
                <small>{members ? `Members Only · ${circle.length} selected` : "Everyone who follows you"}</small>
              </span>
              <span className={members ? "toggle on" : "toggle"}>
                <i />
              </span>
            </button>
            {members && (
              <div className="members-preview">
                <Icon name="spark" />
                <span>
                  <b>Members Only</b>
                  <small>Only your selected free private circle can view this {mode.toLowerCase()}.</small>
                </span>
                <button onClick={manageCircle}>Manage</button>
              </div>
            )}
            <Button className="full-width" onClick={publish} disabled={mode === "Update" && !caption.trim()}>
              Publish {mode.toLowerCase()}
            </Button>
          </>
        )}
      </main>
    </div>
  )
}

function CircleEditor({ initial, onChange }: { initial: string[]; onChange: (v: string[]) => void }) {
  const [picked, setPicked] = useState(initial)
  return (
    <div className="sheet-options">
      {friends.map((f) => {
        const on = picked.includes(f.name)
        return (
          <button
            key={f.name}
            className="toggle-row"
            aria-pressed={on}
            onClick={() => {
              const next = on ? picked.filter((x) => x !== f.name) : [...picked, f.name]
              setPicked(next)
              onChange(next)
            }}
          >
            <span>
              <b>{f.name}</b>
              <small>{on ? "Can see Members Only posts" : "Not in your circle"}</small>
            </span>
            <span className={on ? "toggle on" : "toggle"}>
              <i />
            </span>
          </button>
        )
      })}
    </div>
  )
}
