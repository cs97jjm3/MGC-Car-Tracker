# MGC Price Monitor - Deployment Script
# Run this after stopping the tracker with Ctrl+C

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host " MGC Car Tracker -> MGC Price Monitor Migration" -ForegroundColor Yellow
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Confirm
Write-Host "This will:" -ForegroundColor Yellow
Write-Host "  1. Delete car-prices.db (lose price history)" -ForegroundColor White
Write-Host "  2. Rename all files (cars -> items)" -ForegroundColor White
Write-Host "  3. Add category support" -ForegroundColor White
Write-Host "  4. Update config.json" -ForegroundColor White
Write-Host ""
$confirm = Read-Host "Continue? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Starting migration..." -ForegroundColor Green

# Step 2: Delete old database
if (Test-Path "car-prices.db") {
    Remove-Item "car-prices.db"
    Write-Host "✓ Deleted car-prices.db" -ForegroundColor Green
}

# Step 3: Replace files
Write-Host "Replacing files..." -ForegroundColor Yellow

Copy-Item "database-new.js" "database.js" -Force
Write-Host "✓ Updated database.js" -ForegroundColor Green

Copy-Item "check-prices-new.js" "check-prices.js" -Force
Write-Host "✓ Updated check-prices.js" -ForegroundColor Green

Copy-Item "scraper-new.js" "scraper.js" -Force  
Write-Host "✓ Updated scraper.js" -ForegroundColor Green

Copy-Item "config-new.json" "config.json" -Force
Write-Host "✓ Updated config.json (items + categories)" -ForegroundColor Green

# Step 4: Clean up temp files
Remove-Item "*-new.js" -ErrorAction SilentlyContinue
Remove-Item "config-new.json" -ErrorAction SilentlyContinue
Write-Host "✓ Cleaned up temporary files" -ForegroundColor Green

Write-Host ""
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host " Migration Complete!" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Rename folder: 'MGC Car Tracker' -> 'MGC Price Monitor'" -ForegroundColor White
Write-Host "  2. Update package.json name field" -ForegroundColor White
Write-Host "  3. Update git repo name on GitHub" -ForegroundColor White
Write-Host "  4. Run: npm start" -ForegroundColor White
Write-Host ""
