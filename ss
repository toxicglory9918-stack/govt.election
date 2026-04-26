<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Handy AI — Gesture Intelligence Platform</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root {
  --accent: #7cffc4;
  --accent2: #ff6bca;
  --accent3: #6bb5ff;
  --bg: #03020a;
  --glass: rgba(255,255,255,0.04);
  --glass-border: rgba(255,255,255,0.08);
}
*,*::before,*::after { box-sizing: border-box; margin: 0; padding: 0; }
html,body { width:100%; height:100%; overflow:hidden; background:var(--bg); font-family:'DM Mono',monospace; color:#fff; }

/* NOISE */
#noise {
  position:fixed; inset:0; z-index:999; pointer-events:none;
  opacity:0.025;
}

/* SPLASH */
#splash {
  position:fixed; inset:0; z-index:900; background:var(--bg);
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:24px; transition:opacity 0.8s ease;
}
#splash.hidden { opacity:0; pointer-events:none; }
.rings-wrap {
  position:relative; width:220px; height:220px;
  display:flex; align-items:center; justify-content:center;
}
.ring {
  position:absolute; border-radius:50%; border:1.5px solid;
  animation:pulse 2.4s ease-in-out infinite;
}
.ring:nth-child(1){width:220px;height:220px;border-color:rgba(124,255,196,0.25);animation-delay:0s;}
.ring:nth-child(2){width:160px;height:160px;border-color:rgba(107,181,255,0.35);animation-delay:0.5s;}
.ring:nth-child(3){width:100px;height:100px;border-color:rgba(255,107,202,0.45);animation-delay:1s;}
@keyframes pulse {
  0%,100%{transform:scale(1);opacity:0.5;}
  50%{transform:scale(1.08);opacity:1;}
}
.logo-wrap { text-align:center; }
.logo {
  font-family:'Syne',sans-serif; font-weight:800;
  font-size:clamp(52px,8vw,96px); line-height:1;
  background:linear-gradient(90deg,var(--accent),var(--accent3),var(--accent2));
  -webkit-background-clip:text; -webkit-text-fill-color:transparent;
  background-clip:text; filter:drop-shadow(0 0 30px rgba(124,255,196,0.4));
}
.subtitle {
  font-size:11px; letter-spacing:0.25em; text-transform:uppercase;
  color:rgba(255,255,255,0.4); margin-top:8px;
}
.pills-row { display:flex; gap:12px; flex-wrap:wrap; justify-content:center; }
.pill {
  padding:6px 16px; border-radius:100px; border:1px solid var(--glass-border);
  background:var(--glass); font-size:12px; color:rgba(255,255,255,0.6);
  backdrop-filter:blur(12px);
}
.cta-btn {
  padding:14px 40px; border-radius:100px; border:none; cursor:pointer;
  background:var(--accent); color:#03020a;
  font-family:'Syne',sans-serif; font-weight:800; font-size:16px;
  box-shadow:0 0 40px rgba(124,255,196,0.5), 0 0 80px rgba(124,255,196,0.2);
  transition:transform 0.2s, box-shadow 0.2s;
}
.cta-btn:hover { transform:scale(1.05); box-shadow:0 0 60px rgba(124,255,196,0.7),0 0 120px rgba(124,255,196,0.3); }
.cam-note { font-size:11px; color:rgba(255,255,255,0.25); }

/* LAYERS */
video, #bgCanvas, #fxCanvas, #drawCanvas {
  position:fixed; inset:0; width:100%; height:100%;
}
video { z-index:1; object-fit:cover; transform:scaleX(-1); filter:brightness(0.25) saturate(0.6); }
#bgCanvas { z-index:2; }
#fxCanvas { z-index:3; }
#drawCanvas { z-index:4; }

/* TOP STRIPE */
#stripe {
  position:fixed; top:0; left:0; right:0; height:2px; z-index:500;
  background:var(--accent);
  transition:background 0.5s;
  box-shadow:0 0 12px currentColor;
}

/* TOP BAR */
#topbar {
  position:fixed; top:10px; left:50%; transform:translateX(-50%);
  z-index:600; display:flex; align-items:center; gap:12px;
  background:rgba(3,2,10,0.6); backdrop-filter:blur(20px) saturate(1.4);
  border:1px solid var(--glass-border); border-radius:100px;
  padding:8px 16px; min-width:min(90vw,620px);
  justify-content:space-between;
}
.brand {
  font-family:'Syne',sans-serif; font-weight:800; font-size:16px;
  background:linear-gradient(90deg,var(--accent),var(--accent3));
  -webkit-background-clip:text; -webkit-text-fill-color:transparent;
  background-clip:text; white-space:nowrap;
  display:flex; align-items:center; gap:8px;
}
.beta-pill {
  font-family:'DM Mono',monospace; font-size:9px;
  padding:2px 6px; border-radius:4px;
  background:rgba(124,255,196,0.15); border:1px solid rgba(124,255,196,0.3);
  color:var(--accent); -webkit-text-fill-color:var(--accent); letter-spacing:0.1em;
}
.mode-switcher {
  display:flex; background:rgba(0,0,0,0.4); border-radius:100px; padding:3px; gap:2px;
}
.mode-btn {
  border:none; background:transparent; cursor:pointer; color:rgba(255,255,255,0.4);
  border-radius:100px; padding:6px 14px; font-family:'DM Mono',monospace; font-size:12px;
  display:flex; align-items:center; gap:5px; transition:all 0.25s; white-space:nowrap;
}
.mode-btn.active { background:rgba(255,255,255,0.08); color:#fff; }
.mode-btn[data-mode="play"].active { box-shadow:0 0 12px rgba(124,255,196,0.6); color:var(--accent); }
.mode-btn[data-mode="shapes"].active { box-shadow:0 0 12px rgba(255,107,202,0.6); color:var(--accent2); }
.mode-btn[data-mode="write"].active { box-shadow:0 0 12px rgba(107,181,255,0.6); color:var(--accent3); }
.mode-label { }
@media(max-width:600px){ .mode-label{display:none;} }
.hud-chips { display:flex; gap:8px; align-items:center; }
.chip {
  font-size:11px; padding:4px 10px; border-radius:100px;
  background:rgba(255,255,255,0.05); border:1px solid var(--glass-border);
  display:flex; align-items:center; gap:6px; white-space:nowrap;
}
.cam-dot {
  width:7px;height:7px;border-radius:50%;background:#333;
  box-shadow:0 0 0 2px #333; transition:all 0.3s;
}
.cam-dot.live { background:var(--accent); box-shadow:0 0 8px var(--accent); }

/* BOTTOM HUD */
#bottomHud {
  position:fixed; bottom:24px; left:50%; transform:translateX(-50%);
  z-index:600;
  background:rgba(3,2,10,0.7); backdrop-filter:blur(16px);
  border:1px solid var(--glass-border); border-radius:100px;
  padding:8px 20px; display:flex; align-items:center; gap:10px;
  font-size:13px; transition:opacity 0.4s;
}
.active-dot {
  width:8px; height:8px; border-radius:50%;
  background:var(--accent); box-shadow:0 0 10px var(--accent);
  animation:blink 1.2s ease-in-out infinite;
}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:0.3;}}

/* TOAST */
#toast {
  position:fixed; inset:0; z-index:700; pointer-events:none;
  display:flex; align-items:center; justify-content:center;
  opacity:0; transition:opacity 0.2s;
}
#toastInner {
  font-family:'Syne',sans-serif; font-weight:800;
  font-size:clamp(28px,5vw,52px);
  text-shadow:0 0 40px currentColor;
  transform:scale(0.85);
  transition:transform 0.3s cubic-bezier(0.34,1.56,0.64,1);
}
#toast.show { opacity:1; }
#toast.show #toastInner { transform:scale(1); }

/* HELP PANEL */
#help {
  position:fixed; bottom:24px; right:20px; z-index:600;
  background:rgba(3,2,10,0.7); backdrop-filter:blur(16px);
  border:1px solid var(--glass-border); border-radius:16px;
  padding:14px 18px; max-width:220px; font-size:11px;
  color:rgba(255,255,255,0.5); line-height:1.8;
}
#help strong { color:rgba(255,255,255,0.8); display:block; margin-bottom:4px; font-family:'Syne',sans-serif; }

/* SHAKE RING */
#shakeRingWrap {
  position:fixed; bottom:80px; right:28px; z-index:600;
  width:56px; height:56px; display:none;
}
#shakeRingWrap svg { transform:rotate(-90deg); }

/* CLEAR BTN */
#clearBtn {
  position:fixed; bottom:24px; right:260px; z-index:600;
  display:none; padding:8px 18px; border-radius:100px;
  border:1px solid rgba(107,181,255,0.4); background:rgba(107,181,255,0.1);
  color:var(--accent3); font-family:'DM Mono',monospace; font-size:12px;
  cursor:pointer; transition:all 0.2s;
}
#clearBtn:hover { background:rgba(107,181,255,0.25); }
</style>
</head>
<body>

<!-- NOISE OVERLAY -->
<svg id="noise" xmlns="http://www.w3.org/2000/svg">
  <filter id="noiseFilter"><feTurbulence type="fractalNoise" baseFrequency="0.65" numOctaves="3" stitchTiles="stitch"/><feColorMatrix type="saturate" values="0"/></filter>
  <rect width="100%" height="100%" filter="url(#noiseFilter)"/>
</svg>

<!-- SPLASH -->
<div id="splash">
  <div class="rings-wrap">
    <div class="ring"></div><div class="ring"></div><div class="ring"></div>
  </div>
  <div class="logo-wrap">
    <div class="logo">Handy AI</div>
    <div class="subtitle">Gesture Intelligence Platform</div>
  </div>
  <div class="pills-row">
    <div class="pill">⚡ Real-time Tracking</div>
    <div class="pill">✦ Gesture Physics</div>
    <div class="pill">✏ Air Drawing</div>
  </div>
  <button class="cta-btn" id="enterBtn">Enter Experience</button>
  <div class="cam-note">Camera access required · Best in Chrome / Edge</div>
</div>

<!-- LAYERS -->
<video id="vid" autoplay playsinline muted></video>
<canvas id="bgCanvas"></canvas>
<canvas id="fxCanvas"></canvas>
<canvas id="drawCanvas"></canvas>

<!-- TOP STRIPE -->
<div id="stripe"></div>

<!-- TOP BAR -->
<div id="topbar">
  <div class="brand">
    Handy AI
    <span class="beta-pill">BETA</span>
  </div>
  <div class="mode-switcher">
    <button class="mode-btn active" data-mode="play">▶ <span class="mode-label">Play</span></button>
    <button class="mode-btn" data-mode="shapes">♥ <span class="mode-label">Shapes</span></button>
    <button class="mode-btn" data-mode="write">✏ <span class="mode-label">Write</span></button>
  </div>
  <div class="hud-chips">
    <div class="chip"><div class="cam-dot" id="camDot"></div><span id="fpsLabel">0 fps</span></div>
    <div class="chip">👋 <span id="handCount">0</span></div>
  </div>
</div>

<!-- BOTTOM HUD -->
<div id="bottomHud"><div class="active-dot" id="activeDot"></div><span id="gestureLabel">Initializing…</span></div>

<!-- TOAST -->
<div id="toast"><div id="toastInner"></div></div>

<!-- HELP PANEL -->
<div id="help">
  <strong id="helpTitle">Play Mode</strong>
  <div id="helpBody"></div>
</div>

<!-- SHAKE RING -->
<div id="shakeRingWrap">
  <svg width="56" height="56" viewBox="0 0 56 56">
    <circle cx="28" cy="28" r="22" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="4"/>
    <circle id="shakeArc" cx="28" cy="28" r="22" fill="none" stroke="var(--accent3)" stroke-width="4"
      stroke-dasharray="138.2" stroke-dashoffset="138.2" stroke-linecap="round"/>
  </svg>
</div>

<!-- CLEAR BUTTON -->
<button id="clearBtn">🗑 Clear Canvas</button>

<!-- Copyright -->
<div style="position:fixed;bottom:6px;left:50%;transform:translateX(-50%);z-index:800;font-size:10px;color:rgba(255,255,255,0.2);text-align:center;pointer-events:none;">
  Created by <a href="https://www.instagram.com/mithun.ai.lab/" target="_blank" style="color:rgba(255,255,255,0.35);text-decoration:none;">Mithun AI Lab</a>
</div>

<!-- MediaPipe -->
<script src="https://cdn.jsdelivr.net/npm/@mediapipe/camera_utils/camera_utils.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@mediapipe/control_utils/control_utils.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@mediapipe/hands/hands.js" crossorigin="anonymous"></script>

<script>
// ── STATE ──────────────────────────────────────────────────────────────────
let mode = 'play';
let handsData = [];
let frameCount = 0, fps = 0, lastFpsTime = performance.now();
let started = false;

// Audio
let audioCtx, humOsc, humGain;
let audioReady = false;

function initAudio() {
  if (audioReady) return;
  audioCtx = new (window.AudioContext || window.webkitAudioContext)();
  humOsc = audioCtx.createOscillator();
  humGain = audioCtx.createGain();
  humOsc.type = 'sine';
  humOsc.frequency.value = 80;
  humGain.gain.value = 0;
  humOsc.connect(humGain);
  humGain.connect(audioCtx.destination);
  humOsc.start();
  audioReady = true;
}
function playZap() {
  if (!audioReady) return;
  const o = audioCtx.createOscillator();
  const g = audioCtx.createGain();
  o.type = 'sawtooth';
  o.frequency.setValueAtTime(700, audioCtx.currentTime);
  o.frequency.exponentialRampToValueAtTime(30, audioCtx.currentTime + 0.12);
  g.gain.setValueAtTime(0.18, audioCtx.currentTime);
  g.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.12);
  o.connect(g); g.connect(audioCtx.destination);
  o.start(); o.stop(audioCtx.currentTime + 0.12);
}
function playPop(freq=440) {
  if (!audioReady) return;
  const o = audioCtx.createOscillator();
  const g = audioCtx.createGain();
  o.type = 'sine';
  o.frequency.setValueAtTime(freq, audioCtx.currentTime);
  o.frequency.exponentialRampToValueAtTime(freq*0.5, audioCtx.currentTime + 0.08);
  g.gain.setValueAtTime(0.2, audioCtx.currentTime);
  g.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.08);
  o.connect(g); g.connect(audioCtx.destination);
  o.start(); o.stop(audioCtx.currentTime + 0.1);
}

// ── CANVAS SETUP ──────────────────────────────────────────────────────────
const vid = document.getElementById('vid');
const bgC = document.getElementById('bgCanvas');
const fxC = document.getElementById('fxCanvas');
const dwC = document.getElementById('drawCanvas');
const bgX = bgC.getContext('2d');
const fxX = fxC.getContext('2d');
const dwX = dwC.getContext('2d');

let W = window.innerWidth, H = window.innerHeight;
function resize() {
  W = window.innerWidth; H = window.innerHeight;
  [bgC, fxC, dwC].forEach(c => { c.width = W; c.height = H; });
  initMatrix();
}
window.addEventListener('resize', resize);
resize();

// ── MATRIX RAIN ───────────────────────────────────────────────────────────
const KANA = [];
for (let i=0x30A0; i<=0x30FF; i++) KANA.push(String.fromCharCode(i));
let matrixCols = [], matrixDrops = [];
const FONT_SIZE = 15;

function initMatrix() {
  const cols = Math.floor(W / FONT_SIZE);
  matrixCols = Array.from({length: cols}, () => ({
    char: KANA[Math.floor(Math.random()*KANA.length)],
    opacity: Math.random()
  }));
  matrixDrops = Array.from({length: cols}, () => Math.random() * -H/FONT_SIZE * 2);
}

let matrixHue = 0;
let handVelocity = 0;
let prevHandPos = null;

function drawMatrix(dt) {
  matrixHue = (matrixHue + 0.3) % 360;
  const fade = 0.12 + handVelocity * 0.003;
  bgX.globalCompositeOperation = 'destination-out';
  bgX.fillStyle = `rgba(0,0,0,${fade})`;
  bgX.fillRect(0, 0, W, H);
  bgX.globalCompositeOperation = 'source-over';
  bgX.font = `${FONT_SIZE}px 'DM Mono', monospace`;

  const speed = 1 + handVelocity * 0.08;
  for (let i=0; i<matrixDrops.length; i++) {
    const hue = (matrixHue + i * 3) % 360;
    bgX.fillStyle = `hsl(${hue},80%,60%)`;
    const char = KANA[Math.floor(Math.random()*KANA.length)];
    bgX.fillText(char, i * FONT_SIZE, matrixDrops[i] * FONT_SIZE);
    if (matrixDrops[i] * FONT_SIZE > H && Math.random() > 0.975) matrixDrops[i] = 0;
    matrixDrops[i] += speed;
  }
}

// ── PARTICLES & RIPPLES ───────────────────────────────────────────────────
let particles = [], ripples = [];

function spawnParticles(x, y, count=12, color='#7cffc4') {
  for (let i=0; i<count; i++) {
    const angle = Math.random() * Math.PI * 2;
    const speed = 1.5 + Math.random() * 4;
    particles.push({ x, y, vx: Math.cos(angle)*speed, vy: Math.sin(angle)*speed, life:45, maxLife:45, color, r: 2+Math.random()*3 });
  }
}
function spawnRipple(x, y, color='#7cffc4') {
  ripples.push({ x, y, r:0, maxR:80, life:40, maxLife:40, color });
}

function drawParticlesRipples() {
  fxX.globalCompositeOperation = 'screen';
  // ripples
  ripples = ripples.filter(r => r.life > 0);
  for (const r of ripples) {
    const t = 1 - r.life/r.maxLife;
    r.r = r.maxR * t;
    const alpha = r.life/r.maxLife;
    fxX.strokeStyle = r.color + Math.floor(alpha*255).toString(16).padStart(2,'0');
    fxX.lineWidth = 1.5;
    fxX.beginPath(); fxX.arc(r.x, r.y, r.r, 0, Math.PI*2); fxX.stroke();
    fxX.beginPath(); fxX.arc(r.x, r.y, r.r*0.6, 0, Math.PI*2); fxX.stroke();
    r.life--;
  }
  // particles
  particles = particles.filter(p => p.life > 0);
  for (const p of particles) {
    const t = p.life/p.maxLife;
    p.vy += 0.15;
    p.x += p.vx; p.y += p.vy;
    fxX.fillStyle = p.color + Math.floor(t*200).toString(16).padStart(2,'0');
    fxX.beginPath(); fxX.arc(p.x, p.y, p.r*t, 0, Math.PI*2); fxX.fill();
    p.life--;
  }
  fxX.globalCompositeOperation = 'source-over';
}

// ── HAND SKELETON RENDERING ────────────────────────────────────────────────
const CONNECTIONS = [
  [0,1],[1,2],[2,3],[3,4],
  [0,5],[5,6],[6,7],[7,8],
  [0,9],[9,10],[10,11],[11,12],
  [0,13],[13,14],[14,15],[15,16],
  [0,17],[17,18],[18,19],[19,20],
  [5,9],[9,13],[13,17]
];
const TIPS = [4,8,12,16,20];

let timeOff = 0;
let pinchCooldown = {};

function lm(lms, i, flip=true) {
  const x = flip ? W - lms[i].x*W : lms[i].x*W;
  return { x, y: lms[i].y*H };
}

function dist(a,b){ return Math.hypot(a.x-b.x, a.y-b.y); }
function distLm(lms,a,b){ return Math.hypot(lms[a].x-lms[b].x, lms[a].y-lms[b].y); }

function drawSkeleton(lms, hue) {
  fxX.globalCompositeOperation = 'screen';
  // bones
  for (const [a,b] of CONNECTIONS) {
    const pa = lm(lms,a), pb = lm(lms,b);
    const grad = fxX.createLinearGradient(pa.x,pa.y,pb.x,pb.y);
    grad.addColorStop(0, `hsla(${hue},90%,65%,0.8)`);
    grad.addColorStop(1, `hsla(${(hue+40)%360},90%,65%,0.8)`);
    fxX.strokeStyle = grad; fxX.lineWidth = 2.5;
    fxX.shadowColor = `hsl(${hue},90%,65%)`; fxX.shadowBlur = 8;
    fxX.beginPath(); fxX.moveTo(pa.x,pa.y); fxX.lineTo(pb.x,pb.y); fxX.stroke();
  }
  // fingertip blobs
  for (const t of TIPS) {
    const p = lm(lms,t);
    fxX.fillStyle = `hsla(${hue},100%,75%,0.9)`;
    fxX.shadowColor = `hsl(${hue},100%,70%)`; fxX.shadowBlur = 18;
    fxX.beginPath(); fxX.arc(p.x, p.y, 5, 0, Math.PI*2); fxX.fill();
    // sparkle
    if (Math.random()<0.35) spawnParticles(p.x, p.y, 1, `hsl(${hue},100%,70%)`);
  }
  fxX.shadowBlur = 0;
  fxX.globalCompositeOperation = 'source-over';
}

// ── PLAY MODE ─────────────────────────────────────────────────────────────
function renderPlay() {
  timeOff += 0.01;
  handsData.forEach((lms, hi) => {
    const hue = (timeOff*40 + hi*120) % 360;
    drawSkeleton(lms, hue);

    // pinch
    const thumb = lm(lms,4), index = lm(lms,8);
    const pinchDist = dist(thumb,index)/W;
    const key = `pinch_${hi}`;
    if (pinchDist < 0.055 && !pinchCooldown[key]) {
      const mx = (thumb.x+index.x)/2, my = (thumb.y+index.y)/2;
      spawnRipple(mx, my, '#7cffc4');
      spawnParticles(mx, my, 20, '#7cffc4');
      playZap();
      showToast('⚡ Pinch', '#7cffc4');
      pinchCooldown[key] = 30;
    }
    if (pinchCooldown[key]>0) pinchCooldown[key]--;
  });

  // Two-hand interaction
  if (handsData.length===2) {
    const lms0 = handsData[0], lms1 = handsData[1];
    fxX.globalCompositeOperation = 'screen';
    // gradient lines between matching fingertips
    for (const t of TIPS) {
      const a = lm(lms0,t), b = lm(lms1,t);
      const d = dist(a,b);
      const grad = fxX.createLinearGradient(a.x,a.y,b.x,b.y);
      grad.addColorStop(0,'rgba(124,255,196,0.4)');
      grad.addColorStop(1,'rgba(107,181,255,0.4)');
      fxX.strokeStyle = grad; fxX.lineWidth = 1.5;
      fxX.beginPath(); fxX.moveTo(a.x,a.y); fxX.lineTo(b.x,b.y); fxX.stroke();
      // lightning if close
      if (d < 140) drawLightning(a, b);
    }

    // mandala
    const cx = TIPS.reduce((s,t) => s+(lm(lms0,t).x+lm(lms1,t).x)/2, 0)/TIPS.length;
    const cy = TIPS.reduce((s,t) => s+(lm(lms0,t).y+lm(lms1,t).y)/2, 0)/TIPS.length;
    drawMandala(cx, cy, lms0, lms1);

    // hum
    const wrist0 = lm(lms0,0), wrist1 = lm(lms1,0);
    const handDist = dist(wrist0,wrist1);
    if (humGain) {
      const pitch = 80 + (handDist/W)*280;
      humOsc.frequency.setTargetAtTime(pitch, audioCtx.currentTime, 0.1);
      humGain.gain.setTargetAtTime(0.04, audioCtx.currentTime, 0.1);
    }
    fxX.globalCompositeOperation = 'source-over';
  } else {
    if (humGain) humGain.gain.setTargetAtTime(0, audioCtx.currentTime, 0.3);
  }
}

function drawLightning(a, b) {
  fxX.strokeStyle = 'rgba(255,255,150,0.8)'; fxX.lineWidth = 1.5;
  fxX.shadowColor = '#fff'; fxX.shadowBlur = 10;
  fxX.beginPath(); fxX.moveTo(a.x, a.y);
  let cx=a.x, cy=a.y;
  const steps=6;
  for(let i=1;i<=steps;i++){
    const t=i/steps;
    const nx=a.x+(b.x-a.x)*t + (Math.random()-0.5)*30;
    const ny=a.y+(b.y-a.y)*t + (Math.random()-0.5)*30;
    fxX.lineTo(nx,ny);
  }
  fxX.lineTo(b.x,b.y); fxX.stroke();
  fxX.shadowBlur=0;
}

function drawMandala(cx, cy, lms0, lms1) {
  const ang = timeOff*0.5;
  fxX.strokeStyle = 'rgba(255,255,255,0.15)'; fxX.lineWidth=1;
  fxX.beginPath();
  TIPS.forEach((t,i) => {
    const a = lm(lms0,t), b = lm(lms1,t);
    const px=(a.x+b.x)/2, py=(a.y+b.y)/2;
    if(i===0) fxX.moveTo(px,py); else fxX.lineTo(px,py);
  });
  fxX.closePath(); fxX.stroke();
}

// ── SHAPES MODE ───────────────────────────────────────────────────────────
let shapeCooldown = 0;
let lastShape = null;
let shapeAnim = 0;

function fingerSpread(lms) {
  const tips = TIPS.map(t => ({x:lms[t].x, y:lms[t].y}));
  let maxD=0;
  for(let i=0;i<tips.length;i++)
    for(let j=i+1;j<tips.length;j++)
      maxD=Math.max(maxD,Math.hypot(tips[i].x-tips[j].x,tips[i].y-tips[j].y));
  return maxD;
}

function renderShapes() {
  shapeAnim += 0.05;
  if (shapeCooldown>0) shapeCooldown--;

  if (handsData.length < 2) {
    setGestureLabel('Show both hands…');
    // still render skeletons
    handsData.forEach((lms,hi) => drawSkeleton(lms,(timeOff*40+hi*120)%360));
    // persistent last shape
    if (lastShape) renderLastShape();
    return;
  }

  handsData.forEach((lms,hi) => drawSkeleton(lms,(timeOff*40+hi*120)%360));

  const lms0=handsData[0], lms1=handsData[1];
  const w0=lm(lms0,0), w1=lm(lms1,0);
  const palmDist=Math.hypot(lms0[0].x-lms1[0].x,lms0[0].y-lms1[0].y);
  const spread0=fingerSpread(lms0), spread1=fingerSpread(lms1);

  // HEART: close palms + open fingers
  if (palmDist<0.35 && spread0>0.09 && spread1>0.09) {
    setGestureLabel('♥ Heart');
    const cx=(w0.x+w1.x)/2, cy=(w0.y+w1.y)/2;
    drawHeart(cx,cy);
    if (!shapeCooldown) { lastShape={type:'heart',cx,cy}; playPop(440); showToast('♥ Heart','#ff6bca'); shapeCooldown=60; }
    return;
  }

  // PEACE: one hand, index+middle up, ring+pinky down
  for (const lms of handsData) {
    const indexUp = Math.hypot(lms[8].x-lms[0].x,lms[8].y-lms[0].y)>0.18;
    const midUp   = Math.hypot(lms[12].x-lms[0].x,lms[12].y-lms[0].y)>0.18;
    const ringDn  = Math.hypot(lms[16].x-lms[0].x,lms[16].y-lms[0].y)<0.16;
    const pinkDn  = Math.hypot(lms[20].x-lms[0].x,lms[20].y-lms[0].y)<0.16;
    if (indexUp&&midUp&&ringDn&&pinkDn) {
      setGestureLabel('✌ Peace');
      const p=lm(lms,9);
      drawPeace(p.x,p.y-60);
      if (!shapeCooldown) { lastShape={type:'peace',cx:p.x,cy:p.y-60}; playPop(550); showToast('✌ Peace','#ff6bca'); shapeCooldown=60; }
      return;
    }
  }

  // STAR BURST: both fisted
  if (spread0<0.09 && spread1<0.09) {
    setGestureLabel('💥 Star Burst!');
    const cx=(w0.x+w1.x)/2, cy=(w0.y+w1.y)/2;
    drawStar(cx,cy);
    if (!shapeCooldown) {
      spawnParticles(cx,cy,25,'#ffee88');
      playZap();
      showToast('💥 Star Burst!','#ffee88');
      lastShape={type:'star',cx,cy};
      shapeCooldown=60;
    }
    return;
  }

  setGestureLabel('Shapes Mode — try a gesture!');
  if (lastShape) renderLastShape();
}

function renderLastShape() {
  if (!lastShape) return;
  if (lastShape.type==='heart') drawHeart(lastShape.cx,lastShape.cy,0.3);
  else if (lastShape.type==='peace') drawPeace(lastShape.cx,lastShape.cy,0.3);
  else if (lastShape.type==='star') drawStar(lastShape.cx,lastShape.cy,0.3);
}

function drawHeart(cx,cy,alpha=1) {
  fxX.globalCompositeOperation='screen';
  const scale=140+Math.sin(shapeAnim)*7;
  const s=scale/17;
  fxX.save();
  fxX.translate(cx,cy);
  // fill
  const grad=fxX.createRadialGradient(0,-20,10,0,0,scale);
  grad.addColorStop(0,`rgba(255,107,202,${0.9*alpha})`);
  grad.addColorStop(1,`rgba(255,0,100,${0.2*alpha})`);
  fxX.fillStyle=grad;
  fxX.shadowColor='#ff6bca'; fxX.shadowBlur=40*alpha;
  fxX.beginPath();
  for(let t=0;t<=Math.PI*2;t+=0.05){
    const x=(16*Math.pow(Math.sin(t),3))*s;
    const y=-(13*Math.cos(t)-5*Math.cos(2*t)-2*Math.cos(3*t)-Math.cos(4*t))*s;
    t===0?fxX.moveTo(x,y):fxX.lineTo(x,y);
  }
  fxX.closePath(); fxX.fill();
  // stroke
  fxX.strokeStyle=`rgba(255,180,220,${0.8*alpha})`; fxX.lineWidth=2.5;
  fxX.stroke();
  // shine
  fxX.fillStyle=`rgba(255,255,255,${0.15*alpha})`;
  fxX.beginPath(); fxX.ellipse(-14,-28,14,8,0.5,0,Math.PI*2); fxX.fill();
  fxX.restore();
  fxX.shadowBlur=0;
  fxX.globalCompositeOperation='source-over';
}

function drawPeace(cx,cy,alpha=1) {
  fxX.globalCompositeOperation='screen';
  fxX.save();
  fxX.translate(cx,cy);
  fxX.strokeStyle=`rgba(255,107,202,${0.9*alpha})`; fxX.lineWidth=3;
  fxX.shadowColor='#ff6bca'; fxX.shadowBlur=20*alpha;
  const r=60;
  fxX.beginPath(); fxX.arc(0,0,r,0,Math.PI*2); fxX.stroke();
  fxX.beginPath(); fxX.moveTo(0,-r); fxX.lineTo(0,r); fxX.stroke();
  fxX.beginPath(); fxX.moveTo(0,0); fxX.lineTo(-r*Math.cos(Math.PI/6),r*Math.sin(Math.PI/6)); fxX.stroke();
  fxX.beginPath(); fxX.moveTo(0,0); fxX.lineTo(r*Math.cos(Math.PI/6),r*Math.sin(Math.PI/6)); fxX.stroke();
  fxX.restore();
  fxX.shadowBlur=0;
  fxX.globalCompositeOperation='source-over';
}

function drawStar(cx,cy,alpha=1) {
  fxX.globalCompositeOperation='screen';
  fxX.save();
  fxX.translate(cx,cy);
  fxX.rotate(shapeAnim*0.5);
  const grad=fxX.createRadialGradient(0,0,0,0,0,100);
  grad.addColorStop(0,`rgba(255,255,255,${0.9*alpha})`);
  grad.addColorStop(0.4,`rgba(255,215,0,${0.7*alpha})`);
  grad.addColorStop(1,`rgba(255,180,0,0)`);
  fxX.fillStyle=grad;
  fxX.beginPath();
  const pts=8;
  for(let i=0;i<pts*2;i++){
    const r=i%2===0?100:45;
    const a=i*Math.PI/pts;
    i===0?fxX.moveTo(Math.cos(a)*r,Math.sin(a)*r):fxX.lineTo(Math.cos(a)*r,Math.sin(a)*r);
  }
  fxX.closePath(); fxX.fill();
  fxX.restore();
  fxX.globalCompositeOperation='source-over';
}

// ── WRITE MODE ────────────────────────────────────────────────────────────
let drawPaths = [];
let activePath = null;
let penDown = false;
let drawHue = 0;
let shakeCooldown = 0;
let wristXHistory = [];
let shakeProgress = 0;
let writePinchCooldown = 0;

function renderWrite() {
  if (handsData.length===0) { setGestureLabel('Show your hand…'); return; }
  const lms=handsData[0];
  const tipLm=lm(lms,8);
  const wristLm=lm(lms,0);
  const thumbLm=lm(lms,4);

  // wrist history for shake
  const wx=lms[0].x;
  wristXHistory.push(wx);
  if(wristXHistory.length>30) wristXHistory.shift();

  // open palm check
  let fingersUp=0;
  for(const t of [8,12,16,20]){
    if(Math.hypot(lms[t].x-lms[0].x,lms[t].y-lms[0].y)>0.13) fingersUp++;
  }
  const openPalm=fingersUp>=3;

  // shake detection
  if(openPalm && shakeCooldown===0) {
    let reversals=0;
    for(let i=2;i<wristXHistory.length;i++){
      const d1=wristXHistory[i-1]-wristXHistory[i-2];
      const d2=wristXHistory[i]-wristXHistory[i-1];
      if(Math.abs(d1)>0.015&&Math.abs(d2)>0.015&&Math.sign(d1)!==Math.sign(d2)) reversals++;
    }
    shakeProgress=Math.min(reversals/6,1);
    updateShakeRing(shakeProgress);
    if(reversals>=6){
      drawPaths=[]; activePath=null;
      dwX.clearRect(0,0,W,H);
      playPop(350);
      showToast('🌊 Canvas cleared','#6bb5ff');
      shakeCooldown=120; wristXHistory=[];
      shakeProgress=0; updateShakeRing(0);
    }
  } else {
    shakeProgress=Math.max(0,shakeProgress-0.02);
    updateShakeRing(shakeProgress);
  }
  if(shakeCooldown>0) shakeCooldown--;

  // index pointing = pen down
  const indexDist=Math.hypot(lms[8].x-lms[0].x,lms[8].y-lms[0].y);
  const pinchDist2=Math.hypot(lms[4].x-lms[8].x,lms[4].y-lms[8].y);
  const pointing=indexDist>0.17 && pinchDist2>0.06;

  // show skeleton
  drawSkeleton(lms,(timeOff*30)%360);

  // cursor
  fxX.save();
  fxX.globalCompositeOperation='screen';
  fxX.strokeStyle=pointing?`rgba(107,181,255,0.9)`:`rgba(255,255,255,0.3)`;
  fxX.lineWidth=2; fxX.shadowColor='#6bb5ff'; fxX.shadowBlur=pointing?20:5;
  fxX.beginPath(); fxX.arc(tipLm.x,tipLm.y,10+Math.sin(timeOff*5)*2,0,Math.PI*2); fxX.stroke();
  fxX.restore();

  // pinch = pen up
  if(pinchDist2<0.06) {
    if(penDown && activePath && activePath.pts.length>1) {
      drawPaths.push(activePath); activePath=null; penDown=false;
      setGestureLabel('✏ Stroke saved');
    }
  } else if(pointing) {
    if(!penDown) {
      drawHue=(drawHue+30)%360;
      activePath={pts:[{x:tipLm.x,y:tipLm.y}],hue:drawHue};
      penDown=true;
      setGestureLabel('✏ Drawing…');
    } else {
      activePath.pts.push({x:tipLm.x,y:tipLm.y});
      redrawCanvas();
    }
  } else {
    if(penDown && activePath) {
      drawPaths.push(activePath); activePath=null; penDown=false;
    }
    setGestureLabel('✏ Write Mode — point to draw');
  }
}

function redrawCanvas() {
  dwX.clearRect(0,0,W,H);
  const allPaths=activePath?[...drawPaths,activePath]:drawPaths;
  for(const path of allPaths) {
    if(path.pts.length<2) continue;
    dwX.shadowColor=`hsl(${path.hue},90%,65%)`;
    dwX.shadowBlur=12;
    dwX.strokeStyle=`hsl(${path.hue},90%,65%)`;
    dwX.lineWidth=4.5; dwX.lineCap='round'; dwX.lineJoin='round';
    dwX.beginPath();
    dwX.moveTo(path.pts[0].x,path.pts[0].y);
    for(let i=1;i<path.pts.length-1;i++){
      const mx=(path.pts[i].x+path.pts[i+1].x)/2;
      const my=(path.pts[i].y+path.pts[i+1].y)/2;
      dwX.quadraticCurveTo(path.pts[i].x,path.pts[i].y,mx,my);
    }
    dwX.stroke();
  }
  dwX.shadowBlur=0;
}

function updateShakeRing(p) {
  const wrap=document.getElementById('shakeRingWrap');
  const arc=document.getElementById('shakeArc');
  const circ=138.2;
  arc.style.strokeDashoffset=circ*(1-p);
  const hue=200+p*60;
  const sat=p>0.5?'100%':'80%';
  arc.style.stroke=`hsl(${hue},${sat},60%)`;
  wrap.style.display=p>0?'block':'none';
}

// ── GESTURE LABEL / TOAST / HUD ───────────────────────────────────────────
let gestureLabel = 'Initializing…';
function setGestureLabel(txt) {
  gestureLabel=txt;
  document.getElementById('gestureLabel').textContent=txt;
}

let toastTimer=null;
function showToast(txt, color='#7cffc4') {
  const t=document.getElementById('toast');
  const ti=document.getElementById('toastInner');
  ti.textContent=txt; ti.style.color=color;
  t.classList.add('show');
  if(toastTimer) clearTimeout(toastTimer);
  toastTimer=setTimeout(()=>t.classList.remove('show'),1600);
}

// ── MODE HELP TEXTS ────────────────────────────────────────────────────────
const HELP = {
  play: 'Pinch thumb+index to zap\nTwo hands = lightning\nMove fast = faster rain',
  shapes: 'HEART: close palms, open fingers\nPEACE: index+middle up\nSTAR: both fists',
  write: 'Point index finger to draw\nPinch to lift pen\nShake open palm to clear'
};

function updateHelp() {
  document.getElementById('helpTitle').textContent=
    mode==='play'?'Play Mode':mode==='shapes'?'Shapes Mode':'Write Mode';
  document.getElementById('helpBody').textContent=HELP[mode];
}

// ── MODE SWITCHER ──────────────────────────────────────────────────────────
const modeColors={play:'#7cffc4',shapes:'#ff6bca',write:'#6bb5ff'};
document.querySelectorAll('.mode-btn').forEach(btn=>{
  btn.addEventListener('click',()=>{
    mode=btn.dataset.mode;
    document.querySelectorAll('.mode-btn').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('stripe').style.background=modeColors[mode];
    document.getElementById('stripe').style.boxShadow=`0 0 12px ${modeColors[mode]}`;
    document.getElementById('clearBtn').style.display=mode==='write'?'block':'none';
    document.getElementById('shakeRingWrap').style.display='none';
    updateHelp();
    lastShape=null;
    shapeAnim=0;
    if(mode!=='play') { if(humGain) humGain.gain.setTargetAtTime(0,audioCtx?.currentTime||0,0.3); }
  });
});
document.getElementById('clearBtn').addEventListener('click',()=>{
  drawPaths=[]; activePath=null; dwX.clearRect(0,0,W,H);
  playPop(350); showToast('🌊 Canvas cleared','#6bb5ff');
});

// ── MAIN RENDER LOOP ───────────────────────────────────────────────────────
let lastTime=0;
function loop(ts) {
  const dt=ts-lastTime; lastTime=ts;

  // FPS
  frameCount++;
  if(ts-lastFpsTime>1000){
    fps=Math.round(frameCount*1000/(ts-lastFpsTime));
    frameCount=0; lastFpsTime=ts;
    document.getElementById('fpsLabel').textContent=fps+' fps';
    document.getElementById('camDot').className='cam-dot'+(fps>5?' live':'');
  }

  timeOff+=0.016;

  // hand velocity
  if(handsData.length>0){
    const wrist=lm(handsData[0],0);
    if(prevHandPos){
      handVelocity=Math.hypot(wrist.x-prevHandPos.x,wrist.y-prevHandPos.y);
    }
    prevHandPos={x:wrist.x,y:wrist.y};
  } else {
    handVelocity*=0.9; prevHandPos=null;
  }

  // hand count
  document.getElementById('handCount').textContent=handsData.length;

  // bg
  drawMatrix(dt);

  // fx
  fxX.clearRect(0,0,W,H);
  if(started){
    if(mode==='play') renderPlay();
    else if(mode==='shapes') renderShapes();
    else renderWrite();
  }
  drawParticlesRipples();

  requestAnimationFrame(loop);
}
requestAnimationFrame(loop);

// ── MEDIAPIPE ─────────────────────────────────────────────────────────────
function startMediaPipe() {
  const hands = new Hands({locateFile: f=>`https://cdn.jsdelivr.net/npm/@mediapipe/hands/${f}`});
  hands.setOptions({
    maxNumHands:2, modelComplexity:1,
    minDetectionConfidence:0.72, minTrackingConfidence:0.72
  });
  hands.onResults(results=>{
    handsData=results.multiHandLandmarks||[];
  });

  const cam = new Camera(vid,{
    onFrame: async()=>{ await hands.send({image:vid}); },
    width:1920, height:1080
  });
  cam.start();
  started=true;
  setGestureLabel('Ready — use your hands!');
}

// ── SPLASH ENTER ──────────────────────────────────────────────────────────
document.getElementById('enterBtn').addEventListener('click',()=>{
  initAudio();
  document.getElementById('splash').classList.add('hidden');
  setTimeout(()=>document.getElementById('splash').remove(), 900);
  startMediaPipe();
  updateHelp();
  document.getElementById('stripe').style.background=modeColors[mode];
  document.getElementById('stripe').style.boxShadow=`0 0 12px ${modeColors[mode]}`;
});

updateHelp();
</script>
</body>
</html>
