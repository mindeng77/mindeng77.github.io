---
title: refresh token으로 access token발급
date: 2023-09-01 13:55:00 +0900
categories: [Javascript, React.js]
tags: [axios, refresh token]
published: true
---

```javascript
import axios from "axios";
import store from "../stores";
import { setLoading } from "../stores/loadingSlice";
import { setIsLogout } from "../stores/logoutSlice";

const instance = axios.create({
  baseURL: process.env.REACT_APP_API_URL,
  timeout: 1000 * 60,
});

let isRefreshing = false;
const refreshSubscribers = [];

/**
 * 리프래시 토큰으로 신규 액세스토큰 발급
 * @returns
 */
const getAccessTokenByRefreshToken = async () => {
  try {
    const localStorageUser = window.localStorage.getItem("user");
    if (localStorageUser && localStorageUser !== "null") {
      const user = JSON.parse(localStorageUser);
      const { data } = await axios.post(
        `${process.env.REACT_APP_API_URL}/api/master/auth/refresh`,
        null,
        {
          headers: {
            Authorization: `Bearer ${user.refreshToken}`,
          },
        }
      );
      if (data.resultCode === "OK") {
        const { accessToken: newAccessToken } = data.data;
        user.accessToken = newAccessToken;
        window.localStorage.setItem("user", JSON.stringify(user));

        refreshSubscribers.forEach((callback) => {
          callback(newAccessToken);
        });

        return newAccessToken;
      }
    }
  } catch (error) {
    return null;
  }
};

instance.interceptors.request.use(async (config) => {
  try {
    const isLoading = store.getState().loading.isLoading;
    if (isLoading === false) {
      store.dispatch(setLoading(true));
    }
    const localStorageUser = window.localStorage.getItem("user");

    if (localStorageUser && localStorageUser !== "null") {
      const { usrId, accessToken, tenantId } = JSON.parse(localStorageUser);

      if (usrId) {
        config.headers.usrId = usrId;
      }
      if (accessToken) {
        config.headers.Authorization = `Bearer ${accessToken}`;
      }
      if (tenantId) {
        config.headers["x-smp-project-code"] = tenantId;
      }
    }
  } catch (err) {
    console.log(err);
  }
  return config;
});

instance.interceptors.response.use(
  (response) => {
    store.dispatch(setLoading(false));
    const { data } = response;
    return data;
  },
  async (error) => {
    store.dispatch(setLoading(false));

    // 요청이 이루어졌으며 서버가 2xx의 범위를 벗어나는 상태 코드로 응답했습니다.
    if (error.response) {
      if (error.response.status === 404) {
        alert("page not found");
      } else if (error.response.status === 401) {
        const { config: originRequest } = error;
        if (isRefreshing) {
          return new Promise((resolve) => {
            refreshSubscribers.push((token) => {
              originRequest.headers.Authorization = `Bearer ${token}`;
              resolve(axios(originRequest));
            });
          });
        }

        isRefreshing = true;
        const newAccessToken = await getAccessTokenByRefreshToken();
        isRefreshing = false;

        if (newAccessToken) {
          originRequest.headers.Authorization = `Bearer ${newAccessToken}`;
          return axios(originRequest);
        } else {
          store.dispatch(setIsLogout(true));
          return {
            resultCode: "OK",
          };
        }
      } else {
        console.error(error.message);
      }
    }
    // 요청이 이루어 졌으나 응답을 받지 못했습니다.
    else if (error.request) {
      console.log(
        "요청이 이루어 졌으나 응답을 받지 못했습니다.",
        error.message
      );
    } else {
      console.log(
        "오류를 발생시킨 요청을 설정하는 중에 문제가 발생했습니다.",
        error.message
      );
    }
  }
);

export default instance;
```
