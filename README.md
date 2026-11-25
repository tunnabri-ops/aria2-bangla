# aria2 Bangla — হালকা ও শক্তিশালী ডাউনলোডার

Bangla-ready aria2 setup, built on **aria2/aria2**.

- **Original repo:** https://github.com/aria2/aria2 (হালকা কমান্ড-লাইন ডাউনলোড ইউটিলিটি — HTTP/HTTPS, FTP, BitTorrent, Metalink; এক ফাইল অনেক ভাগে ভাগ করে নামায়)

## কী আছে / What is inside

- `aria2.conf` — রেডি কনফিগ: ১৬ কানেকশন, রিজিউম, রিট্রাই, স্পিড লিমিট — প্রতিটি অপশন অফিসিয়াল ম্যানুয়াল থেকে যাচাই করা।
- `download-bangla.sh` — ব্যাচ ডাউনলোডার: `video` / `audio` / `slow` / `batch` প্রিসেট।
- `example-urls.txt` — পরীক্ষার জন্য ৪টি পাবলিক ফাইল (সব HTTP 200 যাচাই করা)।

## যা ঠিক করা হয়েছে / What was fixed

- Upstream-এর ম্যানুয়াল বিশাল — কোন অপশনটা আসলে লাগে, বোঝা কঠিন। এই কনফিগে শুধু দরকারি অপশনগুলোই আছে, Bangla কমেন্টসহ।
- Upstream-এ কোনো রেডি কনফিগ বা ব্যাচ স্ক্রিপ্ট নেই — এখানে দুটোই আছে, ভিডিও/অডিও আলাদা প্রিসেটসহ।

## ব্যবহার / How to use

```bash
# 1. ইনস্টল (Ubuntu/Debian)
sudo apt install aria2

# 2. একটা ফাইল নামান (কনফিগসহ)
aria2c --conf-path=aria2.conf https://example.com/file.zip

# 3. প্রিসেট দিয়ে নামান
bash download-bangla.sh video https://example.com/movie.mp4
bash download-bangla.sh audio https://example.com/song.mp3
bash download-bangla.sh slow  https://example.com/big.iso   # 1 MB/s সীমা

# 4. তালিকা থেকে অনেক ফাইল একসাথে
bash download-bangla.sh batch example-urls.txt

# 5. আধা-ডাউনলোড আবার চালু করুন (resume) — একই কমান্ড আবার দিন,
#    continue=true থাকায় যেখান থেকে থেমেছিল সেখান থেকে চলবে
```

স্পিড লিমিট দিতে `aria2.conf`-এ `max-overall-download-limit`-এর `#` সরিয়ে
মান বসান (যেমন `5M`)।
