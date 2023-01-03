---
title: PDF Viewer Sample
date: 2021-07-08 17:56:00 +0900
categories: [Javascript, Vue.js]
tags: [Vue.js, PDF Viewer]
published: true
---

## 환경

- backend: Spring Boot
- frontend: Vue.js
- library: vue-pdf-app

## Spring Boot 설정

로컬환경에서 돌리면 문제될게 없겠지만, 실제로 운영은 보통 frontend와 backend는 각기 다른 서버로 구성이 되므로 CORS(Cross-Origin Resource Sharing)설정을 해야한다.
그래서 Spring에서 다음과 같이 설정을 한다.

#### WebConfig.java

```java
package com.sample.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("*")
            .allowedHeaders("*");
    }
}
```

특정 서버만 접근을 허용한다면 allowedOrigins("http://sample.com")과 같이 될것이다.

PDF다운로드시 제일 중요한게 allowedHeaders 메소드를 이용하여 모든 header정보를 허용해줘야한다.
보통의 applicationi/json형태의 데이터를 요청하면 allowedHeaders가 필요없지만, PDF같은(application/pdf) 파일을 다운로드 할 경우에만 해줘야한다.

Spring Boot의 서비스 포트를 9999로 변경(Vue.js의 포트와 겹쳐서...)

#### application.properties

```properties
server.port = 9999
```

#### PDFController.java

```java
package com.sample.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PDFController {

    @Autowired
    private ServletContext servletContext;

    /**
     * PDF파일 다운로드 샘플
     * @param fileName 파일명
     * @return
     * @throws FileNotFoundException
     */
    @GetMapping(path = "/sample/pdf", produces = MediaType.APPLICATION_PDF_VALUE)
    public ResponseEntity<InputStreamResource> samplePdf(@RequestParam("fileName") String fileName)
            throws FileNotFoundException {
        String mineType = servletContext.getMimeType(fileName);
        MediaType mediaType = null;
        try {
            mediaType = MediaType.parseMediaType(mineType);
        } catch (Exception e) {
            mediaType = MediaType.APPLICATION_OCTET_STREAM;
        }

        File file = new File("C:\\vue-workspace\\sample\\public\\" + fileName);

        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + file.getName())
                .contentType(mediaType)
                .contentLength(file.length())
                .body(resource);
    }
}
```

Postman또는 인터넷 브라우져에서 다음의 주소로 정상적으로 PDF파일을 다운로드 받는지 확인.

```
http://localhost:9999/sample/pdf?fileName=sample.pdf
```

![Desktop View](/assets/img/2021-07-08-01.png)

## npm 추가

```console
npm i vue-pdf-app
```

<https://www.npmjs.com/package/vue-pdf-app>{:target="\_blank"}

## Vue.js 화면소스

```vue
<template>
  <div style="height: 98vh">
    <vue-pdf-app :pdf="pdfsrc"></vue-pdf-app>
  </div>
</template>

<script>
import VuePdfApp from "vue-pdf-app";
import axios from "axios";
export default {
  components: {
    VuePdfApp,
  },

  data() {
    return {
      pdfsrc: null,
    };
  },

  created() {
    this.loadByAxios();
  },

  methods: {
    /**
     * axios 사용
     */
    async loadByAxios() {
      try {
        const response = await axios.get("http://localhost:9999/sample/pdf", {
          responseType: "blob",
          params: {
            fileName: "sample.pdf",
          },
        });
        const blob = new Blob([response.data]);
        const objectUrl = URL.createObjectURL(blob);
        this.pdfsrc = objectUrl;
      } catch (e) {
        console.error(e);
      }
    },

    /**
     * fetch 사용
     */
    async load() {
      fetch("http://localhost:9999/sample/pdf?fileName=sample.pdf")
        .then((response) => response.blob())
        .then((blob) => {
          const objectUrl = URL.createObjectURL(blob);
          this.pdfsrc = objectUrl;
        });
    },
  },
};
</script>
```

<!-- prettier-ignore -->
> 여기서 눈여겨 보아야할 부분은 첫번째로 pdf가 보여지는 영역의 부모 element의 높이를 반드시 지정을 해야한다.
{: .prompt-warning }

두번째는 서버로부터 받은 데이터를 적절하게 blob으로 형태로 변환하는 부분인데, 위의 소스에는 fetch를 이용한 방법과 axios를 이용한 방법 두가지를 첨부해놨다. 적절한 것을 갖다 쓰면 될 거 같다.

![Desktop View](/assets/img/2021-07-08-02.png)
