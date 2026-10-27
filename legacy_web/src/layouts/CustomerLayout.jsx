import React from 'react';
import { Outlet } from 'react-router-dom';

export default function CustomerLayout() {
  return (
    <div style={{ background: '#F8FAFC', minHeight: '100vh' }}>
      <Outlet />
    </div>
  );
}
