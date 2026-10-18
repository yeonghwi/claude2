# 공지사항 + 자유게시판 (Plain HTML + Supabase)

## 파일 구조
```
index.html    공지사항 홈 (누구나 열람)
board.html    자유게시판 (열람: 누구나 / 작성: 로그인 회원)
login.html    로그인 · 회원가입
admin.html    관리자 페이지 (공지 작성·삭제)
js/app.js     Supabase 연결 설정 + 공통 함수
css/style.css 공통 스타일
schema.sql    Supabase 테이블·권한 SQL
```

## 1. Supabase 설정
1. https://supabase.com 에서 새 프로젝트 생성
2. **SQL Editor**에서 `schema.sql` 내용 전체를 실행
3. **Project Settings > API**에서 `Project URL`과 `anon public` 키를 복사해 `js/app.js` 상단에 붙여넣기
4. (실습 편의) **Authentication > Sign In / Providers > Email**에서 `Confirm email`을 끄면 가입 즉시 로그인됩니다.

## 2. 관리자 지정
1. `login.html`에서 관리자로 쓸 이메일로 회원가입
2. SQL Editor에서 실행:
   ```sql
   insert into admins (user_id)
     select id from auth.users where email = '관리자이메일@example.com';
   ```
3. 로그인 후 `admin.html` 접속 → 공지 작성

## 3. 로컬 실행
VS Code의 Live Server 확장 등으로 `index.html`을 열면 됩니다.

## 4. Vercel 배포
1. 이 폴더를 GitHub 저장소에 올리기
2. Vercel > Add New Project > 저장소 선택 > Framework Preset: **Other** > Deploy
3. Supabase **Authentication > URL Configuration**의 Site URL에 Vercel 주소 입력

## 보안 메모
- `anon` 키는 브라우저에 공개되어도 되는 키입니다. 실제 권한은 `schema.sql`의 RLS 정책이 막아줍니다.
- 관리자 페이지 화면을 숨기는 건 편의 기능일 뿐이고, 관리자가 아닌 사람의 공지 작성은 DB(RLS)에서 거부됩니다.
- `service_role` 키는 절대 프론트엔드에 넣지 마세요.
