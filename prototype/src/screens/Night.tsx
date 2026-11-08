import { useState } from "react"
import {
  arrivalDay,
  bottleMenu,
  dateById,
  guestCounts,
  guestSlots,
  mapsUrl,
  media,
  money,
  nextInvitee,
  quote,
  SIGN_STYLES,
  tables,
} from "../data"
import { useApp } from "../store"
import { Avatar, Button, Icon, QR, ShareButton, TopBar } from "../ui"
import { PriceLines } from "./Booking"
import { SignPreview, SignSheet } from "./Sign"

function useBooking() {
  const app = useApp()
  const b = app.state.booking
  const table = tables[b.tableId]
  const date = dateById(b.dateId)
  const q = quote(table, b.bottles, b.sign)
  const counts = guestCounts(b.guests, app.state.invited)
  return { app, b, table, date, q, counts }
}

type PassStatus = "Valid" | "Used" | "Cancelled" | "Refunded" | "Waiting" | "Unassigned"
type Pass = { id: string; holder: string; image?: string; kind: string; status: PassStatus; note: string; mine: boolean }

const passLabel = (s: PassStatus) => (s === "Unassigned" ? "Open" : s === "Waiting" ? "Invited" : s)
const PASS_TONE: Record<PassStatus, string> = { Valid: "green", Used: "gray", Cancelled: "red", Refunded: "amber", Waiting: "blue", Unassigned: "gray" }

/** Every pass on this booking. Each guest only ever sees their own; the host sees all. Demo data. */
function usePasses(): Pass[] {
  const app = useApp()
  const b = app.state.booking
  const slots = guestSlots(b.guests, app.state.invited)
  const list: Pass[] = [{ id: "p-you", holder: app.state.profile.name, image: media.friends, kind: "Table guest · host", status: "Valid", note: "Your pass", mine: true }]
  slots.forEach((s, i) =>
    list.push({
      id: "p-" + i,
      holder: s.name === "Open pass" ? "Open pass" : s.name,
      image: s.image,
      kind: "Table guest",
      status: s.status === "Checked in" ? "Used" : s.status === "Accepted" ? "Valid" : s.status === "Sent" ? "Waiting" : "Unassigned",
      note: s.status === "Checked in" ? "Checked in at 11:52 PM" : s.status === "Sent" ? "Invite sent · not claimed yet" : s.status === "Accepted" ? "Claimed in their app" : "Invite someone to use it",
      mine: false,
    }),
  )
  for (let i = 0; i < app.state.gaTickets; i++) list.push({ id: "ga-" + i, holder: app.state.profile.name, image: media.friends, kind: "General admission", status: "Valid", note: "Entry before 11:30 PM", mine: true })
  list.push({ id: "p-eli", holder: "Chris Morgan", image: media.photographer, kind: "Table guest", status: "Cancelled", note: "Removed by host · pass no longer works", mine: false })
  list.push({ id: "ga-old", holder: app.state.profile.name, image: media.friends, kind: "General admission", status: "Refunded", note: "Refunded to card on Aug 20", mine: true })
  return list
}

function WalletButton({ pass }: { pass: Pass }) {
  const app = useApp()
  const state = app.state.wallet[pass.id]
  const [busy, setBusy] = useState(false)
  if (pass.status !== "Valid")
    return (
      <p className="wallet-unavailable">
        <Icon name="wallet" size={16} /> Apple Wallet isn't available for {passLabel(pass.status).toLowerCase()} passes.
      </p>
    )
  if (state === "added")
    return (
      <div className="wallet-added" role="status">
        <Icon name="check" size={16} /> Added to Apple Wallet
        <button onClick={() => app.toast("Opening Apple Wallet… (demo)")}>Open</button>
      </div>
    )
  const add = () => {
    setBusy(true)
    window.setTimeout(() => {
      setBusy(false)
      const failed = app.state.demo.failWallet || navigator.onLine === false
      app.update((s) => ({ wallet: { ...s.wallet, [pass.id]: failed ? "failed" : "added" } }))
      if (!failed) app.toast("Pass added to Apple Wallet")
    }, 900)
  }
  return (
    <>
      <button className="wallet-btn" onClick={add} disabled={busy} aria-label="Add to Apple Wallet">
        <Icon name="wallet" size={20} />
        <span>{busy ? "Adding…" : "Add to Apple Wallet"}</span>
      </button>
      {state === "failed" && (
        <p className="wallet-failed" role="alert">
          Couldn't add the pass. Check your connection and try again. Your QR code below still works.
        </p>
      )}
      
    </>
  )
}

export function MyNight() {
  const { app, b, table, date, q, counts } = useBooking()
  const passes = usePasses()
  const you = passes[0]
  const openPass = (id: string) => {
    app.update({ activePass: id })
    app.go("ticket")
  }
  const editSign = () =>
    app.openSheet({
      title: b.sign ? "Edit your sign" : "Add a bottle sign",
      eyebrow: "BOTTLE PRESENTATION",
      body: (close) => (
        <SignSheet
          initial={b.sign ?? null}
          bottleIds={q.bottleLines.map((l) => bottleMenu.find((x) => x.name === l.name)!.id)}
          close={close}
          onSave={(s) => {
            app.update((st) => ({ booking: { ...st.booking, sign: s } }))
            app.toast(b.sign ? "Sign updated" : "Sign added to your bottle")
          }}
          onRemove={() => {
            app.update((st) => ({ booking: { ...st.booking, sign: null } }))
            app.toast("Sign removed")
          }}
        />
      ),
    })
  const paid = q.total
  const remaining = q.dueAtVenue
  return (
    <div className="screen">
      <TopBar
        title="My Night"
        back
        action={
          <button className="icon-btn" aria-label="Open group chat" onClick={() => app.openThread("crew")}>
            <Icon name="message" />
          </button>
        }
      />
      <main className="padded mn">
        <header className="mn-head">
          <img src={media.hero} alt="" />
          <span>
            <b>{date.event}</b>
            <small>Nova Room · Toronto</small>
            <small>
              {date.short} · arrive {b.arrival}
              {b.arrival.endsWith("AM") ? " (after midnight)" : ""}
            </small>
          </span>
        </header>

        <section className="mn-entry" aria-label="Your entry">
          <button className="mn-qr" onClick={() => openPass(you.id)} aria-label="View entry QR full screen">
            <QR value={`BU:${b.ref}:${you.id}`} size={132} label="Your entry QR code" />
          </button>
          <div>
            <span className={`srv-chip tone-${PASS_TONE[you.status]}`}>{passLabel(you.status)}</span>
            <b>Your pass</b>
            <small>{b.ref} · show at the door</small>
            <button className="text-btn" onClick={() => openPass(you.id)}>
              View ticket <Icon name="chevron" size={13} />
            </button>
          </div>
        </section>
        <WalletButton pass={you} />

        <section className="mn-section">
          <div className="mn-title">
            <h2>Passes</h2>
            <button onClick={() => app.go("guests")}>Manage</button>
          </div>
          <div className="mn-list">
            {passes.map((p) => (
              <button key={p.id} className="mn-row" onClick={() => openPass(p.id)}>
                {p.image ? <Avatar src={p.image} label={p.holder} /> : <span className="mn-empty-av"><Icon name="user" size={16} /></span>}
                <span>
                  <b>{p.mine && p.id !== "p-you" ? `${p.kind}` : p.holder}</b>
                  <small>{p.note}</small>
                </span>
                <span className={`srv-chip tone-${PASS_TONE[p.status]}`}>{passLabel(p.status)}</span>
              </button>
            ))}
          </div>
          <p className="mn-note">Each guest gets their own pass in their app. They never see how the booking was paid.</p>
        </section>

        <section className="mn-section">
          <h2>Reservation</h2>
          <div className="mn-res">
            <img src={table.image} alt={`${table.name} table`} />
            <span>
              <b>
                {table.name} · {table.level}
              </b>
              <small>
                {b.guests} guests allowed · {counts.joined} in
              </small>
              <small>Package: bottle service, mixers, priority entry</small>
              <small>Ref {b.ref} · Confirmed</small>
            </span>
          </div>
        </section>

        <section className="mn-section">
          <div className="mn-title">
            <h2>Guests</h2>
            <button onClick={() => app.go("guests")}>Invite</button>
          </div>
          <p className="mn-line">
            {counts.joined} of {b.guests} in · {counts.sent} invited · {counts.open} open
          </p>
        </section>

        <section className="mn-section">
          <h2>Orders</h2>
          {q.bottleLines.length ? (
            q.bottleLines.map((l) => (
              <p className="mn-line" key={l.name}>
                {l.name} × {l.qty} · delivered after you arrive
              </p>
            ))
          ) : (
            <p className="mn-line">No bottles pre-ordered. Order from your table on the night.</p>
          )}
          {q.bottleLines.length > 0 &&
            (b.sign ? (
              <div className="mn-sign">
                <SignPreview sign={b.sign} />
                <div>
                  <span>
                    <b>{SIGN_STYLES.find((s) => s.id === b.sign!.style)?.name}</b>
                    <small>
                      With {bottleMenu.find((x) => x.id === b.sign!.bottleId)?.name} · {b.sign.timing.toLowerCase()}
                    </small>
                    {/* Demo status, matching the venue's record for NR-2841. Live updates need the shared backend. */}
                    <small className="mn-sign-status">
                      <i /> Waiting for Nova Room to approve the message · you'll get a notification
                    </small>
                  </span>
                  <button className="text-btn" onClick={editSign}>
                    Edit
                  </button>
                </div>
              </div>
            ) : (
              <button className="sign-offer" onClick={editSign}>
                <span className="sign-offer-icon">
                  <Icon name="spark" size={18} />
                </span>
                <span>
                  <b>Add a sign to your bottle</b>
                  <small>A custom message carried out with it · from $25</small>
                </span>
                <span className="sign-add">Add</span>
              </button>
            ))}
        </section>

        <section className="mn-section">
          <div className="mn-title">
            <h2>Payments</h2>
            <span className="mn-private">
              Only you can see this
            </span>
          </div>
          <div className="mn-pay">
            <div>
              <small>Paid</small>
              <b>{money(paid)}</b>
            </div>
            <div>
              <small>Left to spend at venue</small>
              <b>{remaining ? money(remaining, false) : "$0"}</b>
            </div>
          </div>
          <button className="text-btn" onClick={() => app.go("receipt")}>
            View receipt <Icon name="chevron" size={13} />
          </button>
        </section>

        <div className="mn-quick">
          <a href={mapsUrl} target="_blank" rel="noreferrer">
            <Icon name="map" /> Directions
          </a>
          <button onClick={() => app.openThread("nova")}>
            <Icon name="message" /> Message venue
          </button>
          <button onClick={() => app.go("support")}>
            <Icon name="help" /> Help
          </button>
        </div>
      </main>
    </div>
  )
}

export function Ticket() {
  const app = useApp()
  const b = app.state.booking
  const date = dateById(b.dateId)
  const passes = usePasses()
  const p = passes.find((x) => x.id === app.state.activePass) ?? passes[0]
  const [full, setFull] = useState(false)
  const own = p.mine
  return (
    <div className="screen">
      <TopBar title="Ticket" back fallback="night" />
      <main className="padded tk">
        <div className="tk-switch" role="tablist" aria-label="Passes">
          {passes.map((x) => (
            <button key={x.id} role="tab" aria-selected={x.id === p.id} className={x.id === p.id ? "on" : ""} onClick={() => app.update({ activePass: x.id })}>
              {x.id === "p-you" ? "You" : x.status === "Unassigned" ? `Open pass ${passes.filter((y) => y.status === "Unassigned").indexOf(x) + 1}` : x.kind === "General admission" ? (x.status === "Refunded" ? "GA (refunded)" : "GA ticket") : x.holder.split(" ")[0]}
            </button>
          ))}
        </div>
        <article className={`tk-card status-${p.status.toLowerCase()}`}>
          <div className="tk-top">
            <span>
              <small>{date.weekday.toUpperCase()} · {date.month} {date.day}</small>
              <b>{date.event}</b>
              <small>Nova Room · arrive by {b.arrival}</small>
            </span>
            <span className={`srv-chip tone-${PASS_TONE[p.status]}`}>{passLabel(p.status)}</span>
          </div>
          <div className="tk-holder">
            <small>{p.kind}</small>
            <b>{p.holder}</b>
          </div>
          {p.status === "Valid" && own ? (
            <button className="tk-qr" onClick={() => setFull(true)} aria-label="View entry QR full screen">
              <QR value={`BU:${b.ref}:${p.id}`} size={190} label={`Entry QR for ${p.holder}`} />
              <small>Tap to enlarge</small>
            </button>
          ) : (
            <div className="tk-noqr">
              <Icon name={p.status === "Used" ? "check" : p.status === "Cancelled" || p.status === "Refunded" ? "close" : "users"} size={26} />
              <p>
                {p.status === "Used"
                  ? "Already scanned at the door."
                  : p.status === "Cancelled"
                    ? "This pass was cancelled and won't scan."
                    : p.status === "Refunded"
                      ? "This ticket was refunded and won't scan."
                      : p.status === "Unassigned"
                        ? "Invite a guest to give them this pass."
                        : `${p.holder.split(" ")[0]} sees their own QR code in their app.`}
              </p>
            </div>
          )}
          {p.status !== "Unassigned" && <small className="tk-note">{p.note}</small>}
        </article>
        {own && <WalletButton pass={p} />}
        {p.status === "Unassigned" && (
          <Button className="full-width" onClick={() => app.go("guests")}>
            Invite a guest
          </Button>
        )}
      </main>
      {full && (
        <div className="tk-full" role="dialog" aria-modal="true" aria-label="Entry QR" onClick={() => setFull(false)}>
          <QR value={`BU:${b.ref}:${p.id}`} size={280} label={`Entry QR for ${p.holder}`} />
          <b>{p.holder}</b>
          <small>
            {b.ref} · {date.event}
          </small>
          <Button variant="secondary" onClick={() => setFull(false)}>
            Done
          </Button>
        </div>
      )}
    </div>
  )
}

export function Guests() {
  const { app, b, counts } = useBooking()
  const [name, setName] = useState("")
  const slots = guestSlots(b.guests, app.state.invited)
  const invite = () => {
    const who = name.trim() || nextInvitee(app.state.invited)
    if (!who || counts.open === 0) return
    app.update((s) => ({ invited: [...s.invited, who] }))
    app.toast(`Pass sent to ${who}`)
    setName("")
  }
  return (
    <div className="screen">
      <TopBar
        title="Guests & passes"
        back
        fallback="night"
        action={
          <button className="icon-btn" aria-label="Open group chat" onClick={() => app.openThread("crew")}>
            <Icon name="message" />
          </button>
        }
      />
      <main className="padded">
        <div className="pass-summary">
          <span>
            <b>{counts.passes}</b>
            <small>passes</small>
          </span>
          <i />
          <span>
            <b>{counts.joined}</b>
            <small>in (incl. you)</small>
          </span>
          <i />
          <span>
            <b>{counts.sent}</b>
            <small>sent</small>
          </span>
          <i />
          <span>
            <b>{counts.open}</b>
            <small>available</small>
          </span>
        </div>
        <div className="section-title">
          <b>Saturday Crew</b>
          <button onClick={() => app.openThread("crew")}>Group chat</button>
        </div>
        <div className="guest-list">
          <div>
            <Avatar src={media.friends} label={app.state.profile.name} />
            <span>
              <b>{app.state.profile.name} (you)</b>
              <small>Host</small>
            </span>
            <em className="checked">Host</em>
          </div>
          {slots.map((s, i) =>
            s.status === "Open pass" ? (
              <div key={`open-${i}`} className="open-slot">
                <span className="avatar empty-avatar">
                  <Icon name="ticket" size={18} />
                </span>
                <span>
                  <b>Open pass</b>
                  <small>Not sent yet</small>
                </span>
                <em>Available</em>
              </div>
            ) : (
              <div key={s.name + i}>
                {s.image ? (
                  <Avatar src={s.image} label={s.name} />
                ) : (
                  <span className="avatar empty-avatar">
                    <Icon name="user" size={18} />
                  </span>
                )}
                <span>
                  <b>{s.name}</b>
                  <small>{s.status === "Sent" ? "Waiting to accept" : s.status}</small>
                </span>
                <em className={s.status === "Checked in" ? "checked" : ""}>{s.status}</em>
              </div>
            ),
          )}
        </div>
        {counts.open > 0 ? (
          <form
            className="invite-box"
            onSubmit={(e) => {
              e.preventDefault()
              invite()
            }}
          >
            <Icon name="send" />
            <span>
              <b>Send a pass</b>
              <input id="invite-name" value={name} onChange={(e) => setName(e.target.value)} placeholder={`Username, phone or email (or ${nextInvitee(app.state.invited) ?? "a friend"})`} aria-label="Who should get the pass?" />
            </span>
          </form>
        ) : (
          <div className="night-info-note">
            <Icon name="check" />
            <span>
              <b>Every pass is sent</b>
              <small>Add guests by editing your booking group size.</small>
            </span>
          </div>
        )}
        <Button className="full-width" onClick={invite} disabled={counts.open === 0}>
          {counts.open === 0 ? "All passes sent" : `Send pass to ${name.trim() || nextInvitee(app.state.invited) || "guest"}`}
        </Button>
        <p className="legal">Each QR pass is individual and can only be accepted by one guest. Demo data only.</p>
      </main>
    </div>
  )
}

export function Receipt() {
  const { app, b, table, date, q } = useBooking()
  return (
    <div className="screen">
      <TopBar title="Receipt" back fallback="night" action={<ShareButton what="receipt" />} />
      <main className="padded receipt-body">
        <div className="receipt-success">
          <span>
            <Icon name="check" />
          </span>
          <b>Paid</b>
          <small>Nova Room · Booking {b.ref}</small>
        </div>
        <div className="receipt-card">
          <div className="summary-event">
            <img src={table.image} alt="" />
            <span>
              <b>{table.name}</b>
              <small>
                {date.event} · {date.short}
              </small>
              <small>
                {b.guests} guest{b.guests === 1 ? "" : "s"} · {b.guests} entry pass{b.guests === 1 ? "" : "es"}
              </small>
            </span>
          </div>
          <PriceLines q={q} mode="receipt" />
        </div>
        {app.state.ticketOrders.map((o) => (
          <div className="receipt-card tk-receipt" key={o.ref}>
            <b>EONICS: Afterglow · General admission × {o.qty}</b>
            <small>
              Order {o.ref} · {o.date} · Visa ending 2048 (demo)
            </small>
            <p>
              <span>Paid</span>
              <strong>${(o.total / 100).toFixed(2)}</strong>
            </p>
          </div>
        ))}
        <Button className="full-width" onClick={() => app.back("night")}>
          Back to My Night
        </Button>
      </main>
    </div>
  )
}

const prompts = ["Great atmosphere", "Helpful staff", "Easy entry", "Table matched photos"]

export function Review() {
  const { app, table, date } = useBooking()
  const [rating, setRating] = useState(5)
  const [picked, setPicked] = useState<string[]>(["Great atmosphere"])
  const [text, setText] = useState(`The ${table.name} had a great view and our host made the night effortless.`)
  return (
    <div className="screen">
      <TopBar title="Review your night" back fallback="night" />
      <main className="padded review-body">
        <div className="review-venue">
          <img src={media.venue} alt="" />
          <span>
            <b>How was Nova Room?</b>
            <small>
              {date.event} · {table.name}
            </small>
          </span>
        </div>
        <div className="rating-row" role="radiogroup" aria-label="Rating">
          {[1, 2, 3, 4, 5].map((n) => (
            <button key={n} role="radio" aria-checked={n === rating} aria-label={`${n} star${n === 1 ? "" : "s"}`} onClick={() => setRating(n)}>
              <Icon name="star" filled={n <= rating} />
            </button>
          ))}
        </div>
        <div className="review-prompts">
          {prompts.map((p) => (
            <button key={p} className={picked.includes(p) ? "selected" : ""} aria-pressed={picked.includes(p)} onClick={() => setPicked(picked.includes(p) ? picked.filter((x) => x !== p) : [...picked, p])}>
              {p}
            </button>
          ))}
        </div>
        <textarea id="review-text" className="review-field" value={text} onChange={(e) => setText(e.target.value)} aria-label="Your review" placeholder="Tell others about your night" />
        <Button
          className="full-width"
          onClick={() => {
            app.toast("Review submitted")
            app.update({ composeMode: "Recap", composeMembers: false })
            app.go("composer")
          }}
        >
          Submit & share a recap
        </Button>
        <button
          className="text-link center"
          onClick={() => {
            app.toast("Review submitted privately")
            app.go("home", { reset: true })
          }}
        >
          Submit privately
        </button>
      </main>
    </div>
  )
}

export function Support() {
  const { app, b, table, date } = useBooking()
  return (
    <div className="screen">
      <TopBar
        title="Booking support"
        back
        fallback="night"
        action={
          <button className="icon-btn" aria-label="Message support" onClick={() => app.openThread("support")}>
            <Icon name="message" />
          </button>
        }
      />
      <main className="padded">
        <div className="support-hero">
          <span>
            <Icon name="check" />
          </span>
          <div>
            <b>Your host is online</b>
            <small>Typical reply in under 2 minutes</small>
          </div>
        </div>
        <div className="settings-section-title">How can we help?</div>
        <div className="support-options">
          {["I need venue assistance", "A guest cannot access their pass", "Question about my payment", "Report a safety concern"].map((x) => (
            <button key={x} onClick={() => app.openThread("support", x + ".")}>
              <span>{x}</span>
              <Icon name="chevron" />
            </button>
          ))}
        </div>
        <div className="booking-reference">
          <small>LINKED BOOKING</small>
          <b>
            {table.name} · {b.ref}
          </b>
          <span>
            Nova Room · {date.short} · {b.guests} guest{b.guests === 1 ? "" : "s"}
          </span>
        </div>
        <Button className="full-width" onClick={() => app.openThread("support")}>
          Message support
        </Button>
      </main>
    </div>
  )
}
