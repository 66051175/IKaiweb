import React, { useState, useEffect, useContext } from 'react';
import {
  Flame, Clock, MapPin, Heart, ShoppingBag, ArrowLeft,
  QrCode, CheckCircle2, Sparkles, Share2, Tag, ChevronRight
} from 'lucide-react';
import { AppContext } from '../../App';
import { DISCOUNTS, PRODUCTS } from '../../data/mockData';

export default function DealFeed() {
  const { setRole } = useContext(AppContext);
  const [selectedDeal, setSelectedDeal] = useState(null);
  const [claimedDeal, setClaimedDeal] = useState(null);
  const [savedDeals, setSavedDeals] = useState({});
  const [activeTab, setActiveTab] = useState('deals');

  // Live countdown timer for deal detail modal (HH:MM:SS)
  const [timeLeft, setTimeLeft] = useState({ h: 1, m: 42, s: 35 });

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        if (prev.s > 0) return { ...prev, s: prev.s - 1 };
        if (prev.m > 0) return { ...prev, m: 59, s: 59 };
        if (prev.h > 0) return { h: prev.h - 1, m: 59, s: 59 };
        return prev;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const dealList = [
    {
      id: 'd1',
      name: 'Fresh Salmon Sushi Set',
      emoji: '🍣',
      originalPrice: 99,
      discountPercent: 40,
      finalPrice: 59,
      expiresIn: '01h 42m',
      remainingUnits: 8,
      aisle: 'Aisle 3',
      category: 'Japanese Bento',
      description: 'Handcrafted Norwegian salmon nigiri and maki rolls prepared fresh in-store this morning.',
      whyDeal: 'This sushi set is approaching its evening freshness best-before window. Rescue fresh sushi while cutting organic food waste!',
    },
    {
      id: 'd2',
      name: 'Artisan Caesar Salad Bowl',
      emoji: '🥗',
      originalPrice: 120,
      discountPercent: 30,
      finalPrice: 84,
      expiresIn: '03h 20m',
      remainingUnits: 15,
      aisle: 'Aisle 8',
      category: 'Fresh Produce',
      description: 'Crisp organic romaine lettuce, shaved parmesan, garlic croutons & signature dressing.',
      whyDeal: 'Surplus afternoon batch prepared for lunch rush. Enjoy fresh farm greens at 30% off!',
    },
    {
      id: 'd3',
      name: 'French Butter Croissant',
      emoji: '🥐',
      originalPrice: 35,
      discountPercent: 50,
      finalPrice: 17,
      expiresIn: '00h 55m',
      remainingUnits: 12,
      aisle: 'Aisle 7',
      category: 'Bakery',
      description: 'Flaky, buttery golden croissants baked in pure European butter.',
      whyDeal: 'Last call evening clearance! Flavour and crispness remain top-tier today.',
    },
    {
      id: 'd4',
      name: 'Mango Sticky Rice with Coconut',
      emoji: '🍚',
      originalPrice: 80,
      discountPercent: 25,
      finalPrice: 60,
      expiresIn: '04h 10m',
      remainingUnits: 16,
      aisle: 'Aisle 8',
      category: 'Dessert',
      description: 'Sweet Golden Nam Dok Mai mango served with aromatic warm coconut sticky rice.',
      whyDeal: 'Daily prepared traditional dessert. Help us eliminate daily surplus.',
    },
  ];

  const handleClaim = (deal) => {
    setClaimedDeal(deal);
  };

  const toggleSave = (id, e) => {
    e.stopPropagation();
    setSavedDeals(prev => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div style={{ minHeight: '100vh', background: '#F1F5F9', display: 'flex', justifyContent: 'center', padding: '16px 8px' }}>
      
      {/* Mobile Device Simulation Shell */}
      <div style={{
        width: '100%',
        maxWidth: 420,
        background: '#FFFFFF',
        minHeight: '92vh',
        borderRadius: 28,
        boxShadow: '0 16px 40px rgba(0,0,0,0.12)',
        display: 'flex',
        flexDirection: 'column',
        position: 'relative',
        overflow: 'hidden',
        border: '6px solid #1E293B',
      }}>
        
        {/* Device Top Speaker & Notch */}
        <div style={{ display: 'flex', justifyContent: 'center', padding: '8px 0', background: '#FFFFFF' }}>
          <div style={{ width: 80, height: 5, background: '#CBD5E1', borderRadius: 10 }} />
        </div>

        {/* Customer App Top Header */}
        <div style={{ padding: '12px 18px', borderBottom: '1px solid #F1F5F9' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ fontSize: 22 }}>🌱</span>
              <span style={{ fontSize: 18, fontWeight: 900, color: '#16A34A', letterSpacing: -0.5 }}>FreshFlow</span>
            </div>
            <button
              onClick={() => setRole(null)}
              style={{
                fontSize: 11, fontWeight: 700, color: '#64748B', background: '#F1F5F9',
                border: 'none', padding: '6px 12px', borderRadius: 20, cursor: 'pointer'
              }}
            >
              Switch Role
            </button>
          </div>

          {/* Location Picker */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8 }}>
            <MapPin size={14} color="#EF4444" />
            <span style={{ fontSize: 12, fontWeight: 700, color: '#0F172A' }}>FreshFlow Central Bangkok · Store #001</span>
            <span style={{ fontSize: 11, color: '#16A34A', fontWeight: 600 }}>• 350m</span>
          </div>
        </div>

        {/* Content Body */}
        <div style={{ flex: 1, overflowY: 'auto', padding: '16px 18px 80px' }}>
          
          {/* Flash Deals Hero Banner */}
          <div style={{
            background: 'linear-gradient(135deg, #EF4444 0%, #F59E0B 100%)',
            borderRadius: 18, padding: '18px 20px', color: 'white', marginBottom: 20,
            boxShadow: '0 8px 20px rgba(239, 68, 68, 0.25)'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, fontWeight: 800, textTransform: 'uppercase', letterSpacing: 0.5 }}>
              <Flame size={18} /> Fresh Clearance Deals
            </div>
            <h2 style={{ fontSize: 20, fontWeight: 900, margin: '6px 0 4px 0' }}>
              Save up to 50% OFF!
            </h2>
            <p style={{ fontSize: 12, opacity: 0.95, margin: 0 }}>
              Help eliminate food waste while grabbing fresh gourmet food at steep discounts.
            </p>
          </div>

          {/* Section Title */}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <h3 style={{ fontSize: 16, fontWeight: 800, color: '#0F172A', margin: 0, display: 'flex', alignItems: 'center', gap: 6 }}>
              🔥 Live Flash Deals
            </h3>
            <span style={{ fontSize: 12, color: '#64748B', fontWeight: 600 }}>{dealList.length} Active</span>
          </div>

          {/* Deals Feed */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {dealList.map(deal => (
              <div
                key={deal.id}
                onClick={() => setSelectedDeal(deal)}
                style={{
                  background: 'white',
                  borderRadius: 16,
                  border: '1.5px solid #E2E8F0',
                  padding: '14px',
                  display: 'flex',
                  gap: 14,
                  cursor: 'pointer',
                  transition: 'transform 0.15s, box-shadow 0.15s',
                  boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
                }}
                onMouseEnter={e => { e.currentTarget.style.transform = 'translateY(-2px)'; e.currentTarget.style.boxShadow = '0 6px 16px rgba(0,0,0,0.08)'; }}
                onMouseLeave={e => { e.currentTarget.style.transform = 'translateY(0)'; e.currentTarget.style.boxShadow = '0 2px 8px rgba(0,0,0,0.04)'; }}
              >
                {/* Product Emoji Icon Box */}
                <div style={{
                  width: 74, height: 74, borderRadius: 14, background: '#F8FAFC',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: 38, border: '1px solid #F1F5F9', flexShrink: 0
                }}>
                  {deal.emoji}
                </div>

                {/* Product Info */}
                <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
                  <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                      <h4 style={{ fontSize: 14, fontWeight: 800, color: '#0F172A', margin: 0 }}>
                        {deal.name}
                      </h4>
                      <button
                        onClick={(e) => toggleSave(deal.id, e)}
                        style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 2 }}
                      >
                        <Heart size={16} color={savedDeals[deal.id] ? '#EF4444' : '#CBD5E1'} fill={savedDeals[deal.id] ? '#EF4444' : 'none'} />
                      </button>
                    </div>
                    <span style={{ fontSize: 11, color: '#64748B' }}>{deal.category} · {deal.aisle}</span>
                  </div>

                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginTop: 8 }}>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
                        <span style={{ fontSize: 18, fontWeight: 900, color: '#EF4444' }}>฿{deal.finalPrice}</span>
                        <span style={{ fontSize: 12, color: '#94A3B8', textDecoration: 'line-through' }}>฿{deal.originalPrice}</span>
                        <span style={{
                          fontSize: 11, fontWeight: 800, color: '#16A34A', background: '#DCFCE7',
                          padding: '2px 6px', borderRadius: 6
                        }}>
                          {deal.discountPercent}% OFF
                        </span>
                      </div>
                      <div style={{ fontSize: 11, color: '#D97706', fontWeight: 600, marginTop: 2, display: 'flex', alignItems: 'center', gap: 4 }}>
                        <Clock size={11} /> Ends in {deal.expiresIn} · {deal.remainingUnits} left
                      </div>
                    </div>

                    <button
                      className="btn btn-primary btn-sm"
                      style={{ padding: '6px 12px', fontSize: 11, fontWeight: 700, borderRadius: 8 }}
                      onClick={(e) => { e.stopPropagation(); setSelectedDeal(deal); }}
                    >
                      Get Deal
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>

        </div>

        {/* Mobile Bottom Navigation Bar */}
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          background: 'white', borderTop: '1px solid #E2E8F0', padding: '10px 24px',
          display: 'flex', justifyContent: 'space-between', alignItems: 'center'
        }}>
          <button
            onClick={() => setActiveTab('deals')}
            style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, background: 'none', border: 'none', cursor: 'pointer', color: activeTab === 'deals' ? '#16A34A' : '#94A3B8' }}
          >
            <Flame size={20} />
            <span style={{ fontSize: 10, fontWeight: 700 }}>Deals</span>
          </button>
          <button
            onClick={() => setActiveTab('stores')}
            style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, background: 'none', border: 'none', cursor: 'pointer', color: activeTab === 'stores' ? '#16A34A' : '#94A3B8' }}
          >
            <MapPin size={20} />
            <span style={{ fontSize: 10, fontWeight: 600 }}>Stores</span>
          </button>
          <button
            onClick={() => setActiveTab('saved')}
            style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, background: 'none', border: 'none', cursor: 'pointer', color: activeTab === 'saved' ? '#16A34A' : '#94A3B8' }}
          >
            <Heart size={20} />
            <span style={{ fontSize: 10, fontWeight: 600 }}>Saved</span>
          </button>
          <button
            onClick={() => setActiveTab('profile')}
            style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, background: 'none', border: 'none', cursor: 'pointer', color: activeTab === 'profile' ? '#16A34A' : '#94A3B8' }}
          >
            <ShoppingBag size={20} />
            <span style={{ fontSize: 10, fontWeight: 600 }}>My Deals</span>
          </button>
        </div>

        {/* Deal Detail Modal (Point 9 in User Prompt) */}
        {selectedDeal && (
          <div style={{
            position: 'absolute', inset: 0, background: 'rgba(15,23,42,0.6)',
            display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', zIndex: 100
          }}>
            <div style={{
              background: 'white', borderTopLeftRadius: 24, borderTopRightRadius: 24,
              padding: '24px 20px', maxHeight: '85%', overflowY: 'auto', animation: 'slideUp 0.25s ease-out'
            }}>
              
              {/* Top back button */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
                <button
                  onClick={() => { setSelectedDeal(null); setClaimedDeal(null); }}
                  style={{ background: '#F1F5F9', border: 'none', borderRadius: 20, padding: '6px 12px', fontSize: 12, fontWeight: 700, cursor: 'pointer' }}
                >
                  ✕ Close
                </button>
                <span className="badge badge-warning">
                  🔥 {selectedDeal.remainingUnits} Left in Store
                </span>
              </div>

              {/* Product Big Icon */}
              <div style={{ textAlign: 'center', margin: '8px 0 16px' }}>
                <div style={{ fontSize: 64 }}>{selectedDeal.emoji}</div>
                <h3 style={{ fontSize: 20, fontWeight: 900, color: '#0F172A', marginTop: 8 }}>
                  {selectedDeal.name}
                </h3>
                <div style={{ fontSize: 12, color: '#64748B' }}>
                  {selectedDeal.category} · {selectedDeal.aisle}
                </div>
              </div>

              {/* Price & Discount Big Display */}
              <div style={{
                background: '#FEF2F2', border: '1.5px solid #FECACA', borderRadius: 16,
                padding: '16px 20px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 18
              }}>
                <div>
                  <div style={{ fontSize: 11, color: '#991B1B', fontWeight: 700, textTransform: 'uppercase' }}>
                    Special Flash Price
                  </div>
                  <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
                    <span style={{ fontSize: 32, fontWeight: 900, color: '#EF4444' }}>฿{selectedDeal.finalPrice}</span>
                    <span style={{ fontSize: 16, color: '#94A3B8', textDecoration: 'line-through' }}>฿{selectedDeal.originalPrice}</span>
                  </div>
                </div>
                <div style={{
                  background: '#EF4444', color: 'white', padding: '8px 14px',
                  borderRadius: 12, fontWeight: 900, fontSize: 16
                }}>
                  {selectedDeal.discountPercent}% OFF
                </div>
              </div>

              {/* Urgency Live Countdown Box */}
              <div style={{
                background: '#0F172A', color: 'white', borderRadius: 14, padding: '14px 18px',
                textAlign: 'center', marginBottom: 18
              }}>
                <div style={{ fontSize: 11, color: '#94A3B8', textTransform: 'uppercase', letterSpacing: 0.5, fontWeight: 600 }}>
                  ⏰ Offer Expiration Countdown
                </div>
                <div style={{
                  fontSize: 26, fontWeight: 900, letterSpacing: 3, marginTop: 4,
                  fontFamily: 'monospace', color: '#FCD34D'
                }}>
                  {String(timeLeft.h).padStart(2, '0')} : {String(timeLeft.m).padStart(2, '0')} : {String(timeLeft.s).padStart(2, '0')}
                </div>
                <div style={{ fontSize: 11, color: '#CBD5E1', marginTop: 4 }}>
                  📍 FreshFlow Store #001 · Central Bangkok
                </div>
              </div>

              {/* Why This Deal? (Crucial section from prompt) */}
              <div style={{
                background: '#F0FDF4', border: '1px solid #BBF7D0', borderRadius: 14,
                padding: '14px 16px', marginBottom: 20
              }}>
                <div style={{ fontSize: 13, fontWeight: 800, color: '#166534', display: 'flex', alignItems: 'center', gap: 6 }}>
                  🌱 Why this deal?
                </div>
                <p style={{ fontSize: 12, color: '#15803D', lineHeight: 1.5, margin: '6px 0 0 0' }}>
                  {selectedDeal.whyDeal}
                </p>
              </div>

              {/* Claim Action or QR Code display */}
              {claimedDeal?.id === selectedDeal.id ? (
                <div style={{
                  background: '#F8FAFC', border: '2px dashed #16A34A', borderRadius: 16,
                  padding: '20px', textAlign: 'center'
                }}>
                  <div style={{ color: '#16A34A', fontWeight: 800, fontSize: 16, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
                    <CheckCircle2 size={20} /> Voucher Claimed!
                  </div>
                  <div style={{
                    margin: '16px auto', width: 140, height: 140, background: 'white',
                    border: '1px solid #CBD5E1', borderRadius: 12, display: 'flex',
                    alignItems: 'center', justifyContent: 'center'
                  }}>
                    <QrCode size={110} color="#0F172A" />
                  </div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: '#0F172A' }}>
                    CODE: FF-{selectedDeal.id.toUpperCase()}-7729
                  </div>
                  <div style={{ fontSize: 11, color: '#64748B', marginTop: 4 }}>
                    Show barcode at register within 45 minutes to redeem
                  </div>
                </div>
              ) : (
                <button
                  className="btn btn-primary"
                  onClick={() => handleClaim(selectedDeal)}
                  style={{
                    width: '100%',
                    padding: '16px',
                    fontSize: 16,
                    fontWeight: 900,
                    borderRadius: 14,
                    background: 'linear-gradient(135deg, #16A34A, #15803D)',
                    boxShadow: '0 6px 20px rgba(22,163,74,0.3)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: 8,
                  }}
                >
                  <Tag size={20} /> CLAIM DEAL NOW (฿{selectedDeal.finalPrice})
                </button>
              )}

            </div>
          </div>
        )}

      </div>
    </div>
  );
}
