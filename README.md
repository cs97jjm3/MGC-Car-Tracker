# 🏷️ MGC Price Monitor 

> **Note:** Formerly known as "MGC Car Tracker" - renamed in v2.0 to reflect universal item tracking capabilities.

Universal automated price monitoring tool that tracks any items (cars, electronics, furniture, toys, and more) and sends email alerts when prices change. Built for smart shoppers with configurable schedules, thresholds, and visual dashboard.

## ✨ Features

- **🎯 Universal Tracking**: Monitor ANY category - cars, electronics, furniture, toys, sports equipment
- **📧 Smart Alerts**: Configurable thresholds - only alert for significant changes (£100+ or 5%+)
- **👥 Per-Item Recipients**: Different people get alerts for items they're interested in
- **📊 Real-time Dashboard**: Visual price history graphs at http://localhost:3739
- **🗓️ Weekly Summaries**: Comprehensive overview of all tracked items and price trends
- **⏰ Automated Scheduling**: UK timezone-aware with customizable check times
- **💾 Price History**: SQLite database stores complete pricing history
- **🔒 Enhanced Scraping**: Bypasses basic bot detection on major retailers
- **🛡️ Robust Error Handling**: Automatic retries, failure tracking, and intelligent alerts
- **🌐 Web Management**: Add/pause/delete items through browser interface

## 🚀 Quick Start

```bash
# Clone and install
git clone [repository-url]
cd MGC-Price-Monitor
npm install

# Configure
cp config.example.json config.json
# Edit config.json with your items and Gmail settings

# Test
npm run check

# Run continuously
npm start
```

Once running, visit **http://localhost:3739** for the dashboard.

## ⚙️ Configuration

Edit `config.json`:

```json
{
  "email": {
    "sender": "your-gmail@gmail.com",
    "password": "your-gmail-app-password"
  },
  "items": [
    {
      "url": "https://dealer.com/item-url",
      "name": "Item Description",
      "category": "Cars",
      "recipients": ["buyer1@email.com", "buyer2@email.com"],
      "thresholds": {
        "minAmount": 100,
        "minPercent": 5
      }
    }
  ],
  "schedule": {
    "times": ["06:00", "08:00", "10:00", "12:00", "14:00", "16:00", "18:00", "20:00", "22:00"],
    "timezone": "Europe/London"
  },
  "weeklyEmail": {
    "enabled": true,
    "dayOfWeek": "sunday",
    "time": "18:00"
  }
}
```

### Categories

Organize your tracked items:
- 🚗 Cars
- 🪑 Furniture  
- 🍳 Kitchen
- 🧸 Toys
- 💻 Electronics
- 🌱 Garden
- 👕 Clothing
- ⚽ Sports
- ...or any custom category!

### Smart Thresholds

Prevent email spam from minor price fluctuations:
- `minAmount`: Only alert if price drops by this amount or more (e.g., £100)
- `minPercent`: Only alert if price drops by this percentage or more (e.g., 5%)
- Alerts sent if **either** threshold is met
- Only applies to price drops (increases always alert)

## 📧 Gmail Setup

1. Enable 2-Step Verification in your Google Account
2. Go to Security → App passwords
3. Generate app password for "Mail"
4. Use this password in config.json (not your regular Gmail password)

## 🎮 Usage

**Continuous monitoring:**
```bash
npm start
```
- Starts price checking, weekly emails, and dashboard
- Dashboard available at http://localhost:3739

**One-time check:**
```bash
npm run check
```

**Test email setup:**
```bash
node test-email.js
```

## 🌐 Web Dashboard

Access at **http://localhost:3739**

### Main Dashboard
- Real-time prices for all tracked items
- Price change indicators (📉📈➡️)
- Category badges
- Quick links to item listings
- Auto-refresh every 5 minutes

### Management Interface (`/manage`)
Add items through the browser:
1. Click "Add New Item"
2. Enter item URL and name
3. Select category
4. Set optional recipient emails and thresholds
5. Click "Add Item" - automatically saves to config.json

Manage existing items:
- **Pause**: Temporarily stop checking an item
- **Resume**: Restart monitoring  
- **Delete**: Remove item completely

### Individual Item Pages (`/item/N`)
Click any item name to see:
- Complete price history table
- Interactive price trend graph
- All recorded price changes with dates
- Current statistics (highest, lowest, range)

## 🌍 Remote Access with ngrok

Access your dashboard from anywhere using ngrok:

### Setup ngrok
1. **Install ngrok**: Download from https://ngrok.com/download
2. **Sign up**: Create free account at https://ngrok.com
3. **Get auth token**: Copy from https://dashboard.ngrok.com/get-started/your-authtoken
4. **Configure**: Run `ngrok config add-authtoken YOUR_TOKEN`

### Start Remote Access
```bash
# In terminal 1: Start MGC Price Monitor
npm start

# In terminal 2: Create ngrok tunnel
ngrok http 3739
```

### Access Dashboard
ngrok will display a URL like:
```
Forwarding   https://abc123.ngrok-free.app -> http://localhost:3739
```

**Now accessible from anywhere:**
- Dashboard: `https://abc123.ngrok-free.app/`
- Management: `https://abc123.ngrok-free.app/manage`
- Item details: `https://abc123.ngrok-free.app/item/0`

### Security Tips
- Free ngrok URLs are public - anyone with the URL can access
- URL changes each time you restart ngrok
- For permanent URLs and password protection, upgrade to ngrok paid plan
- Monitor your ngrok dashboard for unusual traffic
- Stop ngrok (Ctrl+C) when not needed

### Keep Running 24/7
**Option 1: Two terminals**
```bash
# Terminal 1
npm start

# Terminal 2  
ngrok http 3739
```

**Option 2: Background service (Windows)**
```powershell
# Save your ngrok URL
ngrok http 3739 > ngrok.log &

# Or use Windows Task Scheduler to run both on startup
```

**Option 3: Cloud deployment**
Deploy to AWS/Azure/Google Cloud for professional 24/7 hosting with proper security.

## 🛡️ Error Handling

### Automatic Retry Logic
The tracker handles temporary errors with intelligent retries:
- **Attempt 1**: Fails → wait 2s → retry with different user agent
- **Attempt 2**: Fails → wait 4s → retry  
- **Attempt 3**: Fails → log failure

### Failure Types
- **404 Not Found**: Item likely sold or removed
- **403 Forbidden**: Site blocking access (enhanced scraper helps bypass)
- **Parse Error**: Price format changed
- **Timeout**: Network issues (auto-retry)
- **500 Server Error**: Site down (auto-retry)

### Enhanced Bot Detection Bypass
- Multiple rotating user agents (Chrome, Firefox, Safari)
- Complete browser headers (Accept, Referer, DNT)
- Random delays between attempts
- Works on most major retailers including Lego, Amazon marketplace dealers, etc.

### Alert System
**Immediate Alert** (3 consecutive failures):
- Email explaining the error
- Direct link to check item
- Suggested actions

**Daily Summary** (6pm):
- All failures that occurred today
- Only sent if failures exist

**Weekly Summary** (Sunday 6pm):
- Items with 7+ days of failures
- Suggested items to remove

## 📊 Database

Price history stored in `item-prices.db` (SQLite):
- All monitored items with complete price history
- UK timezone timestamps
- Mileage tracking (for cars)
- Category organization

## 🔧 Advanced Configuration

### Per-Item Recipients
Each item can have different watchers:
```json
{
  "name": "Lego Death Star",
  "category": "Toys",
  "recipients": ["dad@email.com", "son@email.com"]
},
{
  "name": "Garden Furniture Set",
  "category": "Garden", 
  "recipients": ["mum@email.com", "daughter@email.com"]
}
```

### Custom Schedules
```json
{
  "schedule": {
    "times": ["06:00", "12:00", "18:00"],
    "timezone": "Europe/London"
  }
}
```

### Change Dashboard Port
The dashboard runs on port 3739 by default. To change it:

**Edit dashboard.js:**
```javascript
// Line 7 in dashboard.js
this.port = 3739;  // Change to your preferred port
```

Then restart the application and access at your new port (e.g., `http://localhost:8080`).

**Update ngrok command:**
```bash
ngrok http YOUR_PORT
```

### Failure Alert Configuration
```json
{
  "failureAlerts": {
    "immediate": true,
    "dailySummary": true,
    "dailySummaryTime": "18:00",
    "circuitBreaker": {
      "consecutiveFailures": 5,
      "waitHours": 24
    }
  }
}
```

## 📁 File Structure

```
MGC Price Monitor/
├── index.js              # Main scheduler + launcher
├── check-prices.js       # Price checking engine
├── database.js           # SQLite handler
├── scraper.js           # Enhanced web scraper
├── email.js             # Gmail notifications
├── dashboard.js         # Web interface server
├── weekly-summary.js    # Weekly report generator
├── daily-failure-summary.js  # Daily failure digest
├── config.json          # Your configuration
├── item-prices.db       # Price history database
├── logo.png             # MGC logo
└── README.md            # This file
```

## 🔍 Technical Details

- **Web Scraping**: Cheerio + Axios with anti-bot measures
- **Database**: sql.js (pure JavaScript SQLite)
- **Email**: Nodemailer with Gmail SMTP
- **Scheduling**: node-cron with timezone support  
- **Dashboard**: Chart.js for visualizations
- **Bot Detection Bypass**: Rotating user agents, full browser headers

## 🛠️ Troubleshooting

**Emails not sending:**
- Verify Gmail app password (not regular password)
- Check spam folders  
- Ensure 2-step verification enabled

**Price not detected:**
- Website structure may differ
- Check console output for errors
- Try different item URL

**Dashboard not loading:**
- Check port 3739 isn't in use
- Verify tracker is running (`npm start`)

**403 Forbidden errors:**
- Enhanced scraper retries with different signatures
- Some sites still may block (use smaller dealers)

## 📜 License

MIT License

## 👤 Author

James Murrell - Business Analyst specializing in practical automation

## 🎉 Version 2.0 Features

- ✅ Universal item tracking (not just cars!)
- ✅ Category organization
- ✅ Enhanced bot detection bypass
- ✅ Web-based item management
- ✅ Individual item detail pages
- ✅ Smart price thresholds
- ✅ Per-item email recipients
- ✅ Real-time dashboard with graphs
- ✅ Comprehensive failure handling
- ✅ Weekly and daily summaries

---

**Track anything. Save money. Stay informed.** 🏷️
