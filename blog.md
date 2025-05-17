## **airborne texts**

i love a good book club.
it’s how i’ve stayed close to people through years of packing and unpacking.
shared books have been postcards. a memory-keeper. ways back.

so i started wondering: what if you could stumble into a book club, just by joining a wifi network?

somewhere between a local hotspot and a love letter, this project asks:
what *is* connection, really?
and what could it be, outside of the internet?

you connect.
and then—

```
(\ (\
(„• ֊ •„)
━O━O━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ˖ ݁𖥔. you fall down the rabbit hole .𖥔 ݁ ˖
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

a simple html page opens. black and white. nothing fancy.
reminds me of e-ink readers.
quiet screens. nothing yelling at you.

at the bottom?
a lo-fi library full of critical tech theory, speculative manifestos, essays about surveillance and bias and power and all the invisible systems we swim in.

**airborne texts** is a whisper from the network.
a reminder to stop doomscrolling.
take a break.
read something that cracks you open a little.

---

## why this? why now?

**solidarity infrastructures** at the school for poetic computation got into my bones.

it made clear, yet again, that infrastructure is never neutral. it never was.
who builds it, who owns it, who it leaves behind. that stuff matters.

so i wanted to build something that resists frictionless design.
something that sits quietly outside the algorithm.
a kind of anti-feed.

because i believe the most radical thing we can do right now is *think critically*.
and read deeply.
and talk about it.
especially outside the dopamine loops. outside of subscriptions and paywalls and notification bells.

---

## what’s in the library?

the collection was pulled together over years:
from tech shelves in libraries around the world.
from zines i found thumbing through hours of links.
from books i stayed up too late reading.
they made me want to dismantle a server farm with my bare hands.

some books are full-length; some are short, sharp essays.
i've got over 75 titles so far. more are always coming.

themes range wide but stay critical:
* surveillance
* racism & algorithmic bias
* digital labor
* military tech
* speculative futures
* the aesthetics of power

each title has a little author blurb and a link to buy it (support authors, always!).
you can read them right there on the portal. it's all hand-built html. no javascript. no distractions.
a space made for quiet reading.

---

## the technical bones...

the whole system runs off a little raspberry pi 4b.
it was sitting in a drawer. now it lives in my bag.

the pi runs linux and creates its own local wifi network.
no internet access. no signal. just the library.

when someone connects, a captive portal triggers and opens a local webpage.
no ads. no trackers. just text. and a lot of care.

---

## ...and the flesh

raspberry pi 4b -> running linux -> broadcasting a local-only wifi hotspot -> captive portal triggers a static html page -> entire library is served locally

this was my first time working with networking.
i cursed. i googled. i learned.
in the end, i made something i was proud of.
no backend. no analytics. no noise.

---

## final thoughts

right now, the network’s called **library.local**
but it might show up with a new name, in a new city, in a new bag.

this isn’t a replacement for the internet.
it’s the seeds of a rebellion. a portable portal. a reminder that other kinds of networks exist.

ones built on curiosity.
on trust.
on care.

and if nothing else, i hope it makes you pause.
just for a moment.
before you reconnect to the feed.

---

📬 want to share a book rec or ask questions?  
i’d love that: **[naestech@proton.me](mailto:naestech@proton.me)**
