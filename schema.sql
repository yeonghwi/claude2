-- Supabase 대시보드 > SQL Editor 에 붙여넣고 실행하세요.

-- 1) 관리자 목록 (여기에 등록된 사용자만 공지사항 작성 가능)
create table admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

-- 2) 공지사항 (관리자 작성)
create table notices (
  id bigint generated always as identity primary key,
  title text not null,
  content text not null,
  created_at timestamptz default now()
);

-- 3) 자유게시판 (회원 작성)
create table posts (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  author_email text not null,
  title text not null,
  content text not null,
  created_at timestamptz default now()
);

-- RLS(행 단위 보안) 켜기
alter table admins  enable row level security;
alter table notices enable row level security;
alter table posts   enable row level security;

-- admins: 본인이 관리자인지 확인하는 용도로만 조회 허용
create policy "본인 관리자 여부 조회" on admins
  for select using (user_id = auth.uid());

-- notices: 누구나 읽기, 관리자만 쓰기/수정/삭제
create policy "공지 누구나 읽기" on notices
  for select using (true);
create policy "공지 관리자 작성" on notices
  for insert with check (exists (select 1 from admins where user_id = auth.uid()));
create policy "공지 관리자 수정" on notices
  for update using (exists (select 1 from admins where user_id = auth.uid()));
create policy "공지 관리자 삭제" on notices
  for delete using (exists (select 1 from admins where user_id = auth.uid()));

-- posts: 누구나 읽기, 로그인 회원만 작성, 본인 글만 삭제
create policy "게시글 누구나 읽기" on posts
  for select using (true);
create policy "게시글 회원 작성" on posts
  for insert with check (auth.uid() = user_id);
create policy "게시글 본인 삭제" on posts
  for delete using (auth.uid() = user_id);

-- 관리자 지정 방법 (회원가입 후 실행):
-- insert into admins (user_id)
--   select id from auth.users where email = 'admin@example.com';
