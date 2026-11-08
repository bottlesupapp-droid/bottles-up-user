import { useState } from "react"
import { media, mapsUrl, tables, type TableId } from "../data"
import { useApp } from "../store"
import { BackGlass, Button, Icon, OptionList, type IconName } from "../ui"
import { GalleryViewer, HeroCarousel, PhotoSection, useVenuePhotos, type VenuePhoto } from "./VenuePhotos"

const UPCOMING = [
  { when: "Tonight", date: "Sat, Aug 24", time: "10 PM", title: "EONICS: Afterglow", price: "Tickets from $35", image: media.hero },
  { when: "Next Friday", date: "Fri, Aug 30", time: "10 PM", title: "Nova Fridays", price: "Entry from $20", image: media.stage },
  { when: "Next Saturday", date: "Sat, Aug 31", time: "9 PM", title: "Neon Garden with Amara Vale", price: "Tickets from $30", image: media.crowd },
]
const DETAILS: [IconName, string, string][] = [
  ["clock", "Hours", "Fri–Sat · 10 PM – 3 AM · last entry 1:30 AM"],
  ["music", "Music", "Afro house · R&B · amapiano"],
  ["user", "Dress code", "Smart evening wear"],
  ["ticket", "Age", "19+ · physical ID required"],
  ["users", "Accessibility", "Step-free entry · accessible washroom"],
]

export function Venue() {
  const app = useApp()
    const following = app.state.following.includes("nova")
  const [aboutOpen, setAboutOpen] = useState(false)
  const photos = useVenuePhotos()
  const [viewer, setViewer] = useState<{ list: VenuePhoto[]; i: number } | null>(null)
  const jump = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" })
  const openTable = (tableId: TableId) => {
    app.update({ tableId })
    app.go("table")
  }
  const openMenu = () =>
    app.openSheet({
      title: "Nova Room",
      eyebrow: "VENUE",
      body: (close) => (
        <OptionList
          close={close}
          options={[
            { label: app.state.saved.includes("venue") ? "Remove from saved" : "Save venue", icon: "bookmark", onSelect: () => app.toggleIn("saved", "venue", "Nova Room") },
            { label: "Copy link", icon: "link", onSelect: () => app.share("Nova Room") },
            { label: "Report venue", detail: "Our safety team reviews every report", icon: "flag", danger: true, onSelect: () => app.toast("Report sent. Thanks for keeping BottlesUp safe.") },
          ]}
        />
      ),
    })
  return (
    <div className="screen overlay-screen">
      <div className="venue-hero">
        <HeroCarousel photos={photos} onOpen={(i) => setViewer({ list: photos, i })} />
        <div className="venue-overlay" />
        <div className="floating-nav">
          <BackGlass fallback="explore" />
          <div>
            <button className="glass-btn" aria-label="Share Nova Room" onClick={() => app.share("Nova Room")}>
              <Icon name="share" />
            </button>
            <button className="glass-btn" aria-label="More options" onClick={openMenu}>
              <Icon name="menu" />
            </button>
          </div>
        </div>
        <div className="venue-identity">
          <span className="eyebrow">VENUE</span>
          <div className="venue-name">
            Nova Room{" "}
            <span className="verified" aria-label="Verified">
              <Icon name="check" size={12} />
            </span>
          </div>
          <p>Music, art and late nights above the city.</p>
        </div>
      </div>
      <main className="padded venue-content venue-v2">
        <p className="vv-meta">
          <span>
            <Icon name="map" size={14} /> King West · 19 Mercer St
          </span>
          <button onClick={() => jump("vv-reviews")}>
            <Icon name="star" size={14} /> 4.8 <small>(312)</small>
          </button>
          <span>$$$ · Open until 3 AM</span>
        </p>
        <Button className="full-width vv-book" onClick={() => openTable("halo")}>
          Book a Table
        </Button>
        <div className="vv-secondary">
          <button className={following ? "on" : ""} aria-pressed={following} onClick={() => app.toggleIn("following", "nova", "Nova Room")}>
            <Icon name={following ? "check" : "plus"} size={16} /> {following ? "Following" : "Follow"}
          </button>
          <button onClick={() => app.openThread("nova")}>
            <Icon name="message" size={16} /> Message
          </button>
          <button onClick={() => app.share("Nova Room")}>
            <Icon name="share" size={16} /> Share
          </button>
        </div>
        <nav className="vv-jump" aria-label="Venue sections">
          {[
            ["vv-upcoming", "Upcoming"],
            ["vv-tables", "Tables"],
            ["vv-menu", "Menu"],
            ["vv-reviews", "Reviews"],
            ["vv-photos", "Photos"],
          ].map(([id, label]) => (
            <button key={id} onClick={() => jump(id)}>
              {label}
            </button>
          ))}
        </nav>

        {/* Perks Nova Room gave this account (Jordan Ellis is a linked VIP client in BottlesUp Business). Demo data. */}
        <section className="vv-section vv-perks" aria-label="Your perks at Nova Room">
          <h2>Your perks here</h2>
          <p className="vv-perks-sub">From Nova Room · show your profile at the door to use them</p>
          {[
            { kind: "Priority entry", detail: "Skip the line with up to 6 guests", state: "5 of 12 left · until Dec 31", tone: "ok" },
            { kind: "Birthday benefit", detail: "Complimentary champagne on your birthday visit", state: "1 left · use by Sat, Aug 31", tone: "ok" },
            { kind: "Guest passes", detail: "Free guest-list spots", state: "Expired Aug 1 · all 4 used", tone: "off" },
          ].map((pk) => (
            <div key={pk.kind} className={`vv-perk ${pk.tone}`}>
              <span>
                <b>{pk.kind}</b>
                <small>{pk.detail}</small>
              </span>
              <em>{pk.state}</em>
            </div>
          ))}
        </section>
        <section id="vv-upcoming" className="vv-section">
          <h2>Upcoming</h2>
          <div className="vv-list">
            {UPCOMING.map((e) => (
              <button key={e.title} className="vv-event" onClick={() => app.go("event")}>
                <img src={e.image} alt="" />
                <span>
                  <em>{e.when}</em>
                  <b>{e.title}</b>
                  <small>
                    {e.date} · {e.time} · {e.price}
                  </small>
                </span>
                <Icon name="chevron" size={16} />
              </button>
            ))}
          </div>
        </section>

        <section className="vv-section">
          <h2>About</h2>
          <p className="vv-about">
            A two-level music room built for immersive sound, skyline views and intimate late-night sets.
            {aboutOpen && " The upper level holds six private booths overlooking the stage; the main floor has larger tables for groups of up to eight. Resident nights run Friday and Saturday, with guest DJs most weekends."}{" "}
            <button onClick={() => setAboutOpen(!aboutOpen)}>{aboutOpen ? "Show less" : "Read more"}</button>
          </p>
          <div className="vv-details">
            {DETAILS.map(([icon, label, value]) => (
              <div key={label}>
                <Icon name={icon} size={18} />
                <span>
                  <small>{label}</small>
                  <b>{value}</b>
                </span>
              </div>
            ))}
            <a href={mapsUrl} target="_blank" rel="noreferrer">
              <Icon name="map" size={18} />
              <span>
                <small>Parking</small>
                <b>Paid lot on Mercer · rideshare zone</b>
              </span>
              <Icon name="chevron" size={15} />
            </a>
          </div>
        </section>

        <section id="vv-tables" className="vv-section">
          <h2>Tables</h2>
          <div className="vv-list">
            {(["halo", "arc"] as TableId[]).map((id) => {
              const t = tables[id]
              return (
                <button className="vv-table" key={id} onClick={() => openTable(id)}>
                  <img src={t.image} alt={`${t.name} photo`} />
                  <span>
                    <b>{t.name}</b>
                    <small>
                      {t.level} · up to {t.capacity} guests
                    </small>
                    <small className="vv-price">
                      ${t.minimum.toLocaleString("en-CA")} minimum spend · ${t.deposit} deposit to reserve, counted toward your spend
                    </small>
                  </span>
                  <Icon name="chevron" size={16} />
                </button>
              )
            })}
          </div>
        </section>

        <section id="vv-menu" className="vv-section">
          <h2>Menu</h2>
          <div className="vv-menu">
            <img src={media.bottles} alt="" />
            <span>
              <b>Bottle service</b>
              <small>Don Julio 1942 · Dom Pérignon · Grey Goose · from $650, mixers included. Add bottles when you book a table.</small>
            </span>
          </div>
        </section>

        <section id="vv-reviews" className="vv-section">
          <h2>Reviews</h2>
          <div className="vv-rating">
            <strong>4.8</strong>
            <span>
              <b>312 verified reviews</b>
              <small>From guests who booked through BottlesUp · demo data</small>
            </span>
          </div>
          {[
            ["Maya C.", "The table matched the photos exactly. Host was on it all night."],
            ["Noah R.", "Sound system is unreal. Book the upper level for the view."],
          ].map(([who, text]) => (
            <blockquote key={who} className="vv-review">
              “{text}” <cite>{who}</cite>
            </blockquote>
          ))}
        </section>

        <div id="vv-photos">
          <PhotoSection onOpen={(list, i) => setViewer({ list, i })} />
        </div>
        <Button variant="secondary" className="full-width" onClick={() => app.openThread("nova", "Hi! I'd like to host an event at Nova Room. What dates are open?")}>
          Host your event here
        </Button>
      </main>
      {viewer && <GalleryViewer photos={viewer.list} start={viewer.i} onClose={() => setViewer(null)} />}
    </div>
  )
}
