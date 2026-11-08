import { media, tables, dateById, guestCounts } from "../data"
import { useApp } from "../store"
import { Icon, OptionList, TopBar } from "../ui"
import { FEED, PostCard } from "./Posts"

function Stories() {
  const app = useApp()
  const newStory = () => {
    app.update({ cameraMode: "Story" })
    app.go("camera")
  }
  const items: [string, string][] = [
    ["Your story", media.friends],
    ["EONICS", media.dj],
    ["Nova Room", media.venue],
    ["Maya", media.friends],
    ["Afterdark", media.stage],
  ]
  return (
    <section className="stories-block" aria-label="Stories">
      <div className="stories">
        {items.map(([name, src], index) => (
          <button className="story" key={name} aria-label={index === 0 ? "Add to your story" : `View ${name}'s story`} onClick={() => (index === 0 ? newStory() : app.go("reel"))}>
            <span className={`story-avatar ${index === 0 ? "your-story" : ""}`}>
              <img src={src} alt="" />
              {index === 0 && (
                <span className="story-plus">
                  <Icon name="plus" size={11} />
                </span>
              )}
            </span>
            <span>{name}</span>
          </button>
        ))}
      </div>
    </section>
  )
}

export function useCityPicker() {
  const app = useApp()
  return () =>
    app.openSheet({
      title: "Choose a city",
      eyebrow: "LOCATION",
      body: (close) => (
        <OptionList
          close={close}
          options={[
            { label: "Toronto", detail: app.state.city === "Toronto" ? "Current city" : "Available now", icon: "map", onSelect: () => app.update({ city: "Toronto" }) },
            { label: "Montreal", detail: "Coming soon", icon: "map", disabled: true },
            { label: "Vancouver", detail: "Coming soon", icon: "map", disabled: true },
            { label: "Calgary", detail: "Coming soon", icon: "map", disabled: true },
          ]}
        />
      ),
    })
}

export function Home() {
  const app = useApp()
  const { state } = app
  const booking = state.booking
  const counts = guestCounts(booking.guests, state.invited)
  return (
    <div className="screen">
      <TopBar
        action={
          <div className="home-actions">
            <button className="icon-btn" aria-label="Reels" onClick={() => app.go("reel")}>
              <Icon name="reels" />
            </button>
            <button className="icon-btn notification-btn" aria-label="Notifications" onClick={() => app.go("notifications")}>
              <Icon name="bell" />
              {!state.notificationsRead && <i className="dot-badge" />}
            </button>
          </div>
        }
      />
      <main>
        <button className="night-card" onClick={() => app.go("night")}>
          <span className="night-card-icon">
            <Icon name="moon" />
          </span>
          <span>
            <b>My Night · {dateById(booking.dateId).short}</b>
            <small>
              {tables[booking.tableId].name} · arrive {booking.arrival} · {counts.joined} of {booking.guests} in
            </small>
          </span>
          <Icon name="chevron" size={18} />
        </button>
        <Stories />
        {FEED.map((p) => (
          <PostCard key={p.id} p={p} />
        ))}
        <section className="home-discovery">
          <div className="section-title">
            <b>Suggested for {state.city}</b>
            <button onClick={() => app.go("explore")}>Explore all</button>
          </div>
          <div className="suggestion-row">
            <button onClick={() => app.go("professional")}>
              <img src={media.pro} alt="Amara Vale" />
              <span>
                <b>Amara Vale</b>
                <small>Afro house DJ</small>
              </span>
              <em>{state.following.includes("amara") ? "Following" : "View"}</em>
            </button>
            <button onClick={() => app.go("event")}>
              <img src={media.stage} alt="Afterglow stage" />
              <span>
                <b>Afterglow</b>
                <small>Saturday · Nova</small>
              </span>
              <em>View</em>
            </button>
          </div>
        </section>
      </main>
    </div>
  )
}
