#!/bin/bash
# Upload ebix-app and ebix-upi to kirtigoyal2807 GitHub (after gh auth login)
set -e

echo "=== 1/2 Pilates app (ebix-app) ==="
bash "/Users/kirti/Desktop/LiveProjects/ebix-app/publish-to-github.sh"

echo ""
echo "=== 2/2 UPI app (ebix-upi) ==="
bash "/Users/kirti/Desktop/LiveProjects/EBIX-UPI/BHIM-22Aug/ebixcash_bhim_upi/publish-to-github.sh"

echo ""
echo "=== Both repos published ==="
echo "https://github.com/kirtigoyal2807/ebix-app"
echo "https://github.com/kirtigoyal2807/ebix-upi"
