# Roblox Script Hub

## Pakai

Jalankan di executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nade-is-not-a-dev/roblox-script-hub/master/init.lua"))()
```

Atau pasang sebagai autoexecute di Delta:

```text
/sdcard/Delta/Autoexecute/hub.lua
```

Loader akan mengecek PlaceId. Kalau game didukung, script game langsung jalan. Kalau tidak, muncul layar "Game belum didukung".

## Tambah game

1. Taruh script di `games/<PlaceId>.lua`.
2. Tambah entri di `REGISTRY` dalam `init.lua`.
3. Commit dan push.
