// Demo content and the booking math shared by every screen.

export const media = {
  hero: "https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=1080&q=88",
  crowd: "https://images.unsplash.com/photo-1622743941533-cde694bff56a?auto=format&fit=crop&w=1080&q=88",
  dj: "https://images.unsplash.com/photo-1623099405608-83508f309cc2?auto=format&fit=crop&w=1080&q=88",
  stage: "https://images.unsplash.com/photo-1647885672601-da4e2f8eaf94?auto=format&fit=crop&w=1080&q=88",
  venue: "https://images.unsplash.com/photo-1781078687115-115e4247216e?auto=format&fit=crop&w=1080&q=88",
  table: "https://images.unsplash.com/photo-1781955781178-6ea29c66e860?auto=format&fit=crop&w=1080&q=88",
  bottles: "https://images.unsplash.com/photo-1763081756934-ea920762e6ad?auto=format&fit=crop&w=1080&q=88",
  friends: "https://images.unsplash.com/photo-1792323090100-628c95bd8283?auto=format&fit=crop&w=1080&q=88",
  pro: "https://images.unsplash.com/photo-1516873240891-4bf014598ab4?auto=format&fit=crop&w=1080&q=88",
  photographer: "https://images.unsplash.com/photo-1711473610014-0505db6f6702?auto=format&fit=crop&w=1080&q=88",
}

export const venueAddress = "19 Mercer St, Toronto"
export const mapsUrl = "https://www.google.com/maps/search/?api=1&query=19+Mercer+St+Toronto"

export type TableId = "halo" | "arc"

export type Table = {
  id: TableId
  name: string
  level: string
  capacity: number
  minimum: number // dollars
  deposit: number // dollars
  image: string
  planNumber: number
}

export const tables: Record<TableId, Table> = {
  halo: {
    id: "halo",
    name: "Halo Booth",
    level: "Upper level",
    capacity: 6,
    minimum: 1000,
    deposit: 150,
    image: media.table,
    planNumber: 4,
  },
  arc: {
    id: "arc",
    name: "Arc Table",
    level: "Main floor",
    capacity: 8,
    minimum: 1500,
    deposit: 200,
    image: media.bottles,
    planNumber: 2,
  },
}

export type NightDate = {
  id: string
  day: string
  month: string
  weekday: string
  label: string
  short: string
  event: string
}

export const nightDates: NightDate[] = [
  { id: "aug24", day: "24", month: "AUG", weekday: "Saturday", label: "Saturday, Aug 24", short: "Sat, Aug 24", event: "EONICS: Afterglow" },
  { id: "aug31", day: "31", month: "AUG", weekday: "Saturday", label: "Saturday, Aug 31", short: "Sat, Aug 31", event: "Neon Garden with Amara Vale" },
  { id: "sep7", day: "7", month: "SEP", weekday: "Saturday", label: "Saturday, Sep 7", short: "Sat, Sep 7", event: "Nova Saturdays" },
]

export const dateById = (id: string | null) => nightDates.find((d) => d.id === id) ?? nightDates[0]

export const arrivalTimes = ["11:30 PM", "12:30 AM", "1:30 AM"]
export const arrivalDay = (time: string) => (time.endsWith("PM") ? "Saturday" : "Sunday")
export const arrivalShortDay = (time: string) => (time.endsWith("PM") ? "Sat" : "Sun")

export type Bottle = { id: string; name: string; size: string; price: number; note: string }

export const bottleMenu: Bottle[] = [
  { id: "donjulio", name: "Don Julio 1942", size: "750 ML", price: 1000, note: "Soda, citrus & ice" },
  { id: "dom", name: "Dom Pérignon Brut", size: "750 ML", price: 850, note: "Chilled, with flutes" },
  { id: "greygoose", name: "Grey Goose", size: "1.75 L", price: 650, note: "Mixers & ice" },
]

// Bottles the venue has marked unavailable for a night (Venue page > Menu in BottlesUp Business).
// Demo data for tonight; live stock needs the shared backend.
export const UNAVAILABLE: Record<string, string[]> = { aug24: ["dom"] }

export const MAX_BOTTLES = 4

/* Bottle presentation sign: a message carried out with your bottles. */
export type SignStyle = "led" | "sparkler" | "neon"
export type BottleSign = { style: SignStyle; text: string; bottleId: string; timing: "On arrival" | "At midnight" | "When we ask" }
export const SIGN_STYLES: { id: SignStyle; name: string; price: number; note: string }[] = [
  { id: "led", name: "LED message board", price: 25, note: "Lit board carried out with your bottles" },
  { id: "sparkler", name: "Sparkler sign", price: 40, note: "Board with venue-approved sparklers" },
  { id: "neon", name: "Neon script", price: 60, note: "Glowing script that stays at your table" },
]
export const SIGN_MAX = 24
export const signCheck = (text: string) => {
  const t = text.trim()
  if (!t) return "Add a message for your sign."
  if (t.length > SIGN_MAX) return `Keep it to ${SIGN_MAX} characters.`
  if (/\b(fuck|shit|bitch|cunt|nigg)/i.test(t)) return "The venue won't print that. Try something else."
  return null
}

export type Quote = {
  deposit: number
  bottleLines: { name: string; qty: number; amount: number }[]
  bottleTotal: number
  credit: number
  fee: number
  tax: number
  total: number
  dueAtVenue: number
  minimum: number
  applied: number // deposit + prepaid bottles that count toward the minimum
  signLine: { name: string; amount: number } | null
}

// All math in cents to avoid rounding drift. Service fee is 3% of what's charged today
// (the deposit is credited to bottles, so it's never charged twice); HST is 13% of that.
// Everything paid today, deposit included, counts toward the table minimum.
export function quote(table: Table, bottles: Record<string, number>, sign?: BottleSign | null): Quote {
  const deposit = table.deposit * 100
  const bottleLines = bottleMenu
    .filter((b) => (bottles[b.id] ?? 0) > 0)
    .map((b) => ({ name: b.name, qty: bottles[b.id], amount: b.price * 100 * bottles[b.id] }))
  const bottleTotal = bottleLines.reduce((sum, l) => sum + l.amount, 0)
  const credit = bottleTotal > 0 ? Math.min(deposit, bottleTotal) : 0
  const style = sign && bottleTotal > 0 ? SIGN_STYLES.find((s) => s.id === sign.style) : undefined
  const signLine = style ? { name: `${style.name} · “${sign!.style === "neon" ? sign!.text.trim() : sign!.text.trim().toUpperCase()}”`, amount: style.price * 100 } : null
  const extras = signLine?.amount ?? 0
  const fee = Math.round(((deposit + bottleTotal + extras - credit) * 3) / 100)
  const tax = Math.round(((deposit + bottleTotal + extras - credit + fee) * 13) / 100)
  const total = deposit + bottleTotal + extras - credit + fee + tax
  const applied = deposit + bottleTotal - credit
  const dueAtVenue = Math.max(0, table.minimum * 100 - applied)
  return { deposit, bottleLines, bottleTotal, credit, fee, tax, total, dueAtVenue, minimum: table.minimum * 100, applied, signLine }
}

export const money = (cents: number, decimals = true) =>
  "$" +
  (cents / 100).toLocaleString("en-CA", {
    minimumFractionDigits: decimals ? 2 : 0,
    maximumFractionDigits: decimals ? 2 : 0,
  })

export const bottleCount = (bottles: Record<string, number>) =>
  Object.values(bottles).reduce((a, b) => a + b, 0)

// Friends who can receive passes. Base status is what they did before you invited anyone.
export type Friend = { name: string; image: string; status: "accepted" | "checked" | "open" }

export const friends: Friend[] = [
  { name: "Maya Chen", image: media.friends, status: "accepted" },
  { name: "Noah Reid", image: media.dj, status: "checked" },
  { name: "Sofia Bell", image: media.crowd, status: "accepted" },
  { name: "Eli James", image: media.photographer, status: "open" },
  { name: "Priya Shah", image: media.pro, status: "open" },
  { name: "Marcus Lee", image: media.stage, status: "open" },
  { name: "Jade Kim", image: media.venue, status: "open" },
]

export type GuestSlot = { name: string; image?: string; status: "Accepted" | "Checked in" | "Sent" | "Open pass" }

// One pass per guest. You hold one; the rest go to friends.
export function guestSlots(guests: number, invited: string[]): GuestSlot[] {
  const slots: GuestSlot[] = []
  for (const f of friends) {
    if (f.status === "accepted") slots.push({ name: f.name, image: f.image, status: "Accepted" })
    if (f.status === "checked") slots.push({ name: f.name, image: f.image, status: "Checked in" })
  }
  for (const name of invited) {
    const f = friends.find((x) => x.name === name)
    slots.push({ name, image: f?.image, status: "Sent" })
  }
  while (slots.length < guests - 1) slots.push({ name: "Open pass", status: "Open pass" })
  return slots.slice(0, Math.max(0, guests - 1))
}

export function guestCounts(guests: number, invited: string[]) {
  const slots = guestSlots(guests, invited)
  const joined = 1 + slots.filter((s) => s.status === "Accepted" || s.status === "Checked in").length
  const sent = slots.filter((s) => s.status === "Sent").length
  const open = slots.filter((s) => s.status === "Open pass").length
  return { passes: guests, joined, sent, open }
}

export const nextInvitee = (invited: string[]) =>
  friends.find((f) => f.status === "open" && !invited.includes(f.name))?.name
