import { BottlePop } from "../BottlePop"
import { useEffect, useRef, useState } from "react"

/* Launch, delayed, connection-error and sign-in screens from the BottlesUp Figma design. */

type Props = { dark: boolean }

function Lockup({ dark, size }: { dark: boolean; size: "launch" | "form" }) {
  return (
    <div className={`bu-lockup ${size}`} role="img" aria-label="BottlesUp">
      {size === "launch" ? <BottlePop width={104} className="bu-bottle" /> : <img className="bu-bottle" src="/launch/bottle.svg" alt="" />}
      <img className="bu-wordmark" src={dark ? "/launch/wordmark-dark.svg" : "/launch/wordmark-light.svg"} alt="" />
    </div>
  )
}

const reducedMotion = () => window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ?? false

export function LaunchScreen({ dark }: Props) {
  const still = reducedMotion()
  return (
    <div className={`bu-screen bu-launch ${dark ? "dark" : "light"}`} aria-busy="true" aria-label="Loading BottlesUp">
      <div className="bu-launch-identity">
        <Lockup dark={dark} size="launch" />
        {still ? <i className="bu-still-cue" aria-hidden="true" /> : <img className="bu-spinner" src="/launch/spinner.svg" alt="" />}
      </div>
    </div>
  )
}

export function DelayedSignIn({ dark }: Props) {
  return (
    <div className={`bu-screen bu-form-screen ${dark ? "dark" : "light"}`} aria-busy="true">
      <Lockup dark={dark} size="form" />
      <div className="bu-skeleton" aria-hidden="true">
        <i style={{ width: 214, height: 26, marginTop: 8 }} />
        <i style={{ width: 241, height: 12, marginTop: 20 }} />
        <i style={{ width: 87, height: 10, marginTop: 33 }} />
        <b />
        <i style={{ width: 62, height: 10, marginTop: 23 }} />
        <b />
        <i style={{ width: 112, height: 10, marginTop: 25, alignSelf: "flex-end" }} />
        <b className="btn-ph" />
        <i style={{ width: 236, height: 10, marginTop: 29, alignSelf: "center" }} />
      </div>
      <p className="bu-delayed" role="status">
        <img src="/launch/spinner-static.svg" alt="" /> Preparing sign in…
      </p>
    </div>
  )
}

export function ConnectionError({ dark, onRetry }: Props & { onRetry: () => Promise<void> }) {
  const [busy, setBusy] = useState(false)
  return (
    <div className={`bu-screen bu-error ${dark ? "dark" : "light"}`}>
      <Lockup dark={dark} size="form" />
      <div className="bu-error-copy" role="alert">
        <h1>Unable to connect.</h1>
        <p>
          Check your internet connection
          <br />
          and try again.
        </p>
      </div>
      <button
        className="bu-primary"
        disabled={busy}
        onClick={async () => {
          if (busy) return
          setBusy(true)
          await onRetry()
          setBusy(false)
        }}
      >
        {busy ? <img className="bu-spinner small" src="/launch/spinner.svg" alt="" /> : "Retry"}
        {busy && <span className="sr-only">Retrying</span>}
      </button>
    </div>
  )
}

type Mode = "signin" | "signup" | "reset"

export function SignIn({ dark, onSignedIn, onDemo }: Props & { onSignedIn: (name: string) => void; onDemo: (kind: "slow" | "offline") => void }) {
  const [mode, setMode] = useState<Mode>("signin")
  const [name, setName] = useState("")
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [show, setShow] = useState(false)
  const [errors, setErrors] = useState<{ name?: string; email?: string; password?: string; form?: string }>({})
  const [busy, setBusy] = useState(false)
  const [resetSent, setResetSent] = useState(false)
  const timer = useRef<number | null>(null)
  useEffect(() => () => {
    if (timer.current) window.clearTimeout(timer.current)
  }, [])
  const validEmail = (v: string) => /^\S+@\S+\.\S+$/.test(v.trim())
  const submit = () => {
    if (busy) return
    const e: typeof errors = {}
    if (mode === "signup" && name.trim().length < 2) e.name = "Enter your name."
    if (!email.trim()) e.email = "Enter your email address."
    else if (!validEmail(email)) e.email = "Enter a valid email, like you@example.com."
    if (mode !== "reset") {
      if (!password) e.password = "Enter your password."
      else if (mode === "signup" && password.length < 8) e.password = "Use at least 8 characters."
    }
    if (mode === "signin" && password && password.toLowerCase() === "wrong") e.form = "That email and password don't match. Try again or reset your password."
    setErrors(e)
    if (Object.keys(e).length) return
    if (mode === "reset") return setResetSent(true)
    setBusy(true)
    timer.current = window.setTimeout(() => {
      setBusy(false)
      onSignedIn(mode === "signup" ? name.trim() : "")
    }, 700)
  }
  const switchMode = (m: Mode) => {
    setMode(m)
    setErrors({})
    setResetSent(false)
  }
  const title = mode === "signin" ? "Welcome back." : mode === "signup" ? "Create your account." : "Reset your password."
  const sub = mode === "signin" ? "Sign in to your BottlesUp account." : mode === "signup" ? "Book tables, follow DJs and plan your nights." : resetSent ? `If ${email.trim()} has an account, a reset link is on its way.` : "Enter your email and we'll send a reset link."
  return (
    <div className={`bu-screen bu-form-screen ${dark ? "dark" : "light"}`}>
      <Lockup dark={dark} size="form" />
      <form
        className="bu-form"
        noValidate
        onSubmit={(ev) => {
          ev.preventDefault()
          submit()
        }}
      >
        <div className="bu-welcome">
          <h1>{title}</h1>
          <p>{sub}</p>
        </div>
        {errors.form && (
          <p className="bu-form-error" role="alert">
            {errors.form}
          </p>
        )}
        {!(mode === "reset" && resetSent) && (
          <div className="bu-credentials">
            {mode === "signup" && (
              <label className="bu-field">
                <span>Your name</span>
                <span className={`bu-input ${errors.name ? "invalid" : ""}`}>
                  <input value={name} onChange={(e) => { setName(e.target.value); setErrors((x) => ({ ...x, name: undefined })) }} placeholder="Jordan Ellis" autoComplete="name" aria-invalid={!!errors.name} />
                </span>
                {errors.name && <em>{errors.name}</em>}
              </label>
            )}
            <label className="bu-field">
              <span>Email address</span>
              <span className={`bu-input ${errors.email ? "invalid" : ""}`}>
                <input type="email" inputMode="email" value={email} onChange={(e) => { setEmail(e.target.value); setErrors((x) => ({ ...x, email: undefined, form: undefined })) }} placeholder="you@example.com" autoComplete="email" aria-invalid={!!errors.email} />
              </span>
              {errors.email && <em>{errors.email}</em>}
            </label>
            {mode !== "reset" && (
              <label className="bu-field">
                <span>Password</span>
                <span className={`bu-input ${errors.password ? "invalid" : ""}`}>
                  <input type={show ? "text" : "password"} value={password} onChange={(e) => { setPassword(e.target.value); setErrors((x) => ({ ...x, password: undefined, form: undefined })) }} placeholder={mode === "signup" ? "At least 8 characters" : "Enter your password"} autoComplete={mode === "signup" ? "new-password" : "current-password"} aria-invalid={!!errors.password} />
                  <button type="button" className={`bu-eye ${show ? "on" : ""}`} aria-label={show ? "Hide password" : "Show password"} aria-pressed={show} onClick={() => setShow(!show)}>
                    <img src={dark ? "/launch/eye-dark.svg" : "/launch/eye-light.svg"} alt="" />
                  </button>
                </span>
                {errors.password && <em>{errors.password}</em>}
              </label>
            )}
            {mode === "signin" && (
              <div className="bu-recovery">
                <button type="button" onClick={() => switchMode("reset")}>
                  Forgot password?
                </button>
              </div>
            )}
          </div>
        )}
        {!(mode === "reset" && resetSent) ? (
          <button className="bu-primary" type="submit" disabled={busy}>
            {busy ? <img className="bu-spinner small" src="/launch/spinner.svg" alt="" /> : mode === "signin" ? "Sign In" : mode === "signup" ? "Create account" : "Send reset link"}
            {busy && <span className="sr-only">Signing in</span>}
          </button>
        ) : (
          <button className="bu-primary" type="button" onClick={() => switchMode("signin")}>
            Back to sign in
          </button>
        )}
        <p className="bu-switch">
          {mode === "signin" ? (
            <>
              <span>New to BottlesUp?</span>
              <button type="button" onClick={() => switchMode("signup")}>
                Create an account
              </button>
            </>
          ) : (
            <>
              <span>{mode === "signup" ? "Already have an account?" : "Remembered it?"}</span>
              <button type="button" onClick={() => switchMode("signin")}>
                Sign in
              </button>
            </>
          )}
        </p>
      </form>
      <p className="bu-demo">
        Demo previews:{" "}
        <button type="button" onClick={() => onDemo("slow")}>
          Slow connection
        </button>{" "}
        ·{" "}
        <button type="button" onClick={() => onDemo("offline")}>
          Offline
        </button>
      </p>
    </div>
  )
}
