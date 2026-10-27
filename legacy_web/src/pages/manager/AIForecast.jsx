import React, { useState } from 'react';
import {
  AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Legend
} from 'recharts';
import {
  BrainCircuit, Sparkles, CloudRain, Clock, Calendar,
  DollarSign, BarChart2, CheckCircle, ArrowRight, Info
} from 'lucide-react';
import TopBar from '../../components/TopBar';
import { TRAFFIC_FORECAST } from '../../data/mockData';

export default function AIForecast() {
  const [selectedHour, setSelectedHour] = useState('18:00');
  const [weatherCondition, setWeatherCondition] = useState('Heavy Rain');
  const [isPayday, setIsPayday] = useState(true);

  // Hourly traffic details
  const hourlyData = [
    { hour: '12:00', customers: 45, confidence: 92, status: 'Completed' },
    { hour: '14:00', customers: 72, confidence: 90, status: 'Completed' },
    { hour: '16:00', customers: 85, confidence: 94, status: 'Completed' },
    { hour: '18:00', customers: 54, confidence: 87, status: 'Current Forecast' },
    { hour: '20:00', customers: 38, confidence: 83, status: 'Upcoming' },
    { hour: '22:00', customers: 22, confidence: 80, status: 'Upcoming' },
  ];

  return (
    <div>
      <TopBar title="AI Prediction Engine" subtitle="Multi-parameter forecasting models for foot traffic & dynamic liquidation" />
      <div className="page-container">

        {/* Top Summary Banner */}
        <div className="card" style={{
          background: 'linear-gradient(135deg, #1E3A8A 0%, #2563EB 100%)',
          color: 'white', marginBottom: 20, border: 'none', padding: '24px 28px'
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 16 }}>
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
                <BrainCircuit size={22} color="#93C5FD" />
                <span style={{ fontSize: 13, textTransform: 'uppercase', letterSpacing: 1, fontWeight: 700, color: '#BFDBFE' }}>
                  Two-Stage Autonomous Decision Architecture
                </span>
              </div>
              <h2 style={{ fontSize: 22, fontWeight: 800, margin: '0 0 6px 0' }}>
                How FreshFlow AI Powers Demand & Waste Reduction
              </h2>
              <p style={{ fontSize: 13, color: '#DBEAFE', margin: 0, maxWidth: 650 }}>
                Combining external environmental factors with internal shelf telemetry to predict customer velocity and optimize real-time inventory clearing.
              </p>
            </div>
            <div style={{
              background: 'rgba(255, 255, 255, 0.12)', backdropFilter: 'blur(8px)',
              borderRadius: 12, padding: '12px 20px', textAlign: 'center', border: '1px solid rgba(255,255,255,0.2)'
            }}>
              <div style={{ fontSize: 11, color: '#BFDBFE', textTransform: 'uppercase', fontWeight: 600 }}>System Confidence</div>
              <div style={{ fontSize: 32, fontWeight: 900, color: '#FFFFFF' }}>87%</div>
              <div style={{ fontSize: 11, color: '#86EFAC' }}>● High Reliability</div>
            </div>
          </div>
        </div>

        {/* Main Grid: Forecast Chart + Prediction Inputs */}
        <div className="grid-2" style={{ alignItems: 'start', marginBottom: 24 }}>
          
          {/* Left: AI Foot Traffic Forecast Graph */}
          <div className="card">
            <div className="card-header">
              <div>
                <span className="card-title">📈 AI Foot Traffic Forecast (Today)</span>
                <p style={{ fontSize: 12, color: '#64748B', margin: '2px 0 0 0' }}>
                  Predicted visitor percentage over 24-hour retail cycle
                </p>
              </div>
              <span className="badge badge-ai">Model 1 Active</span>
            </div>

            <div className="card-body">
              <ResponsiveContainer width="100%" height={260}>
                <AreaChart data={TRAFFIC_FORECAST} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="trafficGradient" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#2563EB" stopOpacity={0.25} />
                      <stop offset="95%" stopColor="#2563EB" stopOpacity={0.0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
                  <XAxis dataKey="hour" tick={{ fontSize: 12, fill: '#64748B' }} />
                  <YAxis tick={{ fontSize: 12, fill: '#64748B' }} unit="%" />
                  <Tooltip
                    formatter={(val) => [`${val}% Capacity`, 'Traffic']}
                    contentStyle={{ borderRadius: 10, border: '1px solid #E2E8F0', boxShadow: '0 4px 12px rgba(0,0,0,0.05)' }}
                  />
                  <Area
                    type="monotone"
                    dataKey="predicted"
                    stroke="#2563EB"
                    strokeWidth={3}
                    fillOpacity={1}
                    fill="url(#trafficGradient)"
                    name="Predicted Traffic"
                  />
                  <Area
                    type="monotone"
                    dataKey="actual"
                    stroke="#16A34A"
                    strokeWidth={2}
                    strokeDasharray="4 4"
                    fill="none"
                    name="Actual Traffic"
                  />
                </AreaChart>
              </ResponsiveContainer>

              <div style={{ display: 'flex', justifyContent: 'center', gap: 24, marginTop: 14 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, color: '#2563EB', fontWeight: 600 }}>
                  <span style={{ width: 14, height: 3, background: '#2563EB', borderRadius: 2 }} />
                  Predicted Foot Traffic
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, color: '#16A34A', fontWeight: 600 }}>
                  <span style={{ width: 14, height: 3, background: '#16A34A', borderRadius: 2 }} />
                  Actual Historical Checkpoint
                </div>
              </div>

              <div style={{
                marginTop: 16, padding: '12px 14px', background: '#F8FAFC',
                borderRadius: 10, border: '1px solid #E2E8F0', fontSize: 12, color: '#475569'
              }}>
                💡 <strong>Traffic Insight:</strong> Peak traffic reached 85% at 16:00. Evening dip predicted at 18:00–20:00 due to sudden heavy monsoon rainfall in Central Bangkok.
              </div>
            </div>
          </div>

          {/* Right: Prediction Inputs & Weights */}
          <div className="card">
            <div className="card-header">
              <span className="card-title">⚙️ Prediction Inputs & Weighting</span>
              <span className="badge badge-normal">Active Variables</span>
            </div>

            <div className="card-body">
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 18 }}>
                
                {/* Weather Input */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', background: '#EFF6FF', borderRadius: 10, border: '1px solid #BFDBFE' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <CloudRain size={18} color="#2563EB" />
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 700, color: '#1E3A8A' }}>Weather</div>
                      <div style={{ fontSize: 11, color: '#64748B' }}>Real-time sensor & radar</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: '#2563EB' }}>🌧️ Heavy Rain</div>
                    <span style={{ fontSize: 11, color: '#EF4444', fontWeight: 600 }}>-35% Traffic Impact</span>
                  </div>
                </div>

                {/* Time of Day */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', background: '#F8FAFC', borderRadius: 10, border: '1px solid #E2E8F0' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <Clock size={18} color="#64748B" />
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>Time of Day</div>
                      <div style={{ fontSize: 11, color: '#64748B' }}>Evening rush window</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>18:00</div>
                    <span style={{ fontSize: 11, color: '#64748B' }}>Dinner Shoppers</span>
                  </div>
                </div>

                {/* Payday Cycle */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', background: '#F0FDF4', borderRadius: 10, border: '1px solid #BBF7D0' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <DollarSign size={18} color="#16A34A" />
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 700, color: '#14532D' }}>Payday Cycle</div>
                      <div style={{ fontSize: 11, color: '#64748B' }}>First week of month</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: '#16A34A' }}>+12% Uplift</div>
                    <span style={{ fontSize: 11, color: '#16A34A', fontWeight: 600 }}>High Basket Size</span>
                  </div>
                </div>

                {/* Day of Week */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', background: '#F8FAFC', borderRadius: 10, border: '1px solid #E2E8F0' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <Calendar size={18} color="#64748B" />
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>Day of Week</div>
                      <div style={{ fontSize: 11, color: '#64748B' }}>Weekend buying patterns</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>Sunday</div>
                    <span style={{ fontSize: 11, color: '#64748B' }}>High Fresh Produce demand</span>
                  </div>
                </div>

                {/* Historical Sales Trend */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', background: '#F8FAFC', borderRadius: 10, border: '1px solid #E2E8F0' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <BarChart2 size={18} color="#64748B" />
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>Historical Trend</div>
                      <div style={{ fontSize: 11, color: '#64748B' }}>90-day moving average</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>High</div>
                    <span style={{ fontSize: 11, color: '#16A34A' }}>+8% YoY</span>
                  </div>
                </div>
              </div>

              {/* Bottom Prediction Result */}
              <div style={{
                background: 'linear-gradient(135deg, #F8FAFC, #EFF6FF)',
                borderRadius: 12, padding: 14, border: '1.5px solid #DBEAFE',
                display: 'flex', justifyContent: 'space-between', alignItems: 'center'
              }}>
                <div>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>Predicted Foot Traffic (18:00)</div>
                  <div style={{ fontSize: 28, fontWeight: 900, color: '#2563EB' }}>54%</div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>Model Confidence</div>
                  <div style={{ fontSize: 28, fontWeight: 900, color: '#16A34A' }}>87%</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Bottom Section: Dual Model Explanation for Pitch/Judges */}
        <div className="card">
          <div className="card-header">
            <span className="card-title">🧠 Dual AI Architecture Breakdown</span>
            <span className="badge badge-ai">Judge Pitch Architecture</span>
          </div>

          <div className="card-body">
            <div className="grid-2" style={{ gap: 20 }}>
              
              {/* Model 1 Box */}
              <div style={{ background: '#F8FAFC', border: '1.5px solid #E2E8F0', borderRadius: 12, padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
                  <span style={{
                    background: '#2563EB', color: 'white', width: 28, height: 28,
                    borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center',
                    fontWeight: 800, fontSize: 13
                  }}>1</span>
                  <h4 style={{ fontSize: 15, fontWeight: 700, color: '#0F172A', margin: 0 }}>
                    Model 1 — Foot Traffic Prediction (Time-Series & Regression)
                  </h4>
                </div>
                <p style={{ fontSize: 12, color: '#64748B', lineHeight: 1.5, marginBottom: 14 }}>
                  Anticipates customer arrival density across every 30-minute window by synthesizing weather anomalies, calendar events, paydays, and store location dynamics.
                </p>
                <div style={{
                  background: '#FFFFFF', padding: '10px 14px', borderRadius: 8,
                  border: '1px dashed #CBD5E1', fontSize: 12, fontFamily: 'monospace', color: '#1E293B'
                }}>
                  Traffic(t) = f(Weather, Hour, DayOfWeek, Payday, HistSales)
                </div>
              </div>

              {/* Model 2 Box */}
              <div style={{ background: '#F8FAFC', border: '1.5px solid #E2E8F0', borderRadius: 12, padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
                  <span style={{
                    background: '#16A34A', color: 'white', width: 28, height: 28,
                    borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center',
                    fontWeight: 800, fontSize: 13
                  }}>2</span>
                  <h4 style={{ fontSize: 15, fontWeight: 700, color: '#0F172A', margin: 0 }}>
                    Model 2 — Dynamic Liquidation Pricing (Optimization Engine)
                  </h4>
                </div>
                <p style={{ fontSize: 12, color: '#64748B', lineHeight: 1.5, marginBottom: 14 }}>
                  Calculates the exact discount threshold needed to ensure 100% sell-through before expiration, maximizing margin retention while eliminating organic landfill waste.
                </p>
                <div style={{
                  background: '#FFFFFF', padding: '10px 14px', borderRadius: 8,
                  border: '1px dashed #CBD5E1', fontSize: 12, fontFamily: 'monospace', color: '#1E293B'
                }}>
                  Discount% = g(ExpiryRemaining, Stock, Velocity, PredictedTraffic)
                </div>
              </div>

            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
