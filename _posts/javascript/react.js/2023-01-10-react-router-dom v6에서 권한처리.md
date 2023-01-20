---
title: React Router v6에서 권한처리
date: 2023-01-10 16:51:00 +0900
categories: [Javascript, React.js]
tags: [React.js, React Router]
published: true
---

# 기본 설정

## /src/hooks/useLocalStorage.js

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

## /src/context/AuthContext.jsx

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

## /src/components/layout/auth/AuthLayout.jsx

AuthProvider를 감싸서 하위의 컴포넌트들이 권한 정보의 접근이 가능하게 함.

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

## /src/components/auth/ProtectedLayout.jsx

전체 layout을 구성하고 로그인 체크를 한다. 로그인이 필요한 모든 화면은 해당 컴포넌트의 자식으로 등록한다.

```jsx
import React from "react";
import { Navigate, Outlet } from "react-router-dom";

import { useAuth } from "../../context/AuthContext";
import Header from "../layout/Header";
import Nav from "../layout/Nav";
import Footer from "../layout/Footer";

export default function ProtectedLayout() {
  const { isLogin } = useAuth();

  // 로그인체크
  if (!isLogin()) {
    // 로그인 화면으로 이동
    return <Navigate to="/login" />;
  }

  return (
    <>
      <div className="wrap">
        <Header />
        <main className="main">
          <Nav />
          <Outlet />
        </main>
      </div>
      <Footer />
    </>
  );
}
```

## 그 밖에 화면들

**/src/pages/LoginPage.jsx**

로그인화면

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

**/src/pages/MainPage.jsx**

```jsx
import React from "react";

export default function MainPage() {
  return <div>MainPage</div>;
}
```

**/src/pages/error/PageNotFound.jsx**

```jsx
import React from "react";

export default function PageNotFound() {
  return <div>PageNotFound</div>;
}
```

## /router/system.js

각 메뉴별로 모듈화

```javascript
import React from "react";
import AuthManagePage from "../pages/system/AuthManagePage";
import RootMenuMngPage from "../pages/system/RootMenuMngPage";

const system = [
  {
    path: "system/auth",
    element: <AuthManagePage />,
  },
  {
    path: "system/menu",
    element: <RootMenuMngPage />,
  },
];

export default system;
```

## /src/App.jsx

```jsx
import React from "react";
import "./App.css";
import { Route, Routes } from "react-router-dom";

import AuthLayout from "./components/auth/AuthLayout";

import LoginPage from "./pages/account/LoginPage";
import MainPage from "./pages/MainPage";
import ProtectedLayout from "./components/auth/ProtectedLayout";
import PageNotFound from "./pages/error/PageNotFound";

import system from "./router/system";

export default function App() {
  return (
    <Routes>
      <Route path="*" element={<PageNotFound />} />

      <Route element={<AuthLayout />}>
        <Route path="/login" element={<LoginPage />} />

        <Route element={<ProtectedLayout />}>
          <Route path="/" element={<MainPage />} />
          {system.map((item) => (
            <Route key={item.path} path={item.path} element={item.element} />
          ))}
        </Route>
      </Route>
    </Routes>
  );
}
```

## 테스트

### 로그인

![로그인](/assets/img/2023-01-10-01.png)
이메일을 입력하고 로그인버튼 클릭

### 로그인 후 메인화면

![메인화면](/assets/img/2023-01-10-02.png)
로그인 처리후 Root화면으로 이동

### Page Not Found

![PageNotFound](/assets/img/2023-01-10-03.png)

[출처: https://blog.logrocket.com/complete-guide-authentication-with-react-router-v6](https://blog.logrocket.com/complete-guide-authentication-with-react-router-v6){:target="\_blank"}
