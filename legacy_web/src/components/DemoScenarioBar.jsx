import React, { useContext, useState } from 'react';
import { Play, Sparkles, CloudRain, Clock, CheckCircle2, ChevronRight, RotateCcw } from 'lucide-react';
import { AppContext } from '../App';

export default function DemoScenarioBar() {
  const { demoScenarioStep, applyScenarioStep, role, setRole } = useContext(AppContext);
  const [expanded, setExpanded] = useState(true);

  const steps = [
    {
      step: 1,
      time: '🕓 16:00',
      title: 'Sushi 20% OFF',
      desc: 'Stock = 20, Expiry = 19:00. AI calculates 20% discount for customer feed.',
    },
    {
      step: 2,
      time: '🕕 18:00',
      title: '🌧️ Heavy Rain',
      desc: 'Traffic dips 35%. AI immediately raises discount to 40% OFF flash deal.',
    },
    {
      step: 3,
      time: '🕖 19:00',
      title: '🔴 Milk Stockout Risk',
      desc: 'Milk sells fast! Stock = 3, Velocity = 8/hr. Stockout in 22 min. Aisle 4 turns RED.',
    },
    {
      step: 4,
      time: '👷 Restock Action',
      desc: 'Staff receives urgent task -> taps Restock Now -> Aisle 4 turns GREEN.',
    },
    {
      step: 5,
      time: '🏆 End of Day',
      desc: '86 items rescued, 18.4 kg waste avoided, ฿12,450 recovered revenue!',
    },
  ];

  return (
    <div style={{
      background: 'linear-gradient(90deg, #0F172A 0%, #1E293B 100%)',
      color: 'white',
      padding: expanded ? '10px 20px' : '6px 20px',
      borderBottom: '2px solid #22C55E',
      position: 'relative',
      zIndex: 50,
      boxShadow: '0 4px 16px rgba(0,0,0,0.15)',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 10 }}>
        
        {/* Left: Title & Quick Role Switcher */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <span style={{
            background: '#22C55E', color: '#0F172A', fontWeight: 900, fontSize: 11,
            padding: '3px 8px', borderRadius: 6, textTransform: 'uppercase', letterSpacing: 0.5
          }}>
            Demo Scenario Player
          </span>
          <span style={{ fontSize: 13, fontWeight: 700, color: '#F8FAFC' }}>
            Presentation Flow (Point 20)
          </span>

          {/* Role switcher pill */}
          <div style={{ display: 'flex', background: 'rgba(255,255,255,0.1)', padding: 2, borderRadius: 20 }}>
            <button
              onClick={() => setRole('manager')}
              style={{
                background: role === 'manager' ? '#16A34A' : 'transparent',
                color: 'white', border: 'none', padding: '3px 10px', borderRadius: 16,
                fontSize: 11, fontWeight: 700, cursor: 'pointer'
              }}
            >
              👔 Manager
            </button>
            <button
              onClick={() => setRole('staff')}
              style={{
                background: role === 'staff' ? '#2563EB' : 'transparent',
                color: 'white', border: 'none', padding: '3px 10px', borderRadius: 16,
                fontSize: 11, fontWeight: 700, cursor: 'pointer'
              }}
            >
              🧑‍🏭 Staff
            </button>
            <button
              onClick={() => setRole('customer')}
              style={{
                background: role === 'customer' ? '#7C3AED' : 'transparent',
                color: 'white', border: 'none', padding: '3px 10px', borderRadius: 16,
                fontSize: 11, fontWeight: 700, cursor: 'pointer'
              }}
            >
              🛒 Customer
            </button>
          </div>
        </div>

        {/* Right: Step buttons */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
          {steps.map(s => {
            const isActive = demoScenarioStep === s.step;
            return (
              <button
                key={s.step}
                onClick={() => applyScenarioStep(s.step)}
                title={s.desc}
                style={{
                  background: isActive ? '#22C55E' : 'rgba(255,255,255,0.08)',
                  color: isActive ? '#0F172A' : '#E2E8F0',
                  border: isActive ? '1px solid #4ADE80' : '1px solid rgba(255,255,255,0.12)',
                  borderRadius: 8,
                  padding: '5px 10px',
                  fontSize: 11,
                  fontWeight: 700,
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 4,
                  transition: 'all 0.15s',
                }}
              >
                <span>{s.time}</span>
                <span style={{ opacity: isActive ? 1 : 0.8 }}>{s.title}</span>
              </button>
            );
          })}

          <button
            onClick={() => applyScenarioStep(0)}
            title="Reset Scenario"
            style={{
              background: 'rgba(255,255,255,0.05)', color: '#94A3B8',
              border: 'none', borderRadius: 8, padding: '5px 8px',
              fontSize: 11, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4
            }}
          >
            <RotateCcw size={12} /> Reset
          </button>
        </div>

      </div>

      {/* Active step explanation banner */}
      {demoScenarioStep > 0 && (
        <div style={{
          marginTop: 8, padding: '6px 12px', background: 'rgba(34, 197, 94, 0.15)',
          borderRadius: 8, border: '1px solid rgba(34, 197, 94, 0.3)',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between', fontSize: 12
        }}>
          <div>
            <strong>Step {demoScenarioStep}:</strong> {steps[demoScenarioStep - 1].desc}
          </div>
          <span style={{ fontSize: 11, color: '#86EFAC', fontWeight: 600 }}>
            Live sync active across all views
          </span>
        </div>
      )}
    </div>
  );
}
