import { useState } from "react"
import { SIGN_MAX, SIGN_STYLES, bottleMenu, signCheck, type BottleSign } from "../data"
import { Button, Icon } from "../ui"

/* Bottle presentation sign: pick a style, write a short message, choose the bottle
   and when it comes out. A live preview shows what the table will see. */

const TIMINGS: BottleSign["timing"][] = ["On arrival", "At midnight", "When we ask"]

export function SignPreview({ sign }: { sign: BottleSign }) {
  const raw = sign.text.trim()
  const text = sign.style === "neon" ? raw || "Your message" : raw.toUpperCase() || "YOUR MESSAGE"
  return (
    <div className={`sign-preview sign-${sign.style}`} aria-label={`Sign preview: ${text}`}>
      {sign.style === "sparkler" && (
        <>
          <i className="spark l" />
          <i className="spark r" />
        </>
      )}
      <span>{text}</span>
    </div>
  )
}

export function SignEditor({ value, bottleIds, onChange, showErrors }: { value: BottleSign; bottleIds: string[]; onChange: (s: BottleSign) => void; showErrors?: boolean }) {
  const err = signCheck(value.text)
  const set = (p: Partial<BottleSign>) => onChange({ ...value, ...p })
  return (
    <div className="sign-editor">
      <SignPreview sign={value} />
      <div className="sign-styles" role="radiogroup" aria-label="Sign style">
        {SIGN_STYLES.map((s) => (
          <button key={s.id} role="radio" aria-checked={value.style === s.id} className={value.style === s.id ? "on" : ""} onClick={() => set({ style: s.id })}>
            <b>{s.name}</b>
            <small>
              +${s.price} · {s.note}
            </small>
          </button>
        ))}
      </div>
      <label className="sign-field">
        <span>
          Your message <em>{value.text.length}/{SIGN_MAX}</em>
        </span>
        <input value={value.text} maxLength={SIGN_MAX} onChange={(e) => set({ text: e.target.value })} placeholder="e.g. HAPPY BDAY MAYA" aria-invalid={!!(showErrors && err)} />
        {showErrors && err && <small className="sign-error">{err}</small>}
      </label>
      {bottleIds.length > 1 && (
        <div className="sign-row">
          <span>With which bottle?</span>
          <div className="cp-chips">
            {bottleIds.map((id) => (
              <button key={id} aria-pressed={value.bottleId === id} className={value.bottleId === id ? "on" : ""} onClick={() => set({ bottleId: id })}>
                {bottleMenu.find((b) => b.id === id)?.name}
              </button>
            ))}
          </div>
        </div>
      )}
      <div className="sign-row">
        <span>When should it come out?</span>
        <div className="cp-chips">
          {TIMINGS.map((t) => (
            <button key={t} aria-pressed={value.timing === t} className={value.timing === t ? "on" : ""} onClick={() => set({ timing: t })}>
              {t}
            </button>
          ))}
        </div>
      </div>
      <p className="sign-note">Staff carry the sign out with your bottle. Messages are checked by the venue before printing.</p>
    </div>
  )
}

/** Checkout card: collapsed offer, or the editor once added. */
export function SignCard({ sign, bottleIds, onChange, showErrors }: { sign: BottleSign | null; bottleIds: string[]; onChange: (s: BottleSign | null) => void; showErrors?: boolean }) {
  if (!bottleIds.length) return null
  if (!sign)
    return (
      <button className="sign-offer" onClick={() => onChange({ style: "led", text: "", bottleId: bottleIds[0], timing: "On arrival" })}>
        <span className="sign-offer-icon">
          <Icon name="spark" size={18} />
        </span>
        <span>
          <b>Add a sign to your bottle</b>
          <small>A custom message carried out with it · from $25</small>
        </span>
        <span className="sign-add">Add</span>
      </button>
    )
  const fixed = bottleIds.includes(sign.bottleId) ? sign : { ...sign, bottleId: bottleIds[0] }
  return (
    <section className="sign-card">
      <div className="sign-card-head">
        <b>Bottle sign</b>
        <button onClick={() => onChange(null)}>Remove</button>
      </div>
      <SignEditor value={fixed} bottleIds={bottleIds} onChange={onChange} showErrors={showErrors} />
    </section>
  )
}

/** Sheet body for adding or editing a sign after booking (from My Night). */
export function SignSheet({ initial, bottleIds, onSave, onRemove, close }: { initial: BottleSign | null; bottleIds: string[]; onSave: (s: BottleSign) => void; onRemove: () => void; close: () => void }) {
  const [draft, setDraft] = useState<BottleSign>(initial ?? { style: "led", text: "", bottleId: bottleIds[0], timing: "On arrival" })
  const [tried, setTried] = useState(false)
  const price = SIGN_STYLES.find((s) => s.id === draft.style)!.price
  return (
    <div className="sign-sheet">
      <SignEditor value={draft} bottleIds={bottleIds} onChange={setDraft} showErrors={tried} />
      <Button
        className="full-width"
        onClick={() => {
          setTried(true)
          if (signCheck(draft.text)) return
          onSave(draft)
          close()
        }}
      >
        {initial ? "Save changes" : `Add sign · $${price}`}
      </Button>
      {initial && (
        <Button
          variant="secondary"
          className="full-width"
          onClick={() => {
            onRemove()
            close()
          }}
        >
          Remove sign
        </Button>
      )}
      <p className="sign-note">{initial ? "You can change the message until 6 PM on the day." : "Charged to the card on this booking. Demo: no real charge."}</p>
    </div>
  )
}
