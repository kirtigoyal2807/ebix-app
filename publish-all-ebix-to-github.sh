#!/bin/bash
# Upload all Ebix projects to kirtigoyal2807 GitHub (after gh auth login)
set -e

echo "=== 1/3 Pilates app (ebix-app) ==="
bash "/Users/kirti/Desktop/LiveProjects/ebix-app/publish-to-github.sh"

echo ""
echo "=== 2/3 UPI Flutter app (ebix-upi) ==="
bash "/Users/kirti/Desktop/LiveProjects/EBIX-UPI/BHIM-22Aug/ebixcash_bhim_upi/publish-to-github.sh"

echo ""
echo "=== 3/3 EbixCash iOS (ebixcash-ios) ==="
bash "/Users/kirti/Desktop/LiveProjects/EbixCash App/updated-Code-30May/Develop-13JAN/ebix-cash-iOS/publish-to-github.sh"

echo ""
echo "=== All repos published ==="
echo "https://github.com/kirtigoyal2807/ebix-app"
echo "https://github.com/kirtigoyal2807/ebix-upi"
echo "https://github.com/kirtigoyal2807/ebixcash-ios"
