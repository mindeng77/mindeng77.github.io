---
title: no quota left for account aws
date: 2020-04-24 15:25:00 +0900
categories: [aws]
tags: [aws, sns]
published: true
---

AWS SNS의 문자 서비스를 이용중인데 문자 발송이 자꾸 실패하여 로그를 확인해보니

`no quota left for account aws` 에러가 발생했다.

사용한 만큼 나중에 과금되는건 맞는데 최대 한도를 초과하면 문자 발송이 안되는거였다.

그래서 최대한도를 높여야하는데 그냥 설정으로 높이는건 아니고, AWS 지원센터에서 요청을 해야한다.

방법은 다음 링크에 잘 설명되어 있다.

월별 최대사용량을 계산하여 요청하고, 요청 내용을 영문으로 풀어서 작성하면된다.

<https://aws.amazon.com/ko/premiumsupport/knowledge-center/sns-sms-spending-limit-increase>{:target="\_blank"}

**내가 작성한 내용: 30달러로 요청하는 내용**

```text
Limit increase request 1
Service: SNS Text Messaging
Resource Type: General Limits
Limit name: Account Spend Threshold Increase for SMS
New limit value: 30
------------
Use case description: We need an SMS spending limit of 30 USD to keep the application (mybareum.com) highly available.
Our application uses SMS messages to authenticate mobile phones to users.
Users need to submit and verify their mobile phone number when creating an account.
Customer locations are worldwide, and spending limits must apply to the eu-west-1 AWS Region.
It is expected to send 10 SMS messages per hour.
Provide a link to the site or app which will be sending SMS messages:
What type of messages do you plan to send?: Transactional
Which countries do you plan to send messages to?:
How do your customers opt to receive messages from you? Provide specific information about the opt-in process:
Which AWS Region will you be sending messages from?:
Please provide the message template that you plan to use to send messages to your customers:
```

**답변**

```text
Hello,

Your new SMS monthly spending limit of $30 USD was implemented. This may take up to one hour to reflect in your console.

Before you can send messages, you must update your account spend limit using the Amazon SNS console or API ( http://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html  ).

When you complete these procedures, you may see a message stating that your default limit is $1.00. You can disregard this message.

We recommend monitoring metrics for Amazon SNS using CloudWatch ( https://docs.aws.amazon.com/sns/latest/dg/MonitorSNSwithCloudWatch.html  ).

As you get started with Amazon SNS, we recommend that you:
-- Apply for higher spending limits before you need them.
-- Open a case in the AWS Support Center to request other SMS options, if needed ( https://console.aws.amazon.com/support/home  ).
-- Review additional information on sending SMS messages for best practices ( https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-best-practices.html  ).

*IMPORTANT*
Certain countries may require pre-registration of sender IDs and/or templates for successful delivery — please ensure to review the follow document to determine if any of the target countries you intend to send to have these requirements and submit relevant registration requests. (https://docs.aws.amazon.com/sns/latest/dg/sns-supported-regions-countries.html

-- If you plan to send messages that will or may contain Protected Health Information (PHI), as defined by the Health Insurance Portability and Accountability Act (HIPAA) and associated legislation, you will be required to register for a dedicated short code. Information on registering for a dedicated short code can be found here: https://docs.aws.amazon.com/sns/latest/dg/sms_shortcodes.html

Thank you for choosing Amazon Web Services.

Best regards,

Prakash S.
Amazon Web Services

Check out the AWS Support Knowledge Center, a knowledge base of articles and videos that answer customer questions about AWS services: https://aws.amazon.com/premiumsupport/knowledge-center/?icmpid=support_email_category

We value your feedback. Please rate my response using the link below.
===================================================

To contact us again about this case, please return to the AWS Support Center using the following URL:

https://console.aws.amazon.com/support/home#/case/?displayId=6959824691&language=en

(If you are connecting by federation, log in before following the link.)

*Please note: this e-mail was sent from an address that cannot accept incoming e-mail. Please use the link above if you need to contact us again about this same issue.

====================================================================
Learn to work with the AWS Cloud. Get started with free online videos and self-paced labs at
http://aws.amazon.com/training/
====================================================================

Amazon Web Services, Inc. is an affiliate of Amazon.com, Inc. Amazon.com is a registered trademark of Amazon.com, Inc. or its affiliates.
```
