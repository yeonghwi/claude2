// Supabase 프로젝트 설정 > API 에서 값을 복사해 넣으세요.
const SUPABASE_URL = 'https://jvywkxcvnlrwepnirqam.supabase.co/';
const SUPABASE_ANON_KEY = 'sb_publishable_tbMt9tTdh8v5OkWdur4AmQ_xAoCETon';

const sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 사용자 입력을 화면에 그대로 넣을 때 HTML 태그가 실행되지 않게 변환
function esc(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('ko-KR');
}

// 2026.10.14. 형식
function formatDotDate(iso) {
  const d = new Date(iso);
  const mm = String(d.getMonth() + 1).padStart(2, '0');
  const dd = String(d.getDate()).padStart(2, '0');
  return `${d.getFullYear()}.${mm}.${dd}.`;
}

// 상단 메뉴의 로그인/로그아웃 표시
async function renderAuthMenu() {
  const el = document.getElementById('auth-menu');
  if (!el) return null;
  const { data: { user } } = await sb.auth.getUser();
  if (user) {
    el.innerHTML = `${esc(user.email)} <button id="logout-btn">로그아웃</button>`;
    document.getElementById('logout-btn').onclick = async () => {
      await sb.auth.signOut();
      location.href = 'index.html';
    };
  } else {
    el.innerHTML = '<a href="login.html">로그인 / 회원가입</a>';
  }
  return user;
}
