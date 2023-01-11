---
title: React Router v6에서 권한처리
date: 2023-01-10 16:51:00 +0900
categories: [Javascript, React.js]
tags: [React.js, React Router]
published: true
---

## 기본 설정

**/src/hooks/useLocalStorage.js**

로그인 정보를 저장하기 위한 유틸

```javascript
import { useState } from "react";

export const useLocalStorage = (keyName, defaultValue) => {
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const value = window.localStorage.getItem(keyName);

      if (value) {
        return JSON.parse(value);
      } else {
        window.localStorage.setItem(keyName, JSON.stringify(defaultValue));
        return defaultValue;
      }
    } catch (err) {
      return defaultValue;
    }
  });
  const setValue = (newValue) => {
    try {
      window.localStorage.setItem(keyName, JSON.stringify(newValue));
    } catch (err) {
      console.log(err);
    }
    setStoredValue(newValue);
  };
  return [storedValue, setValue];
};
```

<br />

**/src/context/AuthContext.jsx**

Context를 이용하여 AuthProvider 하위의 컴포넌트에서 로그인, 로그아웃, 사용자 정보에 접근할 수 있게 한다.

```jsx
import React, { createContext, useContext, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { useLocalStorage } from "../hooks/useLocalStorage";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useLocalStorage("user", null);
  const navigate = useNavigate();

  /**
   * 로그인 처리 후 메인화면으로 이동
   * @param {any} data
   */
  const login = async (data) => {
    setUser(data);
    navigate("/");
  };

  /**
   * 로그아웃 처리 후 로그인 화면으로 이동
   */
  const logout = () => {
    setUser(null);
    navigate("/login", { replace: true });
  };

  /**
   * 로그인 여부 조회
   * @returns true: 로그인상태, false: 로그아웃상태
   */
  const isLogin = () => {
    return !!user;
  };

  const value = useMemo(
    () => ({
      user,
      login,
      logout,
      isLogin,
    }),
    [user]
  );
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  return useContext(AuthContext);
};
```

<br />

**/src/components/layout/AuthLayout.jsx**

권한체크가 필요한 Route의 상단에서 적용하여 하위 Route에서 권한 정보에 접근할 수 있게 AuthProvider를 사용

```jsx
import React from "react";
import { useOutlet } from "react-router-dom";
import { AuthProvider } from "../../context/AuthContext";

const AuthLayout = () => {
  const outlet = useOutlet();
  return <AuthProvider>{outlet}</AuthProvider>;
};

export default AuthLayout;
```

<br/>

**/src/components/AuthRoute.jsx**

각 Route에서 권한이 필요한 Route에서 사용, 여기에서 권한에 따라 분기를 한다.

```jsx
import React from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

const AuthRoute = ({ children }) => {
  const { isLogin } = useAuth();
  if (!isLogin()) {
    return <Navigate to="/login" />;
  }
  return children;
};

export default AuthRoute;
```

## 사용

**/src/pages/LoginPage.jsx**

```jsx
import React, { useState } from "react";
import { useAuth } from "../context/AuthContext";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const { login } = useAuth();
  const onClickLogin = () => {
    login({
      email,
    });
  };

  return (
    <div>
      <h3>로그인화면</h3>
      <div>
        email:
        <input value={email} onChange={(e) => setEmail(e.target.value)} />
        <button onClick={onClickLogin}>로그인</button>
      </div>
    </div>
  );
}
```

**/src/pages/RootPage.jsx**

```jsx
import React from "react";
import { useAuth } from "../context/AuthContext";

export default function Root() {
  const { logout, user } = useAuth();
  return (
    <div>
      <h3>Root화면</h3>
      <p>사용자정보: {JSON.stringify(user)}</p>
      <button onClick={logout}>로그아웃</button>
    </div>
  );
}
```

**/src/App.jsx**

```jsx
import React from "react";
import "./App.css";
import { Route, Routes } from "react-router-dom";

import AuthRoute from "./components/AuthRoute";
import AuthLayout from "./components/layout/AuthLayout";

import RootPage from "./pages/RootPage";
import LoginPage from "./pages/LoginPage";
import MyPage from "./pages/user/MyPage";
import PageNotFound from "./pages/error/PageNotFound";

function App() {
  return (
    <Routes>
      <Route path="*" element={<PageNotFound />} />
      <Route element={<AuthLayout />}>
        <Route
          path="/"
          element={
            <AuthRoute>
              <RootPage />
            </AuthRoute>
          }
        />
        <Route
          path="/mypage"
          element={
            <AuthRoute>
              <MyPage />
            </AuthRoute>
          }
        />
        <Route path="/login" element={<LoginPage />} />
      </Route>
    </Routes>
  );
}

export default App;
```

## 실행화면

![Desktop View](/assets/img/2023-01-10-01.png)
이메일을 입력하고 로그인버튼 클릭

![Desktop View](/assets/img/2023-01-10-02.png)
로그인 처리후 Root화면으로 이동

[출처: https://blog.logrocket.com/complete-guide-authentication-with-react-router-v6](https://blog.logrocket.com/complete-guide-authentication-with-react-router-v6){:target="\_blank"}
