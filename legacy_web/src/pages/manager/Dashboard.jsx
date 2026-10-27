import React, { useState, useEffect, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  LineChart, Line, AreaChart, Area,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend
} from 'recharts';
import {
  TrendingDown, TrendingUp, AlertTriangle, ShoppingBag,
  DollarSign, ChevronRight, Map, ArrowUp, ArrowDown
} from 'lucide-react';
import TopBar from '../../components/TopBar';
import { AppContext } from '../../App';
import { KPI, AISLES, ALERTS, SALES_WASTE_CHART, TRAFFIC_FORECAST, PRODUCTS } from '../../data/mockData';

const aisleColors = {
  normal: '#16A34A', low: '#EAB308',
  expiring: '#F59E0B', critical: '#EF4444', promo: '#7C3AED'
};
const aisleEmoji = { normal: '🟢', low: '🟡', expiring: '🟠', critical: '🔴', promo: '🟣' };

function KpiCard({ icon: Icon, title, value, change, colorClass, iconBg, delay }) {
  const isPos = change > 0;
  const isNeg = change < 0;
  return (
    <div className={`kpi-card animate-in animate-delay-${delay}`}>
      <div className="kpi-card-top">
        <div className="kpi-icon" style={{ background: iconBg }}>{Icon}</div>
        <span className={`kpi-change ${isPos ? 'positive' : isNeg ? 'negative' : 'neutral'}`}>
          {isPos ? <ArrowUp size={10} /> : isNeg ? <ArrowDown size={10} /> : null}
          {Math.abs(change)}%
        </span>
      </div>
      <div className="kpi-value">{value}</div>
      <div className="kpi-label">{title}</div>
    </div>
  );
}

function MiniFloorplan() {
  const navigate = useNavigate();
  const { aisles: globalAisles } = useContext(AppContext);
  const aisleList = globalAisles || AISLES;

  return (
    <div className="card" style={{ height: '100%' }}>
      <div className="card-header">
        <span className="card-title">🗺️ Live Store Floorplan</span>
        <button className="btn btn-ghost btn-sm" onClick={() => navigate('/store-map')}
          style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          Full Map <ChevronRight size={14} />
        </button>
      </div>
      <div className="card-body">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 12 }}>
          {aisleList.slice(0, 6).map(aisle => (
            <div key={aisle.id} onClick={() => navigate('/store-map')}
              style={{
                padding: '12px 10px', borderRadius: 10, cursor: 'pointer',
                border: `1.5px solid ${aisleColors[aisle.status]}30`,
                background: `${aisleColors[aisle.status]}08`,
                transition: 'all 0.15s',
                textAlign: 'center',
              }}
              onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.03)'}
              onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
            >
              <div style={{ fontSize: 18 }}>{aisleEmoji[aisle.status]}</div>
              <div style={{ fontSize: 11, fontWeight: 600, color: '#0F172A', marginTop: 4 }}>{aisle.id}</div>
              <div style={{ fontSize: 10, color: '#94A3B8' }}>{aisle.label}</div>
            </div>
          ))}
        </div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {Object.entries(aisleEmoji).map(([status, emoji]) => (
            <span key={status} style={{ fontSize: 11, color: '#64748B', display: 'flex', alignItems: 'center', gap: 3 }}>
              {emoji} {status.charAt(0).toUpperCase() + status.slice(1)}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

function AlertsPanel() {
  const navigate = useNavigate();
  const { alerts: globalAlerts } = useContext(AppContext);
  const alertList = globalAlerts || ALERTS;
  const open = alertList.filter(a => a.status !== 'resolved');

  const alertStyle = { critical: { bg: '#FEF2F2', border: '#FCA5A5', dot: '#EF4444', emoji: '🔴' },
    warning: { bg: '#FFFBEB', border: '#FCD34D', dot: '#F59E0B', emoji: '🟠' },
    success: { bg: '#F0FDF4', border: '#86EFAC', dot: '#16A34A', emoji: '🟢' },
    ai: { bg: '#EFF6FF', border: '#93C5FD', dot: '#2563EB', emoji: '🤖' } };

  return (
    <div className="card" style={{ height: '100%' }}>
      <div className="card-header">
        <span className="card-title">🚨 Urgent Alerts</span>
        <button className="btn btn-ghost btn-sm" onClick={() => navigate('/restock')}
          style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          View All <ChevronRight size={14} />
        </button>
      </div>
      <div className="card-body" style={{ padding: '12px 16px 16px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {open.slice(0, 4).map(alert => {
            const s = alertStyle[alert.type] || alertStyle.warning;
            return (
              <div key={alert.id} style={{
                padding: '12px 14px', borderRadius: 10,
                background: s.bg, border: `1px solid ${s.border}`,
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 3 }}>
                  <span>{s.emoji}</span>
                  <span style={{ fontSize: 13, fontWeight: 600, color: '#0F172A' }}>{alert.message}</span>
                </div>
                <p style={{ fontSize: 12, color: '#64748B', paddingLeft: 20 }}>{alert.detail}</p>
                <p style={{ fontSize: 11, color: '#94A3B8', marginTop: 4, paddingLeft: 20 }}>{alert.time}</p>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    return (
      <div className="custom-tooltip">
        <div className="label">{label}</div>
        {payload.map(p => (
          <div key={p.name} style={{ color: p.color, fontSize: 12 }}>
            {p.name}: {p.name === 'sales' ? `฿${(p.value/1000).toFixed(0)}k` : `${(p.value/1000).toFixed(1)}kg`}
          </div>
        ))}
      </div>
    );
  }
  return null;
};

export default function Dashboard() {
  const now = new Date();
  const hour = now.getHours();
  const greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';

  return (
    <div>
      <TopBar title="Manager Dashboard" subtitle={`${greeting}, Somchai 👋 · Store #001`} />
      <div className="page-container">

        {/* KPI Grid */}
        <div className="kpi-grid">
          <KpiCard delay={1} icon="🗑️" title="Food Waste Today" value="18.4 kg"
            change={KPI.wasteChange} iconBg="#FEF2F2" />
          <KpiCard delay={2} icon="💰" title="Revenue Saved" value="฿12,450"
            change={KPI.savedRevenueChange} iconBg="#F0FDF4" />
          <KpiCard delay={3} icon="📦" title="Out of Stock" value={`${KPI.outOfStock} Items`}
            change={-5} iconBg="#FFF7ED" />
          <KpiCard delay={4} icon="🏷️" title="Discounted Sold" value={`${KPI.discountedItemsSold} Items`}
            change={12} iconBg="#EFF6FF" />
          <KpiCard delay={5} icon="💵" title="Today's Revenue" value="฿284,520"
            change={KPI.todayRevenueChange} iconBg="#F5F3FF" />
        </div>

        {/* Mid Row — Floorplan + Alerts */}
        <div className="grid-2" style={{ marginBottom: 20, alignItems: 'start' }}>
          <MiniFloorplan />
          <AlertsPanel />
        </div>

        {/* Bottom Row — Charts */}
        <div className="grid-2">
          {/* Sales & Waste Chart */}
          <div className="card animate-in animate-delay-3">
            <div className="card-header">
              <span className="card-title">📈 Sales & Waste (This Week)</span>
            </div>
            <div className="card-body">
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={SALES_WASTE_CHART} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
                  <XAxis dataKey="day" tick={{ fontSize: 12, fill: '#94A3B8' }} axisLine={false} tickLine={false} />
                  <YAxis hide />
                  <Tooltip content={<CustomTooltip />} />
                  <Line type="monotone" dataKey="sales" stroke="#16A34A" strokeWidth={2.5}
                    dot={{ r: 3, fill: '#16A34A' }} name="sales" />
                  <Line type="monotone" dataKey="waste" stroke="#EF4444" strokeWidth={2}
                    dot={{ r: 3, fill: '#EF4444' }} strokeDasharray="4 2" name="waste" />
                </LineChart>
              </ResponsiveContainer>
              <div style={{ display: 'flex', gap: 16, marginTop: 8 }}>
                <span style={{ fontSize: 12, color: '#16A34A', display: 'flex', alignItems: 'center', gap: 4 }}>
                  <span style={{ width: 12, height: 2, background: '#16A34A', borderRadius: 1, display: 'inline-block' }} />
                  Sales
                </span>
                <span style={{ fontSize: 12, color: '#EF4444', display: 'flex', alignItems: 'center', gap: 4 }}>
                  <span style={{ width: 12, height: 2, background: '#EF4444', borderRadius: 1, display: 'inline-block' }} />
                  Waste (kg × 100)
                </span>
              </div>
            </div>
          </div>

          {/* AI Traffic Forecast */}
          <div className="card animate-in animate-delay-4">
            <div className="card-header">
              <span className="card-title">🤖 AI Foot Traffic Forecast</span>
              <span className="badge badge-ai">Live</span>
            </div>
            <div className="card-body">
              <ResponsiveContainer width="100%" height={220}>
                <AreaChart data={TRAFFIC_FORECAST} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="predGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#2563EB" stopOpacity={0.15} />
                      <stop offset="95%" stopColor="#2563EB" stopOpacity={0} />
                    </linearGradient>
                    <linearGradient id="actGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#16A34A" stopOpacity={0.15} />
                      <stop offset="95%" stopColor="#16A34A" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
                  <XAxis dataKey="hour" tick={{ fontSize: 11, fill: '#94A3B8' }} axisLine={false} tickLine={false} />
                  <YAxis hide />
                  <Tooltip formatter={(v) => `${v}%`} contentStyle={{ fontFamily: 'Inter', fontSize: 12 }} />
                  <Area type="monotone" dataKey="predicted" stroke="#2563EB" strokeWidth={2}
                    fill="url(#predGrad)" name="Predicted %" />
                  <Area type="monotone" dataKey="actual" stroke="#16A34A" strokeWidth={2}
                    fill="url(#actGrad)" name="Actual %" />
                </AreaChart>
              </ResponsiveContainer>
              <div style={{ display: 'flex', gap: 16, marginTop: 8 }}>
                <span style={{ fontSize: 12, color: '#2563EB', display: 'flex', alignItems: 'center', gap: 4 }}>
                  <span style={{ width: 12, height: 2, background: '#2563EB', borderRadius: 1, display: 'inline-block' }} />
                  AI Predicted
                </span>
                <span style={{ fontSize: 12, color: '#16A34A', display: 'flex', alignItems: 'center', gap: 4 }}>
                  <span style={{ width: 12, height: 2, background: '#16A34A', borderRadius: 1, display: 'inline-block' }} />
                  Actual
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
