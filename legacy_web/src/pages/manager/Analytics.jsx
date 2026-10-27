import React, { useState } from 'react';
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Legend
} from 'recharts';
import {
  TrendingDown, TrendingUp, DollarSign, Award, ShieldCheck,
  Download, Filter, Leaf, Sparkles, AlertCircle
} from 'lucide-react';
import TopBar from '../../components/TopBar';
import { KPI, MONTHLY_IMPACT } from '../../data/mockData';

export default function Analytics() {
  const [period, setPeriod] = useState('monthly');

  const beforeAfterData = [
    { period: 'Before FreshFlow', waste: 42.0, color: '#EF4444' },
    { period: 'After FreshFlow', waste: 18.4, color: '#16A34A' },
  ];

  return (
    <div>
      <TopBar title="Business Impact & Waste Reduction" subtitle="Quantifiable ESG & bottom-line financial metrics" />
      <div className="page-container">

        {/* Top Pitch Metric Cards */}
        <div className="grid-2" style={{ marginBottom: 20 }}>
          
          {/* Card 1: Food Saved */}
          <div className="card" style={{
            background: 'linear-gradient(135deg, #15803D 0%, #16A34A 100%)',
            color: 'white', padding: '24px 28px', border: 'none'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div>
                <span style={{ fontSize: 12, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 700, opacity: 0.9 }}>
                  🥦 Food Saved Today
                </span>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 12, marginTop: 8 }}>
                  <span style={{ fontSize: 44, fontWeight: 900 }}>18.4</span>
                  <span style={{ fontSize: 20, fontWeight: 600 }}>kg avoided</span>
                </div>
                <div style={{ fontSize: 16, fontWeight: 600, opacity: 0.95, marginTop: 4 }}>
                  86 individual items rescued from landfill
                </div>
              </div>
              <div style={{
                background: 'rgba(255,255,255,0.2)', width: 54, height: 54,
                borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 28
              }}>🌱</div>
            </div>

            <div style={{
              marginTop: 18, paddingTop: 14, borderTop: '1px solid rgba(255,255,255,0.2)',
              display: 'flex', justifyContent: 'space-between', fontSize: 13
            }}>
              <span>↓ 56.2% Reduction vs Baseline</span>
              <span>~46.0 kg CO₂e Offset</span>
            </div>
          </div>

          {/* Card 2: Revenue Saved */}
          <div className="card" style={{
            background: 'linear-gradient(135deg, #1E40AF 0%, #2563EB 100%)',
            color: 'white', padding: '24px 28px', border: 'none'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div>
                <span style={{ fontSize: 12, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 700, opacity: 0.9 }}>
                  💰 Recovered Revenue Today
                </span>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 12, marginTop: 8 }}>
                  <span style={{ fontSize: 44, fontWeight: 900 }}>฿12,450</span>
                </div>
                <div style={{ fontSize: 16, fontWeight: 600, opacity: 0.95, marginTop: 4 }}>
                  Salvaged from near-expiry clearance items
                </div>
              </div>
              <div style={{
                background: 'rgba(255,255,255,0.2)', width: 54, height: 54,
                borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 28
              }}>💵</div>
            </div>

            <div style={{
              marginTop: 18, paddingTop: 14, borderTop: '1px solid rgba(255,255,255,0.2)',
              display: 'flex', justifyContent: 'space-between', fontSize: 13
            }}>
              <span>+18.4% vs Previous Month Average</span>
              <span>100% Margin Retention Above Cost</span>
            </div>
          </div>

        </div>

        {/* Secondary Impact Badges */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 14, marginBottom: 24 }}>
          <div className="card" style={{ padding: '16px 18px', textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>Stockouts Prevented</div>
            <div style={{ fontSize: 24, fontWeight: 800, color: '#16A34A', marginTop: 4 }}>17 Items</div>
            <div style={{ fontSize: 11, color: '#94A3B8' }}>Via Restock AI Alerts</div>
          </div>
          <div className="card" style={{ padding: '16px 18px', textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>AI Price Adjustments</div>
            <div style={{ fontSize: 24, fontWeight: 800, color: '#2563EB', marginTop: 4 }}>142 Decisions</div>
            <div style={{ fontSize: 11, color: '#94A3B8' }}>Zero Manual Effort</div>
          </div>
          <div className="card" style={{ padding: '16px 18px', textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>Customer Engagement</div>
            <div style={{ fontSize: 24, fontWeight: 800, color: '#7C3AED', marginTop: 4 }}>420 Claims</div>
            <div style={{ fontSize: 11, color: '#94A3B8' }}>In Deal Feed App</div>
          </div>
          <div className="card" style={{ padding: '16px 18px', textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>ESG Score Rating</div>
            <div style={{ fontSize: 24, fontWeight: 800, color: '#F59E0B', marginTop: 4 }}>A+ Grade</div>
            <div style={{ fontSize: 11, color: '#94A3B8' }}>Top 5% Retail Benchmark</div>
          </div>
        </div>

        {/* Charts Row: Before/After Waste Comparison + Revenue Recovered Trend */}
        <div className="grid-2" style={{ marginBottom: 24 }}>
          
          {/* Before vs After Waste Comparison */}
          <div className="card">
            <div className="card-header">
              <div>
                <span className="card-title">📉 Daily Food Waste: Before vs After</span>
                <p style={{ fontSize: 12, color: '#64748B', margin: '2px 0 0 0' }}>
                  Comparing baseline waste before FreshFlow adoption
                </p>
              </div>
              <span className="badge badge-critical">-56% Waste</span>
            </div>
            <div className="card-body">
              <ResponsiveContainer width="100%" height={260}>
                <BarChart data={beforeAfterData} margin={{ top: 20, right: 20, left: -10, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
                  <XAxis dataKey="period" tick={{ fontSize: 13, fontWeight: 600, fill: '#334155' }} />
                  <YAxis unit=" kg" tick={{ fontSize: 12, fill: '#64748B' }} />
                  <Tooltip
                    formatter={(val) => [`${val} kg / day`, 'Daily Waste']}
                    contentStyle={{ borderRadius: 10, border: '1px solid #E2E8F0' }}
                  />
                  <Bar dataKey="waste" fill="#16A34A" radius={[8, 8, 0, 0]} barSize={64} />
                </BarChart>
              </ResponsiveContainer>

              <div style={{
                marginTop: 16, padding: '14px', background: '#F8FAFC',
                borderRadius: 10, border: '1px solid #E2E8F0', display: 'flex', alignItems: 'center', gap: 12
              }}>
                <Leaf size={24} color="#16A34A" />
                <div style={{ fontSize: 12, color: '#475569' }}>
                  <strong>Real-world Proof:</strong> Waste plummeted from <strong>42 kg/day</strong> down to <strong>18.4 kg/day</strong> within 30 days of dynamic pricing activations.
                </div>
              </div>
            </div>
          </div>

          {/* Revenue Recovered Monthly Trend */}
          <div className="card">
            <div className="card-header">
              <div>
                <span className="card-title">📈 Monthly Recovered Revenue</span>
                <p style={{ fontSize: 12, color: '#64748B', margin: '2px 0 0 0' }}>
                  Cumulative revenue rescued through AI flash deals
                </p>
              </div>
              <span className="badge badge-normal">+51% 4-Mo Growth</span>
            </div>
            <div className="card-body">
              <ResponsiveContainer width="100%" height={260}>
                <BarChart data={MONTHLY_IMPACT} margin={{ top: 20, right: 20, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
                  <XAxis dataKey="month" tick={{ fontSize: 13, fontWeight: 600, fill: '#334155' }} />
                  <YAxis unit="฿" tick={{ fontSize: 12, fill: '#64748B' }} />
                  <Tooltip
                    formatter={(val) => [`฿${val.toLocaleString()}`, 'Recovered Revenue']}
                    contentStyle={{ borderRadius: 10, border: '1px solid #E2E8F0' }}
                  />
                  <Bar dataKey="revenue" fill="#2563EB" radius={[8, 8, 0, 0]} barSize={48} />
                </BarChart>
              </ResponsiveContainer>

              <div style={{
                marginTop: 16, padding: '14px', background: '#EFF6FF',
                borderRadius: 10, border: '1px solid #BFDBFE', display: 'flex', alignItems: 'center', gap: 12
              }}>
                <DollarSign size={24} color="#2563EB" />
                <div style={{ fontSize: 12, color: '#1E3A8A' }}>
                  <strong>Direct Financial ROI:</strong> By April, recovered revenue reached <strong>฿12,450</strong>, generating positive net operating profit from previously unsellable goods.
                </div>
              </div>
            </div>
          </div>

        </div>

      </div>
    </div>
  );
}
