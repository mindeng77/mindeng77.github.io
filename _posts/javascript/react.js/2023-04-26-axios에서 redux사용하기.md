---
title: axios에서 redux사용하기
date: 2023-04-06 17:31:00 +0900
categories: [Javascript, React.js]
tags: [React.js, axios, 로딩바]
published: true
---

## 조건

- 서버 요청 중에 로딩바를 보여주고, 응답을 받으면 로딩바를 숨기고 싶다.
- redux로 로딩중 정보를 등록하여 관리

## 제약

- 컴포넌트가 아닌 영역에서 useSelector, useDispatch를 사용할 수 없다.

## 해결

None Component에서 직접 store정보에 접근하여 사용이 가능함

### /src/store/loadingSlice.js

```javascript
import { createSlice } from "@reduxjs/toolkit";

export const loadingSlice = createSlice({
  name: "loading",
  initialState: {
    isLoading: false,
  },
  reducers: {
    setLoading: (state, action) => {
      state.isLoading = action.payload;
    },
  },
});

export const { setLoading } = loadingSlice.actions;

export default loadingSlice.reducer;
```

### /src/store/index.js

```javascript
import { configureStore } from "@reduxjs/toolkit";
import thunkMiddleware from "redux-thunk";

import loading from "./loadingSlice";

const store = configureStore({
  reducer: {
    loading,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(thunkMiddleware),
});

export default store;
```

### /src/util/axios.js

```javascript
import axios from "axios";
import store from "../stores";
import { setLoading } from "../stores/loadingSlice";

const instance = axios.create({
  baseURL: process.env.REACT_APP_API_URL,
  timeout: 1000 * 10,
});

instance.interceptors.request.use(async (config) => {
  try {
    const isLoading = store.getState().loading.isLoading;
    if (isLoading === false) {
      store.dispatch(setLoading(true));
    }
    /* 요청처리 생략 */
  } catch (err) {
    console.log(err);
  }
  return config;
});

instance.interceptors.response.use(
  (response) => {
    store.dispatch(setLoading(false));
    /* 응답처리 생략 */
  },
  (error) => {
    store.dispatch(setLoading(false));
    /* 에러처리 생략 */
  }
);

export default instance;
```

### /src/App.jsx

ui template으로 mui를 사용

```jsx
import React from "react";
import { Route, Routes } from "react-router-dom";
import { useSelector } from "react-redux";
import CircularProgress from "@mui/material/CircularProgress";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";

import "./App.css";

const CircularProgressCentered = ({ open }) => {
  return (
    <Dialog>
      <DialogContent>
        <CircularProgress size={50} />
      </DialogContent>
    </Dialog>
  );
};

function App() {
  const { isLoading } = useSelector((state) => state.loading);
  return (
    <>
      {/* 생략 */}
      <CircularProgressCentered open={isLoading} />
    </>
  );
}

export default App;
```
