import React, { useState, useContext } from 'react';
import { Tag, Sparkles, CloudRain, Sun, ArrowRight, CheckCircle2, TrendingUp, AlertCircle, ShoppingCart } from 'lucide-react';
import TopBar from '../../components/TopBar';
import { AppContext } from '../../App';
import { DISCOUNTS, PRODUCTS } from '../../data/mockData';

export default function DynamicPricing() {
  const { discounts: globalDiscounts, setDiscounts: setGlobalDiscounts } = useContext(AppContext);
  const [discountsList, setDiscountsList] = useState(globalDiscounts || DISCOUNTS);
  const [selectedId, setSelectedId] = useState('d2'); // Default Caesar Salad
  const [weatherOverride, setWeatherOverride] = useState('rain'); // 'rain' | 'sunny'
  const [appliedNotification, setAppliedNotification] = useState(null);

  const currentItem = discountsList.find(d => d.id === selectedId) || discountsList[0];
  const product = PRODUCTS.find(p => p.id === currentItem.productId);

  // Dynamic simulation based on weather toggle
  const simulatedDiscount = weatherOverride === 'rain' ? 30 : 15;
  const simulatedTraffic = weatherOverride === 'rain' ? 42 : 78;
  const simulatedFinalPrice = Math.round(currentItem.originalPrice * (1 - simulatedDiscount / 100));
  const simulatedExpectedSold = weatherOverride === 'rain' ? 15 : 17;
  const simulatedWasteProb = weatherOverride === 'rain' ? 12 : 5;

  const handleApplyDiscount = (id) => {
    const updated = discountsList.map(d => {
      if (d.id === id) {
        return {
          ...d,
          discountPercent: simulatedDiscount,
          finalPrice: simulatedFinalPrice,
          status: 'active',
        };
      }
      return d;
    });
    setDiscountsList(updated);
    if (setGlobalDiscounts) setGlobalDiscounts(updated);
    setAppliedNotification(`Applied ${simulatedDiscount}% OFF to ${product.name}! Deal is now live in Customer App.`);
    setTimeout(() => setAppliedNotification(null), 4000);
  };

  return (
    <div>
      <TopBar title="Dynamic Discount Engine" subtitle="Real-time AI pricing driven by expiry, stock velocity & weather" />
      <div className="page-container">

        {appliedNotification && (
          <div style={{
            background: '#F0FDF4', border: '1.5px solid #86EFAC', borderRadius: 12,
            padding: '12px 18px', marginBottom: 20, display: 'flex', alignItems: 'center',
            gap: 12, color: '#16A34A', fontWeight: 600, animation: 'fadeIn 0.2s ease-in'
          }}>
            <CheckCircle2 size={20} />
            <span>{appliedNotification}</span>
          </div>
        )}

        {/* Weather condition simulator banner */}
        <div className="card" style={{ marginBottom: 20, background: 'linear-gradient(135deg, #EFF6FF 0%, #F0FDF4 100%)', border: '1px solid #BFDBFE' }}>
          <div className="card-body" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 16 }}>
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <span className="badge badge-ai"><Sparkles size={12} /> AI Live Simulator</span>
                <span style={{ fontSize: 13, color: '#475569', fontWeight: 500 }}>Bangkok Forecast Model</span>
              </div>
              <h3 style={{ fontSize: 16, fontWeight: 700, color: '#0F172A', marginTop: 4 }}>
                Simulate Weather & Customer Foot Traffic
              </h3>
              <p style={{ fontSize: 12, color: '#64748B' }}>
                Toggle weather conditions to observe how the AI model recalibrates discount rates to prevent food waste.
              </p>
            </div>

            <div style={{ display: 'flex', gap: 8 }}>
              <button
                className={`btn ${weatherOverride === 'rain' ? 'btn-primary' : 'btn-outline'}`}
                onClick={() => setWeatherOverride('rain')}
                style={{ display: 'flex', alignItems: 'center', gap: 6, background: weatherOverride === 'rain' ? '#2563EB' : 'white' }}
              >
                <CloudRain size={16} /> Heavy Rain (-35% Foot Traffic)
              </button>
              <button
                className={`btn ${weatherOverride === 'sunny' ? 'btn-primary' : 'btn-outline'}`}
                onClick={() => setWeatherOverride('sunny')}
                style={{ display: 'flex', alignItems: 'center', gap: 6, background: weatherOverride === 'sunny' ? '#F59E0B' : 'white' }}
              >
                <Sun size={16} /> Sunny (+20% Foot Traffic)
              </button>
            </div>
          </div>
        </div>

        {/* Product selector tabs */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 20, overflowX: 'auto', paddingBottom: 4 }}>
          {discountsList.map(d => {
            const prod = PRODUCTS.find(p => p.id === d.productId);
            const isSel = d.id === selectedId;
            return (
              <button
                key={d.id}
                onClick={() => setSelectedId(d.id)}
                style={{
                  padding: '12px 18px',
                  borderRadius: 12,
                  border: isSel ? '2px solid #2563EB' : '1.5px solid #E2E8F0',
                  background: isSel ? '#EFF6FF' : 'white',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 10,
                  transition: 'all 0.15s',
                  boxShadow: isSel ? '0 2px 8px rgba(37,99,235,0.15)' : 'none',
                }}
              >
                <span style={{ fontSize: 24 }}>{prod?.emoji}</span>
                <div style={{ textAlign: 'left' }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: '#0F172A' }}>{prod?.name}</div>
                  <div style={{ fontSize: 11, color: '#64748B' }}>
                    Stock: {d.stock} · {d.discountPercent}% OFF
                  </div>
                </div>
                {d.status === 'active' && (
                  <span className="badge badge-normal" style={{ marginLeft: 4 }}>Active</span>
                )}
              </button>
            );
          })}
        </div>

        {/* Main Discount Breakdown (2 columns) */}
        <div className="grid-2" style={{ alignItems: 'start' }}>
          
          {/* Left Column: Product & Variables */}
          <div className="card">
            <div className="card-header">
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <span style={{ fontSize: 28 }}>{product?.emoji}</span>
                <div>
                  <h2 style={{ fontSize: 18, fontWeight: 800, color: '#0F172A' }}>{product?.name}</h2>
                  <span style={{ fontSize: 12, color: '#64748B' }}>Aisle 8 · Fresh Produce</span>
                </div>
              </div>
              <span className="badge badge-ai" style={{ fontSize: 12 }}>
                Expires in {currentItem.aiInputs.expiryHours}
              </span>
            </div>

            <div className="card-body">
              {/* Pricing metrics */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 12, marginBottom: 20 }}>
                <div style={{ background: '#F8FAFC', padding: 14, borderRadius: 10, border: '1px solid #E2E8F0' }}>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>Original Price</div>
                  <div style={{ fontSize: 22, fontWeight: 800, color: '#94A3B8', textDecoration: 'line-through' }}>
                    ฿{currentItem.originalPrice}
                  </div>
                </div>
                <div style={{ background: '#EFF6FF', padding: 14, borderRadius: 10, border: '1px solid #BFDBFE' }}>
                  <div style={{ fontSize: 11, color: '#2563EB', fontWeight: 600 }}>AI Suggested</div>
                  <div style={{ fontSize: 22, fontWeight: 800, color: '#2563EB' }}>
                    ฿{simulatedFinalPrice}
                  </div>
                </div>
                <div style={{ background: '#FEF2F2', padding: 14, borderRadius: 10, border: '1px solid #FECACA' }}>
                  <div style={{ fontSize: 11, color: '#EF4444', fontWeight: 600 }}>Discount Rate</div>
                  <div style={{ fontSize: 22, fontWeight: 800, color: '#EF4444' }}>
                    {simulatedDiscount}%
                  </div>
                </div>
              </div>

              {/* Dynamic Input Variables Table */}
              <h4 style={{ fontSize: 13, fontWeight: 700, color: '#334155', marginBottom: 10 }}>
                📊 Real-Time Decision Factors
              </h4>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 12px', background: '#F8FAFC', borderRadius: 8, fontSize: 13 }}>
                  <span style={{ color: '#64748B' }}>Current Shelf Stock</span>
                  <span style={{ fontWeight: 700, color: '#0F172A' }}>{currentItem.stock} units</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 12px', background: '#F8FAFC', borderRadius: 8, fontSize: 13 }}>
                  <span style={{ color: '#64748B' }}>Time to Expiry</span>
                  <span style={{ fontWeight: 700, color: '#D97706' }}>{currentItem.aiInputs.expiryHours}</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 12px', background: '#F8FAFC', borderRadius: 8, fontSize: 13 }}>
                  <span style={{ color: '#64748B' }}>Historical Sales Velocity</span>
                  <span style={{ fontWeight: 700, color: '#0F172A' }}>{currentItem.aiInputs.salesVelocity}</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 12px', background: '#F8FAFC', borderRadius: 8, fontSize: 13 }}>
                  <span style={{ color: '#64748B' }}>Predicted Foot Traffic</span>
                  <span style={{ fontWeight: 700, color: '#2563EB' }}>{simulatedTraffic}% (Current Hour)</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '8px 12px', background: '#F8FAFC', borderRadius: 8, fontSize: 13 }}>
                  <span style={{ color: '#64748B' }}>Live Weather Influence</span>
                  <span style={{ fontWeight: 700, color: weatherOverride === 'rain' ? '#2563EB' : '#F59E0B' }}>
                    {weatherOverride === 'rain' ? '🌧️ Heavy Rain (-35% visitors)' : '☀️ Clear Skies (+20% visitors)'}
                  </span>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column: AI Recommendation & Impact */}
          <div className="card" style={{ border: '2px solid #93C5FD', boxShadow: '0 8px 24px rgba(37,99,235,0.08)' }}>
            <div className="card-header" style={{ background: 'linear-gradient(135deg, #1E40AF, #2563EB)', color: 'white', borderRadius: '14px 14px 0 0' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <Sparkles size={18} />
                <span style={{ fontSize: 15, fontWeight: 700 }}>AI Recommendation Engine</span>
              </div>
              <span style={{ background: 'rgba(255,255,255,0.2)', padding: '4px 10px', borderRadius: 20, fontSize: 11, fontWeight: 600 }}>
                Confidence: 94%
              </span>
            </div>

            <div className="card-body">
              {/* Highlight Box */}
              <div style={{
                background: '#EFF6FF', border: '1.5px dashed #2563EB', borderRadius: 14,
                padding: '18px 20px', textAlign: 'center', marginBottom: 20
              }}>
                <div style={{ fontSize: 13, color: '#1E40AF', fontWeight: 600, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                  Recommended Action
                </div>
                <div style={{ fontSize: 36, fontWeight: 900, color: '#1E3A8A', margin: '6px 0' }}>
                  {simulatedDiscount}% OFF NOW
                </div>
                <p style={{ fontSize: 13, color: '#3B82F6', margin: 0 }}>
                  {weatherOverride === 'rain'
                    ? `Heavy rain slows customer influx. A ${simulatedDiscount}% price adjustment creates urgency to liquidate inventory.`
                    : `Strong customer traffic allows higher margins while ensuring all stock is sold before expiry.`}
                </p>
              </div>

              {/* Forecasted Outcomes */}
              <h4 style={{ fontSize: 13, fontWeight: 700, color: '#334155', marginBottom: 12 }}>
                🎯 Projected Optimization Outcome
              </h4>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 20 }}>
                <div style={{ background: '#F0FDF4', border: '1px solid #BBF7D0', padding: 14, borderRadius: 10 }}>
                  <div style={{ fontSize: 11, color: '#16A34A', fontWeight: 600 }}>Expected Sold</div>
                  <div style={{ fontSize: 20, fontWeight: 800, color: '#166534' }}>
                    {simulatedExpectedSold} / {currentItem.stock} units
                  </div>
                  <div style={{ fontSize: 11, color: '#4ADE80', marginTop: 2 }}>
                    Recovering ฿{simulatedExpectedSold * simulatedFinalPrice}
                  </div>
                </div>

                <div style={{ background: '#FEF2F2', border: '1px solid #FECACA', padding: 14, borderRadius: 10 }}>
                  <div style={{ fontSize: 11, color: '#DC2626', fontWeight: 600 }}>Waste Probability</div>
                  <div style={{ fontSize: 20, fontWeight: 800, color: '#991B1B' }}>
                    {simulatedWasteProb}%
                  </div>
                  <div style={{ fontSize: 11, color: '#F87171', marginTop: 2 }}>
                    Down from 68% without discount
                  </div>
                </div>
              </div>

              {/* Action Button */}
              <button
                className="btn btn-primary"
                onClick={() => handleApplyDiscount(currentItem.id)}
                style={{
                  width: '100%',
                  padding: '14px',
                  fontSize: 15,
                  fontWeight: 700,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: 8,
                  background: 'linear-gradient(135deg, #16A34A, #15803D)',
                  boxShadow: '0 4px 14px rgba(22,163,74,0.3)',
                }}
              >
                <Tag size={18} /> Apply {simulatedDiscount}% Discount to Store & Customer App
              </button>

              <div style={{ textAlign: 'center', marginTop: 12, fontSize: 11, color: '#94A3B8' }}>
                ✓ Syncs instantaneously to ESL (Electronic Shelf Labels) & Customer Deal Feed
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
