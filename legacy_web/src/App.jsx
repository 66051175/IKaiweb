import React, { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import './styles/design-system.css';
import './App.css';

// Pages & Layouts
import Login from './pages/Login';
import ManagerLayout from './layouts/ManagerLayout';
import StaffLayout from './layouts/StaffLayout';
import CustomerLayout from './layouts/CustomerLayout';
import Dashboard from './pages/manager/Dashboard';
import StoreMap from './pages/manager/StoreMap';
import RestockAlert from './pages/manager/RestockAlert';
import DynamicPricing from './pages/manager/DynamicPricing';
import AIForecast from './pages/manager/AIForecast';
import Analytics from './pages/manager/Analytics';
import Inventory from './pages/manager/Inventory';
import Notifications from './pages/Notifications';
import StaffTasks from './pages/staff/StaffTasks';
import DealFeed from './pages/customer/DealFeed';

// Initial data
import { AISLES, ALERTS, DISCOUNTS, PRODUCTS } from './data/mockData';

export const AppContext = React.createContext(null);

export default function App() {
  const [role, setRole] = useState(null); // 'manager' | 'staff' | 'customer'
  const [aisles, setAisles] = useState(AISLES);
  const [alerts, setAlerts] = useState(ALERTS);
  const [discounts, setDiscounts] = useState(DISCOUNTS);
  const [demoScenarioStep, setDemoScenarioStep] = useState(0); // 0: Idle, 1: 16:00, 2: 18:00 Rain, 3: 19:00 Stockout, 4: Restocked, 5: End of Day

  // Helper function to step through the competition demo scenario
  const applyScenarioStep = (step) => {
    setDemoScenarioStep(step);
    if (step === 1) {
      // 16:00 — Sushi 20% OFF
      setDiscounts(prev => prev.map(d => d.productId === 'p2' ? { ...d, discountPercent: 20, finalPrice: 79, status: 'active' } : d));
    } else if (step === 2) {
      // 18:00 — Heavy Rain -> 40% OFF
      setDiscounts(prev => prev.map(d => d.productId === 'p2' ? { ...d, discountPercent: 40, finalPrice: 59, status: 'active' } : d));
      setAlerts(prev => [
        {
          id: `al-rain-${Date.now()}`,
          type: 'ai',
          aisleId: 'A3',
          productId: 'p2',
          message: 'AI Dynamic Pricing: Sushi increased to 40% OFF',
          detail: 'Heavy rain reduced foot traffic to 35%. Accelerated discount to clear 20 units before 19:00.',
          time: 'Just now',
          status: 'open',
          estimatedMinutes: 60,
        },
        ...prev,
      ]);
    } else if (step === 3) {
      // 19:00 — Milk Stockout in 22 min! Aisle 4 turns RED
      setAisles(prev => prev.map(a => a.id === 'A4' ? { ...a, status: 'critical', stock: 3, salesVelocity: 8 } : a));
      setAlerts(prev => [
        {
          id: `al-milk-${Date.now()}`,
          type: 'critical',
          aisleId: 'A4',
          productId: 'p1',
          message: 'Fresh Milk critically low (3 units left)',
          detail: 'Stockout predicted in 22 minutes (Stock 3 ÷ Velocity 8/hr). Staff alert dispatched.',
          time: 'Just now',
          status: 'open',
          estimatedMinutes: 22,
        },
        ...prev,
      ]);
    } else if (step === 4) {
      // Staff Alex restocks Aisle 4 -> turns GREEN
      setAisles(prev => prev.map(a => a.id === 'A4' ? { ...a, status: 'normal', stock: 40 } : a));
      setAlerts(prev => prev.map(a => a.aisleId === 'A4' ? { ...a, status: 'resolved' } : a));
    }
  };

  if (!role) {
    return <Login onLogin={setRole} />;
  }

  return (
    <AppContext.Provider value={{
      role,
      setRole,
      aisles,
      setAisles,
      alerts,
      setAlerts,
      discounts,
      setDiscounts,
      demoScenarioStep,
      applyScenarioStep,
    }}>
      <BrowserRouter>
        <Routes>
          {role === 'manager' && (
            <Route path="/" element={<ManagerLayout />}>
              <Route index element={<Navigate to="/dashboard" replace />} />
              <Route path="dashboard" element={<Dashboard />} />
              <Route path="store-map" element={<StoreMap />} />
              <Route path="restock" element={<RestockAlert />} />
              <Route path="pricing" element={<DynamicPricing />} />
              <Route path="ai-forecast" element={<AIForecast />} />
              <Route path="analytics" element={<Analytics />} />
              <Route path="inventory" element={<Inventory />} />
              <Route path="notifications" element={<Notifications />} />
              <Route path="*" element={<Navigate to="/dashboard" replace />} />
            </Route>
          )}
          {role === 'staff' && (
            <Route path="/" element={<StaffLayout />}>
              <Route index element={<Navigate to="/tasks" replace />} />
              <Route path="tasks" element={<StaffTasks />} />
              <Route path="restock" element={<RestockAlert />} />
              <Route path="inventory" element={<Inventory />} />
              <Route path="notifications" element={<Notifications />} />
              <Route path="*" element={<Navigate to="/tasks" replace />} />
            </Route>
          )}
          {role === 'customer' && (
            <Route path="/" element={<CustomerLayout />}>
              <Route index element={<Navigate to="/deals" replace />} />
              <Route path="deals" element={<DealFeed />} />
              <Route path="*" element={<Navigate to="/deals" replace />} />
            </Route>
          )}
        </Routes>
      </BrowserRouter>
    </AppContext.Provider>
  );
}
