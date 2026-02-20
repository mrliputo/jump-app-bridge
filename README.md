# jump-app-bridge

Library React Native (Android) untuk komunikasi auth antar **2 aplikasi** via IPC yang aman.

- **Host app**: app utama (handle login, role, simpan token/user)
- **Client app**: app kedua (minta token/user ke host)

## Cara kerja singkat
Client melakukan **bind** ke service di host (Bound Service + AIDL). Host mengembalikan `AuthContext` (accessToken, expiry, user info). Aksesnya dibatasi dengan **permission protectionLevel=signature** (jadi hanya app yang ditandatangani cert yang sama).

## Install (dari Git)
Tambahkan dependency dari repo git kalian. Contoh:

```json
{
  "dependencies": {
    "jump-app-bridge": "git+ssh://git@YOUR_GIT_SERVER/your-group/jump-app-bridge.git#main"
  }
}
```

## Pemakaian (di RN JS)
Di app client:

```ts
import { JumpAuth } from 'jump-app-bridge';

await JumpAuth.configure({
  hostPackage: 'com.example.host',
  // optional kalau class servicenya beda
  // hostServiceClass: 'com.example.host.jump.JumpAuthService',
  timeoutMs: 3000,
});

const ctx = await JumpAuth.getAuthContext({ forceRefresh: false });
console.log(ctx.accessToken, ctx.userId, ctx.roles);
```

## Integrasi Android di HOST
Kamu WAJIB menambahkan service + permission di host app. Library ini hanya menyediakan kontrak AIDL dan client binder.

### 1) Tambahkan permission signature + service
Di `android/app/src/main/AndroidManifest.xml` (host):

- Define permission signature (contoh):
  - `com.example.host.permission.JUMP_AUTH`
- Declare exported bound service pakai permission itu.

Contoh:

```xml
<manifest>
  <permission
    android:name="com.example.host.permission.JUMP_AUTH"
    android:protectionLevel="signature" />

  <application>
    <service
      android:name="com.mrliputo.jumpappbridge.JumpAuthService"
      android:exported="true"
      android:permission="com.example.host.permission.JUMP_AUTH" />
  </application>
</manifest>
```

> Catatan: `android:name` service class bisa kalian taruh di package lain. Pastikan client memanggil `hostServiceClass` yang tepat.

### 2) Implementasi Service (AIDL Stub)
Host perlu implementasi `com.mrliputo.jumpappbridge.ipc.IJumpAuthService.Stub` dan mengembalikan `AuthContext`.

Minimal logic yang disarankan di host:
- Cek caller package dari parameter `callerPackage`
- Ambil `Binder.getCallingUid()` lalu pastikan UID itu memang milik `callerPackage`
- (Optional) verifikasi signing certificate caller sama dengan host

## Catatan keamanan
- Jangan kirim **refreshToken** lewat IPC.
- Dengan permission `signature`, kedua app harus ditandatangani cert yang sama.

## Status
- Fokus saat ini: request/response `getAuthContext()`.
- `subscribeAuthChanges()` sudah disiapkan di JS, tapi butuh implementasi push event dari host.
