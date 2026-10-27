import React, { useState } from 'react';

const roles = [
  {
    id: 'manager',
    label: 'Manager',
    emoji: '👔',
    desc: 'Full dashboard access, AI insights, pricing control',
    color: '#16A34A',
    email: 'manager@freshflow.ai',
  },
  {
    id: 'staff',
    label: 'Staff',
    emoji: '🧑‍🏭',
    desc: 'Task list, restock alerts, inventory updates',
    color: '#2563EB',
    email: 'staff@freshflow.ai',
  },
  {
    id: 'customer',
    label: 'Customer',
    emoji: '🛒',
    desc: 'Browse flash deals and nearby store offers',
    color: '#7C3AED',
    email: 'customer@freshflow.ai',
  },
];

export default function Login({ onLogin }) {
  const [selectedRole, setSelectedRole] = useState('manager');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const role = roles.find(r => r.id === selectedRole);

  const handleLogin = (e) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => onLogin(selectedRole), 900);
  };

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #0F4C2A 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: 24,
      position: 'relative',
      overflow: 'hidden',
    }}>
      {/* Background decorations */}
      <div style={{
        position: 'absolute', top: -100, right: -100,
        width: 400, height: 400, borderRadius: '50%',
        background: 'radial-gradient(circle, rgba(22,163,74,0.15) 0%, transparent 70%)',
        pointerEvents: 'none',
      }} />
      <div style={{
        position: 'absolute', bottom: -150, left: -100,
        width: 500, height: 500, borderRadius: '50%',
        background: 'radial-gradient(circle, rgba(37,99,235,0.1) 0%, transparent 70%)',
        pointerEvents: 'none',
      }} />

      <div style={{ width: '100%', maxWidth: 460, animation: 'fadeIn 0.5s ease' }}>
        {/* Logo */}
        <div style={{ textAlign: 'center', marginBottom: 36 }}>
          <div style={{
            width: 64, height: 64,
            background: 'linear-gradient(135deg, #16A34A, #22C55E)',
            borderRadius: 18,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 32, margin: '0 auto 16px',
            boxShadow: '0 8px 32px rgba(22,163,74,0.35)',
          }}>🌱</div>
          <h1 style={{ fontSize: 28, fontWeight: 800, color: 'white', letterSpacing: -1 }}>FreshFlow</h1>
          <p style={{ fontSize: 14, color: '#94A3B8', marginTop: 6 }}>Smart Retail Platform · AI-Powered</p>
        </div>

        {/* Login Card */}
        <div style={{
          background: 'rgba(255,255,255,0.04)',
          border: '1px solid rgba(255,255,255,0.08)',
          borderRadius: 24,
          padding: 32,
          backdropFilter: 'blur(20px)',
        }}>
          <h2 style={{ fontSize: 18, fontWeight: 700, color: 'white', marginBottom: 6 }}>Sign In</h2>
          <p style={{ fontSize: 13, color: '#94A3B8', marginBottom: 24 }}>Select your role to continue</p>

          {/* Role Selector */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 24 }}>
            {roles.map(r => (
              <button
                key={r.id}
                onClick={() => setSelectedRole(r.id)}
                style={{
                  display: 'flex', alignItems: 'center', gap: 14,
                  padding: '14px 16px',
                  borderRadius: 14,
                  border: `2px solid ${selectedRole === r.id ? r.color : 'rgba(255,255,255,0.08)'}`,
                  background: selectedRole === r.id ? `${r.color}18` : 'transparent',
                  cursor: 'pointer',
                  transition: 'all 0.2s',
                  textAlign: 'left',
                }}
              >
                <span style={{ fontSize: 24 }}>{r.emoji}</span>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 600, color: 'white' }}>{r.label}</div>
                  <div style={{ fontSize: 12, color: '#64748B', marginTop: 2 }}>{r.desc}</div>
                </div>
                <div style={{
                  width: 18, height: 18, borderRadius: '50%',
                  border: `2px solid ${selectedRole === r.id ? r.color : '#334155'}`,
                  background: selectedRole === r.id ? r.color : 'transparent',
                  transition: 'all 0.2s',
                  flexShrink: 0,
                }} />
              </button>
            ))}
          </div>

          {/* Form */}
          <form onSubmit={handleLogin}>
            <div style={{ marginBottom: 14 }}>
              <label style={{ fontSize: 12, fontWeight: 600, color: '#94A3B8', display: 'block', marginBottom: 6, letterSpacing: 0.5 }}>EMAIL</label>
              <input
                type="email"
                value={role.email}
                readOnly
                style={{
                  width: '100%', padding: '12px 14px',
                  background: 'rgba(255,255,255,0.06)',
                  border: '1px solid rgba(255,255,255,0.1)',
                  borderRadius: 10, color: '#94A3B8',
                  fontSize: 14, fontFamily: 'Inter, sans-serif',
                }}
              />
            </div>
            <div style={{ marginBottom: 24 }}>
              <label style={{ fontSize: 12, fontWeight: 600, color: '#94A3B8', display: 'block', marginBottom: 6, letterSpacing: 0.5 }}>PASSWORD</label>
              <input
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={e => setPassword(e.target.value)}
                style={{
                  width: '100%', padding: '12px 14px',
                  background: 'rgba(255,255,255,0.06)',
                  border: '1px solid rgba(255,255,255,0.12)',
                  borderRadius: 10, color: 'white',
                  fontSize: 14, fontFamily: 'Inter, sans-serif',
                  outline: 'none',
                }}
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              style={{
                width: '100%', padding: '14px',
                background: loading ? '#334155' : `linear-gradient(135deg, ${role.color}, ${role.color}CC)`,
                color: 'white', border: 'none', borderRadius: 12,
                fontSize: 15, fontWeight: 700, cursor: loading ? 'not-allowed' : 'pointer',
                transition: 'all 0.2s',
                fontFamily: 'Inter, sans-serif',
                boxShadow: loading ? 'none' : `0 4px 20px ${role.color}40`,
              }}
            >
              {loading ? 'Signing in...' : `Continue as ${role.label} →`}
            </button>
          </form>
        </div>

        <p style={{ textAlign: 'center', fontSize: 12, color: '#475569', marginTop: 20 }}>
          FreshFlow Retail Platform · Demo Mode · All data is simulated
        </p>
      </div>
    </div>
  );
}
