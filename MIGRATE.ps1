# MGC Price Monitor - COMPLETE MIGRATION SCRIPT
# This does EVERYTHING - all file updates, renames, etc.

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " MGC Car Tracker → MGC Price Monitor" -ForegroundColor Yellow
Write-Host " COMPLETE AUTOMATED MIGRATION" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Confirm
Write-Host "This script will:" -ForegroundColor Yellow
Write-Host "  ✓ Delete car-prices.db (lose history)" -ForegroundColor White
Write-Host "  ✓ Update ALL .js files (cars→items)" -ForegroundColor White
Write-Host "  ✓ Add category support" -ForegroundColor White
Write-Host "  ✓ Update config with categories" -ForegroundColor White
Write-Host "  ✓ Update package.json" -ForegroundColor White
Write-Host ""
$confirm = Read-Host "Continue? Type YES to proceed"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Starting..." -ForegroundColor Green

# Delete old database
if (Test-Path "car-prices.db") {
    Remove-Item "car-prices.db"
    Write-Host "✓ Deleted car-prices.db" -ForegroundColor Green
}

# Replace new core files
Copy-Item "database-new.js" "database.js" -Force
Copy-Item "check-prices-new.js" "check-prices.js" -Force
Copy-Item "scraper-new.js" "scraper.js" -Force
Copy-Item "package-new.json" "package.json" -Force
Write-Host "✓ Core files updated" -ForegroundColor Green

# Update config.json
Copy-Item "config-new.json" "config.json" -Force
Write-Host "✓ Config updated (items + categories)" -ForegroundColor Green

# Update remaining files with find/replace
$files = @("email.js", "weekly-summary.js", "daily-failure-summary.js", "index.js")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Replace cars → items
        $content = $content -replace 'config\.cars', 'config.items'
        $content = $content -replace '\.cars\[', '.items['
        $content = $content -replace 'for \(const car of', 'for (const item of'
        $content = $content -replace 'forEach\(car =>', 'forEach(item =>'
        $content = $content -replace '\bcar\.', 'item.'
        $content = $content -replace 'carId', 'itemId'
        $content = $content -replace 'carDetails', 'itemDetails'
        $content = $content -replace 'Car Tracker', 'Price Monitor'
        $content = $content -replace 'car prices', 'item prices'
        $content = $content -replace 'Checking car', 'Checking item'
        $content = $content -replace 'getCarId', 'getItemId'
        $content = $content -replace 'addCar', 'addItem'
        $content = $content -replace 'getAllCars', 'getAllItems'
        $content = $content -replace 'CarScraper', 'ItemScraper'
        $content = $content -replace 'scrapeCarDetails', 'scrapeItemDetails'
        $content = $content -replace 'View Car Listing', 'View Item Listing'
        $content = $content -replace '🚗', '🏷️'
        
        Set-Content $file $content
        Write-Host "✓ Updated $file" -ForegroundColor Green
    }
}

# Clean up temp files
Remove-Item "*-new.js", "*-new.json" -ErrorAction SilentlyContinue
Write-Host "✓ Cleaned up temp files" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Migration Complete!" -ForegroundColor Green  
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  DASHBOARD.JS needs manual update:" -ForegroundColor Yellow
Write-Host "    Open dashboard.js and replace:" -ForegroundColor White
Write-Host "    - All 'car' → 'item'" -ForegroundColor White
Write-Host "    - 'Car Tracker' → 'Price Monitor'" -ForegroundColor White
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  1. Fix dashboard.js (see above)" -ForegroundColor White
Write-Host "  2. Run: npm start" -ForegroundColor White
Write-Host "  3. Test at http://localhost:3739" -ForegroundColor White
Write-Host ""
Write-Host "Folder rename:" -ForegroundColor Yellow
Write-Host "  cd .." -ForegroundColor White
Write-Host "  Rename-Item 'MGC Car Tracker' 'MGC Price Monitor'" -ForegroundColor White
Write-Host ""
