import React, { useState, useContext } from 'react';
import { Send, CheckCircle2, Clock, Calculator, Sparkles } from 'lucide-react';
import TopBar from '../../components/TopBar';
import { AppContext } from '../../App';
import { ALERTS, PRODUCTS, AISLES } from '../../data/mockData';

function getStockoutText(mins) {
  if (!mins) return null;
  if (mins < 60) return `~${mins} min`;
  return `~${Math.round(mins / 60)}h ${mins % 60}m`;
}

export default function RestockAlert() {
  const { alerts: globalAlerts, setAlerts: setGlobalAlerts, aisles, setAisles } = useContext(AppContext);
  const alerts = globalAlerts || ALERTS;
  const [filter, setFilter] = useState('all');

  const updateStatus = (id, status) => {
    const targetAlert = alerts.find(a => a.id === id);
    if (setGlobalAlerts) {
      setGlobalAlerts(prev => prev.map(a => a.id === id ? { ...a, status } : a));
    }
    if (status === 'resolved' && targetAlert && setAisles) {
      setAisles(prev => prev.map(aisle => aisle.id === targetAlert.aisleId ? { ...aisle, status: 'normal', stock: aisle.maxStock } : aisle));
    }
  };

  const filtered = alerts.filter(a => {
    if (filter === 'all') return true;
    if (filter === 'critical') return a.type === 'critical';
    if (filter === 'warning') return a.type === 'warning';
    if (filter === 'resolved') return a.status === 'resolved';
    return true;
  });

  const urgentCount = alerts.filter(a => a.type === 'critical' && a.status !== 'resolved').length;

  const typeStyle = {
    critical: { bg: '#FEF2F2', border: '#FCA5A5', text: '#DC2626', icon: '🔴', badge: 'critical' },
    warning: { bg: '#FFF7ED', border: '#FCD34D', text: '#D97706', icon: '🟠', badge: 'warning' },
    success: { bg: '#F0FDF4', border: '#86EFAC', text: '#16A34A', icon: '🟢', badge: 'normal' },
    ai: { bg: '#EFF6FF', border: '#93C5FD', text: '#2563EB', icon: '🤖', badge: 'ai' },
  };

  return (
    <div>
      <TopBar title="Restock Center" subtitle={`${urgentCount} critical alerts require immediate action`} />
      <div className="page-container">

        {/* AI Formula Explanation Banner (Point 17 in Prompt) */}
        <div className="card" style={{ marginBottom: 20, background: 'linear-gradient(135deg, #FEF2F2 0%, #FFF7ED 100%)', border: '1.5px solid #FECACA' }}>
          <div className="card-body" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{ background: '#EF4444', color: 'white', width: 44, height: 44, borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Calculator size={22} />
              </div>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{ fontSize: 11, fontWeight: 800, textTransform: 'uppercase', color: '#DC2626' }}>Restock AI Logic</span>
                  <span className="badge badge-critical" style={{ fontSize: 10 }}>Demo Proof</span>
                </div>
                <h3 style={{ fontSize: 16, fontWeight: 800, color: '#0F172A', margin: '2px 0' }}>
                  Estimated Stockout Time = Current Stock ÷ Sales Velocity
                </h3>
                <p style={{ fontSize: 12, color: '#64748B', margin: 0 }}>
                  Example: Fresh Milk has <strong>3 units</strong> left with <strong>8 units/hr</strong> sales velocity → 3 ÷ 8 = 0.375 hr ≈ <strong>22.5 minutes</strong> to stockout!
                </p>
              </div>
            </div>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 20, alignItems: 'flex-start' }}>
          <div style={{ flex: 1 }}>
            {/* Filter Tabs */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
              <div className="filter-tabs">
                {[['all', 'All'], ['critical', '🔴 Critical'], ['warning', '🟠 Warning'], ['resolved', '✅ Resolved']].map(([val, label]) => (
                  <button key={val} className={`filter-tab${filter === val ? ' active' : ''}`} onClick={() => setFilter(val)}>
                    {label}
                  </button>
                ))}
              </div>
              <span className="badge badge-critical">{urgentCount} urgent</span>
            </div>

            {/* Alert Cards */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              {filtered.map(alert => {
                const ts = typeStyle[alert.type];
                const product = PRODUCTS.find(p => p.id === alert.productId);
                const aisle = AISLES.find(a => a.id === alert.aisleId);
                const stockoutText = alert.estimatedMinutes ? getStockoutText(alert.estimatedMinutes) : null;
                const isResolved = alert.status === 'resolved';

                return (
                  <div key={alert.id} className="card animate-in" style={{ opacity: isResolved ? 0.6 : 1 }}>
                    <div style={{ padding: '16px 20px' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                          <span style={{ fontSize: 24 }}>{product?.emoji}</span>
                          <div>
                            <div style={{ fontWeight: 700, fontSize: 15 }}>{product?.name}</div>
                            <div style={{ fontSize: 12, color: '#64748B' }}>{aisle?.name} · {aisle?.label}</div>
                          </div>
                        </div>
                        <span className={`badge badge-${ts.badge}`} style={{ flexShrink: 0 }}>
                          {ts.icon} {alert.type === 'critical' ? 'Critical' : alert.type === 'warning' ? 'Warning' : alert.type === 'success' ? 'Resolved' : 'AI'}
                        </span>
                      </div>

                      <div style={{
                        background: ts.bg, border: `1px solid ${ts.border}`,
                        borderRadius: 10, padding: '10px 14px', marginBottom: 14,
                      }}>
                        <p style={{ fontSize: 13, fontWeight: 600, color: ts.text, marginBottom: 2 }}>{alert.message}</p>
                        <p style={{ fontSize: 12, color: '#64748B' }}>{alert.detail}</p>
                      </div>

                      {aisle && !isResolved && (
                        <div style={{ display: 'flex', gap: 20, marginBottom: 14 }}>
                          {[
                            ['Stock', `${aisle.stock} / ${aisle.maxStock}`],
                            ['Velocity', `${aisle.salesVelocity}/hr`],
                            ['Stockout In', stockoutText || 'N/A'],
                          ].map(([k, v]) => (
                            <div key={k}>
                              <div style={{ fontSize: 11, color: '#94A3B8', marginBottom: 2 }}>{k}</div>
                              <div style={{ fontSize: 14, fontWeight: 700, color: k === 'Stockout In' ? ts.text : '#0F172A' }}>{v}</div>
                            </div>
                          ))}
                        </div>
                      )}

                      {!isResolved && (
                        <div style={{ display: 'flex', gap: 10 }}>
                          {alert.status === 'open' && (
                            <button className="btn btn-warning btn-sm" onClick={() => updateStatus(alert.id, 'notified')}
                              style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
                              <Send size={13} /> Send Alert
                            </button>
                          )}
                          {alert.status === 'notified' && (
                            <span style={{ fontSize: 13, color: '#F59E0B', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 5 }}>
                              <Clock size={13} /> Staff Notified
                            </span>
                          )}
                          <button className="btn btn-primary btn-sm" onClick={() => updateStatus(alert.id, 'resolved')}
                            style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
                            <CheckCircle2 size={13} /> Mark as Restocked ✓
                          </button>
                        </div>
                      )}
                      {isResolved && (
                        <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: '#16A34A', fontWeight: 600, fontSize: 13 }}>
                          <CheckCircle2 size={14} /> Resolved · {alert.time}
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Summary Sidebar */}
          <div style={{ width: 260, flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 14 }}>
            {[
              { label: 'Critical', count: alerts.filter(a => a.type === 'critical' && a.status !== 'resolved').length, color: '#EF4444', bg: '#FEF2F2' },
              { label: 'Warning', count: alerts.filter(a => a.type === 'warning' && a.status !== 'resolved').length, color: '#F59E0B', bg: '#FFF7ED' },
              { label: 'Resolved Today', count: alerts.filter(a => a.status === 'resolved').length, color: '#16A34A', bg: '#F0FDF4' },
            ].map(stat => (
              <div key={stat.label} className="card" style={{ padding: 16, background: stat.bg, border: `1px solid ${stat.color}30` }}>
                <div style={{ fontSize: 28, fontWeight: 800, color: stat.color }}>{stat.count}</div>
                <div style={{ fontSize: 12, color: '#64748B', marginTop: 2 }}>{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
