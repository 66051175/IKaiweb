import React, { useState, useContext } from 'react';
import { ClipboardList, CheckCircle2, AlertTriangle, Clock, ArrowRight, Sparkles, Send, ShieldAlert } from 'lucide-react';
import TopBar from '../../components/TopBar';
import { AppContext } from '../../App';
import { STAFF_TASKS } from '../../data/mockData';

export default function StaffTasks() {
  const { aisles, setAisles } = useContext(AppContext);
  const [tasks, setTasks] = useState(STAFF_TASKS);
  const [completedTaskIds, setCompletedTaskIds] = useState({});
  const [successToast, setSuccessToast] = useState(null);

  const handleRestock = (taskId, aisleLabel) => {
    setCompletedTaskIds(prev => ({ ...prev, [taskId]: true }));

    // If global aisles state exists, update Aisle 4 to normal
    if (setAisles) {
      setAisles(prev => {
        if (!prev) return prev;
        return prev.map(a => a.id === 'A4' ? { ...a, status: 'normal', stock: a.maxStock } : a);
      });
    }

    setSuccessToast(`✓ Successfully restocked ${aisleLabel}! Floorplan status updated to GREEN.`);
    setTimeout(() => setSuccessToast(null), 4500);
  };

  const pendingCount = tasks.filter(t => !completedTaskIds[t.id]).length;

  return (
    <div>
      <TopBar title="Staff Task Center" subtitle="Direct AI instructions · Actionable floor tasks" />
      <div className="page-container" style={{ maxWidth: 640, margin: '0 auto' }}>

        {/* Mobile View Header Card */}
        <div style={{
          background: 'linear-gradient(135deg, #0F172A 0%, #1E293B 100%)',
          color: 'white', borderRadius: 16, padding: '20px 24px', marginBottom: 20,
          boxShadow: '0 8px 24px rgba(0,0,0,0.12)'
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ fontSize: 12, color: '#94A3B8', fontWeight: 600, textTransform: 'uppercase' }}>
                Floor Operation Tasklist
              </div>
              <h2 style={{ fontSize: 22, fontWeight: 800, margin: '4px 0 2px 0' }}>
                Good afternoon, Alex 👋
              </h2>
              <div style={{ fontSize: 13, color: '#CBD5E1' }}>
                Store #001 · Central Bangkok
              </div>
            </div>
            <div style={{
              background: pendingCount > 0 ? '#EF4444' : '#16A34A',
              color: 'white', padding: '8px 16px', borderRadius: 24, fontWeight: 800, fontSize: 14,
              display: 'flex', alignItems: 'center', gap: 6
            }}>
              <AlertTriangle size={16} /> {pendingCount} TASKS
            </div>
          </div>
        </div>

        {/* Toast Notification */}
        {successToast && (
          <div style={{
            background: '#F0FDF4', border: '2px solid #86EFAC', borderRadius: 12,
            padding: '14px 18px', marginBottom: 20, color: '#15803D', fontWeight: 700,
            display: 'flex', alignItems: 'center', gap: 10, animation: 'fadeIn 0.2s ease-in'
          }}>
            <CheckCircle2 size={22} color="#16A34A" />
            <span>{successToast}</span>
          </div>
        )}

        {/* Tasks List */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          {tasks.map(task => {
            const isDone = completedTaskIds[task.id];
            const isUrgent = task.urgency === 'critical';

            return (
              <div
                key={task.id}
                className="card"
                style={{
                  border: isDone
                    ? '1.5px solid #86EFAC'
                    : isUrgent
                      ? '2px solid #EF4444'
                      : '1.5px solid #FCD34D',
                  background: isDone
                    ? '#F0FDF4'
                    : isUrgent
                      ? '#FEF2F2'
                      : '#FFFBEB',
                  transition: 'all 0.2s',
                  boxShadow: isUrgent && !isDone ? '0 4px 16px rgba(239, 68, 68, 0.15)' : 'none',
                }}
              >
                <div className="card-body" style={{ padding: 20 }}>
                  
                  {/* Task Top Header */}
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <span style={{ fontSize: 24 }}>{task.emoji}</span>
                      <div>
                        <span style={{
                          fontSize: 11, fontWeight: 800, textTransform: 'uppercase', letterSpacing: 0.5,
                          color: isDone ? '#16A34A' : isUrgent ? '#DC2626' : '#D97706'
                        }}>
                          {isDone ? 'COMPLETED' : isUrgent ? '🔴 URGENT RESTOCK' : '🟠 INSPECT EXPOSURE'}
                        </span>
                        <h3 style={{ fontSize: 18, fontWeight: 800, color: '#0F172A', margin: 0 }}>
                          {task.aisle} · {task.product}
                        </h3>
                      </div>
                    </div>

                    <span style={{
                      fontSize: 12, fontWeight: 700, padding: '4px 10px', borderRadius: 8,
                      background: isDone ? '#DCFCE7' : isUrgent ? '#FEE2E2' : '#FEF3C7',
                      color: isDone ? '#166534' : isUrgent ? '#991B1B' : '#92400E',
                      display: 'flex', alignItems: 'center', gap: 4
                    }}>
                      <Clock size={12} /> {task.timeRemaining}
                    </span>
                  </div>

                  {/* Task Instruction Details */}
                  <div style={{
                    padding: '10px 14px', background: 'rgba(255,255,255,0.7)',
                    borderRadius: 10, fontSize: 13, color: '#475569', marginBottom: 16
                  }}>
                    {isUrgent ? (
                      <div>
                        ⚠️ <strong>{task.detail}</strong>. AI predicts shelf will empty in <strong>{task.timeRemaining}</strong> based on current sales velocity (8 units/hr).
                      </div>
                    ) : (
                      <div>
                        🏷️ <strong>{task.detail}</strong>. Ensure markdown stickers are visible or relocate to front aisle.
                      </div>
                    )}
                  </div>

                  {/* Action Button */}
                  {isDone ? (
                    <div style={{
                      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
                      padding: 12, background: '#DCFCE7', borderRadius: 10, color: '#15803D', fontWeight: 700
                    }}>
                      <CheckCircle2 size={18} /> Task Complete · Shelf Restocked
                    </div>
                  ) : (
                    <button
                      className="btn"
                      onClick={() => handleRestock(task.id, task.aisle)}
                      style={{
                        width: '100%',
                        padding: '14px',
                        fontSize: 15,
                        fontWeight: 800,
                        background: isUrgent ? '#EF4444' : '#F59E0B',
                        color: 'white',
                        border: 'none',
                        borderRadius: 10,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: 8,
                        cursor: 'pointer',
                        boxShadow: isUrgent ? '0 4px 12px rgba(239,68,68,0.3)' : '0 4px 12px rgba(245,158,11,0.3)'
                      }}
                    >
                      {isUrgent ? '⚡ RESTOCK NOW (39 Units)' : '✓ MARK AS CHECKED'}
                    </button>
                  )}

                </div>
              </div>
            );
          })}
        </div>

        {/* AI Staff Assistant Info */}
        <div style={{
          marginTop: 24, textAlign: 'center', padding: '16px', background: 'white',
          borderRadius: 12, border: '1px solid #E2E8F0', fontSize: 12, color: '#64748B'
        }}>
          🤖 <strong>AI Autonomous Guidance:</strong> Tasks are dynamically ranked by stockout probability & expiry urgency so floor staff focus on high-impact replenishment.
        </div>

      </div>
    </div>
  );
}
