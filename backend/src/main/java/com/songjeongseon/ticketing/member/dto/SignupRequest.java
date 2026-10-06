package com.songjeongseon.ticketing.member.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record SignupRequest (
  @NotBlank(message = "이메일을 입력하세요.")
  @Email(message = "이메일 형식이 아닙니다.")
  @Size(max = 100,message = "이메일은 100자 이하여야 합니다.")
  String email,

  @NotBlank(message = "비밀번호를 입력하세요.")
  @Size(min = 8,max = 64,message = "비밀번호는 8~64자여야 합니다.")
  String password
      ){
}
