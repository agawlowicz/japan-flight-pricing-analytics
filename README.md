# 🇯🇵 Japan Flight Pricing Intelligence

A pricing analytics tool analyzing flight price volatility, seasonal demand 
patterns, and optimal booking windows for Tokyo (HND/NRT) and Osaka (KIX) destinations from United States origin airports New York (JFK), Los Angeles (LAX), San Francisco (SFO), Chicago (ORD), Seattle (SEA) — 
featuring an AI-powered pricing briefing for travel analysts.

---

## 🎯 Project Purpose

This project mirrors real-world travel fintech analytics by exploring how 
flight prices behave across Japan's most popular destinations. It was built 
to demonstrate pricing analytics architecture using SQL, Python, and Looker 
Studio — with an AI insights layer that generates plain-English pricing 
intelligence briefings.

---

## 🗾 Destinations Covered

### Japan Airports
| Airport | Code | City | Notes |
|---------|------|------|-------|
| Tokyo Haneda | HND | Tokyo | Closer to city center, higher competition, slightly lower fares |
| Tokyo Narita | NRT | Tokyo | Higher volume, more budget carriers, slightly higher fares |
| Kansai International | KIX | Osaka | Gateway to Osaka, fewer direct US routes = higher fares |

### US Origin Airports
| Airport | Code | City | Notes |
|---------|------|------|-------|
| John F. Kennedy | JFK | New York | Longest haul, highest base fares |
| Los Angeles Intl | LAX | Los Angeles | Most direct routes, strongest competition, lowest base fares |
| San Francisco Intl | SFO | San Francisco | Similar to LAX with slight premium |
| O'Hare Intl | ORD | Chicago | Limited direct routing, East Coast pricing |
| Seattle-Tacoma | SEA | Seattle | Short Pacific crossing, competitive fares |

---

## 🌸 Seasonal Demand Patterns Analyzed

| Season | Period | Demand Level | Notes |
|--------|--------|-------------|-------|
| Cherry Blossom | March–April | 🔴 Peak | Highest price volatility |
| Golden Week | Late April–May | 🔴 Peak | Domestic + international overlap |
| Summer | July–August | 🟡 Moderate | High heat reduces Western demand |
| Fall Foliage | October–November | 🟠 High | Second peak season |
| Winter | December–February | 🟢 Low–Moderate | Niche appeal — onsens, snow monkeys |

---

## 🛠️ Tech Stack

- **SQL** — Data cleaning and metric calculations
- **Python** — Data processing and OpenAI API integration
- **Looker Studio** — Interactive self-service dashboard
- **Streamlit** — Live AI-powered pricing insights app
- **GitHub** — Version control and project documentation

---

## 📊 Key Metrics Analyzed

- Average flight price by route and season
- Price volatility index by travel period
- Optimal booking window (days in advance)
- Demand index by month
- Price premium during peak seasons vs baseline

---

## 🤖 AI Insights Layer

An AI-powered pricing briefing tool that reads current pricing trends and 
generates plain-English intelligence summaries — similar to what a travel 
fintech analyst would produce for internal stakeholders or B2B partners.

---

## 📁 Project Structure
```
japan-flight-pricing-analytics/
│
├── data/          # Raw and cleaned flight pricing datasets
├── sql/           # Metric queries and data transformations  
├── python/        # AI insights script and data processing
├── dashboard/     # Looker Studio screenshots and live link
└── README.md      # Project documentation
```

---

## 🚧 Status

Currently in development — full dashboard and AI insights app coming soon.

---

## ✈️ Personal Connection

This project was inspired by two personal trips to Japan that gave me 
firsthand experience with exactly the kind of seasonal demand and pricing 
patterns analyzed here.

My first trip was during early cherry blossom season in Tokyo, Osaka, and 
Kyoto — catching the blooms just as they were starting, which meant 
experiencing the price premium of peak season firsthand. We also traveled 
to Nagano on that trip, enjoying onsens in the snow — a completely different 
side of Japan that most Western travelers overlook.

My second trip was a full month in October, deliberately chosen for the fall 
foliage season, comfortable temperatures, and significantly smaller crowds 
compared to spring. That trip extended beyond the classic route — from Tokyo, 
Kyoto, and Osaka south to Yufuin, a charming onsen town in Oita Prefecture 
on Kyushu island, and east to Tottori, home to Japan's iconic sand dunes and 
one of the country's most undervisited destinations (and where my fiancé 
proposed!). We also attended the World Expo, experiencing firsthand how 
major events create dramatic crowd and demand surges — exactly the kind of 
external demand driver that impacts travel pricing models.

Having personally navigated flight pricing across two very different seasons, 
experienced both peak and off-peak demand firsthand, and traveled beyond the 
typical tourist routes — I brought real traveler intuition to every metric 
and seasonal insight in this project. Understanding *why* travelers make the 
decisions they do is just as important as understanding the data behind those 
decisions.

---

## 🤖 Development Notes

This project was developed using AI-assisted workflows, including Claude 
(Anthropic) for project architecture and documentation, and the OpenAI API 
for the pricing insights generation layer. This reflects the AI-augmented 
analytics approach central to modern travel fintech platforms — and mirrors 
the kind of work this project was built to demonstrate.