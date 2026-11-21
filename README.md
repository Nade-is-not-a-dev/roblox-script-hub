# Roblox Script Hub

Struktur repo untuk host script game satu per satu.

```text
init.lua                         loader pertama
games/107430170196919.lua        script game biliar
README.md                        file ini
```

## Cara pakai

1. Upload folder ini ke GitHub, lalu pakai URL raw, misalnya:

   `https://raw.githubusercontent.com/Nade-is-not-a-dev/roblox-script-hub/master/`

2. Di executor, jalankan loader. Bisa langsung dengan URL raw `:loadstring(game:HttpGet(".../init.lua"))()` atau dengan override URL dulu:

   ```lua
   getgenv().HUB_BASE_URL = "https://raw.githubusercontent.com/Nade-is-not-a-dev/roblox-script-hub/master/"
   loadstring(game:HttpGet(getgenv().HUB_BASE_URL .. "init.lua"))()
   ```

3. `init.lua` akan menampilkan welcome screen, loading palsu sekitar 2 detik, lalu mengecek `game.PlaceId`.

4. Kalau PlaceId ada di `REGISTRY`, script game diunduh dan dijalankan. Kalau tidak ada, muncul layar "Game belum didukung" dengan tombol `TUTUP`.

Tombol `TUTUP` hanya menghancurkan GUI hub, bukan menutup Roblox.

## Menambah game baru

1. Taruh script game di `games/<PlaceId>.lua`.
2. Tambah entri di tabel `REGISTRY` pada `init.lua`:

   ```lua
   local REGISTRY = {
       [107430170196919] = "games/107430170196919.lua",
       [PLACE_ID_BARU] = "games/PLACE_ID_BARU.lua",
   }
   ```

3. Commit dan push. Tidak perlu mengubah loader di executor kalau `HUB_BASE_URL` sudah benar.

## Source asli vs script yang di-commit

- Source asli autoaim ada di luar repo: `/root/autoaim.lua`.
- Yang di-commit ke GitHub adalah hasil obfuscate: `games/107430170196919.lua`.
- Alat obfuscator, deobfuscator, kunci, dan metadata ada di `/root/tools/`, juga di luar repo.
- `.gitignore` sudah mengabaikan `/tools/`, `/src/`, `*.key`, `*.map`, `*.meta`, `*.deobf.lua`, `*.ir.txt`, dan artefak `luac.out`.
- Alur edit: ubah `/root/autoaim.lua`, jalankan obfuscator, hasilnya ditulis ke `games/<PlaceId>.lua`, lalu commit hanya file hasil obfuscate.

## Catatan

- Semua path di `REGISTRY` relatif terhadap `HUB_BASE_URL`.
- `HUB_LOADED` di `getgenv()` mencegah loader jalan dua kali dalam satu sesi.
- Script game bertanggung jawab membersihkan GUI dan koneksinya sendiri saat dijalankan ulang.
