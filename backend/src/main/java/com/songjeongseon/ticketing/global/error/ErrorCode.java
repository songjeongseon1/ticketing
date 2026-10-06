package com.songjeongseon.ticketing.global.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ErrorCode {

  INVALID_INPUT(HttpStatus.BAD_REQUEST,"입력값이 올바르지 않습니다."),
  DUPLICATE_EMAIL(HttpStatus.CONFLICT,"이미 가입된 이메일입니다.");

  private final HttpStatus status;
  private final String message;
}
