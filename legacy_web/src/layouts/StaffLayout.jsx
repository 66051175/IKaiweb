import React, { useContext } from 'react';
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { AppContext } from '../App';
import { ClipboardList, AlertTriangle, Package, Bell, LogOut } from 'lucide-react';
import DemoScenarioBar from '../components/DemoScenarioBar';

const navItems = [
  { to: '/tasks', icon: ClipboardList, label: 'My Tasks', badge: 3 },
  { to: '/restock', icon: AlertTriangle, label: 'Restock Alerts', badge: 2 },
  { to: '/inventory', icon: Package, label: 'Inventory' },
  { to: '/notifications', icon: Bell, label: 'Notifications', badge: 5 },
];

export default function StaffLayout() {
  const { setRole } = useContext(AppContext);
  const navigate = useNavigate();

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-logo">
          <div className="sidebar-logo-mark">
            <div className="logo-icon">🌱</div>
            <span className="logo-text">FreshFlow</span>
          </div>
          <div className="sidebar-store">Staff Portal · Store #001</div>
        </div>

        <nav className="sidebar-nav">
          <div className="sidebar-section-label">Tasks</div>
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
        </nav>

        <div className="sidebar-footer">
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
            <div style={{
              width: 36, height: 36, borderRadius: '50%',
              background: 'linear-gradient(135deg, #2563EB, #60A5FA)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: 'white', fontWeight: 700, fontSize: 14
            }}>A</div>
            <div>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'white' }}>Alex Chen</div>
              <div style={{ fontSize: 11, color: '#64748B' }}>Floor Staff</div>
            </div>
          </div>
          <button className="sidebar-link" onClick={() => { setRole(null); navigate('/'); }}>
            <LogOut className="link-icon" size={18} />
            Sign Out
          </button>
        </div>
      </aside>

      <div className="main-content" style={{ display: 'flex', flexDirection: 'column' }}>
        <DemoScenarioBar />
        <div style={{ flex: 1, overflowY: 'auto' }}>
          <Outlet />
        </div>
      </div>
    </div>
  );
}
