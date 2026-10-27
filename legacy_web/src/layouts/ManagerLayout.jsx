import React, { useContext, useState } from 'react';
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { AppContext } from '../App';
import {
  LayoutDashboard, Map, Package, AlertTriangle,
  Tag, BrainCircuit, BarChart3, Bell, Settings, LogOut
} from 'lucide-react';
import TopBar from '../components/TopBar';
import DemoScenarioBar from '../components/DemoScenarioBar';

const navItems = [
  { to: '/dashboard', icon: LayoutDashboard, label: 'Dashboard' },
  { to: '/store-map', icon: Map, label: 'Store Map' },
  { to: '/inventory', icon: Package, label: 'Inventory' },
  { to: '/restock', icon: AlertTriangle, label: 'Restock', badge: 2 },
  { to: '/pricing', icon: Tag, label: 'Dynamic Pricing' },
  { to: '/ai-forecast', icon: BrainCircuit, label: 'AI Forecast' },
  { to: '/analytics', icon: BarChart3, label: 'Analytics' },
  { to: '/notifications', icon: Bell, label: 'Notifications', badge: 5 },
];

export default function ManagerLayout() {
  const { setRole } = useContext(AppContext);
  const navigate = useNavigate();

  return (
    <div className="app-shell">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-logo">
          <div className="sidebar-logo-mark">
            <div className="logo-icon">🌱</div>
            <span className="logo-text">FreshFlow</span>
          </div>
          <div className="sidebar-store">Store #001 · Central Bangkok</div>
        </div>

        <nav className="sidebar-nav">
          <div className="sidebar-section-label">Main Menu</div>
          {navItems.map(({ to, icon: Icon, label, badge }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) => `sidebar-link${isActive ? ' active' : ''}`}
            >
              <Icon className="link-icon" size={18} />
              {label}
              {badge && <span className="sidebar-badge">{badge}</span>}
            </NavLink>
          ))}

          <div className="sidebar-section-label" style={{ marginTop: 16 }}>Account</div>
          <button className="sidebar-link">
            <Settings className="link-icon" size={18} />
            Settings
          </button>
        </nav>

        <div className="sidebar-footer">
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
            <div style={{
              width: 36, height: 36, borderRadius: '50%',
              background: 'linear-gradient(135deg, #16A34A, #22C55E)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: 'white', fontWeight: 700, fontSize: 14
            }}>S</div>
            <div>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'white' }}>Somchai Jaidee</div>
              <div style={{ fontSize: 11, color: '#64748B' }}>Store Manager</div>
            </div>
          </div>
          <button className="sidebar-link" onClick={() => { setRole(null); navigate('/'); }}>
            <LogOut className="link-icon" size={18} />
            Sign Out
          </button>
        </div>
      </aside>

      {/* Main */}
      <div className="main-content" style={{ display: 'flex', flexDirection: 'column' }}>
        <DemoScenarioBar />
        <div style={{ flex: 1, overflowY: 'auto' }}>
          <Outlet />
        </div>
      </div>
    </div>
  );
}
