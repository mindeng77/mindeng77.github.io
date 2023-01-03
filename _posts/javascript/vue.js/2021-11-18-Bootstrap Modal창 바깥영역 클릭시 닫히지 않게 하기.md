---
title: Bootstrap Modal창 바깥영역 클릭시 닫히지 않게 하기
date: 2021-11-18 09:00:00 +0900
categories: [Javascript, Vue.js]
tags: [Vue.js]
published: true
---

## 환경

- Vue.js
- npm: bootstrap-vue

Bootstrap의 컴포넌트인 모달은 기본적으로 모달하게 창을 띄워주지 않는다.
그래서 모달창의 바깥쪽을 클릭하면 모달창이 닫혀버리는데
이를 방지하게 위해 다음과 같은 속성(no-close-on-backdrop)을 준다.

```vue
<b-modal id="modal" :no-close-on-backdrop="true">
...
</b-modal>
```

default값은 false로 해당값을 true로 주면 바깥쪽을 클릭해도 창이 닫히지 않는다.

참고: <https://bootstrap-vue.org/docs/components/modal>{:target="\_blank"}
