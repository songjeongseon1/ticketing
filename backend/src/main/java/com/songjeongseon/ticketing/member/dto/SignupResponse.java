package com.songjeongseon.ticketing.member.dto;

import com.songjeongseon.ticketing.member.Member;

public record SignupResponse (Long id, String email) {
  public static SignupResponse from(Member member) {
    return new SignupResponse(member.getId(), member.getEmail());
  }
}
