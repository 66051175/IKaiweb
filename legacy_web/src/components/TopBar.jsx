import React from 'react';
import { Bell, Search } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function TopBar({ title, subtitle }) {
  const navigate = useNavigate();
  const now = new Date();
  const dateStr = now.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'short', day: 'numeric' });

  return (
    <div className="topbar">
      <div className="topbar-left">
        <h1>{title}</h1>
        <p>{subtitle || `Store #001 · ${dateStr}`}</p>
      </div>
      <div className="topbar-right">
        <button className="topbar-btn" title="Search">
          <Search size={16} />
        </button>
        <button className="topbar-btn" title="Notifications" onClick={() => navigate('/notifications')}>
          <Bell size={16} />
          <span className="topbar-notification-dot" />
        </button>
        <div className="topbar-avatar" title="Profile">S</div>
      </div>
    </div>
  );
}
