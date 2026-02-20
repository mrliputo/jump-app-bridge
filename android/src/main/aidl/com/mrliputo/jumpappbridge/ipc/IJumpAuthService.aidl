package com.mrliputo.jumpappbridge.ipc;

import android.os.Bundle;
import com.mrliputo.jumpappbridge.ipc.AuthContext;
import com.mrliputo.jumpappbridge.ipc.IAuthListener;

interface IJumpAuthService {
  boolean ping();
  AuthContext getAuthContext(String callerPackage, in Bundle options);
  void registerListener(IAuthListener listener);
  void unregisterListener(IAuthListener listener);
}
