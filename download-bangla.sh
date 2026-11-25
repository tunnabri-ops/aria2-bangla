#!/usr/bin/env bash
# download-bangla.sh — aria2 দিয়ে ব্যাচ ডাউনলোড (ভিডিও/অডিও প্রিসেটসহ)
# ব্যবহার:
#   bash download-bangla.sh video  <url>...      # ভিডিও প্রিসেট (১৬ কানেকশন)
#   bash download-bangla.sh audio  <url>...      # অডিও প্রিসেট (হালকা)
#   bash download-bangla.sh batch  example-urls.txt   # ফাইল থেকে অনেক URL
#   bash download-bangla.sh slow   <url>...      # ১ MB/s সীমা
#
# aria2.conf থাকলে সেটা পড়া হয়; প্রিসেট অপশনগুলো তার উপর প্রয়োগ হয়।

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$SCRIPT_DIR/aria2.conf"
OUTDIR="${HOME}/Downloads/aria2"

usage() {
    echo "ব্যবহার / Usage:"
    echo "  bash download-bangla.sh video <url>..."
    echo "  bash download-bangla.sh audio <url>..."
    echo "  bash download-bangla.sh batch <url-তালিকা.txt>"
    echo "  bash download-bangla.sh slow  <url>..."
    exit 1
}

if ! command -v aria2c >/dev/null 2>&1; then
    echo "aria2c পাওয়া যায়নি। ইনস্টল করুন:" >&2
    echo "  Ubuntu/Debian: sudo apt install aria2" >&2
    echo "  macOS:         brew install aria2" >&2
    echo "  Windows:       choco install aria2 (অথবা aria2.github.io থেকে নিন)" >&2
    exit 1
fi

mkdir -p "$OUTDIR"
[ $# -ge 1 ] || usage

MODE="$1"; shift
[ $# -ge 1 ] || usage

# aria2.conf থাকলে ব্যবহার করো, না থাকলে ডিফল্টেই চলবে
CONF_ARGS=()
if [ -f "$CONF" ]; then
    CONF_ARGS=(--conf-path="$CONF")
fi

case "$MODE" in
    video)
        # ভিডিও: ১৬ কানেকশন, ১৬ ভাগ, রিজিউম অন
        echo "ভিডিও প্রিসেট: ১৬ কানেকশন, $OUTDIR-এ নামছে..."
        aria2c "${CONF_ARGS[@]}" \
            --dir="$OUTDIR" \
            --max-connection-per-server=16 --split=16 \
            --min-split-size=1M --continue=true \
            --max-tries=10 --retry-wait=5 \
            "$@"
        ;;
    audio)
        # অডিও: ফাইল ছোট, ৪ কানেকশনই যথেষ্ট; সার্ভারে চাপ কম
        echo "অডিও প্রিসেট: ৪ কানেকশন, $OUTDIR-এ নামছে..."
        aria2c "${CONF_ARGS[@]}" \
            --dir="$OUTDIR" \
            --max-connection-per-server=4 --split=4 \
            --min-split-size=1M --continue=true \
            --max-tries=10 --retry-wait=5 \
            "$@"
        ;;
    slow)
        # ধীরগতি: সব মিলিয়ে সর্বোচ্চ ১ MB/s (অন্য কাজের জন্য ব্যান্ডউইথ রেখে)
        echo "ধীরগতি প্রিসেট: সর্বোচ্চ ১ MB/s..."
        aria2c "${CONF_ARGS[@]}" \
            --dir="$OUTDIR" \
            --max-connection-per-server=8 --split=8 \
            --max-overall-download-limit=1M \
            --continue=true --max-tries=10 --retry-wait=5 \
            "$@"
        ;;
    batch)
        # ফাইল থেকে URL তালিকা: প্রতি লাইনে একটা URL (# দিয়ে কমেন্ট)
        LIST="$1"
        [ -f "$LIST" ] || { echo "ফাইল পাওয়া যায়নি: $LIST" >&2; exit 1; }
        echo "ব্যাচ ডাউনলোড: $LIST থেকে, $OUTDIR-এ নামছে..."
        aria2c "${CONF_ARGS[@]}" \
            --dir="$OUTDIR" \
            --input-file="$LIST" \
            --max-concurrent-downloads=3 \
            --continue=true --max-tries=10 --retry-wait=5
        ;;
    *)
        usage
        ;;
esac

echo
echo "শেষ! ফাইল আছে: $OUTDIR"
