# MGC Price Monitor - Full Migration Guide

## Overview
This migrates **MGC Car Tracker** to **MGC Price Monitor** with:
- Rename: cars → items throughout codebase
- Add: Category support (Cars, Furniture, Kitchen, Toys, Electronics, Garden, Clothing, Sports)
- Keep: Your 3 car URLs and config (lose price history only)
- Database: Fresh start with new structure

---

## ⚠️ BEFORE YOU START

**1. Stop the tracker:**
```bash
# Press Ctrl+C in the terminal running npm start
```

**2. Backup (optional but recommended):**
```bash
# Copy entire folder somewhere safe
```

---

## STEP 1: Replace Core Files

I've created new versions with `-new` suffix. Replace the old files:

```powershell
# In MGC Car Tracker folder
Copy-Item "database-new.js" "database.js" -Force
Copy-Item "check-prices-new.js" "check-prices.js" -Force
Copy-Item "scraper-new.js" "scraper.js" -Force
Copy-Item "config-new.json" "config.json" -Force
Copy-Item "package-new.json" "package.json" -Force
```

---

## STEP 2: Delete Old Database

```powershell
Remove-Item "car-prices.db"
```

**Note:** This deletes price history. New database `item-prices.db` will be created on first run.

---

## STEP 3: Manual File Updates Required

These files need manual updates (I can't automate them easily):

### A. `email.js`
**Find and replace:**
- `car` → `item`  (careful with "care" etc)
- `Car` → `Item`
- Keep email formatting as-is

### B. `weekly-summary.js`
**Find and replace:**
- `config.cars` → `config.items`
- `car` → `item`
- `getCarId` → `getItemId`
- Add category grouping (optional - can skip for now)

### C. `daily-failure-summary.js`
**Find and replace:**
- `car` → `item`
- `carId` → `itemId`

### D. `dashboard.js` (BIG FILE - ~800 lines)
**Find and replace throughout:**
- `cars` → `items` (in config references)
- `car` → `item` (variable names)
- `addCar` → `addItem`
- `deleteCar` → `deleteItem`
- `toggleCar` → `toggleItem`
- `getCarId` → `getItemId`
- `"Car"` → `"Item"` (in UI text)
- `"MGC Car Tracker"` → `"MGC Price Monitor"`

**Add category dropdown to add form** (around line 600):
```html
<div class="form-group">
    <label for="category">Category</label>
    <select id="category" name="category" required>
        <option value="Cars">Cars</option>
        <option value="Furniture">Furniture</option>
        <option value="Kitchen">Kitchen</option>
        <option value="Toys">Toys</option>
        <option value="Electronics">Electronics</option>
        <option value="Garden">Garden</option>
        <option value="Clothing">Clothing</option>
        <option value="Sports">Sports</option>
    </select>
</div>
```

### E. `index.js`
**Find and replace:**
- `console.log('🚗 MGC Car Tracker')` → `console.log('🏷️ MGC Price Monitor')`
- Any other "Car Tracker" references

### F. `README.md`
**Complete rewrite needed - key changes:**
- Title: `# MGC Price Monitor`
- Description: Track prices for cars, furniture, toys, electronics, and more
- Update all examples to use `items` instead of `cars`
- Add category field to config examples
- Update features list to mention categories

---

## STEP 4: Clean Up Temp Files

```powershell
Remove-Item "*-new.js", "*-new.json"
```

---

## STEP 5: Rename Folder & Git

**A. Rename Windows folder:**
```powershell
# Navigate UP one level first
cd ..
Rename-Item "MGC Car Tracker" "MGC Price Monitor"
cd "MGC Price Monitor"
```

**B. Update Git:**
```bash
# Commit all changes
git add .
git commit -m "Renamed to MGC Price Monitor with category support"

# On GitHub:
#  1. Go to repo Settings
#  2. Rename repository to "MGC-Price-Monitor"
#  3. Update local remote:

git remote set-url origin https://github.com/cs97jjm3/MGC-Price-Monitor.git
git push
```

---

## STEP 6: Test

```bash
npm start
```

**Should see:**
- `🏷️ MGC Price Monitor started`
- `📊 Dashboard available at: http://localhost:3739`
- Database creates `item-prices.db`
- First price check runs

**Visit dashboard:**
```
http://localhost:3739
```

---

## ✅ VERIFICATION CHECKLIST

- [ ] Database file is `item-prices.db` (not `car-prices.db`)
- [ ] Dashboard title says "MGC Price Monitor"
- [ ] Add Item form has Category dropdown
- [ ] Config has `items:` array (not `cars:`)
- [ ] All 3 cars have `"category": "Cars"`
- [ ] Email alerts say "item" not "car"
- [ ] Console logs say "Checking item prices"
- [ ] Git repo renamed on GitHub
- [ ] Folder renamed on Windows

---

## 🆘 IF SOMETHING BREAKS

1. **Stop tracker**: Ctrl+C
2. **Restore backup** (if you made one)
3. **OR** Delete `item-prices.db` and restart

---

## 🎯 WHAT YOU GET

**New Features:**
- ✅ Track ANY product (not just cars)
- ✅ Categories (Cars, Furniture, Kitchen, Toys, Electronics, Garden, Clothing, Sports)
- ✅ Category filtering in dashboard (future)
- ✅ Grouped weekly summaries by category (future)
- ✅ Clean "MGC Price Monitor" branding

**What Stays:**
- ✅ All price checking logic
- ✅ Email alerts
- ✅ Weekly summaries
- ✅ Failure tracking
- ✅ Your 3 car URLs configured

**What's Lost:**
- ❌ Price history (starts fresh)

---

## Need Help?

Ask me to:
- Do specific find/replace operations
- Update individual files
- Fix any errors that come up

Good luck! 🚀
