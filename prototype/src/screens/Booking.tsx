import { SignCard } from "./Sign"
import { useEffect, useRef, useState } from "react"
import {
  arrivalDay,
  arrivalShortDay,
  arrivalTimes,
  bottleCount,
  bottleMenu,
  dateById,
  media,
  money,
  nightDates,
  quote,
  tables,
  MAX_BOTTLES,
  UNAVAILABLE,
  type Quote,
  type TableId,
  signCheck,
} from "../data"
import { useApp, type PaymentState } from "../store"
import { BackGlass, Button, Icon, OptionList, ShareButton, TopBar } from "../ui"

const HOLD_MS = 10 * 60 * 1000

export function useDatePicker() {
  const app = useApp()
  return (after?: () => void) =>
    app.openSheet({
      title: "Choose your night",
      eyebrow: "DATE",
      body: (close) => (
        <OptionList
          close={close}
          options={nightDates.map((d) => ({
            label: d.label,
            detail: d.event + (app.state.dateId === d.id ? " · Selected" : ""),
            icon: "calendar",
            onSelect: () => {
              app.update({ dateId: d.id })
              after?.()
            },
          }))}
        />
      ),
    })
}

const gallery = [media.table, media.bottles, media.stage, media.venue, media.crowd, media.hero]

export function TableDetail() {
  const app = useApp()
  const { state } = app
  const table = tables[state.tableId]
  const dateSelected = state.dateId !== null
  const date = dateById(state.dateId)
  const [plan, setPlan] = useState(false)
  const [photo, setPhoto] = useState(0)
  const pickDate = useDatePicker()
  const images = [table.image, ...gallery.filter((g) => g !== table.image)]
  const selectTable = (id: TableId) => app.update({ tableId: id, guests: Math.min(state.guests, tables[id].capacity) })
  const startCheckout = () => {
    app.update({ checkoutStep: 1, paymentState: "ready", guests: Math.min(state.guests, table.capacity) })
    app.go("checkout")
  }
  return (
    <div className="screen overlay-screen">
      <div className="table-hero">
        <button className="hero-photo" aria-label="Next photo" onClick={() => setPhoto((photo + 1) % images.length)}>
          <img src={images[photo]} alt={`${table.name} photo ${photo + 1} of ${images.length}`} />
        </button>
        <div className="floating-nav">
          <BackGlass fallback="venue" />
          <ShareButton what={table.name} className="glass-btn" />
        </div>
        <span className="image-count">
          <Icon name="camera" size={15} /> {photo + 1} / {images.length}
        </span>
      </div>
      <main className="padded table-content">
        <span className="eyebrow">{table.level.toUpperCase()} · DEMO LISTING</span>
        <div className="display-title">{table.name}</div>
        <button className="venue-link" onClick={() => app.go("venue")}>
          <span>
            <b>Nova Room</b>
            <small>View full venue profile</small>
          </span>
          <Icon name="chevron" />
        </button>
        <div className="date-availability">
          <span>
            <b>Your night</b>
            <small>{dateSelected ? `${date.label} · ${date.event}` : "Choose a date to see pricing and availability"}</small>
          </span>
          <button onClick={() => pickDate()}>{dateSelected ? "Change" : "Choose date"}</button>
        </div>
        {plan ? (
          <div className="plan-preview open">
            <div className="floor-plan">
              <span className="stage-label">DJ / STAGE</span>
              {[1, 2, 3, 4, 5, 6].map((n) => {
                const id = (Object.keys(tables) as TableId[]).find((k) => tables[k].planNumber === n)
                return (
                  <button
                    key={n}
                    className={id === state.tableId ? "selected-table" : id ? "" : "unavailable"}
                    disabled={!id}
                    aria-label={id ? `Table ${n}: ${tables[id].name}` : `Table ${n}: unavailable`}
                    onClick={() => id && selectTable(id)}
                  >
                    {n}
                  </button>
                )
              })}
              <small>
                <b></b> Selected <b></b> Available <b></b> Unavailable
              </small>
            </div>
            <button className="text-link center" onClick={() => setPlan(false)}>
              Hide floor plan
            </button>
          </div>
        ) : (
          <button className="plan-preview" onClick={() => setPlan(true)}>
            <span className="plan-icon">
              <Icon name="map" />
            </span>
            <span>
              <b>See where you’ll be</b>
              <small>View on interactive floor plan</small>
            </span>
            <Icon name="chevron" />
          </button>
        )}
        <div className="capacity-row">
          <div>
            <Icon name="users" />
            <span>
              <b>Up to {table.capacity} guests</b>
              <small>Seating capacity</small>
            </span>
          </div>
          <div>
            <Icon name="ticket" />
            <span>
              <b>1 pass per guest</b>
              <small>Admission included</small>
            </span>
          </div>
        </div>
        <section className="content-section">
          <div className="section-title">
            <b>Your table includes</b>
          </div>
          <ul className="check-list">
            <li>
              <Icon name="check" />
              Dedicated host for the evening
            </li>
            <li>
              <Icon name="check" />
              Standard mixers and ice service
            </li>
            <li>
              <Icon name="check" />
              Priority venue entry before midnight
            </li>
          </ul>
        </section>
        {dateSelected ? (
          <section className="spend-card">
            <span>
              <small>TABLE MINIMUM</small>
              <b>${table.minimum.toLocaleString("en-CA")}</b>
            </span>
            <span>
              <small>DEPOSIT TODAY</small>
              <b>${table.deposit}</b>
            </span>
            <p>Your deposit counts toward the minimum. If you pre-order bottles, it's taken off their price, not added on top.</p>
          </section>
        ) : (
          <div className="pricing-prompt">
            <Icon name="calendar" />
            <span>
              <b>Pricing appears after you choose a night</b>
            </span>
          </div>
        )}
        <section className="content-section">
          <div className="section-title">
            <b>Good to know</b>
          </div>
          <div className="policy-list">
            <p>
              <b>Arrival</b>
              <span>Saturday-night session. Arrive between 11:30 PM Saturday and 1:30 AM Sunday.</span>
            </p>
            <p>
              <b>Cancellation</b>
              <span>Full deposit refund up to 48 hours before.</span>
            </p>
            <p>
              <b>Dress code</b>
              <span>Smart evening wear. No athletic wear.</span>
            </p>
          </div>
        </section>
        <div className="sticky-action">
          <div>
            <small>{dateSelected ? "Deposit today" : "Availability"}</small>
            <b>{dateSelected ? `$${table.deposit}` : "Select a date"}</b>
          </div>
          <Button onClick={() => (dateSelected ? startCheckout() : pickDate())}>{dateSelected ? "Reserve this table" : "Choose a date"}</Button>
        </div>
      </main>
    </div>
  )
}

export function PriceLines({ q, mode }: { q: Quote; mode: "checkout" | "receipt" }) {
  return (
    <>
      <div className="line">
        <span>Table deposit</span>
        <b>{money(q.deposit)}</b>
      </div>
      {q.bottleLines.map((l) => (
        <div className="line" key={l.name}>
          <span>
            {l.name} × {l.qty}
          </span>
          <b>{money(l.amount)}</b>
        </div>
      ))}
      {q.signLine && (
        <div className="line">
          <span>{q.signLine.name}</span>
          <b>{money(q.signLine.amount)}</b>
        </div>
      )}
      {q.credit > 0 && (
        <div className="line credit">
          <span>Deposit credit</span>
          <b>−{money(q.credit)}</b>
        </div>
      )}
      <div className="line">
        <span>Service fee</span>
        <b>{money(q.fee)}</b>
      </div>
      <div className="line">
        <span>HST (13%)</span>
        <b>{money(q.tax)}</b>
      </div>
      <div className="total-row">
        <span>
          <b>{mode === "checkout" ? "Due today" : "Total paid"}</b>
          <small>Visa ending 2048</small>
        </span>
        <b>{money(q.total)}</b>
      </div>
      <div className={q.dueAtVenue === 0 ? "due-venue" : "due-venue pending"}>
        <Icon name={q.dueAtVenue === 0 ? "check" : "clock"} />
        <span>
          <b>{q.dueAtVenue === 0 ? "Due at venue: $0" : `Due at venue: ${money(q.dueAtVenue, false)} minimum spend`}</b>
          <small>
            {q.dueAtVenue === 0
              ? "Your bottles meet the table minimum."
              : q.bottleTotal > 0
                ? `Your bottles cover ${money(q.applied, false)} of the ${money(q.minimum, false)} minimum. Food and drinks at the venue count toward the rest.`
                : `Your ${money(q.deposit, false)} deposit already counts toward the ${money(q.minimum, false)} minimum. Food and drinks at Nova Room cover the rest.`}
          </small>
        </span>
      </div>
    </>
  )
}

function useCountdown(until: number | null) {
  const [now, setNow] = useState(() => Date.now())
  useEffect(() => {
    if (!until) return
    const id = window.setInterval(() => setNow(Date.now()), 1000)
    return () => window.clearInterval(id)
  }, [until])
  return until ? Math.max(0, until - now) : HOLD_MS
}

export function Checkout() {
  const app = useApp()
  const { state, update } = app
  const { checkoutStep: step, arrival, guests, bottles, paymentState } = state
  const table = tables[state.tableId]
  const date = dateById(state.dateId)
  const count = bottleCount(bottles)
  const sign = count > 0 ? state.sign : null
  const q = quote(table, bottles, sign)
  const chosen = bottleMenu.filter((b) => (bottles[b.id] ?? 0) > 0).map((b) => b.id)
  const [menuOpen, setMenuOpen] = useState(false)
  const [signTried, setSignTried] = useState(false)
  const pickDate = useDatePicker()
  const payTimer = useRef<number | null>(null)
  const remaining = useCountdown(step === 3 ? state.holdUntil : null)

  useEffect(() => () => {
    if (payTimer.current) window.clearTimeout(payTimer.current)
  }, [])
  useEffect(() => {
    if (step === 3 && state.holdUntil && remaining === 0 && paymentState === "ready") update({ paymentState: "expired" })
  }, [remaining, step, state.holdUntil, paymentState, update])

  const setQty = (id: string, qty: number) => {
    const others = count - (bottles[id] ?? 0)
    const next = Math.max(0, Math.min(qty, MAX_BOTTLES - others))
    update({ bottles: { ...bottles, [id]: next } })
  }
  const restartHold = () => update({ holdUntil: Date.now() + HOLD_MS, paymentState: "ready" })

  const next = () => {
    if (step === 1) return update({ checkoutStep: 2 })
    if (step === 2) {
      if (sign && signCheck(sign.text)) {
        setSignTried(true)
        document.querySelector(".sign-card")?.scrollIntoView({ behavior: "smooth", block: "center" })
        return
      }
      return update({ checkoutStep: 3, holdUntil: Date.now() + HOLD_MS, paymentState: "ready", sign: sign ? { ...sign, bottleId: chosen.includes(sign.bottleId) ? sign.bottleId : chosen[0] } : null })
    }
    if (paymentState === "processing") return
    if (paymentState === "expired") return restartHold()
    if (paymentState !== "ready") return update({ paymentState: "ready" })
    update({ paymentState: "processing" })
    payTimer.current = window.setTimeout(() => {
      const ref = "NR-" + String(Math.floor(1000 + Math.random() * 9000))
      app.update({
        paymentState: "ready",
        checkoutStep: 1,
        holdUntil: null,
        invited: [],
        booking: { ref, tableId: table.id, dateId: date.id, arrival, guests, bottles: { ...bottles }, sign },
        sign: null,
      })
      app.go("confirmation", { reset: true })
    }, 900)
  }
  const mm = String(Math.floor(remaining / 60000)).padStart(2, "0")
  const ss = String(Math.floor((remaining % 60000) / 1000)).padStart(2, "0")
  const featured = bottleMenu[0]
  const moreBottles = bottleMenu.slice(1)
  const shownStates: PaymentState[] = ["ready", "declined", "cancelled", "expired"]
  return (
    <div className="screen">
      <TopBar
        title={`Reserve ${table.name}`}
        back
        onBack={() => (step > 1 ? update({ checkoutStep: step - 1 }) : app.back("table"))}
        action={<span className="step-count">{step}/3</span>}
      />
      <main className="padded checkout">
        <div className="progress" aria-label={`Step ${step} of 3`}>
          {[1, 2, 3].map((n) => (
            <span key={n} className={n <= step ? "done" : ""} />
          ))}
        </div>
        {step === 1 && (
          <>
            <span className="eyebrow">NIGHT & GROUP</span>
            <div className="display-title">When are you going?</div>
            <button className="choice selected-choice" onClick={() => pickDate()}>
              <span className="date-tile">
                <b>{date.day}</b>
                <small>{date.month}</small>
              </span>
              <span>
                <b>{date.weekday} night</b>
                <small>{date.event} · Tap to change</small>
              </span>
              <Icon name="check" />
            </button>
            <div className="field-label">Arrival time</div>
            <div className="choice-grid">
              {arrivalTimes.map((time) => (
                <button key={time} className={arrival === time ? "selected" : ""} aria-pressed={arrival === time} onClick={() => update({ arrival: time })}>
                  {time}
                </button>
              ))}
            </div>
            <div className="midnight-note">
              <Icon name="clock" />
              <span>
                <b>{arrivalDay(arrival) === "Saturday" ? "Saturday arrival" : "After-midnight arrival"}</b>
                <small>
                  Saturday nightlife session · arrival {arrivalDay(arrival)} at {arrival}.
                </small>
              </span>
            </div>
            <div className="field-label">Group size · up to {table.capacity}</div>
            <div className="counter">
              <button aria-label="Fewer guests" disabled={guests <= 1} onClick={() => update({ guests: Math.max(1, guests - 1) })}>
                −
              </button>
              <span>
                <b>{guests}</b>
                <small>guest{guests === 1 ? "" : "s"} · {guests} pass{guests === 1 ? "" : "es"}</small>
              </span>
              <button aria-label="More guests" disabled={guests >= table.capacity} onClick={() => update({ guests: Math.min(table.capacity, guests + 1) })}>
                +
              </button>
            </div>
          </>
        )}
        {step === 2 && (
          <>
            <span className="eyebrow">MAKE IT YOURS</span>
            <div className="display-title">Add a bottle?</div>
            <p className="lead">
              Bottle purchases count toward your {money(q.minimum, false)} table minimum. Up to {MAX_BOTTLES} bottles.
            </p>
            <BottleRow bottle={featured} qty={bottles[featured.id] ?? 0} setQty={setQty} image={media.bottles} canAdd={count < MAX_BOTTLES} />
            {menuOpen && moreBottles.map((b) => <BottleRow key={b.id} bottle={b} qty={bottles[b.id] ?? 0} setQty={setQty} canAdd={count < MAX_BOTTLES} unavailable={(UNAVAILABLE[date.id] ?? []).includes(b.id)} />)}
            <SignCard sign={state.sign} bottleIds={chosen} onChange={(s) => update({ sign: s })} showErrors={signTried} />
            <div className="included-mixers">
              <Icon name="check" size={16} />
              <span>
                <b>Mixers included</b>
                <small>Club soda, tonic, cola, cranberry, citrus and fresh ice.</small>
              </span>
            </div>
            <div className="spend-progress">
              <div>
                <span>Minimum-spend progress</span>
                <b>
                  {money(Math.min(q.applied, q.minimum), false)} / {money(q.minimum, false)}
                </b>
              </div>
              <i>
                <span className={q.dueAtVenue === 0 ? "complete" : ""} style={{ width: `${Math.min(100, (q.applied / q.minimum) * 100)}%` }} />
              </i>
              <small>{q.dueAtVenue === 0 ? "Minimum met · no additional spend required" : `${money(q.dueAtVenue, false)} remaining at the venue`}</small>
            </div>
            <button className="text-link" onClick={() => setMenuOpen(!menuOpen)}>
              {menuOpen ? "Show fewer bottles" : "Browse full bottle menu"} <Icon name="chevron" size={15} />
            </button>
          </>
        )}
        {step === 3 && (
          <>
            <span className="eyebrow">REVIEW & PAY</span>
            <div className="display-title">One last look.</div>
            <div className="order-summary">
              <div className="summary-event">
                <img src={table.image} alt="" />
                <span>
                  <b>{table.name}</b>
                  <small>
                    Nova Room · {date.short} · {date.event}
                  </small>
                  <small>
                    Arrival {arrivalShortDay(arrival)}, {arrival} · {guests} guest{guests === 1 ? "" : "s"}
                  </small>
                </span>
                <button onClick={() => update({ checkoutStep: 1 })}>Edit</button>
              </div>
              <PriceLines q={q} mode="checkout" />
            </div>
            <div className="deposit-explainer">
              <Icon name="ticket" />
              <span>
                <b>What your deposit covers</b>
                <small>
                  It secures {table.name} and becomes a credit toward eligible bottle service. Cancel at least 48 hours before the nightlife session for a full refund.
                </small>
              </span>
            </div>
            <div className={remaining === 0 ? "hold-note expired" : "hold-note"} aria-live="polite">
              <Icon name="clock" />
              <span>
                {remaining === 0 ? (
                  "Your hold has expired"
                ) : (
                  <>
                    Your table is held for{" "}
                    <b>
                      {mm}:{ss}
                    </b>
                  </>
                )}
              </span>
            </div>
            <div className="demo-states">
              <small>DEMO PAYMENT STATES</small>
              <div>
                {shownStates.map((payment) => (
                  <button
                    key={payment}
                    className={paymentState === payment ? "active" : ""}
                    disabled={paymentState === "processing"}
                    onClick={() => (payment === "ready" && remaining === 0 ? restartHold() : update({ paymentState: payment }))}
                  >
                    {payment}
                  </button>
                ))}
              </div>
            </div>
            {paymentState !== "ready" && (
              <div className={`payment-message ${paymentState}`} aria-live="polite">
                <Icon name={paymentState === "expired" || paymentState === "processing" ? "clock" : "close"} />
                <span>
                  <b>
                    {paymentState === "processing"
                      ? "Processing payment"
                      : paymentState === "declined"
                        ? "Payment declined"
                        : paymentState === "cancelled"
                          ? "Payment cancelled"
                          : "Reservation hold expired"}
                  </b>
                  <small>
                    {paymentState === "processing"
                      ? "Keep BottlesUp open while we securely confirm your booking."
                      : paymentState === "declined"
                        ? "Try another payment method. Your card was not charged and your selections are saved."
                        : paymentState === "cancelled"
                          ? "No charge was made. Your selections are still here."
                          : "Recheck availability before trying again. Your selections are saved."}
                  </small>
                </span>
              </div>
            )}
            <p className="legal">By confirming, you agree to Nova Room’s demo booking and cancellation terms. No real payment will be processed.</p>
          </>
        )}
        <div className="checkout-footer">
          <Button className="full-width" onClick={next} disabled={step === 3 && paymentState === "processing"}>
            {step === 1
              ? "Continue to bottles"
              : step === 2
                ? "Review payment"
                : paymentState === "processing"
                  ? "Processing…"
                  : paymentState === "ready"
                    ? `Pay ${money(q.total)}`
                    : paymentState === "expired"
                      ? "Recheck availability"
                      : "Return to payment"}
          </Button>
          <small>Demo checkout · No real charge</small>
        </div>
      </main>
    </div>
  )
}

function BottleRow({
  bottle,
  qty,
  setQty,
  image,
  canAdd,
  unavailable = false,
}: {
  bottle: (typeof bottleMenu)[number]
  qty: number
  setQty: (id: string, qty: number) => void
  image?: string
  canAdd: boolean
  unavailable?: boolean
}) {
  return (
    <div className={`bottle-option ${qty > 0 ? "selected-choice" : ""} ${image ? "" : "compact"}`}>
      {image ? (
        <img src={image} alt={bottle.name} />
      ) : (
        <span className="bottle-thumb">
          <Icon name="bottle" />
        </span>
      )}
      <span>
        <small>
          {bottle.size} · {bottle.note.toUpperCase()}
        </small>
        <b>{bottle.name}</b>
        <strong>{unavailable ? "Unavailable this night" : "$" + bottle.price.toLocaleString("en-CA")}</strong>
      </span>
      <span className="quantity-control">
        <button aria-label={`Remove one ${bottle.name}`} disabled={qty === 0} onClick={() => setQty(bottle.id, qty - 1)}>
          −
        </button>
        <b aria-live="polite">{qty}</b>
        <button aria-label={`Add one ${bottle.name}`} disabled={!canAdd || unavailable} onClick={() => setQty(bottle.id, qty + 1)}>
          +
        </button>
      </span>
    </div>
  )
}

export function Confirmation() {
  const app = useApp()
  const b = app.state.booking
  const table = tables[b.tableId]
  const date = dateById(b.dateId)
  return (
    <div className="screen confirmation-screen">
      <TopBar back fallback="home" onBack={() => app.go("home")} action={<button className="text-btn" onClick={() => app.go("night")}>My Night</button>} />
      <main className="padded confirmation">
        <div className="success-mark">
          <Icon name="check" size={30} />
        </div>
        <span className="eyebrow">BOOKING CONFIRMED · DEMO</span>
        <div className="display-title">{date.weekday} is yours.</div>
        <p>Your {table.name} at Nova Room is confirmed. Everything you need now lives in My Night.</p>
        <div className="ticket-card">
          <img src={media.hero} alt="" />
          <div className="ticket-details">
            <small>
              {date.month} {date.day} · TORONTO
            </small>
            <b>{table.name}</b>
            <span>{date.event}</span>
            <div>
              <span>
                ARRIVE {arrivalShortDay(b.arrival).toUpperCase()}
                <b>{b.arrival}</b>
              </span>
              <span>
                GUESTS<b>{b.guests}</b>
              </span>
            </div>
          </div>
          <div className="ticket-code">
            <div className="fake-qr" aria-hidden="true">
              {Array.from({ length: 32 }).map((_, i) => (
                <i key={i} />
              ))}
            </div>
            <small>BOOKING · {b.ref}</small>
          </div>
        </div>
        <Button icon="users" className="full-width" onClick={() => app.go("guests")}>
          Invite your friends
        </Button>
        <Button variant="secondary" icon="send" className="full-width" onClick={() => app.openThread("crew", `Booked ${table.name} for ${date.short}. Arrival ${arrivalDay(b.arrival)} at ${b.arrival}. Sending passes now.`)}>
          Send to group chat
        </Button>
        <button className="text-link center" onClick={() => app.go("night")}>
          Open My Night <Icon name="chevron" size={15} />
        </button>
      </main>
    </div>
  )
}
