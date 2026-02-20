package com.mrliputo.jumpappbridge.ipc;

import com.mrliputo.jumpappbridge.ipc.AuthContext;

interface IAuthListener {
  void onAuthChanged(in AuthContext context);
  void onAuthInvalidated(String reason);
}
