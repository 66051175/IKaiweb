import React, { useState } from 'react';
import { Search, Filter, AlertTriangle, ArrowUpDown, Tag, Plus, Check } from 'lucide-react';
import TopBar from '../../components/TopBar';
import { PRODUCTS, AISLES } from '../../data/mockData';

export default function Inventory() {
  const [filter, setFilter] = useState('all'); // all | restock | expiring | discounted | critical
  const [search, setSearch] = useState('');
  const [restockedIds, setRestockedIds] = useState({});

  // Combine product data with aisle and status metrics
  const inventoryItems = [
    { id: 'p1', name: 'Fresh Milk', emoji: '🥛', category: 'Dairy', stock: 3, maxStock: 40, expiry: '2 days', velocity: 8, price: 45, status: 'critical', aisle: 'Aisle 4' },
    { id: 'p2', name: 'Salmon Sushi', emoji: '🍣', category: 'Ready Meal', stock: 12, maxStock: 30, expiry: '2 hrs', velocity: 6, price: 59, status: 'expiring', aisle: 'Aisle 3', discounted: true, originalPrice: 99 },
    { id: 'p3', name: 'Caesar Salad', emoji: '🥗', category: 'Ready Meal', stock: 18, maxStock: 30, expiry: '3 hrs', velocity: 5, price: 84, status: 'expiring', aisle: 'Aisle 8', discounted: true, originalPrice: 120 },
    { id: 'p4', name: 'Orange Juice', emoji: '🥤', category: 'Beverage', stock: 42, maxStock: 50, expiry: '7 days', velocity: 3, price: 55, status: 'normal', aisle: 'Aisle 5' },
    { id: 'p5', name: 'Butter Croissant', emoji: '🥐', category: 'Bakery', stock: 14, maxStock: 40, expiry: '1 hr', velocity: 5, price: 17, status: 'expiring', aisle: 'Aisle 7', discounted: true, originalPrice: 35 },
    { id: 'p6', name: 'Greek Yogurt', emoji: '🍦', category: 'Dairy', stock: 26, maxStock: 30, expiry: '5 days', velocity: 2, price: 65, status: 'normal', aisle: 'Aisle 9' },
    { id: 'p7', name: 'Mango Sticky Rice', emoji: '🍚', category: 'Dessert', stock: 20, maxStock: 25, expiry: '4 hrs', velocity: 4, price: 60, status: 'expiring', aisle: 'Aisle 8', discounted: true, originalPrice: 80 },
    { id: 'p8', name: 'Sparkling Water', emoji: '💧', category: 'Beverage', stock: 52, maxStock: 60, expiry: '1 year', velocity: 3, price: 30, status: 'normal', aisle: 'Aisle 2' },
    { id: 'p10', name: 'Strawberries', emoji: '🍓', category: 'Fruit', stock: 8, maxStock: 30, expiry: '3 days', velocity: 4, price: 120, status: 'low', aisle: 'Aisle 6' },
  ];

  const handleQuickRestock = (id) => {
    setRestockedIds(prev => ({ ...prev, [id]: true }));
  };

  const filteredItems = inventoryItems.filter(item => {
    const isRestocked = restockedIds[item.id];
    const effectiveStatus = isRestocked ? 'normal' : item.status;

    // Search filter
    const matchesSearch = item.name.toLowerCase().includes(search.toLowerCase()) ||
                          item.category.toLowerCase().includes(search.toLowerCase()) ||
                          item.aisle.toLowerCase().includes(search.toLowerCase());
    if (!matchesSearch) return false;

    // Tab filter
    if (filter === 'restock') return effectiveStatus === 'critical' || effectiveStatus === 'low';
    if (filter === 'expiring') return effectiveStatus === 'expiring';
    if (filter === 'discounted') return !!item.discounted;
    if (filter === 'critical') return effectiveStatus === 'critical';
    return true;
  });

  const statusBadge = (status, isRestocked) => {
    if (isRestocked) {
      return <span className="badge badge-normal">🟢 Restocked</span>;
    }
    switch (status) {
      case 'critical': return <span className="badge badge-critical">🔴 Urgent Restock</span>;
      case 'low': return <span className="badge badge-low">🟡 Stock Low</span>;
      case 'expiring': return <span className="badge badge-warning">🟠 Near Expiry</span>;
      case 'normal': return <span className="badge badge-normal">🟢 Optimal</span>;
      default: return null;
    }
  };

  return (
    <div>
      <TopBar title="Store Inventory" subtitle="Real-time shelf quantities, expiry countdowns & sales velocity" />
      <div className="page-container">

        {/* Filter Tabs & Search Bar */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20, flexWrap: 'wrap', gap: 14 }}>
          
          {/* Tabs */}
          <div style={{ display: 'flex', background: 'white', padding: 4, borderRadius: 10, border: '1px solid #E2E8F0' }}>
            {[
              { id: 'all', label: 'All Items' },
              { id: 'critical', label: '🔴 Critical' },
              { id: 'expiring', label: '🟠 Expiring' },
              { id: 'discounted', label: '🏷️ Discounted' },
              { id: 'restock', label: '📦 Needs Restock' },
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => setFilter(tab.id)}
                style={{
                  padding: '8px 16px',
                  borderRadius: 8,
                  fontSize: 13,
                  fontWeight: 600,
                  cursor: 'pointer',
                  border: 'none',
                  background: filter === tab.id ? '#16A34A' : 'transparent',
                  color: filter === tab.id ? 'white' : '#64748B',
                  transition: 'all 0.15s'
                }}
              >
                {tab.label}
              </button>
            ))}
          </div>

          {/* Search Box */}
          <div style={{ position: 'relative', width: 280 }}>
            <Search size={16} color="#94A3B8" style={{ position: 'absolute', left: 12, top: '50%', transform: 'translateY(-50%)' }} />
            <input
              type="text"
              placeholder="Search product, category, aisle..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              style={{
                width: '100%',
                padding: '9px 12px 9px 36px',
                borderRadius: 10,
                border: '1.5px solid #E2E8F0',
                fontSize: 13,
                outline: 'none',
                background: 'white'
              }}
            />
          </div>

        </div>

        {/* Inventory Table */}
        <div className="card" style={{ overflow: 'hidden' }}>
          <div style={{ overflowX: 'auto' }}>
            <table className="data-table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Location</th>
                  <th>Shelf Stock</th>
                  <th>Expiry Window</th>
                  <th>Sales Velocity</th>
                  <th>Price</th>
                  <th>Status</th>
                  <th style={{ textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredItems.map(item => {
                  const isRestocked = restockedIds[item.id];
                  const currentStock = isRestocked ? item.maxStock : item.stock;

                  return (
                    <tr key={item.id}>
                      <td>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                          <span style={{ fontSize: 24 }}>{item.emoji}</span>
                          <div>
                            <div style={{ fontWeight: 700, color: '#0F172A', fontSize: 13 }}>{item.name}</div>
                            <div style={{ fontSize: 11, color: '#64748B' }}>{item.category}</div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span style={{ fontSize: 12, fontWeight: 600, color: '#475569', background: '#F1F5F9', padding: '4px 8px', borderRadius: 6 }}>
                          {item.aisle}
                        </span>
                      </td>
                      <td>
                        <div>
                          <span style={{ fontWeight: 800, color: currentStock <= 5 ? '#EF4444' : '#0F172A', fontSize: 14 }}>
                            {currentStock}
                          </span>
                          <span style={{ color: '#94A3B8', fontSize: 12 }}> / {item.maxStock}</span>
                        </div>
                      </td>
                      <td>
                        <span style={{
                          fontWeight: 600,
                          color: item.expiry.includes('hr') ? '#D97706' : '#64748B',
                          fontSize: 13
                        }}>
                          {item.expiry}
                        </span>
                      </td>
                      <td>
                        <span style={{ fontWeight: 700, color: '#2563EB', fontSize: 13 }}>
                          {item.velocity} / hr
                        </span>
                      </td>
                      <td>
                        <div>
                          <span style={{ fontWeight: 700, color: '#0F172A', fontSize: 14 }}>฿{item.price}</span>
                          {item.originalPrice && (
                            <span style={{ textDecoration: 'line-through', color: '#94A3B8', fontSize: 11, marginLeft: 6 }}>
                              ฿{item.originalPrice}
                            </span>
                          )}
                        </div>
                      </td>
                      <td>{statusBadge(item.status, isRestocked)}</td>
                      <td style={{ textAlign: 'right' }}>
                        {isRestocked ? (
                          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, color: '#16A34A', fontSize: 12, fontWeight: 600 }}>
                            <Check size={14} /> Full
                          </span>
                        ) : item.stock <= 5 ? (
                          <button
                            className="btn btn-sm btn-primary"
                            onClick={() => handleQuickRestock(item.id)}
                            style={{ fontSize: 11, padding: '4px 10px' }}
                          >
                            Restock
                          </button>
                        ) : (
                          <span style={{ color: '#94A3B8', fontSize: 12 }}>—</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </div>
  );
}
