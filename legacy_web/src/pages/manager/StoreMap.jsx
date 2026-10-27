import React, { useState, useContext } from 'react';
import { X, AlertTriangle, Send, CheckCircle2, Map as MapIcon } from 'lucide-react';
import TopBar from '../../components/TopBar';
import { AppContext } from '../../App';
import { AISLES, PRODUCTS } from '../../data/mockData';

const statusColors = {
  normal: { bg: '#F0FDF4', border: '#86EFAC', text: '#16A34A', label: 'Normal' },
  low: { bg: '#FEFCE8', border: '#FDE047', text: '#CA8A04', label: 'Low Stock' },
  expiring: { bg: '#FFF7ED', border: '#FCD34D', text: '#D97706', label: 'Expiring' },
  critical: { bg: '#FEF2F2', border: '#FCA5A5', text: '#DC2626', label: 'Critical' },
  promo: { bg: '#F5F3FF', border: '#C4B5FD', text: '#7C3AED', label: 'Promo Active' },
};

const aisleEmoji = { normal: '🟢', low: '🟡', expiring: '🟠', critical: '🔴', promo: '🟣' };

function getStockoutMinutes(aisle) {
  if (!aisle.salesVelocity || aisle.salesVelocity === 0) return null;
  const hrs = aisle.stock / aisle.salesVelocity;
  return Math.round(hrs * 60);
}

export default function StoreMap() {
  const { aisles: globalAisles, setAisles: setGlobalAisles } = useContext(AppContext);
  const aisleData = globalAisles || AISLES;
  const [selected, setSelected] = useState(null);
  const [notified, setNotified] = useState({});
  const [restocked, setRestocked] = useState({});

  const selectedAisle = aisleData.find(a => a.id === selected);
  const product = selectedAisle ? PRODUCTS.find(p => p.id === selectedAisle.productId) : null;
  const stockoutMins = selectedAisle ? getStockoutMinutes(selectedAisle) : null;
  const s = selectedAisle ? statusColors[selectedAisle.status] : null;

  const handleRestock = (aisleId) => {
    setRestocked(prev => ({ ...prev, [aisleId]: true }));
    if (setGlobalAisles) {
      setGlobalAisles(prev => prev.map(a => a.id === aisleId
        ? { ...a, status: 'normal', stock: a.maxStock }
        : a
      ));
    }
    setSelected(null);
  };

  const handleNotify = (aisleId) => setNotified(prev => ({ ...prev, [aisleId]: true }));

  // Arrange aisles in a 3x3 grid
  const grid = [
    [aisleData[0], aisleData[1], aisleData[2]],
    [aisleData[3], aisleData[4], aisleData[5]],
    [aisleData[6], aisleData[7], aisleData[8]],
  ];

  return (
    <div>
      <TopBar title="Store Floorplan" subtitle="Interactive 2D Map · Click any aisle for details" />
      <div className="page-container">
        <div style={{ display: 'flex', gap: 24, alignItems: 'flex-start' }}>
          {/* Floorplan */}
          <div style={{ flex: 1 }}>
            <div className="card">
              <div className="card-body" style={{ padding: 24 }}>
                {/* Legend */}
                <div style={{ display: 'flex', gap: 16, marginBottom: 20, flexWrap: 'wrap' }}>
                  {Object.entries(statusColors).map(([k, v]) => (
                    <span key={k} style={{ fontSize: 12, display: 'flex', alignItems: 'center', gap: 5 }}>
                      <span style={{ width: 10, height: 10, borderRadius: '50%', background: v.text, display: 'inline-block' }} />
                      {v.label}
                    </span>
                  ))}
                </div>

                {/* Entrance */}
                <div style={{
                  background: '#F8FAFC', border: '2px dashed #CBD5E1',
                  borderRadius: 10, padding: '8px 16px', marginBottom: 16,
                  textAlign: 'center', fontSize: 13, fontWeight: 600, color: '#64748B',
                }}>🚪 Entrance / Exit</div>

                {/* Aisle Grid */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                  {grid.map((row, ri) => (
                    <div key={ri} style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 12 }}>
                      {row.map(aisle => {
                        const sc = statusColors[aisle.status];
                        const mins = getStockoutMinutes(aisle);
                        const isSelected = selected === aisle.id;
                        return (
                          <div
                            key={aisle.id}
                            onClick={() => setSelected(isSelected ? null : aisle.id)}
                            style={{
                              padding: '20px 16px', borderRadius: 14, cursor: 'pointer',
                              border: `2px solid ${isSelected ? sc.text : sc.border}`,
                              background: isSelected ? `${sc.text}12` : sc.bg,
                              transition: 'all 0.2s',
                              position: 'relative',
                              boxShadow: isSelected ? `0 0 0 3px ${sc.text}25` : 'none',
                            }}
                            onMouseEnter={e => { if (!isSelected) e.currentTarget.style.transform = 'translateY(-2px)'; }}
                            onMouseLeave={e => { e.currentTarget.style.transform = 'translateY(0)'; }}
                          >
                            <div style={{ fontSize: 28, textAlign: 'center', marginBottom: 6 }}>
                              {aisleEmoji[aisle.status]}
                            </div>
                            <div style={{ textAlign: 'center' }}>
                              <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>{aisle.id}</div>
                              <div style={{ fontSize: 12, color: '#64748B', marginTop: 2 }}>{aisle.label}</div>
                            </div>
                            <div style={{ marginTop: 10 }}>
                              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
                                <span style={{ fontSize: 11, color: '#94A3B8' }}>Stock</span>
                                <span style={{ fontSize: 11, fontWeight: 600, color: sc.text }}>
                                  {aisle.stock}/{aisle.maxStock}
                                </span>
                              </div>
                              <div className="progress-bar">
                                <div className="progress-fill" style={{
                                  width: `${(aisle.stock / aisle.maxStock) * 100}%`,
                                  background: sc.text,
                                }} />
                              </div>
                            </div>
                            {aisle.status === 'critical' && (
                              <div style={{
                                position: 'absolute', top: 8, right: 8,
                                background: '#EF4444', color: 'white',
                                fontSize: 9, fontWeight: 700, padding: '2px 6px',
                                borderRadius: 20,
                              }}>URGENT</div>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  ))}
                </div>

                {/* Checkout */}
                <div style={{
                  background: '#F8FAFC', border: '2px dashed #CBD5E1',
                  borderRadius: 10, padding: '8px 16px', marginTop: 16,
                  textAlign: 'center', fontSize: 13, fontWeight: 600, color: '#64748B',
                }}>🛒 🛒 🛒 Checkout</div>
              </div>
            </div>
          </div>

          {/* Detail Panel */}
          <div style={{ width: 320, flexShrink: 0 }}>
            {selectedAisle && product ? (
              <div className="card animate-in" key={selectedAisle.id}>
                <div style={{ padding: 20, borderBottom: '1px solid var(--border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <div style={{ fontSize: 16, fontWeight: 700 }}>{selectedAisle.name}</div>
                    <span className={`badge badge-${selectedAisle.status === 'normal' ? 'normal' : selectedAisle.status === 'critical' ? 'critical' : 'warning'}`}
                      style={{ marginTop: 6, display: 'inline-flex' }}>
                      {aisleEmoji[selectedAisle.status]} {statusColors[selectedAisle.status].label}
                    </span>
                  </div>
                  <button onClick={() => setSelected(null)} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#94A3B8' }}>
                    <X size={18} />
                  </button>
                </div>
                <div style={{ padding: 20 }}>
                  <div style={{ fontSize: 32, textAlign: 'center', marginBottom: 8 }}>{product.emoji}</div>
                  <h3 style={{ fontSize: 16, fontWeight: 700, textAlign: 'center', marginBottom: 16 }}>{product.name}</h3>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 16 }}>
                    {[
                      ['Current Stock', `${selectedAisle.stock} / ${selectedAisle.maxStock} units`],
                      ['Sales Velocity', `${selectedAisle.salesVelocity} units/hr`],
                      ['Expiry', `${selectedAisle.expiryHours < 24 ? `${selectedAisle.expiryHours}h` : `${Math.round(selectedAisle.expiryHours/24)}d`}`],
                    ].map(([k, v]) => (
                      <div key={k} style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 0', borderBottom: '1px solid var(--border-light)' }}>
                        <span style={{ fontSize: 13, color: '#64748B' }}>{k}</span>
                        <span style={{ fontSize: 13, fontWeight: 600 }}>{v}</span>
                      </div>
                    ))}
                    {stockoutMins !== null && (
                      <div style={{
                        padding: '12px', borderRadius: 10, marginTop: 4,
                        background: s.bg, border: `1px solid ${s.border}`,
                      }}>
                        <div style={{ fontSize: 12, color: s.text, fontWeight: 700, marginBottom: 2 }}>
                          {selectedAisle.status === 'critical' ? '⚠️ ESTIMATED STOCKOUT' : '⏱️ Time to Stockout'}
                        </div>
                        <div style={{ fontSize: 24, fontWeight: 800, color: s.text }}>
                          ~{stockoutMins >= 60 ? `${Math.round(stockoutMins/60)}h ${stockoutMins%60}m` : `${stockoutMins} min`}
                        </div>
                      </div>
                    )}
                  </div>

                  {restocked[selectedAisle.id] ? (
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#16A34A', fontWeight: 600, fontSize: 14, justifyContent: 'center', padding: 12 }}>
                      <CheckCircle2 size={18} /> Restocked Successfully!
                    </div>
                  ) : (
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                      {!notified[selectedAisle.id] ? (
                        <button className="btn btn-warning btn-full" onClick={() => handleNotify(selectedAisle.id)}
                          style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
                          <Send size={14} /> Notify Staff
                        </button>
                      ) : (
                        <div style={{ fontSize: 13, color: '#F59E0B', textAlign: 'center', fontWeight: 600 }}>
                          ✓ Staff Notified
                        </div>
                      )}
                      <button className="btn btn-primary btn-full" onClick={() => handleRestock(selectedAisle.id)}
                        style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
                        <CheckCircle2 size={14} /> Mark as Restocked
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ) : (
              <div className="card">
                <div style={{ padding: 32, textAlign: 'center', color: '#94A3B8' }}>
                  <MapIcon size={40} style={{ margin: '0 auto 12px', opacity: 0.4 }} />
                  <p style={{ fontSize: 14 }}>Click any aisle on the map to see details</p>
                </div>
              </div>
            )}

            {/* Summary */}
            <div className="card" style={{ marginTop: 16 }}>
              <div style={{ padding: 16 }}>
                <div style={{ fontSize: 12, fontWeight: 600, color: '#94A3B8', marginBottom: 12, textTransform: 'uppercase', letterSpacing: 0.5 }}>Status Summary</div>
                {Object.entries(statusColors).map(([status, sc]) => {
                  const count = aisleData.filter(a => a.status === status).length;
                  if (!count) return null;
                  return (
                    <div key={status} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                      <span style={{ fontSize: 13, color: '#475569' }}>{aisleEmoji[status]} {sc.label}</span>
                      <span style={{
                        fontSize: 12, fontWeight: 700, padding: '2px 10px',
                        borderRadius: 20, background: sc.bg, color: sc.text,
                      }}>{count}</span>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
