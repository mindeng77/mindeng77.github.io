---
title: Intellij Community로 Spring Boot 프로젝트 생성
date: 2021-12-28 15:25:00 +0900
categories: [Java, Spring Boot]
tags: [Intellij Community, Spring Boot]
published: true
---

## 목표

- Intellij Community(무료버전)를 이용하여 Spring Boot 프로젝트를 생성한다.
- Maven으로 빌드한다.
- 샘플 컨트롤러를 작성하여 웹에서 확인한다.

## 환경

- Intellij Community
- 빌드방식: Maven
- Spring Boot
- 배포방식: Jar

Intellij Community는 Spring을 지원하지 않는다고 되어있는데, Spring 프로젝트를 생성 할 수만 없을 뿐 이미 만들어진 Spring 프로젝트는 실행 및 개발이 가능하다.

그래서 다음의 사이트에서 Spring 프로젝트를 생성하여 다운받은 프로젝트를 Intellij에서 열면 무료 버전에서도 Spring Boot Framework를 사용할 수 있다.

<https://start.spring.io>{:target="\_blank"}
![https://start.spring.io](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FzyRMH%2FbtrpdnQNtWv%2FAAX6EqNJjguBLs8lPkXrl0%2Fimg.png)
위와 같이 설정하고 우측 상단의 ADD DEPENDENCIES 버튼을 클릭.

![web을 입력하여 검색된 목록 중 Spring Web을 선택](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FESD6j%2Fbtro8x0XYkf%2FKCW3l2AkCTpZU0WN0nKky0%2Fimg.png)
web을 입력하여 검색된 목록 중 Spring Web을 선택

GENERATE 버튼을 클릭하면 zip파일로 다운로드 된다.

<!-- prettier-ignore -->
> 만약 Spring Web에 Tomcat이 포함되어있어서, 없을 경우 Intellij에서 실행을 할 수 없다.
{: .prompt-info }

![Intellij 실행](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbOY0DY%2Fbtro7CVsL2W%2FgSSzxv6kiU9CDqEvlgMMHK%2Fimg.png)
Intellij 실행

![압축을 푼 폴더를 선택](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FeeeXMS%2FbtrpdooBLID%2FeGH87jBEkO0Yan7W2X8bVK%2Fimg.png)
압축을 푼 폴더를 선택

![Trust Project 클릭](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F9FXiW%2Fbtro14k85p2%2Fpb4SFoPK763eZytFJykI90%2Fimg.png)
Trust Project 클릭

프로젝트가 열리면 DemoApplication.java파일을 열고 자동 빌드가 끝나면 플레이(?) 아이콘이 표시되는데 클릭한다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F0XOuZ%2FbtrpcPGLBKZ%2FR3UdAZoNbSu1TtYa0amvy1%2Fimg.png)

![Run... 선택](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcPNOZW%2Fbtro32OdSkF%2FkMizc6MZX9rhjWdMsNMUvk%2Fimg.png)
Run... 선택

![..](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcvBNO5%2Fbtro6aL2H33%2FKXZUleKdGV2wxKph4XPjmK%2Fimg.png)

브라우저에서 확인
![컨트롤러를 등록한게 없어서 404에러가 남](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FdVUqo0%2Fbtro7grATug%2FZwXvX9KJTQSVFLsIFbr3vK%2Fimg.png)
컨트롤러를 등록한게 없어서 404에러가 남

**/src/main/java/com.example.demo/DemoController.java**

```java
package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {

    @GetMapping("/hello")
    public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return String.format("Hello %s!", name);
    }
}
```

위와 같이 컨트롤러를 작성하고, 브라우저에서 확인

![브라우저확인](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FdtJHaq%2FbtrpcOulyq8%2Fl5XazmcXj3ERFYYz5pDfiK%2Fimg.png)
