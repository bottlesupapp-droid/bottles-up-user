import { useState, type CSSProperties } from "react"
import { media, tables } from "../data"
import { resetDemoData, useApp, type Appearance, type ProfileStyle, type Screen } from "../store"
import { Avatar, BackGlass, Button, Icon, ShareButton, TopBar, type IconName, ThemeIcon, QR } from "../ui"
import { REELS } from "./Reels"
import { FEED } from "./Posts"
import { useOpenFeed } from "./Feed"
import { GalleryViewer, HeroCarousel, type VenuePhoto } from "./VenuePhotos"

const EVENT_PHOTOS: VenuePhoto[] = [
  { src: media.hero, caption: "EONICS: Afterglow flyer", tag: "Nights" },
  { src: media.crowd, caption: "Last Afterglow at Nova Room", tag: "Nights" },
  { src: media.stage, caption: "Stage and lights", tag: "Space" },
  { src: media.table, caption: "Halo Booth · upper level", tag: "Tables" },
  { src: media.venue, caption: "Nova Room main floor", tag: "Space" },
]

const TICKET = 35

export function EventDetail() {
  const app = useApp()
  const saved = app.state.saved.includes("event")
  const [tier, setTier] = useState<"ga" | "table">("ga")
  const [gaQty, setGaQty] = useState(1)
  const [viewer, setViewer] = useState<number | null>(null)
  const [aboutOpen, setAboutOpen] = useState(false)
  const halo = tables.halo
  const minSpend = "$" + halo.minimum.toLocaleString("en-CA")
  const openTable = () => {
    app.update({ tableId: "halo", dateId: "aug24" })
    app.go("table")
  }
  return (
    <div className="screen detail-screen">
      <div className="event-hero ev-gallery">
        <HeroCarousel photos={EVENT_PHOTOS} onOpen={setViewer} />
        <div className="floating-nav">
          <BackGlass fallback="home" />
          <div>
            <button className="glass-btn" aria-label={saved ? "Remove from saved" : "Save event"} aria-pressed={saved} onClick={() => app.toggleIn("saved", "event", "Event")}>
              <Icon name="bookmark" filled={saved} />
            </button>
            <ShareButton what="EONICS: Afterglow" className="glass-btn" />
          </div>
        </div>
      </div>
      <main className="padded event-body ev-body">
        <span className="ev-demo">DEMO EVENT</span>
        <h1 className="ev-title">EONICS: Afterglow</h1>
        <p className="ev-when">
          <Icon name="calendar" size={15} /> Sat, Aug 24 · 10 PM – 3 AM
        </p>
        <button className="ev-where" onClick={() => app.go("venue")}>
          <Icon name="map" size={15} /> Nova Room · King West, Toronto <Icon name="chevron" size={14} />
        </button>
        <button className="organizer-row" onClick={() => app.go("organizer")}>
          <Avatar src={media.dj} label="EONICS" />
          <span>
            <small>PRESENTED BY</small>
            <b>EONICS Music</b>
            <em>Organizer profile</em>
          </span>
          <Icon name="chevron" />
        </button>
        <button className="ev-msg-org" onClick={() => app.openThread("eonics", "Hi! I have a question about EONICS: Afterglow (Sat, Aug 24 at Nova Room).")}>
          <Icon name="message" size={16} /> Message organizer
        </button>
        <div className="section-title">
          <b>Confirmed lineup</b>
        </div>
        <div className="lineup-row">
          {[
            ["EONICS", media.dj],
            ["Amara Vale", media.pro],
            ["KAIRO", media.crowd],
          ].map(([name, img]) => (
            <button key={name} onClick={() => app.go(name === "EONICS" ? "organizer" : "professional")}>
              <Avatar src={img} label={name} />
              <span>{name}</span>
            </button>
          ))}
        </div>

        <h2 className="ev-h2">Booking options</h2>
        <div className="ev-options" role="radiogroup" aria-label="Booking options">
          <button role="radio" aria-checked={tier === "ga"} className={`ev-option ${tier === "ga" ? "on" : ""}`} onClick={() => setTier("ga")}>
            <span className="ev-radio" />
            <span>
              <b>General admission</b>
              <small>Entry before 11:30 PM · one QR ticket each</small>
            </span>
            <strong>
              {"$" + TICKET}
              <small>per ticket</small>
            </strong>
          </button>
          <button role="radio" aria-checked={tier === "table"} className={`ev-option ${tier === "table" ? "on" : ""}`} onClick={() => setTier("table")}>
            <span className="ev-radio" />
            <span>
              <b>
                {halo.name} · up to {halo.capacity}
              </b>
              <small>
                {"$" + halo.deposit} deposit to reserve. {minSpend} minimum spend on the night, deposit included.
              </small>
            </span>
            <strong>
              {"$" + halo.deposit}
              <small>deposit</small>
            </strong>
          </button>
        </div>
        {tier === "ga" && (
          <div className="counter ga-counter">
            <button aria-label="Fewer tickets" disabled={gaQty <= 1} onClick={() => setGaQty(gaQty - 1)}>
              −
            </button>
            <span>
              <b>{gaQty}</b>
              <small>ticket{gaQty === 1 ? "" : "s"}</small>
            </span>
            <button aria-label="More tickets" disabled={gaQty >= 6} onClick={() => setGaQty(gaQty + 1)}>
              +
            </button>
          </div>
        )}
        {app.state.gaTickets > 0 && (
          <div className="success-banner">
            <Icon name="check" />
            <span>
              <b>
                {app.state.gaTickets} GA ticket{app.state.gaTickets === 1 ? "" : "s"} in My Night
              </b>
              <small>Demo tickets · no real charge.</small>
            </span>
          </div>
        )}

        <h2 className="ev-h2">Entry</h2>
        <div className="ev-facts">
          <div>
            <small>Age</small>
            <b>19+ · physical government ID</b>
          </div>
          <div>
            <small>Last entry</small>
            <b>1:30 AM</b>
          </div>
          <div>
            <small>Dress code</small>
            <b>Smart evening wear</b>
          </div>
          <div>
            <small>Refunds</small>
            <b>Up to 48 hours before doors</b>
          </div>
        </div>

        <h2 className="ev-h2">About</h2>
        <p className="vv-about">
          EONICS returns to Nova Room for a night of Afro house under the lights, with Amara Vale and KAIRO on support.
          {aboutOpen && " Doors at 10 PM. Tables include priority entry and bottle service from the Nova Room menu. Expect the room to be full by midnight."}{" "}
          <button onClick={() => setAboutOpen(!aboutOpen)}>{aboutOpen ? "Show less" : "Read more"}</button>
        </p>

        <h2 className="ev-h2">Details</h2>
        <div className="ev-facts">
          <div>
            <small>Music</small>
            <b>Afro house · amapiano</b>
          </div>
          <div>
            <small>Getting there</small>
            <b>19 Mercer St · rideshare zone</b>
          </div>
        </div>
        <Button variant="secondary" icon="send" className="full-width ev-send" onClick={() => app.openThread("crew", "Who's in for EONICS: Afterglow at Nova Room on Sat, Aug 24?")}>
          Send to group
        </Button>

        <div className="sticky-action ev-bar">
          <div>
            <small>{tier === "ga" ? `${gaQty} ticket${gaQty === 1 ? "" : "s"} · ${"$" + TICKET} each` : `Table deposit · ${minSpend} min. spend`}</small>
            <b>{tier === "ga" ? "$" + TICKET * gaQty : "$" + halo.deposit}</b>
          </div>
          {tier === "ga" ? (
            <Button onClick={() => app.openSheet({ title: "Checkout", eyebrow: "EONICS: AFTERGLOW · SAT, AUG 24", body: (close) => <TicketCheckout qty={gaQty} close={close} /> })}>Book Tickets</Button>
          ) : (
            <Button onClick={openTable}>Book a Table</Button>
          )}
        </div>
      </main>
      {viewer !== null && <GalleryViewer photos={EVENT_PHOTOS} start={viewer} onClose={() => setViewer(null)} />}
    </div>
  )
}

const COLORS = ["#ff7900", "#e0245e", "#5856d6", "#0a84ff", "#30b0c7", "#34c759", "#1c1c1e"]
const GRADIENTS = ["linear-gradient(135deg,#ff7900,#ff2d55)", "linear-gradient(135deg,#5856d6,#0a84ff)", "linear-gradient(135deg,#1c1c1e,#4a3b2a)", "linear-gradient(135deg,#30b0c7,#34c759)"]

export function headerStyle(p: ProfileStyle): CSSProperties | undefined {
  if (p.kind === "color") return { background: p.value }
  if (p.kind === "gradient") return { background: p.value }
  if (p.kind === "image") return { backgroundImage: `linear-gradient(rgba(0,0,0,.45),rgba(0,0,0,.55)), url(${p.value})`, backgroundSize: "cover", backgroundPosition: `50% ${p.posY}%` }
  return undefined
}

function CustomiseProfile({ close }: { close: () => void }) {
  const app = useApp()
  const [draft, setDraft] = useState<ProfileStyle>(app.state.profileStyle)
  const [error, setError] = useState("")
  const upload = (file?: File) => {
    if (!file) return
    if (!file.type.startsWith("image/")) return setError("Choose an image file.")
    if (file.size > 6 * 1024 * 1024) return setError("That image is over 6 MB. Try a smaller one.")
    const reader = new FileReader()
    reader.onload = () => {
      setError("")
      setDraft({ kind: "image", value: String(reader.result), posY: 50 })
    }
    reader.onerror = () => setError("We couldn't read that image. Try another.")
    reader.readAsDataURL(file)
  }
  const on = (kind: ProfileStyle["kind"], value: string) => draft.kind === kind && draft.value === value
  return (
    <div className="customise">
      <div className={`cp-preview ${draft.kind !== "none" ? "styled" : ""}`} style={headerStyle(draft)} aria-label="Preview">
        <Avatar src={media.friends} label={app.state.profile.name} />
        <span>
          <b>{app.state.profile.name}</b>
          <small>@{app.state.profile.handle}</small>
        </span>
      </div>
      <p className="cp-label">Colour</p>
      <div className="cp-swatches" role="radiogroup" aria-label="Colour">
        <button role="radio" aria-checked={draft.kind === "none"} aria-label="Default" className={`cp-none ${draft.kind === "none" ? "on" : ""}`} onClick={() => setDraft({ kind: "none", value: "", posY: 50 })} />
        {COLORS.map((c) => (
          <button key={c} role="radio" aria-checked={on("color", c)} aria-label={`Colour ${c}`} className={on("color", c) ? "on" : ""} style={{ background: c }} onClick={() => setDraft({ kind: "color", value: c, posY: 50 })} />
        ))}
      </div>
      <p className="cp-label">Gradient</p>
      <div className="cp-swatches" role="radiogroup" aria-label="Gradient">
        {GRADIENTS.map((g, i) => (
          <button key={g} role="radio" aria-checked={on("gradient", g)} aria-label={`Gradient ${i + 1}`} className={on("gradient", g) ? "on" : ""} style={{ background: g }} onClick={() => setDraft({ kind: "gradient", value: g, posY: 50 })} />
        ))}
      </div>
      <p className="cp-label">Cover image</p>
      <label className="cp-upload">
        <Icon name="camera" size={18} /> {draft.kind === "image" ? "Choose a different image" : "Upload an image"}
        <input type="file" accept="image/*" onChange={(e) => upload(e.target.files?.[0])} />
      </label>
      {error && <p className="cp-error" role="alert">{error}</p>}
      {draft.kind === "image" && (
        <label className="cp-slider">
          <span>Reposition</span>
          <input type="range" min={0} max={100} value={draft.posY} onChange={(e) => setDraft({ ...draft, posY: Number(e.target.value) })} aria-label="Vertical position" />
        </label>
      )}
      <p className="cp-hint">Only your profile header changes. A soft overlay keeps your name readable on images. Visitors see your saved background.</p>
      <div className="cp-actions">
        <Button variant="secondary" onClick={() => setDraft({ kind: "none", value: "", posY: 50 })}>
          Reset
        </Button>
        <Button
          onClick={() => {
            app.update({ profileStyle: draft })
            app.toast("Profile header saved")
            close()
          }}
        >
          Save
        </Button>
      </div>
    </div>
  )
}

function ShareProfile({ close }: { close: () => void }) {
  const app = useApp()
  const { profile, profileStyle } = app.state
  const link = `https://bottlesup.com/@${profile.handle}`
  const [copied, setCopied] = useState(false)
  const copy = () => {
    const ok = () => {
      setCopied(true)
      app.toast("Link copied")
    }
    try {
      navigator.clipboard ? navigator.clipboard.writeText(link).then(ok, () => app.toast("Copying isn't available here. Press and hold the link to copy.")) : app.toast("Copying isn't available here.")
    } catch {
      app.toast("Copying isn't available here.")
    }
  }
  const shareTo = async () => {
    if (navigator.share) {
      try {
        await navigator.share({ title: profile.name, text: `${profile.name} on BottlesUp`, url: link })
        close()
      } catch {
        /* user cancelled the system sheet */
      }
    } else
      app.openSheet({
        title: "Share to",
        eyebrow: "SHARE PROFILE",
        body: (c) => (
          <div className="share-to">
            {[
              ["Messages", "message"],
              ["Instagram story", "camera"],
              ["WhatsApp", "send"],
              ["Email", "link"],
            ].map(([label, icon]) => (
              <button key={label} onClick={() => (app.toast(`Opening ${label}… (demo)`), c())}>
                <span>
                  <Icon name={icon as IconName} />
                </span>
                {label}
              </button>
            ))}
          </div>
        ),
      })
  }
  return (
    <div className="share-profile">
      <div className={`sp-card ${profileStyle.kind !== "none" ? "styled" : ""}`} style={headerStyle(profileStyle)}>
        <Avatar src={media.friends} label={profile.name} />
        <b>{profile.name}</b>
        <small>@{profile.handle}</small>
        <div className="sp-qr">
          <QR value={link} size={150} label={`QR code for ${link}`} />
        </div>
        <small className="sp-link">{link.replace("https://", "")}</small>
      </div>
      <div className="sp-actions">
        <button onClick={copy}>
          <span>
            <Icon name={copied ? "check" : "copy"} />
          </span>
          {copied ? "Copied" : "Copy link"}
        </button>
        <button onClick={shareTo}>
          <span>
            <Icon name="send" />
          </span>
          Share to
        </button>
      </div>
    </div>
  )
}

function EditProfile({ close }: { close: () => void }) {
  const app = useApp()
  const [name, setName] = useState(app.state.profile.name)
  const [bio, setBio] = useState(app.state.profile.bio)
  return (
    <form
      className="sheet-form"
      onSubmit={(e) => {
        e.preventDefault()
        if (!name.trim()) return
        app.update((s) => ({ profile: { ...s.profile, name: name.trim(), bio: bio.trim() } }))
        app.toast("Profile updated")
        close()
      }}
    >
      <label htmlFor="profile-name">Name</label>
      <input id="profile-name" value={name} onChange={(e) => setName(e.target.value)} maxLength={40} />
      <label htmlFor="profile-bio">Bio</label>
      <textarea id="profile-bio" value={bio} onChange={(e) => setBio(e.target.value)} maxLength={120} />
      <Button type="submit" className="full-width" disabled={!name.trim()}>
        Save
      </Button>
      <button
        type="button"
        className="customise-link"
        onClick={() => {
          close()
          window.setTimeout(() => app.openSheet({ title: "Customise profile", eyebrow: "ONLY YOU CAN EDIT THIS", body: (c) => <CustomiseProfile close={c} /> }), 0)
        }}
      >
        <Icon name="spark" size={16} /> Customise profile
        <Icon name="chevron" size={16} />
      </button>
    </form>
  )
}

export function Profile({ theme, appearance, setAppearance }: { theme: "light" | "dark"; appearance: Appearance; setAppearance: (a: Appearance) => void }) {
  const app = useApp()
  const { state } = app
  const [tab, setTab] = useState<"grid" | "reels" | "reposts" | "tagged" | "members">("grid")
  const isOwner = true // this is the signed-in user's own profile
  const posts = state.posts.filter((p) => (tab === "grid" ? true : tab === "reels" ? p.reel : tab === "tagged" ? p.tagged : tab === "members" ? p.members : false))
  const openFeed = useOpenFeed()
  const tabs: [typeof tab, IconName, string][] = [
    ["grid", "grid", "All posts"],
    ["reels", "play", "Reels"],
    ["reposts", "repost", "Reposts"],
    ["tagged", "tag", "Tagged"],
  ]
  return (
    <div className="screen">
      <TopBar
        action={
          <div className="header-actions">
            <ThemeIcon dark={theme === "dark"} onChange={(d) => setAppearance(d ? "dark" : "light")} />
            {isOwner && (
              <button className="icon-btn" aria-label="Edit profile" onClick={() => app.openSheet({ title: "Edit profile", eyebrow: "PROFILE", body: (close) => <EditProfile close={close} /> })}>
                <Icon name="edit" />
              </button>
            )}
            <button className="icon-btn" aria-label="Share profile" onClick={() => app.openSheet({ title: "Share profile", eyebrow: "@" + state.profile.handle.toUpperCase(), body: (close) => <ShareProfile close={close} /> })}>
              <Icon name="send" />
            </button>
            <button className="icon-btn" aria-label="Open settings" onClick={() => app.go("settings")}>
              <Icon name="menu" />
            </button>
          </div>
        }
      />
      <main className="padded profile">
        <div className={`profile-head ${state.profileStyle.kind !== "none" ? "styled" : ""}`} style={headerStyle(state.profileStyle)}>
        <div className="profile-main">
          <Avatar src={media.friends} label={state.profile.name} story />
          <div>
            <div className="profile-name">
              {state.profile.name}{" "}
              <span className="verified" aria-label="Verified">
                <Icon name="check" size={11} />
              </span>
            </div>
            <span>@{state.profile.handle}</span>
            <p>{state.profile.bio}</p>
          </div>
        </div>
        <div className="metric-row">
          <div>
            <b>12.4K</b>
            <span>Likes</span>
          </div>
          <div>
            <b>2.8K</b>
            <span>Followers</span>
          </div>
          <div>
            <b>{684 + state.following.length}</b>
            <span>Following</span>
          </div>
        </div>
        <small className="demo-stats">Demo numbers</small>
        </div>
        <button className="night-card profile-night" onClick={() => app.go("night")}>
          <span className="night-card-icon">
            <Icon name="moon" />
          </span>
          <span>
            <b>My Night</b>
            <small>
              {tables[state.booking.tableId].name} · Nova Room
            </small>
          </span>
          <Icon name="chevron" />
        </button>
        <div className="highlights profile-highlights">
          <button onClick={() => app.go("reel")}>
            <span>
              <img src={media.hero} alt="" />
            </span>
            Recaps
          </button>
          <button onClick={() => setTab("members")} className={tab === "members" ? "active" : ""}>
            <span className="members-ring">
              <img src={media.friends} alt="" />
            </span>
            Members
          </button>
          <button onClick={() => app.go("explore")}>
            <span>
              <img src={media.stage} alt="" />
            </span>
            {state.city}
          </button>
          <button onClick={() => app.go("camera")}>
            <span>
              <Icon name="plus" />
            </span>
            New
          </button>
        </div>
        <div className="profile-tabs">
          {tabs.map(([id, icon, label]) => (
            <button key={id} className={tab === id ? "active" : ""} aria-label={label} aria-pressed={tab === id} onClick={() => setTab(id)}>
              <Icon name={icon} />
            </button>
          ))}
        </div>
        {tab === "members" && <p className="tab-caption">Members Only posts · visible to your private circle</p>}
        {tab === "reposts" ? (
          state.reposts.length + state.postReposts.length === 0 ? (
            <div className="empty-state">
              <Icon name="repost" />
              <b>No reposts yet</b>
              <small>Tap the two-arrow repost button on a post or reel to share it here.</small>
            </div>
          ) : (
            <div className="photo-grid">
              {state.postReposts.map((id) => {
                const fp = FEED.find((x) => x.id === id)
                if (!fp) return null
                return (
                  <button
                    key={id}
                    aria-label={`Open repost of @${fp.handle}`}
                    onClick={() => {
                      app.update({ activePost: id })
                      app.go("post")
                    }}
                  >
                    <img src={fp.image} alt="" />
                    <span className="repost-badge">
                      <Icon name="repost" size={11} /> @{fp.handle}
                    </span>
                  </button>
                )
              })}
              {state.reposts.map((id) => {
                const r = REELS.find((x) => x.id === id)
                if (!r) return null
                return (
                  <button
                    key={id}
                    aria-label={`Open repost of @${r.handle}`}
                    onClick={() => {
                      app.update({ reelStart: REELS.indexOf(r) })
                      app.go("reel")
                    }}
                  >
                    <img src={r.image} alt="" />
                    <span className="repost-badge">
                      <Icon name="repost" size={11} /> @{r.handle}
                    </span>
                  </button>
                )
              })}
            </div>
          )
        ) : posts.length === 0 ? (
          <div className="empty-state">
            <Icon name={tab === "reels" ? "play" : "grid"} />
            <b>Nothing here yet</b>
            <small>Tap New to share your first one.</small>
          </div>
        ) : (
          <div className="photo-grid">
            {posts.map((p, i) => (
              <button key={i} onClick={() => openFeed("me", state.posts.indexOf(p))} aria-label={`Open post ${i + 1}`}>
                <img src={p.image} alt="" />
                {p.members && (
                  <span className="members-badge">
                    <Icon name="spark" size={11} /> MEMBERS
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
      </main>
    </div>
  )
}

export function Settings({ appearance, setAppearance, resolvedTheme }: { appearance: Appearance; setAppearance: (a: Appearance) => void; resolvedTheme: "light" | "dark" }) {
  const app = useApp()
  const options: { value: Appearance; title: string; description: string; icon: IconName }[] = [
    { value: "system", title: "System", description: "Match this device", icon: "settings" },
    { value: "light", title: "Light", description: "Bright and clear", icon: "sun" },
    { value: "dark", title: "Dark", description: "Made for late nights", icon: "moon" },
  ]
  return (
    <div className="screen settings-screen">
      <TopBar title="Settings" back fallback="profile" />
      <main className="padded">
        <div className="settings-brand">
          <img src="/bottlesup-app-icon.png" alt="BottlesUp app icon" />
          <span>
            <b>BottlesUp</b>
            <small>Consumer app · Demo prototype</small>
          </span>
        </div>
        <div className="settings-section-title">Display</div>
        <div className="appearance-card">
          <div className="appearance-row">
            <span className="appearance-row-label">
              <b>Match this device</b>
              <small>{appearance === "system" ? `On · following your phone (${resolvedTheme})` : "Off · use the sun and moon switch on your profile"}</small>
            </span>
            <button className={appearance === "system" ? "toggle on" : "toggle"} role="switch" aria-checked={appearance === "system"} aria-label="Match this device" onClick={() => setAppearance(appearance === "system" ? resolvedTheme : "system")}>
              <i />
            </button>
          </div>
        </div>
        <div className="settings-section-title">Demo controls</div>
        <div className="appearance-card">
          {(
            [
              ["failUpload", "Fail the next upload", "Shows the upload error and Retry when you post"],
              ["failWallet", "Fail Apple Wallet", "Shows the error when you add a pass"],
            ] as const
          ).map(([key, label, detail]) => (
            <div className="appearance-row" key={key}>
              <span className="appearance-row-label">
                <b>{label}</b>
                <small>{detail}</small>
              </span>
              <button className={app.state.demo[key] ? "toggle on" : "toggle"} role="switch" aria-checked={app.state.demo[key]} aria-label={label} onClick={() => app.update((s) => ({ demo: { ...s.demo, [key]: !s.demo[key] } }))}>
                <i />
              </button>
            </div>
          ))}
        </div>
        <div className="settings-section-title">Preferences</div>
        <div className="settings-list">
          {(
            [
              ["Notifications", "notifications"],
              ["Privacy & safety", "support"],
              ["Saved experiences", "saved"],
              ["Payments & receipts", "receipt"],
              ["Help & support", "support"],
            ] as [string, Screen][]
          ).map(([item, destination]) => (
            <button key={item} onClick={() => app.go(destination)}>
              <span>{item}</span>
              <Icon name="chevron" size={17} />
            </button>
          ))}
        </div>
        <button className="sign-out-row" onClick={() => app.signOut()}>
          Sign out
        </button>
        <button
          className="sign-out-row reset-demo-row"
          onClick={() =>
            app.openSheet({
              title: "Reset demo data?",
              eyebrow: "DEMO",
              body: (close) => (
                <div className="sheet-options">
                  <p className="sheet-copy">Bookings, tickets, messages, follows and profile edits saved in this browser go back to the starting demo. This can't be undone.</p>
                  <div className="sheet-actions">
                    <Button variant="secondary" onClick={close}>
                      Keep my data
                    </Button>
                    <Button
                      onClick={() => {
                        resetDemoData()
                        window.location.reload()
                      }}
                    >
                      Reset demo
                    </Button>
                  </div>
                </div>
              ),
            })
          }
        >
          Reset demo data
        </button>
      </main>
    </div>
  )
}

/* Ticket checkout: same fee and tax rules as table bookings (3% service fee, 13% HST).
   Demo payment only: no card is charged. */
function TicketCheckout({ qty, close }: { qty: number; close: () => void }) {
  const app = useApp()
  const [state, setState] = useState<"ready" | "paying" | "declined">("ready")
  const sub = TICKET * qty * 100
  const fee = Math.round((sub * 3) / 100)
  const tax = Math.round(((sub + fee) * 13) / 100)
  const total = sub + fee + tax
  const fmt = (c: number) => "$" + (c / 100).toFixed(2)
  const pay = (fail: boolean) => {
    setState("paying")
    window.setTimeout(() => {
      if (fail) return setState("declined")
      const ref = "TK-" + String(Date.now()).slice(-4)
      app.update((s) => ({ gaTickets: s.gaTickets + qty, ticketOrders: [{ ref, qty, total, date: "Today" }, ...s.ticketOrders] }))
      app.toast(`Paid ${fmt(total)} · ${ref}. ${qty} pass${qty === 1 ? "" : "es"} in My Night.`)
      close()
    }, 900)
  }
  return (
    <div className="sheet-options tk-checkout">
      <div className="tk-lines">
        <p>
          <span>General admission × {qty}</span>
          <b>{fmt(sub)}</b>
        </p>
        <p>
          <span>Service fee (3%)</span>
          <b>{fmt(fee)}</b>
        </p>
        <p>
          <span>HST (13%)</span>
          <b>{fmt(tax)}</b>
        </p>
        <p className="tk-total">
          <span>Total today</span>
          <b>{fmt(total)}</b>
        </p>
      </div>
      <p className="sheet-copy">Entry before 11:30 PM. Each pass is a QR code in My Night; send spares to friends from there. Refunds up to 48 hours before doors.</p>
      {state === "declined" && (
        <p className="tk-error" role="alert">
          Your card was declined and nothing was charged. Try another card, or contact your bank.
        </p>
      )}
      <div className="tk-card">
        <span>Visa ending 2048</span>
        <small>Demo card · no real charge</small>
      </div>
      <Button disabled={state === "paying"} onClick={() => pay(false)}>
        {state === "paying" ? "Paying…" : `Pay ${fmt(total)}`}
      </Button>
      <button className="tk-demo-fail" onClick={() => pay(true)} disabled={state === "paying"}>
        Demo: try a declined card
      </button>
    </div>
  )
}
