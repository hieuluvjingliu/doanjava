<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:include page="header.jsp"/>

<style>
:root {
    /* Light Theme */
    --qb-bg: #f8f9fc;
    --qb-surface: #ffffff;
    --qb-text: #1a1a2e;
    --qb-muted: #6b7280;
    --qb-border: #e5e7eb;
    --qb-primary: #d62828;
    --qb-primary-dark: #b71c1c;
    --qb-accent: #6366f1;
    --qb-accent-purple: #8b5cf6;
    --qb-navy: #1a1a2e;
    --qb-navy-light: #2d2d4a;
    --qb-shadow: rgba(26, 26, 46, 0.08);
    --qb-shadow-lg: rgba(26, 26, 46, 0.12);
}

[data-theme="dark"] {
    --qb-bg: #0f0f1a;
    --qb-surface: #1a1a2e;
    --qb-text: #f3f4f6;
    --qb-muted: #9ca3af;
    --qb-border: #2d2d4a;
    --qb-shadow: rgba(0, 0, 0, 0.3);
    --qb-shadow-lg: rgba(0, 0, 0, 0.4);
}

*, *::before, *::after { box-sizing: border-box; }
body {
    font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    color: var(--qb-text);
    margin: 0;
    background: var(--qb-bg);
    transition: background .3s, color .3s;
}

main { overflow: hidden; }

/* ============================================
   HERO SECTION - Glassmorphism + Parallax
============================================ */
.qb-hero {
    position: relative;
    width: 100%;
    min-height: 580px;
    background-image: url('https://images.unsplash.com/photo-1518676590747-1e3dcf5a05e5?w=1920&q=80');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    display: flex;
    align-items: center;
    overflow: hidden;
}
.qb-hero::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, rgba(26,26,46,0.85) 0%, rgba(99,102,241,0.6) 50%, rgba(26,26,46,0.75) 100%);
    z-index: 1;
}
.qb-hero::after {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 30% 50%, rgba(139,92,246,0.15) 0%, transparent 50%);
    z-index: 1;
    animation: heroGlow 8s ease-in-out infinite;
}
@keyframes heroGlow {
    0%, 100% { opacity: 0.5; }
    50% { opacity: 1; }
}
.qb-hero-content {
    position: relative;
    z-index: 2;
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 24px;
    width: 100%;
}
.qb-hero-badge {
    display: inline-block;
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff6b6b 100%);
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    padding: 6px 16px;
    border-radius: 20px;
    margin-bottom: 20px;
    animation: badgePulse 2s ease-in-out infinite;
    box-shadow: 0 4px 15px rgba(214,40,40,0.4);
}
@keyframes badgePulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}
.qb-hero h1 {
    font-size: clamp(36px, 6vw, 64px);
    font-weight: 900;
    color: #fff;
    margin: 0 0 16px;
    line-height: 1.05;
    letter-spacing: 2px;
    text-shadow: 0 4px 20px rgba(0,0,0,0.3);
    animation: fadeUp .8s ease-out;
}
.qb-hero h1 span {
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff8a8a 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
}
.qb-hero-sub {
    font-size: 18px;
    color: rgba(255,255,255,0.9);
    margin: 0 0 32px;
    max-width: 520px;
    line-height: 1.7;
    animation: fadeUp .8s ease-out .1s backwards;
}
.qb-hero-btns {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
    animation: fadeUp .8s ease-out .2s backwards;
}
.qb-btn-hero-primary {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: var(--qb-primary);
    color: #fff;
    font-size: 14px;
    font-weight: 700;
    padding: 14px 32px;
    border-radius: 30px;
    border: none;
    cursor: pointer;
    text-decoration: none;
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    box-shadow: 0 4px 20px rgba(214,40,40,0.4);
}
.qb-btn-hero-primary:hover {
    background: var(--qb-primary-dark);
    transform: translateY(-3px);
    box-shadow: 0 12px 30px rgba(214,40,40,0.5);
    color: #fff;
}
.qb-btn-hero-outline {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(10px);
    color: #fff;
    font-size: 14px;
    font-weight: 700;
    padding: 14px 32px;
    border-radius: 30px;
    border: 1.5px solid rgba(255,255,255,0.3);
    cursor: pointer;
    text-decoration: none;
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
}
.qb-btn-hero-outline:hover {
    background: rgba(255,255,255,0.2);
    border-color: rgba(255,255,255,0.6);
    transform: translateY(-3px);
    color: #fff;
}
.qb-hero-stats {
    display: flex;
    gap: 48px;
    margin-top: 48px;
    padding-top: 32px;
    border-top: 1px solid rgba(255,255,255,0.15);
    animation: fadeUp .8s ease-out .3s backwards;
}
.qb-hero-stat-num {
    font-size: 32px;
    font-weight: 900;
    color: #fff;
    line-height: 1;
}
.qb-hero-stat-num span {
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff8a8a 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.qb-hero-stat-label {
    font-size: 12px;
    color: rgba(255,255,255,0.6);
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-top: 6px;
}

/* ============================================
   FEATURES STRIP - Enhanced Hover
============================================ */
.qb-features {
    background: var(--qb-surface);
    padding: 40px 0;
    border-bottom: 1px solid var(--qb-border);
    transition: background .3s;
}
.qb-features-inner {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 24px;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
}
.qb-feature-item {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 16px 20px;
    border-radius: 16px;
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: default;
}
.qb-feature-item:hover { 
    background: var(--qb-bg);
    transform: translateY(-2px);
    box-shadow: 0 8px 24px var(--qb-shadow);
}
.qb-feature-icon {
    width: 52px;
    height: 52px;
    min-width: 52px;
    border-radius: 14px;
    background: linear-gradient(135deg, rgba(214,40,40,0.1) 0%, rgba(214,40,40,0.05) 100%);
    color: var(--qb-primary);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    transition: all .3s;
}
.qb-feature-item:hover .qb-feature-icon {
    background: var(--qb-primary);
    color: #fff;
    transform: scale(1.1);
}
.qb-feature-title {
    font-size: 14px;
    font-weight: 700;
    color: var(--qb-text);
    line-height: 1.3;
    transition: color .3s;
}
.qb-feature-desc {
    font-size: 12px;
    color: var(--qb-muted);
    margin: 4px 0 0;
    transition: color .3s;
}

/* ============================================
   SECTION TITLE
============================================ */
.qb-section {
    padding: 60px 0;
    background: var(--qb-bg);
    transition: background .3s;
}
.qb-section-title {
    text-align: center;
    margin-bottom: 40px;
    font-size: 28px;
    font-weight: 900;
    color: var(--qb-text);
    letter-spacing: 1px;
    position: relative;
    padding-bottom: 16px;
}
.qb-section-title::after {
    content: '';
    position: absolute;
    bottom: 0; left: 50%;
    transform: translateX(-50%);
    width: 60px; height: 4px;
    background: linear-gradient(90deg, var(--qb-primary) 0%, #ff8a8a 100%);
    border-radius: 2px;
}
.qb-section-title small {
    display: block;
    font-size: 14px;
    font-weight: 500;
    color: var(--qb-muted);
    letter-spacing: 1px;
    margin-top: 8px;
    text-transform: uppercase;
}
.qb-section-inner {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 24px;
}

/* ============================================
   CATEGORY CARDS - Bento Grid + Ken Burns
============================================ */
.qb-categories {
    padding: 60px 0;
    background: var(--qb-bg);
}
.qb-cat-grid {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    grid-template-rows: repeat(2, 200px);
    gap: 20px;
    margin-top: 32px;
}
.qb-cat-card {
    position: relative;
    border-radius: 20px;
    overflow: hidden;
    cursor: pointer;
    text-decoration: none;
    display: block;
    box-shadow: 0 4px 20px var(--qb-shadow);
    transition: all .4s cubic-bezier(0.16, 1, 0.3, 1);
}
.qb-cat-card:hover {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 20px 40px var(--qb-shadow-lg);
}
/* Bento layout: First card spans 2 cols */
.qb-cat-card:first-child {
    grid-column: span 6;
    grid-row: span 2;
}
.qb-cat-card:nth-child(2) { grid-column: span 6; }
.qb-cat-card:nth-child(3) { grid-column: span 6; }
.qb-cat-card:nth-child(4) { grid-column: span 12; }
.qb-cat-card img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .6s cubic-bezier(0.16, 1, 0.3, 1);
}
.qb-cat-card:hover img { transform: scale(1.1); }
.qb-cat-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to top, rgba(26,26,46,0.9) 0%, rgba(26,26,46,0.2) 60%, transparent 100%);
    display: flex;
    align-items: flex-end;
    padding: 24px;
    transition: background .4s;
}
.qb-cat-card:hover .qb-cat-overlay {
    background: linear-gradient(to top, rgba(99,102,241,0.85) 0%, rgba(99,102,241,0.3) 60%, transparent 100%);
}
.qb-cat-name {
    font-size: 18px;
    font-weight: 800;
    color: #fff;
    letter-spacing: 1px;
    text-transform: uppercase;
    transform: translateY(0);
    transition: transform .3s;
}
.qb-cat-card:hover .qb-cat-name { transform: translateY(-4px); }
.qb-cat-count {
    font-size: 13px;
    color: rgba(255,255,255,0.8);
    margin-top: 4px;
}

/* ============================================
   PRODUCT GRID - 4 Col + Spotlight Border
============================================ */
.qb-showcase {
    padding: 60px 0;
    background: var(--qb-surface);
    transition: background .3s;
}
.qb-product-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
    margin-top: 32px;
}
.qb-product-card {
    background: var(--qb-surface);
    border-radius: 20px;
    overflow: hidden;
    transition: all .4s cubic-bezier(0.16, 1, 0.3, 1);
    height: 100%;
    display: flex;
    flex-direction: column;
    border: 2px solid transparent;
    position: relative;
}
.qb-product-card::before {
    content: '';
    position: absolute;
    inset: -2px;
    border-radius: 22px;
    padding: 2px;
    background: linear-gradient(135deg, var(--qb-primary), var(--qb-accent), var(--qb-accent-purple));
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
    opacity: 0;
    transition: opacity .4s;
}
.qb-product-card:hover::before { opacity: 1; }
.qb-product-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 24px 48px var(--qb-shadow-lg);
}
.qb-product-img {
    position: relative;
    width: 100%;
    aspect-ratio: 1 / 1;
    overflow: hidden;
    background: var(--qb-bg);
}
.qb-product-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .5s cubic-bezier(0.16, 1, 0.3, 1);
}
.qb-product-card:hover .qb-product-img img { transform: scale(1.08); }
.qb-product-badge {
    position: absolute;
    top: 12px; left: 12px;
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff6b6b 100%);
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 6px;
    letter-spacing: 0.5px;
    box-shadow: 0 2px 10px rgba(214,40,40,0.4);
}
.qb-product-wishlist {
    position: absolute;
    top: 12px; right: 12px;
    width: 36px; height: 36px;
    border-radius: 50%;
    background: rgba(255,255,255,0.95);
    border: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    color: var(--qb-muted);
    cursor: pointer;
    opacity: 0;
    transform: translateY(-8px);
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.qb-product-card:hover .qb-product-wishlist {
    opacity: 1;
    transform: translateY(0);
}
.qb-product-wishlist:hover { color: var(--qb-primary); }
.qb-product-add-cart {
    position: absolute;
    right: 12px; bottom: 12px;
    width: 42px; height: 42px;
    border-radius: 50%;
    background: var(--qb-primary);
    color: #fff;
    border: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    opacity: 0;
    transform: translateY(8px);
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(214,40,40,0.4);
}
.qb-product-card:hover .qb-product-add-cart {
    opacity: 1;
    transform: translateY(0);
}
.qb-product-add-cart:hover { 
    background: var(--qb-primary-dark);
    transform: scale(1.1);
}
.qb-product-body {
    padding: 16px 18px 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
}
.qb-product-name {
    font-size: 15px;
    font-weight: 600;
    margin: 0 0 10px;
    line-height: 1.4;
    color: var(--qb-text);
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    min-height: 2.8em;
    transition: color .3s;
}
.qb-product-name a { color: inherit; transition: color .3s; }
.qb-product-name a:hover { color: var(--qb-primary); }
.qb-product-price-row {
    display: flex;
    align-items: baseline;
    gap: 8px;
    margin-top: auto;
    flex-wrap: wrap;
}
.qb-product-price {
    font-size: 18px;
    font-weight: 800;
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff6b6b 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.qb-product-price-old {
    font-size: 13px;
    color: var(--qb-muted);
    text-decoration: line-through;
}

/* ============================================
   SALE BANNER - Deep Purple + Shimmer
============================================ */
.qb-sale-banner {
    position: relative;
    width: 100%;
    min-height: 320px;
    background: linear-gradient(135deg, #1a1a2e 0%, #2d2d4a 50%, #1a1a2e 100%);
    background-size: 200% 200%;
    animation: gradientShift 8s ease infinite;
    display: flex;
    align-items: center;
    overflow: hidden;
}
@keyframes gradientShift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}
.qb-sale-banner::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 20% 80%, rgba(139,92,246,0.2) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(214,40,40,0.15) 0%, transparent 50%);
}
.qb-sale-banner::after {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent 40%, rgba(255,255,255,0.03) 50%, transparent 60%);
    animation: shimmer 6s linear infinite;
}
@keyframes shimmer {
    from { transform: translateX(-100%) translateY(-100%); }
    to { transform: translateX(100%) translateY(100%); }
}
.qb-sale-content {
    position: relative;
    z-index: 2;
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 24px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 32px;
}
.qb-sale-text h2 {
    font-size: clamp(32px, 5vw, 48px);
    font-weight: 900;
    color: #fff;
    margin: 0 0 12px;
    letter-spacing: 2px;
}
.qb-sale-text h2 span {
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff8a8a 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.qb-sale-text p {
    font-size: 18px;
    color: rgba(255,255,255,0.9);
    margin: 0 0 20px;
}
.qb-sale-countdown {
    display: flex;
    gap: 16px;
}
.qb-countdown-box {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 12px;
    padding: 12px 18px;
    text-align: center;
    min-width: 72px;
}
.qb-countdown-num {
    font-size: 28px;
    font-weight: 900;
    color: #fff;
    line-height: 1;
}
.qb-countdown-label {
    font-size: 11px;
    color: rgba(255,255,255,0.6);
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-top: 4px;
}
.qb-btn-sale {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: linear-gradient(135deg, var(--qb-primary) 0%, #ff6b6b 100%);
    color: #fff;
    font-size: 15px;
    font-weight: 800;
    padding: 16px 36px;
    border-radius: 30px;
    border: none;
    cursor: pointer;
    text-decoration: none;
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    box-shadow: 0 8px 24px rgba(214,40,40,0.4);
    white-space: nowrap;
}
.qb-btn-sale:hover {
    transform: translateY(-3px);
    box-shadow: 0 16px 36px rgba(214,40,40,0.5);
    color: #fff;
}

/* ============================================
   NEWSLETTER - Glassmorphism Card
============================================ */
.qb-newsletter {
    padding: 80px 0;
    background: var(--qb-bg);
}
.qb-newsletter-inner {
    max-width: 640px;
    margin: 0 auto;
    padding: 0 24px;
    text-align: center;
}
.qb-newsletter-card {
    background: var(--qb-surface);
    border-radius: 24px;
    padding: 48px 40px;
    box-shadow: 0 20px 60px var(--qb-shadow-lg);
    border: 1px solid var(--qb-border);
    position: relative;
    overflow: hidden;
}
.qb-newsletter-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--qb-primary), var(--qb-accent), var(--qb-accent-purple));
}
.qb-newsletter-icon {
    font-size: 52px;
    background: linear-gradient(135deg, var(--qb-primary) 0%, var(--qb-accent-purple) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 16px;
}
.qb-newsletter h2 {
    font-size: 26px;
    font-weight: 900;
    color: var(--qb-text);
    margin: 0 0 10px;
}
.qb-newsletter p {
    font-size: 15px;
    color: var(--qb-muted);
    margin: 0 0 28px;
}
.qb-newsletter-form {
    display: flex;
    gap: 12px;
    max-width: 480px;
    margin: 0 auto;
}
.qb-newsletter-form input {
    flex: 1;
    padding: 14px 20px;
    border: 2px solid var(--qb-border);
    border-radius: 12px;
    font-size: 14px;
    outline: none;
    background: var(--qb-bg);
    color: var(--qb-text);
    transition: all .3s;
}
.qb-newsletter-form input::placeholder { color: var(--qb-muted); }
.qb-newsletter-form input:focus {
    border-color: var(--qb-primary);
    box-shadow: 0 0 0 4px rgba(214,40,40,0.1);
}
.qb-newsletter-form button {
    padding: 14px 28px;
    background: var(--qb-primary);
    color: #fff;
    font-size: 14px;
    font-weight: 700;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    white-space: nowrap;
    transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
}
.qb-newsletter-form button:hover {
    background: var(--qb-primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(214,40,40,0.3);
}

/* ============================================
   EMPTY STATE
============================================ */
.qb-empty {
    text-align: center;
    padding: 60px 0;
    color: var(--qb-muted);
}
.qb-empty .bi {
    font-size: 48px;
    margin-bottom: 12px;
    opacity: 0.4;
}

/* ============================================
   RESPONSIVE
============================================ */
@media (max-width: 1200px) {
    .qb-product-grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 992px) {
    .qb-hero h1 { font-size: 42px; }
    .qb-features-inner { grid-template-columns: repeat(2, 1fr); }
    .qb-cat-grid { grid-template-columns: repeat(2, 1fr); grid-template-rows: auto; }
    .qb-cat-card:first-child,
    .qb-cat-card:nth-child(2),
    .qb-cat-card:nth-child(3),
    .qb-cat-card:nth-child(4) {
        grid-column: span 1;
        grid-row: span 1;
    }
    .qb-cat-card:first-child { grid-column: span 2; }
    .qb-product-grid { grid-template-columns: repeat(2, 1fr); }
    .qb-hero-stats { gap: 28px; }
}
@media (max-width: 768px) {
    .qb-hero { min-height: 480px; background-attachment: scroll; }
    .qb-hero h1 { font-size: 32px; }
    .qb-hero-sub { font-size: 15px; }
    .qb-hero-stats { flex-wrap: wrap; gap: 20px; }
    .qb-cat-grid { grid-template-columns: 1fr; }
    .qb-cat-card:first-child { grid-column: span 1; grid-row: span 1; }
    .qb-product-grid { grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .qb-sale-content { flex-direction: column; align-items: flex-start; }
    .qb-newsletter-form { flex-direction: column; }
    .qb-newsletter-card { padding: 36px 24px; }
    .qb-sale-countdown { flex-wrap: wrap; }
}
@media (max-width: 480px) {
    .qb-features-inner { grid-template-columns: 1fr; }
    .qb-product-grid { grid-template-columns: 1fr; }
    .qb-hero { min-height: 420px; }
    .qb-btn-hero-primary, .qb-btn-hero-outline { width: 100%; justify-content: center; }
}
</style>

<main>

    <!-- ========== HERO BANNER ========== -->
    <section class="qb-hero">
        <div class="qb-hero-content">
            <div class="qb-hero-badge">Hot 2026</div>
            <h1>QUÝ BỬU <span>STORE</span></h1>
            <p class="qb-hero-sub">Chuyên đồ Cosplay & Anime chính hãng. Hàng nhập khẩu, chất lượng cao, giao hàng toàn quốc.</p>
            <div class="qb-hero-btns">
                <a href="#section_products" class="qb-btn-hero-primary">
                    <i class="bi bi-bag"></i> Xem Sản Phẩm
                </a>
                <a href="#section_categories" class="qb-btn-hero-outline">
                    <i class="bi bi-compass"></i> Khám Phá Ngay
                </a>
            </div>
            <div class="qb-hero-stats">
                <div>
                    <div class="qb-hero-stat-num">50<span>+</span></div>
                    <div class="qb-hero-stat-label">Sản phẩm</div>
                </div>
                <div>
                    <div class="qb-hero-stat-num">5K<span>+</span></div>
                    <div class="qb-hero-stat-label">Khách hàng</div>
                </div>
                <div>
                    <div class="qb-hero-stat-num">4.9<span>/5</span></div>
                    <div class="qb-hero-stat-label">Đánh giá</div>
                </div>
            </div>
        </div>
    </section>

    <!-- ========== FEATURES STRIP ========== -->
    <section class="qb-features">
        <div class="qb-features-inner">
            <div class="qb-feature-item">
                <div class="qb-feature-icon"><i class="bi bi-bag-check"></i></div>
                <div>
                    <div class="qb-feature-title">50+ Sản Phẩm</div>
                    <div class="qb-feature-desc">Đa dạng Cosplay & Anime</div>
                </div>
            </div>
            <div class="qb-feature-item">
                <div class="qb-feature-icon"><i class="bi bi-patch-check"></i></div>
                <div>
                    <div class="qb-feature-title">Chính Hãng 100%</div>
                    <div class="qb-feature-desc">Cam kết authentic</div>
                </div>
            </div>
            <div class="qb-feature-item">
                <div class="qb-feature-icon"><i class="bi bi-truck"></i></div>
                <div>
                    <div class="qb-feature-title">Giao Hàng Toàn Quốc</div>
                    <div class="qb-feature-desc">Miễn phí từ 500.000₫</div>
                </div>
            </div>
            <div class="qb-feature-item">
                <div class="qb-feature-icon"><i class="bi bi-arrow-repeat"></i></div>
                <div>
                    <div class="qb-feature-title">Đổi Trả 7 Ngày</div>
                    <div class="qb-feature-desc">Không phí nếu lỗi</div>
                </div>
            </div>
        </div>
    </section>

    <!-- ========== CATEGORIES ========== -->
    <section class="qb-categories" id="section_categories">
        <div class="qb-section-inner">
            <h2 class="qb-section-title">
                DANH MỤC NỔI BẬT
                <small>Khám phá bộ sưu tập của chúng tôi</small>
            </h2>
            <div class="qb-cat-grid">
                <c:if test="${not empty listDanhMuc}">
                    <c:forEach var="dm" items="${listDanhMuc}" begin="0" end="3" varStatus="catStatus">
                        <a href="${ctx}/trang-chu?category=${dm.id}" class="qb-cat-card">
                            <img src="https://picsum.photos/seed/${dm.name}/800/600" alt="${dm.name}">
                            <div class="qb-cat-overlay">
                                <div>
                                    <div class="qb-cat-name">${dm.name}</div>
                                    <div class="qb-cat-count">Xem chi tiết &rarr;</div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:if>
                <c:if test="${empty listDanhMuc}">
                    <a href="${ctx}/trang-chu" class="qb-cat-card">
                        <img src="https://picsum.photos/seed/ao-thun-anime/800/600" alt="Áo Thun">
                        <div class="qb-cat-overlay">
                            <div><div class="qb-cat-name">Áo Thun Anime</div><div class="qb-cat-count">Xem chi tiết &rarr;</div></div>
                        </div>
                    </a>
                    <a href="${ctx}/trang-chu" class="qb-cat-card">
                        <img src="https://picsum.photos/seed/ao-hoodie/800/600" alt="Áo Hoodie">
                        <div class="qb-cat-overlay">
                            <div><div class="qb-cat-name">Áo Hoodie</div><div class="qb-cat-count">Xem chi tiết &rarr;</div></div>
                        </div>
                    </a>
                    <a href="${ctx}/trang-chu" class="qb-cat-card">
                        <img src="https://picsum.photos/seed/phu-kien-cosplay/800/600" alt="Phụ Kiện">
                        <div class="qb-cat-overlay">
                            <div><div class="qb-cat-name">Phụ Kiện Cosplay</div><div class="qb-cat-count">Xem chi tiết &rarr;</div></div>
                        </div>
                    </a>
                    <a href="${ctx}/trang-chu" class="qb-cat-card">
                        <img src="https://picsum.photos/seed/bo-cosplay/1200/400" alt="Bộ Cosplay">
                        <div class="qb-cat-overlay">
                            <div><div class="qb-cat-name">Bộ Cosplay</div><div class="qb-cat-count">Xem chi tiết &rarr;</div></div>
                        </div>
                    </a>
                </c:if>
            </div>
        </div>
    </section>

    <!-- ========== PRODUCT SHOWCASE GRID ========== -->
    <section class="qb-showcase" id="section_products">
        <div class="qb-section-inner">
            <h2 class="qb-section-title">
                SẢN PHẨM NỔI BẬT
                <small>Tủ chọn lọc các sản phẩm tốt nhất</small>
            </h2>

            <div class="qb-product-grid">
                <c:choose>
                    <c:when test="${not empty listNewProducts}">
                        <c:forEach var="sp" items="${listNewProducts}" varStatus="status">
                            <c:if test="${status.index < 4}">
                                <div class="qb-product-card">
                                    <div class="qb-product-img">
                                        <a href="${ctx}/chi-tiet?id=${sp.id}" title="${sp.name}">
                                            <img src="<my:safeImage value='${sp.image}' width='400' height='400'/>" alt="${sp.name}" loading="lazy">
                                        </a>
                                        <c:if test="${status.index < 2}">
                                            <span class="qb-product-badge">HOT</span>
                                        </c:if>
                                        <button type="button" class="qb-product-wishlist" title="Yêu thích">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                        <form action="${ctx}/gio-hang" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${sp.id}">
                                            <input type="hidden" name="productName" value="${sp.name}">
                                            <input type="hidden" name="productImage" value="<my:safeImage value='${sp.image}' width='400' height='400'/>">
                                            <input type="hidden" name="price" value="${sp.basePrice}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="qb-product-add-cart" title="Thêm vào giỏ hàng" aria-label="Thêm vào giỏ hàng">
                                                <i class="bi bi-bag-plus"></i>
                                            </button>
                                        </form>
                                    </div>
                                    <div class="qb-product-body">
                                        <h3 class="qb-product-name">
                                            <a href="${ctx}/chi-tiet?id=${sp.id}" title="${sp.name}">${sp.name}</a>
                                        </h3>
                                        <div class="qb-product-price-row">
                                            <span class="qb-product-price"><fmt:formatNumber value="${sp.basePrice}" pattern="#,###"/>₫</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="i" begin="1" end="4">
                            <div class="qb-product-card">
                                <div class="qb-product-img">
                                    <img src="https://picsum.photos/seed/cosplay-product-${i}/400/400" alt="Sản phẩm ${i}">
                                    <button type="button" class="qb-product-wishlist" title="Yêu thích">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                    <form action="${ctx}/gio-hang" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="add">
                                        <button type="submit" class="qb-product-add-cart" title="Thêm vào giỏ hàng">
                                            <i class="bi bi-bag-plus"></i>
                                        </button>
                                    </form>
                                </div>
                                <div class="qb-product-body">
                                    <h3 class="qb-product-name">Sản Phẩm Cosplay ${i}</h3>
                                    <div class="qb-product-price-row">
                                        <span class="qb-product-price">299.000₫</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- ========== SALE BANNER ========== -->
    <section class="qb-sale-banner">
        <div class="qb-sale-content">
            <div class="qb-sale-text">
                <h2>KHUYẾN MÃI <span>SỐC</span></h2>
                <p>Giảm 20% cho đơn hàng từ 500.000₫</p>
                <div class="qb-sale-countdown">
                    <div class="qb-countdown-box">
                        <div class="qb-countdown-num">07</div>
                        <div class="qb-countdown-label">Ngày</div>
                    </div>
                    <div class="qb-countdown-box">
                        <div class="qb-countdown-num">12</div>
                        <div class="qb-countdown-label">Giờ</div>
                    </div>
                    <div class="qb-countdown-box">
                        <div class="qb-countdown-num">45</div>
                        <div class="qb-countdown-label">Phút</div>
                    </div>
                </div>
            </div>
            <a href="#section_products" class="qb-btn-sale">
                <i class="bi bi-lightning-charge-fill"></i> Mua Ngay
            </a>
        </div>
    </section>

    <!-- ========== NEWSLETTER ========== -->
    <section class="qb-newsletter">
        <div class="qb-newsletter-inner">
            <div class="qb-newsletter-card">
                <div class="qb-newsletter-icon"><i class="bi bi-envelope-heart"></i></div>
                <h2>Đăng Ký Nhận Ưu Đãi</h2>
                <p>Nhận e-mail về những chương trình khuyến mãi đặc biệt mới nhất!</p>
                <form class="qb-newsletter-form" action="#" method="post">
                    <input type="email" name="email" placeholder="Nhập email của bạn..." required>
                    <button type="submit"><i class="bi bi-send"></i> Đăng Ký</button>
                </form>
            </div>
        </div>
    </section>

</main>

<jsp:include page="footer.jsp"/>
