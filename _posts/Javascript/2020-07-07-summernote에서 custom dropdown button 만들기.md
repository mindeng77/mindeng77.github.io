---
title: summernote에서 custom dropdown button 만들기
date: 2020-07-07 15:25:00 +0900
categories: [Javascript]
tags: [summernote, custom dropdown button]
published: true
---

## 주요기능

- Custom Button for Dropdown
- 현재 Focus에 텍스트 삽입

```javascript
// 썸머노트 에디터에서 이전 포커스 위치 정보를 저장
var oldEditor = $.summernote.options.modules.editor;
$.summernote.options.modules.editor = function () {
  oldEditor.apply(this, arguments);
  var oldCreateRange = this.createRange;
  var oldFocus = this.focus;

  this.createRange = function () {
    this.focus = function () {};
    var result = oldCreateRange.apply(this, arguments);
    this.focus = oldFocus;
    return result;
  };
};

// 썸머노트 초기화
$("#summernote").summernote({
  toolbar: [
    ["color", ["color"]],
    ["font", ["bold", "underline"]],
    ["mybutton", ["answer"]], // custom button add
  ],
  buttons: {
    answer: (context) => {
      const ui = $.summernote.ui;
      const ulStyle = "margin: 0;padding: 0";
      const liStyle =
        "display: block;padding: 3px 20px;clear: both;font-weight: normal;color: #333;white-space: nowrap;";
      let contents = `<ul style="${ulStyle}">`;
      for (let i = 0; i < 5; i++) {
        contents += `<li style="${liStyle}" data-value="${i}">${i}</li>`;
      }
      contents += "</ul>";
      var button = ui.buttonGroup([
        ui.button({
          className: "dropdown-toggle",
          contents:
            '<span class="fa"></span>버튼이름<span class="caret"></span>',
          tooltip: "tooltip...",
          data: {
            toggle: "dropdown",
          },
        }),

        ui.dropdown({
          className: "drodown-style",
          contents: contents,
          callback: function ($dropdown) {
            $dropdown.find("li").each(function () {
              $(this).click(function () {
                $("#idCardText").summernote(
                  "insertText",
                  "#{" + $(this).text() + "}"
                );
              });
            });
          },
        }),
      ]);
      return button.render();
    },
  },
});

// 썸머노트 이벤트 설정
$("#summernote").on("summernote.blur", function () {
  $("#summernote").summernote("saveRange");
});
$("#summernote").on("summernote.focus", function () {
  $("#summernote").summernote("restoreRange");
});
```
