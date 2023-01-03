---
title: 공통 Modal Alert창(redux)
date: 2021-12-22 18:52:00 +0900
categories: [Javascript, React.js]
tags: [React.js, 공통 modal]
published: true
---

## 환경

- npm i react-bootstrap bootstrap@5.1.3
- npm i redux react-redux

## action type 정의

**/actions/types.js**

```javascript
/**
 * 모달창 띄우기
 */
export const SHOW_ALERT_MODAL = "SHOW_ALERT_MODAL";

/**
 * 모달창 닫기
 */
export const HIDE_ALERT_MODAL = "HIDE_ALERT_MODAL";
```

## reducer 작성

**/reducers/alertModal.js**

```javascript
import { SHOW_ALERT_MODAL, HIDE_ALERT_MODAL } from "../actions/types";

const alertModal = (
  state = {
    show: false,
    text: null,
    callback: null,
  },
  action
) => {
  const { type, payload } = action;
  switch (type) {
    case SHOW_ALERT_MODAL:
      return {
        show: true,
        text: payload.text,
        callback: payload.callback,
      };
    case HIDE_ALERT_MODAL:
      return {
        show: false,
        text: null,
        callback: null,
      };
    default:
      return state;
  }
};

export default alertModal;
```

## reducer 등록

**/reducers/index.js**

```javascript
import { combineReducers } from "redux";
import alertModal from "./alertModal";

export default combineReducers({
  alertModal,
});
```

**/index.js**

```javascript
import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import reportWebVitals from "./reportWebVitals";
import { createStore } from "redux";
import { Provider } from "react-redux";
import rootReducer from "./reducers";
const store = createStore(rootReducer);
ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </React.StrictMode>,
  document.getElementById("root")
);
reportWebVitals();
```

## action 작성

**/actions/alertModal.js**

```javascript
import { SHOW_ALERT_MODAL, HIDE_ALERT_MODAL } from "./types";

export const showAlertModal = (text, callback) => {
  return {
    type: SHOW_ALERT_MODAL,
    payload: {
      show: true,
      text,
      callback,
    },
  };
};

export const hideAlertModal = () => {
  return {
    type: HIDE_ALERT_MODAL,
  };
};
```

## Modal창 작성

**/components/common/AlertModal.js**

```javascript
import React from "react";
import { Button, Modal } from "react-bootstrap";
import { useDispatch } from "react-redux";
import { hideAlertModal } from "../../actions/alertModal";

const AlertModal = ({ text, show, callback }) => {
  const dispatch = useDispatch();
  const handleClose = () => {
    dispatch(hideAlertModal());
  };
  return (
    <Modal show={show} onHide={handleClose}>
      <Modal.Header closeButton>
        <Modal.Title>확인</Modal.Title>
      </Modal.Header>
      <Modal.Body>{text}</Modal.Body>
      <Modal.Footer>
        <Button
          variant="primary"
          onClick={() => {
            handleClose();
            if (callback && typeof callback === "function") {
              callback();
            }
          }}
        >
          확인
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default AlertModal;
```

## Modal창 등록

**/App.js**

```javascript
import "./App.css";
import "bootstrap/dist/css/bootstrap.min.css";
import Routes from "./components/screen/Routes";
import AlertModal from "./components/common/AlertModal";
import { useSelector } from "react-redux";

function App() {
  const alertModal = useSelector((state) => state.alertModal);

  return (
    <div className="App">
      <Routes />
      <AlertModal
        text={alertModal.text}
        show={alertModal.show}
        callback={alertModal.callback}
      />
    </div>
  );
}

export default App;
```

## 화면에서 사용

**/components/screen/Page1.js**

```javascript
import { Container } from "react-bootstrap";
import { Button } from "react-bootstrap";
import { useDispatch } from "react-redux";
import { showAlertModal } from "../../actions/alertModal";

export default function Page1() {
  const dispatch = useDispatch();
  const callback = () => {
    alert("callback");
  };
  const onClickButton = () => {
    dispatch(showAlertModal("하이", callback));
  };
  return (
    <Container>
      <h5>Page1</h5>
      <Button variant="primary" onClick={onClickButton}>
        모달
      </Button>
    </Container>
  );
}
```

화면에서의 호출은 dispatch(showAlertModal('문자열', 콜백함수)); 형태로 호출하면 된다.
콜백함수는 확인 버튼 클릭 후 어떤 로직을 수행할 경우에 사용하면 된다.

## 실행화면

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FY7a15%2FbtroPHaZr4Z%2FPB386QgZxQO2aQZIRBrkgk%2Fimg.png)
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FnvIB1%2FbtroKZYL4aT%2FP9kgBHGe4YEvTI4Vsvbbj0%2Fimg.png)
