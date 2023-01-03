---
title: Mybatis 설정 및 Oracle 연동
date: 2021-12-28 17:29:00 +0900
categories: [Java, Spring Boot]
tags: [Spring Boot, Mybatis Oracle]
published: true
---

## 목표

- Oracle DB 연결하여 SELECT 쿼리 실행
- SELECT시 resultMap 사용하지 않고, resultType에 POJO Class로 받기.
- 기타 mybatis 설정 적용해보기.

## 환경

- Intellij Community
- Spring Boot 2.6.2
- Maven

## DB Table생성

```sql
CREATE TABLE T_BOARD
(
    TEST_SEQ         INT              NOT NULL, -- 일련번호
    TEST_SUBJECT     VARCHAR2(200)    NULL, -- 제목
    TEST_CONTENT     VARCHAR2(512)    NULL, -- 내용
    TEST_REG_TIME    TIMESTAMP        NULL, -- 등록시간
    PRIMARY KEY (TEST_SEQ)
)
```

## Dependency추가

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.2.0</version>
</dependency>
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc8</artifactId>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

Maven을 reload하게 되면 Lombok관련해서 활성화여부를 묻는다.
![Desktop View](/assets/img/2021-12-28-01.png)
_Enable 클릭_

## DB 접속정보 및 Mybatis 설정

이 상태에서 실행을 하게되면 다음과 같은 에러가 뜨면서 서버가 실행되지 않는다.

```console
***************************
APPLICATION FAILED TO START
***************************

Description:

Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured.

Reason: Failed to determine a suitable driver class

Action:

Consider the following:
	If you want an embedded database (H2, HSQL or Derby), please put it on the classpath.
	If you have database settings to be loaded from a particular profile you may need to activate it (no profiles are currently active).

Process finished with exit code 1
```

datasource를 구성하기 위한 설정을 해야한다.

#### src/main/resources/application.properties

```properties
# Oracle DataSource
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@xxx.xxx.xxx.xxx:1521/xe
spring.datasource.username=xxx
spring.datasource.password=xxx

# Mybatis
mybatis.type-aliases-package=com.example.demo.model
mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.configuration.map-underscore-to-camel-case=true
```

mybatis.type-aliases-package
: mybatis에서 사용하는 type들(paramterType, resultType)의 package명의 prefix를 미리 정의하는 설정이다. 이 같은 설정을 하면 mapper.xml 파일에서 type에 class name만 기술하면된다.

mybatis.mapper-locations
: mapper xml들을 scan하기 위한 패턴

mybatis.configuration.map-underscore-to-camel-case
: DB Table Column이 보통 언더바(snake) 표기법으로 되어 있는것을 이전에는 resultMap을 선언해서 Java의 변수와 매핑을 해줬는데, 이를 자동으로 카멜 표기법으로 변환하여 매핑을 해주는 아주 편리한 설정이다.

## Model작성

#### src/main/java/com/example/demo/model/Board.java

```java
package com.example.demo.model;

import lombok.Data;

import java.util.Date;

@Data
public class Board {

    /**
     * 일련번호
     */
    private Integer testSeq;

    /**
     * 제목
     */
    private String testSubject;

    /**
     * 내용
     */
    private String testContent;

    /**
     * 등록시간
     */
    private Date testRegTime;
}
```

## Mapper작성

#### src/main/java/com/example/demo/mapper/BoardMapper.java

```java
package com.example.demo.mapper;

import com.example.demo.model.Board;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardMapper {

    /**
     * 게시판 목록 조회
     * @return
     */
    List<Board> selectList();
}
```

#### src/main/resources/mapper/boardMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTO Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.demo.mapper.BoardMapper">

    <!-- 게시판 목록 조회 -->
    <select id="selectList" resultType="Board">
        SELECT TEST_SEQ
             , TEST_SUBJECT
             , TEST_CONTENT
             , TEST_REG_TIME
          FROM T_BOARD
    </select>
</mapper>
```

## Controller작성

#### src/main/java/com/example/demo/DemoController.java

```java
package com.example.demo;

import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.Board;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class DemoController {

    @Autowired
    private BoardMapper boardMapper;

    @GetMapping("/board/list")
    public List<Board> getBoardList() {
        return boardMapper.selectList();
    }
}
```

## 테스트

![Desktop View](/assets/img/2021-12-28-02.png)
_Model Class의 각 변수에 잘 담아서 출력되는것을 확인_
