---
title: Vue.js 스터디
date: 2022-06-02 14:59:00 +0900
categories: [JS, Vue]
tags: [vue.js, vue study]
published: false
---

작년 부터 유독 Vue나 React 프로젝트들이 많이 보이기 시작했다.
개인적인 생각으로는 굳이 그런 것들로 할 필요가 없다고 생각이 들긴하지만...
`jQuery`만 봐도 얼마나 훌륭한가...

각설하고, 주변 개발자들의 Vue에 대한 열화와 같은 Study 욕구를 해소하기 위해 간단하게나마 정리해보고자 한다.

<!-- prettier-ignore -->
> 이 글은 기존의 웹 개발을 했던 분들을 대상으로 작성해서 어느정도 웹에 대한 이해가 있어야 한다.
{: .prompt-warning }

## 목표

- 개발환경 세팅
- 게시판 만들어 보기

## SPA란

Single Page Application의 약자인데, 단일 페이지? Vue나 React는 `SPA Framework`라고들 하는데, 이전에 웹을 개발하던 방식과는 패러다임이 다르다.

SPA 이전의 개발은 한 페이지를 표시하기 위해 브라우저에서 서버에게 요청을 하면 요청한 페이지에 대한 결과물(HTML)을 서버에서 보내주는 방식이였다.
그리고 이런 방식을 SSR[^ssr]이라고 한다. SPA가 나와서 이런 용어가 있지 SPA 이전의 웹개발 시절엔 들어본적이 없는 용어이다.

SPA는 CSR[^csr]이라고 하여 클라이언트에서 렌더링을 하는 방식인데 최초 접속시 한번 페이지를 렌더링하기 위한 리소스(html, javascript, css...)를 서버로부터 받는다.
그리고 받은 리소스를 가지고 첫 화면을 생성한다. 여기까지는 별 다를게 없어보이는데, 만약 다른 페이지로 이동을 한다면 여기서부터 차이가 난다.

기존의 웹은 다른 페이지로 이동할때 서버에게 이동하고자하는 페이지에 대한 결과물을 다시 요청하고 결과물을 받아 화면에 출력한다.
이와는 다르게 SPA는 페이지 이동시 서버에 요청을 하지 않는다. 이미 다음 페이지를 렌더링할 리소스를 가지고 있기 때문이다. 단 데이터를 출력하기 위한 요청을 하긴 한다.

개인적인 생각이지만, SPA이전의 웹은 페이지를 렌더링하기 위한 요청을 여러번 하기 때문에 SPA와 비교해서 MPA[^mpa]라고 `굳이` 이름을 붙인게 아닌가 싶고,
SPA는 페이지를 렌더링하기 위한 요청을 한번만 하기 때문에 Single Page라고 하는게 아닌가 싶다.

## ES6에 익숙해지기

SPA개발을 위해 ES6는 필수다. 꼭 알아야한다.
ECMAScript라고 하며 JavaScript와 헷갈릴 수 있는데 ECMAScript는 일종의 스크립트에 대한 표준을 정의한 문서이고, 이 표준을 준수한 언어가 JavaScript라고 보면 될거 같다.
여기서 6은 표준 문서가 여섯번째 개정되었음을 말한다.
이전에 우리가 많이 사용하던 JavaScript는 ES5 기준이였고, Vue 개발에 필요한 ES6는 많은 함수들이 추가 되었고 문법 자체도 생소한 것들이 많다.

ES6에서 내가 자주 쓰는것들 위주로 몇 가지 정리해 보면,

- 변수선언

```javascript
// 이전의 JavaScript
var name = "devobba";

// ES6이후
const name = "devobba"; // 상수 재할당 X
let name = "devobba"; // 변수 재할당 O
```

- 화살표 함수(arrow function)

```javascript
// 이전의 JavaScript
function plus(a, b) {
  return a + b;
}

// ES6이후
const plus = (a, b) => {
  return a + b;
};

console.log(plus(5, 6)); // 11
```

- 파라미터 기본값 설정

```javascript
const plus = (a, b = 10) => {
  return a + b;
};

console.log(plus(5, 6)); // 11
console.log(plus(5)); // 15
```

- Template Literal

```javascript
// 이전의 JavaScript
var name = "devobba";
console.log("hi " + name + "! nice meet you."); // hi devobba! nice meet you.

// ES6이후
const name = "devobba";
console.log(`hi ${name}! nice meet you.`); // hi devobba! nice meet you.
```

- object key 생략(key와 변수명이 같다면 생략가능)

```javascript
// 이전의 JavaScript
var name = "devobba";
var obj = {
  name: name,
};
console.log(obj.name); // devobba

// ES6이후
const name = "devobba";
const obj = {
  name,
};
console.log(obj.name); // devobba
```

## Vue 익숙해지기

- 상태(data)

-

## 마치며

#### 각주

[^ssr]: `Server Side Rendering` 이라고 하며, 서버측에서 동적인 데이터를 이용하여 html을 만드는 방식으로 jsp, php, asp 등이 있다.
[^csr]: `Client Side Rendering` 이라고 하며, 클라이언트(브라우저)에서 html을 만드는 방식이다.
[^mpa]: `Multi Page Application`
