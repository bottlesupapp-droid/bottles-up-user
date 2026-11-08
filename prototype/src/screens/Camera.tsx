import { useEffect, useRef, useState, type PointerEvent as RPointerEvent } from "react"
import { media } from "../data"
import { useApp, type CaptureDraft, type CaptureMode } from "../store"
import { Button, Icon } from "../ui"

/* Create flow: full-screen camera → preview (crop, trim, caption, tag, audience) → upload → confirmation.
   Uses the real camera (getUserMedia) and the device gallery (file input). The draft lives in app
   state so going back never loses captured media. */

type CamState = "checking" | "ask" | "starting" | "live" | "denied" | "unavailable"
const MODES: CaptureMode[] = ["Post", "Story", "Reel"]
const MAX_REEL = 30
// Once the camera has worked in this session, reopen it straight away.
let cameraAllowed = false

const blank = (mode: CaptureMode, src: string, kind: "image" | "video"): CaptureDraft => ({
  mode,
  src,
  kind,
  aspect: mode === "Post" ? "4:5" : "9:16",
  x: 50,
  y: 50,
  zoom: 1,
  trimStart: 0,
  trimEnd: 0,
  duration: 0,
  caption: "",
  tag: "",
  audience: mode === "Story" ? "Followers" : "Public",
})

export function Camera() {
  const app = useApp()
  const draft = app.state.capture
  const video = useRef<HTMLVideoElement>(null)
  const stream = useRef<MediaStream | null>(null)
  const recorder = useRef<MediaRecorder | null>(null)
  const chunks = useRef<Blob[]>([])
  const file = useRef<HTMLInputElement>(null)
  const [cam, setCam] = useState<CamState>("checking")
  const [facing, setFacing] = useState<"user" | "environment">("environment")
  const [flash, setFlash] = useState(false)
  const [torch, setTorch] = useState(false)
  const [mode, setMode] = useState<CaptureMode>(app.state.cameraMode)
  const [recording, setRecording] = useState(0)
  const [blink, setBlink] = useState(false)
  const recTimer = useRef<number | null>(null)

  const stop = () => {
    stream.current?.getTracks().forEach((t) => t.stop())
    stream.current = null
  }

  const start = async (face = facing) => {
    if (!navigator.mediaDevices?.getUserMedia) return setCam("unavailable")
    setCam("starting")
    stop()
    try {
      const s = await navigator.mediaDevices.getUserMedia({ video: { facingMode: face, width: { ideal: 1080 }, height: { ideal: 1920 } }, audio: false })
      stream.current = s
      const track = s.getVideoTracks()[0]
      const caps = (track.getCapabilities?.() ?? {}) as MediaTrackCapabilities & { torch?: boolean }
      setTorch(!!caps.torch)
      if (video.current) {
        video.current.srcObject = s
        await video.current.play().catch(() => {})
      }
      cameraAllowed = true
      setCam("live")
    } catch (e) {
      const name = (e as DOMException)?.name
      setCam(name === "NotAllowedError" || name === "SecurityError" ? "denied" : "unavailable")
    }
  }

  useEffect(() => {
    let alive = true
    ;(async () => {
      if (!navigator.mediaDevices?.getUserMedia) return setCam("unavailable")
      if (cameraAllowed) return start()
      try {
        const p = await navigator.permissions?.query({ name: "camera" as PermissionName })
        if (!alive) return
        if (p?.state === "granted") return start()
        if (p?.state === "denied") return setCam("denied")
      } catch {
        /* permissions API not supported: ask first */
      }
      if (alive) setCam("ask")
    })()
    return () => {
      alive = false
      stop()
      if (recTimer.current) window.clearInterval(recTimer.current)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const takeMedia = (src: string, kind: "image" | "video") => {
    stop()
    app.update({ capture: blank(mode, src, kind) })
    app.go("createpreview")
  }

  const toggleFlash = async () => {
    const next = !flash
    setFlash(next)
    const track = stream.current?.getVideoTracks()[0]
    if (torch && track) {
      try {
        await track.applyConstraints({ advanced: [{ torch: next } as MediaTrackConstraintSet] })
      } catch {
        /* torch refused: screen flash is used on capture instead */
      }
    }
  }

  const flip = () => {
    const next = facing === "user" ? "environment" : "user"
    setFacing(next)
    if (cam === "live") void start(next)
  }

  const snap = () => {
    const v = video.current
    if (!v || !v.videoWidth) return app.toast("The camera isn't ready yet")
    if (flash && !torch) {
      setBlink(true)
      window.setTimeout(() => setBlink(false), 180)
    }
    const c = document.createElement("canvas")
    c.width = v.videoWidth
    c.height = v.videoHeight
    const g = c.getContext("2d")!
    if (facing === "user") {
      g.translate(c.width, 0)
      g.scale(-1, 1)
    }
    g.drawImage(v, 0, 0)
    takeMedia(c.toDataURL("image/jpeg", 0.9), "image")
  }

  const record = () => {
    if (recorder.current) {
      recorder.current.stop()
      return
    }
    if (!stream.current || typeof MediaRecorder === "undefined") return app.toast("Recording isn't supported here. Choose a video from your gallery.")
    chunks.current = []
    const r = new MediaRecorder(stream.current)
    recorder.current = r
    r.ondataavailable = (e) => e.data.size && chunks.current.push(e.data)
    r.onstop = () => {
      if (recTimer.current) window.clearInterval(recTimer.current)
      recorder.current = null
      setRecording(0)
      const blob = new Blob(chunks.current, { type: r.mimeType || "video/webm" })
      if (blob.size) takeMedia(URL.createObjectURL(blob), "video")
      else app.toast("Nothing was recorded. Try again.")
    }
    r.start()
    setRecording(0.01)
    const began = Date.now()
    recTimer.current = window.setInterval(() => {
      const t = (Date.now() - began) / 1000
      setRecording(t)
      if (t >= MAX_REEL) r.stop()
    }, 100)
  }

  const pick = (f?: File) => {
    if (!f) return
    const isVideo = f.type.startsWith("video/")
    if (!isVideo && !f.type.startsWith("image/")) return app.toast("Choose a photo or video")
    if (mode === "Reel" && !isVideo) return app.toast("Reels need a video. Choose a video or switch to Post.")
    takeMedia(URL.createObjectURL(f), isVideo ? "video" : "image")
  }

  const close = () => {
    if (recorder.current) recorder.current.stop()
    stop()
    app.back("home")
  }

  const live = cam === "live"
  return (
    <div className="screen cam-screen">
      <video ref={video} className={`cam-video ${facing === "user" ? "mirror" : ""} ${live ? "on" : ""}`} playsInline muted aria-label="Camera preview" />
      {blink && <div className="cam-blink" />}

      {!live && (
        <div className="cam-state" role="status">
          {cam === "checking" || cam === "starting" ? (
            <>
              <span className="cam-spinner" />
              <p>{cam === "starting" ? "Starting camera…" : ""}</p>
            </>
          ) : cam === "ask" ? (
            <>
              <Icon name="camera" size={34} />
              <b>Allow camera access</b>
              <p>BottlesUp uses your camera to take photos and record reels. You can also choose from your gallery.</p>
              <Button onClick={() => start()}>Allow camera</Button>
            </>
          ) : cam === "denied" ? (
            <>
              <Icon name="camera" size={34} />
              <b>Camera access is off</b>
              <p>Turn on camera access for BottlesUp in your browser or device settings, then try again. You can still post from your gallery.</p>
              <Button onClick={() => start()}>Try again</Button>
              <Button variant="secondary" onClick={() => file.current?.click()}>
                Choose from gallery
              </Button>
            </>
          ) : (
            <>
              <Icon name="camera" size={34} />
              <b>Camera unavailable</b>
              <p>We couldn't find a camera, or another app is using it. Choose a photo or video from your gallery instead.</p>
              <Button onClick={() => file.current?.click()}>Choose from gallery</Button>
              <Button variant="secondary" onClick={() => start()}>
                Retry camera
              </Button>
            </>
          )}
        </div>
      )}

      <div className="cam-top">
        <button className="cam-btn" aria-label="Close camera" onClick={close}>
          <Icon name="close" size={24} />
        </button>
        {recording > 0 ? (
          <span className="cam-rec">
            <i /> 0:{String(Math.floor(recording)).padStart(2, "0")} / 0:{MAX_REEL}
          </span>
        ) : (
          <button className="cam-btn" aria-label={flash ? "Turn flash off" : "Turn flash on"} aria-pressed={flash} disabled={!live} onClick={toggleFlash}>
            <Icon name={flash ? "flash" : "flashOff"} size={24} />
          </button>
        )}
        <button className="cam-btn cam-text" aria-label="Write a text update" onClick={() => (stop(), app.update({ composeMode: "Update", composeMembers: false }), app.go("composer"))}>
          Aa
        </button>
      </div>

      <div className="cam-bottom">
        <div className="cam-row">
          <button className="cam-gallery" aria-label="Open gallery" onClick={() => file.current?.click()}>
            {draft ? draft.kind === "image" ? <img src={draft.src} alt="" /> : <video src={draft.src} muted /> : <img src={media.friends} alt="" />}
          </button>
          <button
            className={`cam-shutter ${mode === "Reel" ? "reel" : ""} ${recording ? "rec" : ""}`}
            aria-label={mode === "Reel" ? (recording ? "Stop recording" : "Start recording") : "Take photo"}
            disabled={!live}
            onClick={mode === "Reel" ? record : snap}
          >
            <span style={recording ? { ["--p" as string]: `${(recording / MAX_REEL) * 360}deg` } : undefined} />
          </button>
          <button className="cam-btn cam-flip" aria-label="Flip camera" disabled={!live || recording > 0} onClick={flip}>
            <Icon name="flip" size={26} />
          </button>
        </div>
        {draft && !recording && (
          <button className="cam-resume" onClick={() => (stop(), app.go("createpreview"))}>
            Continue your draft <Icon name="chevron" size={14} />
          </button>
        )}
        <div className="cam-modes" role="tablist" aria-label="Create mode">
          {MODES.map((m) => (
            <button key={m} role="tab" aria-selected={mode === m} className={mode === m ? "on" : ""} disabled={recording > 0} onClick={() => setMode(m)}>
              {m}
            </button>
          ))}
        </div>
      </div>
      <input ref={file} type="file" accept={mode === "Reel" ? "video/*" : "image/*,video/*"} hidden onChange={(e) => (pick(e.target.files?.[0]), (e.target.value = ""))} />
    </div>
  )
}

/* ---------------- Preview & publish ---------------- */

const TAGS = ["Nova Room", "EONICS: Afterglow", "Sky Room"]
const AUDIENCES: { id: CaptureDraft["audience"]; detail: string }[] = [
  { id: "Public", detail: "Anyone on BottlesUp" },
  { id: "Followers", detail: "People who follow you" },
  { id: "Close friends", detail: "Your close friends list" },
  { id: "Members Only", detail: "Your members circle. Always free." },
]

export function CreatePreview() {
  const app = useApp()
  const d = app.state.capture
  const vid = useRef<HTMLVideoElement>(null)
  const drag = useRef<{ x: number; y: number; ox: number; oy: number } | null>(null)
  const [phase, setPhase] = useState<"edit" | "uploading" | "failed" | "done">("edit")
  const [progress, setProgress] = useState(0)
  const timer = useRef<number | null>(null)
  useEffect(() => () => {
    if (timer.current) window.clearInterval(timer.current)
  }, [])
  // Keep a trimmed video looping inside the chosen range.
  useEffect(() => {
    const v = vid.current
    if (!v || !d || d.kind !== "video") return
    const onTime = () => {
      if (d.trimEnd && v.currentTime >= d.trimEnd) v.currentTime = d.trimStart
    }
    v.addEventListener("timeupdate", onTime)
    return () => v.removeEventListener("timeupdate", onTime)
  }, [d])

  if (!d)
    return (
      <div className="screen cp-empty">
        <Icon name="camera" size={30} />
        <b>Nothing to preview</b>
        <p>Take a photo or choose one from your gallery.</p>
        <Button onClick={() => app.go("camera")}>Open camera</Button>
      </div>
    )
  const set = (p: Partial<CaptureDraft>) => app.update((s) => ({ capture: s.capture ? { ...s.capture, ...p } : s.capture }))
  const fixed = d.mode !== "Post"
  const ratio = { "1:1": "1 / 1", "4:5": "4 / 5", "9:16": "9 / 16" }[d.aspect]
  const onDown = (e: RPointerEvent) => {
    drag.current = { x: e.clientX, y: e.clientY, ox: d.x, oy: d.y }
    ;(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId)
  }
  const onMove = (e: RPointerEvent) => {
    const g = drag.current
    if (!g) return
    const clamp = (n: number) => Math.max(0, Math.min(100, n))
    set({ x: clamp(g.ox - (e.clientX - g.x) / 3), y: clamp(g.oy - (e.clientY - g.y) / 3) })
  }

  const publish = () => {
    setPhase("uploading")
    setProgress(0)
    const willFail = app.state.demo.failUpload || navigator.onLine === false
    timer.current = window.setInterval(() => {
      setProgress((p) => {
        const n = p + 7 + Math.random() * 9
        if (willFail && n > 62) {
          window.clearInterval(timer.current!)
          app.update((st) => ({ demo: { ...st.demo, failUpload: false } }))
          setPhase("failed")
          return 62
        }
        if (n >= 100) {
          window.clearInterval(timer.current!)
          finish()
          return 100
        }
        return n
      })
    }, 160)
  }
  const finish = async () => {
    let image = d.src
    if (d.kind === "video") image = (await poster(d.src, d.trimStart)) ?? media.stage
    app.update((s) => ({
      posts: d.mode === "Story" ? s.posts : [{ image, members: d.audience === "Members Only", reel: d.mode === "Reel", tagged: false }, ...s.posts],
    }))
    setPhase("done")
  }

  if (phase === "done")
    return (
      <div className="screen cp-done">
        <span className="cp-check">
          <Icon name="check" size={30} />
        </span>
        <b>{d.mode === "Story" ? "Shared to your story" : d.mode === "Reel" ? "Your reel is live" : "Posted"}</b>
        <p>
          {d.audience === "Members Only" ? "Only your members circle can see it." : d.audience === "Public" ? "Anyone on BottlesUp can see it." : `Visible to ${d.audience.toLowerCase()}.`}
          {d.tag && ` Tagged at ${d.tag}.`}
        </p>
        <Button
          onClick={() => {
            app.update({ capture: null })
            app.go("profile")
          }}
        >
          View on profile
        </Button>
        <Button
          variant="secondary"
          onClick={() => {
            app.update({ capture: null })
            app.go("home")
          }}
        >
          Done
        </Button>
      </div>
    )

  return (
    <div className="screen cp-screen">
      <div className="cp-top">
        <span className="cp-lead">
          <button className="icon-btn" aria-label="Back to camera" onClick={() => app.back("camera")} disabled={phase === "uploading"}>
            <Icon name="back" />
          </button>
          <button
            className="icon-btn"
            aria-label="Close and keep draft"
            disabled={phase === "uploading"}
            onClick={() => {
              app.toast("Draft saved. Tap Create to continue.")
              app.go("home")
            }}
          >
            <Icon name="close" />
          </button>
        </span>
        <b>New {d.mode.toLowerCase()}</b>
        <button
          className="cp-discard"
          disabled={phase === "uploading"}
          onClick={() =>
            app.openSheet({
              title: "Discard this draft?",
              eyebrow: "CREATE",
              body: (close) => (
                <div className="cp-sheet">
                  <p className="list-count">Your photo or video and caption will be removed.</p>
                  <Button
                    className="full-width danger-btn"
                    onClick={() => {
                      close()
                      app.update({ capture: null })
                      app.go("camera")
                    }}
                  >
                    Discard
                  </Button>
                  <Button variant="secondary" className="full-width" onClick={close}>
                    Keep editing
                  </Button>
                </div>
              ),
            })
          }
        >
          Discard
        </button>
      </div>
      <main className="padded cp-body">
        <div className="cp-frame" style={{ aspectRatio: ratio }} onPointerDown={onDown} onPointerMove={onMove} onPointerUp={() => (drag.current = null)} aria-label="Drag to reposition">
          {d.kind === "image" ? (
            <img src={d.src} alt="Your capture" draggable={false} style={{ objectPosition: `${d.x}% ${d.y}%`, transform: `scale(${d.zoom})` }} />
          ) : (
            <video
              ref={vid}
              src={d.src}
              autoPlay
              muted
              loop
              playsInline
              style={{ objectPosition: `${d.x}% ${d.y}%`, transform: `scale(${d.zoom})` }}
              onLoadedMetadata={(e) => {
                const dur = Number.isFinite(e.currentTarget.duration) ? e.currentTarget.duration : 0
                if (!d.duration && dur) set({ duration: dur, trimEnd: dur })
              }}
            />
          )}
          <span className="cp-grid" aria-hidden="true" />
        </div>

        <section className="cp-section">
          <h3>Crop</h3>
          {!fixed && (
            <div className="cp-chips" role="radiogroup" aria-label="Aspect ratio">
              {(["1:1", "4:5", "9:16"] as const).map((a) => (
                <button key={a} role="radio" aria-checked={d.aspect === a} className={d.aspect === a ? "on" : ""} onClick={() => set({ aspect: a })}>
                  {a}
                </button>
              ))}
            </div>
          )}
          <label className="cp-range">
            <span>Zoom</span>
            <input type="range" min={1} max={2.5} step={0.05} value={d.zoom} onChange={(e) => set({ zoom: Number(e.target.value) })} />
          </label>
          <small className="cp-hint">Drag the {d.kind === "image" ? "photo" : "video"} to reposition.{fixed ? " Stories and reels are full screen (9:16)." : ""}</small>
        </section>

        {d.kind === "video" && (
          <section className="cp-section">
            <h3>Trim</h3>
            {d.duration ? (
              <>
                <label className="cp-range">
                  <span>Start {d.trimStart.toFixed(1)}s</span>
                  <input type="range" min={0} max={d.duration} step={0.1} value={d.trimStart} onChange={(e) => set({ trimStart: Math.min(Number(e.target.value), d.trimEnd - 0.5) })} />
                </label>
                <label className="cp-range">
                  <span>End {d.trimEnd.toFixed(1)}s</span>
                  <input type="range" min={0} max={d.duration} step={0.1} value={d.trimEnd} onChange={(e) => set({ trimEnd: Math.max(Number(e.target.value), d.trimStart + 0.5) })} />
                </label>
                <small className="cp-hint">Clip length {(d.trimEnd - d.trimStart).toFixed(1)}s</small>
              </>
            ) : (
              <small className="cp-hint">Reading video length…</small>
            )}
          </section>
        )}

        <section className="cp-section">
          <label className="cp-caption">
            <h3>Caption</h3>
            <textarea value={d.caption} maxLength={300} onChange={(e) => set({ caption: e.target.value })} placeholder="Say something about the night…" />
          </label>
        </section>

        <section className="cp-section">
          <h3>Tag a venue or event</h3>
          <div className="cp-chips">
            {TAGS.map((t) => (
              <button key={t} aria-pressed={d.tag === t} className={d.tag === t ? "on" : ""} onClick={() => set({ tag: d.tag === t ? "" : t })}>
                <Icon name={t.includes(":") ? "calendar" : "map"} size={14} /> {t}
              </button>
            ))}
          </div>
        </section>

        <section className="cp-section">
          <h3>Audience</h3>
          <div className="cp-audience" role="radiogroup" aria-label="Audience">
            {AUDIENCES.map((a) => (
              <button key={a.id} role="radio" aria-checked={d.audience === a.id} className={d.audience === a.id ? "on" : ""} onClick={() => set({ audience: a.id })}>
                <i />
                <span>
                  <b>{a.id}</b>
                  <small>{a.detail}</small>
                </span>
              </button>
            ))}
          </div>
        </section>

        

        <div className="cp-bar">
          {phase === "uploading" ? (
            <div className="cp-progress" role="progressbar" aria-valuenow={Math.round(progress)} aria-valuemin={0} aria-valuemax={100}>
              <span>Uploading… {Math.round(progress)}%</span>
              <i style={{ width: `${progress}%` }} />
            </div>
          ) : phase === "failed" ? (
            <div className="cp-failed" role="alert">
              <span>
                <b>Upload failed</b>
                <small>Your {d.mode.toLowerCase()} is saved. Check your connection and retry.</small>
              </span>
              <Button onClick={publish}>Retry</Button>
            </div>
          ) : (
            <Button className="full-width" onClick={publish}>
              Publish {d.mode === "Story" ? "to story" : d.mode.toLowerCase()}
            </Button>
          )}
        </div>
      </main>
    </div>
  )
}

function poster(src: string, at: number): Promise<string | null> {
  return new Promise((resolve) => {
    const v = document.createElement("video")
    v.muted = true
    v.src = src
    v.onloadeddata = () => {
      v.currentTime = Math.min(at + 0.05, Math.max(0, (v.duration || 1) - 0.05))
    }
    v.onseeked = () => {
      try {
        const c = document.createElement("canvas")
        c.width = v.videoWidth
        c.height = v.videoHeight
        c.getContext("2d")!.drawImage(v, 0, 0)
        resolve(c.toDataURL("image/jpeg", 0.8))
      } catch {
        resolve(null)
      }
    }
    v.onerror = () => resolve(null)
    window.setTimeout(() => resolve(null), 3000)
  })
}
