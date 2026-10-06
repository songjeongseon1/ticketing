package com.songjeongseon.ticketing.member;

import com.songjeongseon.ticketing.global.error.BusinessException;
import com.songjeongseon.ticketing.global.error.ErrorCode;
import com.songjeongseon.ticketing.member.dto.SignupRequest;
import com.songjeongseon.ticketing.member.dto.SignupResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MemberService {
  private final MemberRepository memberRepository;
  private final PasswordEncoder passwordEncoder;

  @Transactional
  public SignupResponse signup(SignupRequest request){
    String email = request.email().trim().toLowerCase();

    if (memberRepository.existsByEmail(email)){
      throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
    }
    Member member = Member.create(email, passwordEncoder.encode(request.password()));

    try {
      memberRepository.saveAndFlush(member);
    }catch (DataIntegrityViolationException e){
      throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
    }
    return SignupResponse.from(member);
  }
}
