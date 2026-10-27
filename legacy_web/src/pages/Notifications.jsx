import React, { useState } from 'react';
import { Bell, CheckCheck, Trash2, Filter, AlertCircle, Sparkles, CheckCircle2, Clock } from 'lucide-react';
import TopBar from '../components/TopBar';
import { NOTIFICATIONS } from '../data/mockData';

export default function Notifications() {
  const [filter, setFilter] = useState('all');
  const [notifications, setNotifications] = useState(NOTIFICATIONS);

  const filterMap = {
    critical: '🔴 Critical',
    warning: '🟠 Warning',
    success: '🟢 Restocked',
    ai: '🤖 AI Decisions',
  };

  const filteredList = notifications.filter(n => {
    if (filter === 'all') return true;
    return n.type === filter;
  });

  const getStyle = (type) => {
    switch (type) {
      case 'critical':
        return { bg: '#FEF2F2', border: '#FCA5A5', icon: '🔴', color: '#991B1B' };
      case 'warning':
        return { bg: '#FFFBEB', border: '#FCD34D', icon: '🟠', color: '#92400E' };
      case 'success':
        return { bg: '#F0FDF4', border: '#86EFAC', icon: '🟢', color: '#166534' };
      case 'ai':
        return { bg: '#EFF6FF', border: '#93C5FD', icon: '🤖', color: '#1E40AF' };
      default:
        return { bg: '#F8FAFC', border: '#E2E8F0', icon: '🔔', color: '#334155' };
    }
  };

  const handleClearAll = () => setNotifications([]);

  return (
    <div>
      <TopBar title="Notification Center" subtitle="Audit log of system alerts, autonomous AI adjustments & floor activities" />
      <div className="page-container">

        {/* Action Header */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20, flexWrap: 'wrap', gap: 12 }}>
          {/* Filters */}
          <div style={{ display: 'flex', gap: 6, background: 'white', padding: 4, borderRadius: 10, border: '1px solid #E2E8F0' }}>
            <button
              onClick={() => setFilter('all')}
              style={{
                padding: '6px 14px', borderRadius: 8, fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: filter === 'all' ? '#0F172A' : 'transparent',
                color: filter === 'all' ? 'white' : '#64748B'
              }}
            >
              All ({notifications.length})
            </button>
            {Object.entries(filterMap).map(([key, label]) => (
              <button
                key={key}
                onClick={() => setFilter(key)}
                style={{
                  padding: '6px 14px', borderRadius: 8, fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                  background: filter === key ? '#0F172A' : 'transparent',
                  color: filter === key ? 'white' : '#64748B'
                }}
              >
                {label}
              </button>
            ))}
          </div>

          <button
            className="btn btn-outline btn-sm"
            onClick={handleClearAll}
            style={{ display: 'flex', alignItems: 'center', gap: 6, color: '#EF4444', borderColor: '#FECACA' }}
          >
            <Trash2 size={14} /> Clear Log
          </button>
        </div>

        {/* Notifications List */}
        <div className="card">
          <div className="card-body" style={{ padding: 16 }}>
            {filteredList.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '40px 20px', color: '#94A3B8' }}>
                <CheckCircle2 size={40} color="#16A34A" style={{ margin: '0 auto 12px' }} />
                <h4 style={{ color: '#0F172A', margin: 0 }}>No notifications found</h4>
                <p style={{ fontSize: 13 }}>All systems are currently running within optimal thresholds.</p>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {filteredList.map(item => {
                  const s = getStyle(item.type);
                  return (
                    <div
                      key={item.id}
                      style={{
                        padding: '14px 18px',
                        borderRadius: 12,
                        background: s.bg,
                        border: `1.5px solid ${s.border}`,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        gap: 14,
                        transition: 'transform 0.15s',
                      }}
                    >
                      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                        <span style={{ fontSize: 20 }}>{s.icon}</span>
                        <div>
                          <div style={{ fontSize: 14, fontWeight: 700, color: s.color }}>
                            {item.title}
                          </div>
                          <div style={{ fontSize: 12, color: '#64748B', display: 'flex', alignItems: 'center', gap: 6, marginTop: 2 }}>
                            <Clock size={12} /> {item.time}
                          </div>
                        </div>
                      </div>

                      <span style={{
                        fontSize: 11, fontWeight: 700, textTransform: 'uppercase',
                        color: s.color, background: 'rgba(255,255,255,0.6)', padding: '4px 8px', borderRadius: 6
                      }}>
                        {item.type}
                      </span>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  );
}
