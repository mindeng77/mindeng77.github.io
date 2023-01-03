---
title: 공통 Modal 만들기(with bootstrap)
date: 2021-06-25 18:04:00 +0900
categories: [Javascript, Vue.js]
tags: [Vue.js, Modal]
published: true
---

## 방법

- $on을 사용하여 전역으로 이벤트를 등록
- 모든 화면에서 $emit으로 이벤트 trigger

## Modal 생성

#### ModalAlert.vue

```vue
<template>
  <b-modal :id="id" :title="title" @shown="init()" @hide="clear()">
    <p>{{ message }}</p>
    <template #modal-footer>
      <div class="btn-wrap">
        <button type="button" class="btn" @click="confirm"{{ buttonName }}</button>
      </div>
    </template>
  </b-modal>
</template>
<script>
export default {
  props: {
    id: { type: String, default: 'modal-alert' },
    title: { type: String, default: '알림' },
    message: String,
    buttonName: { type: String, default: '확인' }
  },
  methods: {
    confirm() {
      this.$bvModal.hide(this.id);  // bootstrap modal hide
      this.$emit('click-confirm');  // 확인 버튼 클릭 후 이벤트 처리
    }
  }
}
</script>
```

## 이벤트 등록

#### App.vue

```vue
<template>
  ...
  <modal-alert id="modal-alert" :message="message" @click-confirm="callback" />
</template>
<script>
import ModalAlert from "./ModalAlert";

export default {
  components: { ModalAlert },
  data() {
    return {
      title: null,
      message: null,
    };
  },
  created() {
    // 이벤트 등록
    this.$root.$on("showModalAlert", (title, message, callback) => {
      if (title) {
        this.title = title;
      }
      if (message) {
        this.message = message;
      }
      if (callback) {
        this.callback = callback;
      } else {
        this.callback = () => {};
      }

      this.$bvModal.show("modal-alert");
    });
  },
  destroyed() {
    this.$root.$off("showModalAlert");
  },
  methods: {
    /**
     * dummy callback function
     */
    callback() {},
  },
};
</script>
```

## 사용

```vue
<script>
export default {
  methods: {
    /**
     * 단순 메세지
     */
    test1() {
      this.$root.$emit("showModalAlert", "알림", "단순메세지");
    },

    /**
     * 확인 클릭시 콜백함수 처리
     */
    test2() {
      this.$root.$emit(
        "showModalAlert",
        "알림",
        "확인 클릭시 콜백함수 처리",
        () => {
          alert("확인버튼 클릭");
        }
      );
    },
  },
};
</script>
```
