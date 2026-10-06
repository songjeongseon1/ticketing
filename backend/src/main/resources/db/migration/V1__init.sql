CREATE TABLE member (
  id         BIGINT AUTO_INCREMENT PRIMARY KEY,
  email      VARCHAR(100) NOT NULL,
  password   VARCHAR(255) NOT NULL,
  role       VARCHAR(20)  NOT NULL,
  created_at DATETIME(6)  NOT NULL,
  UNIQUE KEY uk_member_email (email)
);

CREATE TABLE performance (
  id         BIGINT AUTO_INCREMENT PRIMARY KEY,
  title      VARCHAR(200) NOT NULL,
  venue      VARCHAR(100) NOT NULL,
  open_at    DATETIME(6)  NOT NULL,
  created_at DATETIME(6)  NOT NULL
);

CREATE TABLE schedule (
  id             BIGINT AUTO_INCREMENT PRIMARY KEY,
  performance_id BIGINT      NOT NULL,
  start_at       DATETIME(6) NOT NULL,
  created_at     DATETIME(6) NOT NULL,
  CONSTRAINT fk_schedule_performance FOREIGN KEY (performance_id) REFERENCES performance (id)
);

CREATE TABLE seat_grade (
  id             BIGINT AUTO_INCREMENT PRIMARY KEY,
  performance_id BIGINT      NOT NULL,
  name           VARCHAR(20) NOT NULL,
  price          INT         NOT NULL,
  UNIQUE KEY uk_seat_grade_performance_name (performance_id, name),
  CONSTRAINT fk_seat_grade_performance FOREIGN KEY (performance_id) REFERENCES performance (id)
);

CREATE TABLE seat (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  schedule_id   BIGINT      NOT NULL,
  seat_grade_id BIGINT      NOT NULL,
  seat_no       VARCHAR(10) NOT NULL,
  status        VARCHAR(20) NOT NULL,
  held_by       BIGINT      NULL,
  held_until    DATETIME(6) NULL,
  version       BIGINT      NOT NULL DEFAULT 0,
  UNIQUE KEY uk_seat_schedule_seat_no (schedule_id, seat_no),
  KEY idx_seat_schedule_held_by (schedule_id, held_by),
  CONSTRAINT fk_seat_schedule   FOREIGN KEY (schedule_id)   REFERENCES schedule (id),
  CONSTRAINT fk_seat_seat_grade FOREIGN KEY (seat_grade_id) REFERENCES seat_grade (id),
  CONSTRAINT fk_seat_member     FOREIGN KEY (held_by)       REFERENCES member (id)
);

CREATE TABLE reservation (
  id               BIGINT AUTO_INCREMENT PRIMARY KEY,
  member_id        BIGINT      NOT NULL,
  schedule_id      BIGINT      NOT NULL,
  seat_id          BIGINT      NOT NULL,
  status           VARCHAR(20) NOT NULL,
  price            INT         NOT NULL,
  created_at       DATETIME(6) NOT NULL,
  confirmed_at     DATETIME(6) NULL,
  canceled_at      DATETIME(6) NULL,
  active_seat_id   BIGINT AS (CASE WHEN status IN ('PENDING', 'CONFIRMED') THEN seat_id END) STORED,
  active_member_id BIGINT AS (CASE WHEN status IN ('PENDING', 'CONFIRMED') THEN member_id END) STORED,
  UNIQUE KEY uk_reservation_active_seat (active_seat_id),
  UNIQUE KEY uk_reservation_schedule_active_member (schedule_id, active_member_id),
  CONSTRAINT fk_reservation_member   FOREIGN KEY (member_id)   REFERENCES member (id),
  CONSTRAINT fk_reservation_schedule FOREIGN KEY (schedule_id) REFERENCES schedule (id),
  CONSTRAINT fk_reservation_seat     FOREIGN KEY (seat_id)     REFERENCES seat (id)
);

CREATE TABLE payment (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  reservation_id  BIGINT      NOT NULL,
  idempotency_key VARCHAR(64) NOT NULL,
  amount          INT         NOT NULL,
  status          VARCHAR(20) NOT NULL,
  created_at      DATETIME(6) NOT NULL,
  UNIQUE KEY uk_payment_idempotency_key (idempotency_key),
  CONSTRAINT fk_payment_reservation FOREIGN KEY (reservation_id) REFERENCES reservation (id)
);
