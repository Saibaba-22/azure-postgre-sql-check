<!DOCTYPE html>
<html>
<head>
    <title>Employee Directory</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #c3d7f7;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        .container {
            margin-top: 50px;
            width: 420px;
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        label {
            width: 110px;
            font-weight: bold;
        }

        input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
        }

        input:focus {
            border-color: #4a90e2;
        }

        button {
            width: 100%;
            margin-top: 15px;
            padding: 10px;
            background: #4cf966;
            color: rgb(0, 0, 0);
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        button:hover {
            background: #f5de11;
        }

        ul {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }

        li {
            background: #f4f6f8;
            padding: 10px;
            margin-bottom: 8px;
            border-radius: 8px;
        }
    </style>
</head>

<body>

<div class="container">
    <h1>Employee Directory 🧑‍💼 </h1>

    <div class="form-row">
        <label>Name :</label>
        <input type="text" id="name">
    </div>

    <div class="form-row">
        <label>Department :</label>
        <input type="text" id="department">
    </div>

    <div class="form-row">
        <label>Email :</label>
        <input type="email" id="email">
    </div>

    <div class="form-row">
        <label>Salary :</label>
        <input type="number" id="salary">
    </div>

    <button onclick="addEmployee()">Add Employee</button>

    <ul id="list"></ul>
</div>
<div class="footer-animation-container">
<div class="work-scene-container">
  <div class="floor-line"></div>
  
  <div id="worker" class="worker state-walk-in">
    <div class="work-particles">
      <span class="particle p1">&lt;/&gt;</span>
      <span class="particle p2">&#128187;</span>
      <span class="particle p3">{}</span>
      <span class="particle p4">✓</span>
    </div>

    <div class="character-mesh">
      <div class="head">
        <div class="hair"></div>
        <div class="glasses"></div>
      </div>
      <div class="torso">
        <div class="arm arm-left"></div>
        <div class="arm arm-right"></div>
      </div>
      <div class="legs">
        <div class="leg leg-left"></div>
        <div class="leg leg-right"></div>
      </div>
    </div>

    <div class="laptop-device">
      <div class="laptop-screen"><div class="screen-glow"></div></div>
      <div class="laptop-base"></div>
    </div>
  </div>
</div>
</div>
<style>
:root {
  --skin-tone: #ffdbac;
  --shirt-color: #2563eb;
  --pants-color: #1e293b;
  --hair-color: #475569;
  --accent-glow: rgba(56, 189, 248, 0.6);
}

.work-scene-container {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 160px;
  background: linear-gradient(to top, rgba(248,250,252,0.95), rgba(248,250,252,0));
  overflow: hidden;
  z-index: 999;
  pointer-events: none;
}

.floor-line {
  position: absolute;
  bottom: 20px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #cbd5e1 20%, #cbd5e1 80%, transparent);
}

/* Character Core positioning */
.worker {
  position: absolute;
  bottom: 22px;
  left: -80px;
  width: 60px;
  height: 110px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* Vector Character Graphics */
.character-mesh { position: relative; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; }
.head { width: 24px; height: 24px; background: var(--skin-tone); border-radius: 50%; position: relative; }
.hair { position: absolute; top: -2px; left: -2px; width: 28px; height: 12px; background: var(--hair-color); border-radius: 12px 12px 0 0; }
.glasses { position: absolute; top: 8px; left: 10px; width: 16px; height: 6px; border: 2px solid #000; border-radius: 0 0 4px 4px; border-top: none; opacity: 0.7; }

.torso { width: 30px; height: 42px; background: var(--shirt-color); border-radius: 8px 8px 4px 4px; position: relative; margin-top: 2px; }
.arm { position: absolute; top: 4px; width: 8px; height: 26px; background: var(--shirt-color); border-radius: 4px; transform-origin: top center; }
.arm-left { left: -4px; }
.arm-right { right: -4px; }

.legs { display: flex; justify-content: space-between; width: 22px; height: 40px; }
.leg { width: 8px; height: 100%; background: var(--pants-color); border-radius: 0 0 4px 4px; transform-origin: top center; }

/* Laptop Vector Design */
.laptop-device {
  position: absolute;
  bottom: 40px;
  right: -32px;
  width: 36px;
  perspective: 100px;
  display: none;
}
.laptop-screen {
  width: 36px;
  height: 24px;
  background: #475569;
  border: 2px solid #94a3b8;
  border-radius: 3px 3px 0 0;
  transform-origin: bottom center;
  transform: rotateX(90deg); /* Start closed */
  transition: transform 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  position: relative;
  overflow: hidden;
}
.screen-glow {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  background: radial-gradient(circle, rgba(14,165,233,0.4) 0%, transparent 80%);
  opacity: 0;
  transition: opacity 0.3s;
}
.laptop-base { width: 42px; height: 4px; background: #94a3b8; margin-left: -3px; border-radius: 0 0 2px 2px; }

/* --- ANIMATION SEQUENCES --- */

/* State 1: Walk In */
.state-walk-in { animation: walkToCenter 4.5s cubic-bezier(0.25, 1, 0.5, 1) forwards; }
.state-walk-in .leg-left { animation: legSwing 0.6s infinite alternate linear; }
.state-walk-in .leg-right { animation: legSwing 0.6s infinite alternate-reverse linear; }
.state-walk-in .arm-left { animation: legSwing 0.6s infinite alternate-reverse linear; }
.state-walk-in .arm-right { animation: legSwing 0.6s infinite alternate linear; }

/* State 2: Working/Typing */
.state-working .laptop-device { display: block; }
.state-working .laptop-screen { transform: rotateX(15deg); } /* Open screen */
.state-working .screen-glow { opacity: 1; }
.state-working .arm-left { transform: rotate(-45deg); animation: typingHands 0.15s infinite alternate; }
.state-working .arm-right { transform: rotate(-55deg); animation: typingHands 0.12s infinite alternate-reverse; }

/* Floating Work Particles */
.work-particles { position: absolute; top: -30px; width: 80px; height: 40px; display: none; pointer-events: none; }
.state-working .work-particles { display: block; }
.particle { position: absolute; font-size: 11px; font-weight: bold; color: #0ea5e9; opacity: 0; font-family: monospace; }
.p1 { left: 0; animation: floatUp 1.2s infinite 0s; }
.p2 { left: 25px; animation: floatUp 1.5s infinite 0.4s; }
.p3 { left: 50px; animation: floatUp 1.1s infinite 0.2s; }
.p4 { left: 70px; animation: floatUp 1.3s infinite 0.6s; }

/* State 3: Walk Out */
.state-walk-out { animation: walkToRight 4.5s cubic-bezier(0.5, 0, 0.75, 0) forwards; }
.state-walk-out .leg-left { animation: legSwing 0.5s infinite alternate linear; }
.state-walk-out .leg-right { animation: legSwing 0.5s infinite alternate-reverse linear; }

/* Keyframes */
@keyframes walkToCenter { 0% { left: -80px; } 100% { left: 50%; transform: translateX(-50%); } }
@keyframes walkToRight { 0% { left: 50%; transform: translateX(-50%); } 100% { left: 105%; } }
@keyframes legSwing { 0% { transform: rotate(-25deg); } 100% { transform: rotate(25deg); } }
@keyframes typingHands { 0% { transform: rotate(-50deg) translateY(0); } 100% { transform: rotate(-42deg) translateY(-2px); } }
@keyframes floatUp {
  0% { transform: translateY(20px) scale(0.6); opacity: 0; }
  50% { opacity: 1; }
  100% { transform: translateY(-20px) scale(1); opacity: 0; }
}
</style>
<script>
    async function addEmployee() {
        let name = document.getElementById("name").value.trim();
        let department = document.getElementById("department").value.trim();
        let email = document.getElementById("email").value.trim();
        let salary = document.getElementById("salary").value.trim();

        if (!name) {
            alert("Name is required");
            return;
        }

        if (!department) department = "None";
        if (!email) email = "None";
        if (!salary) salary = 0;

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email !== "None" && !emailPattern.test(email)) {
            alert("Invalid email");
            return;
        }

        await fetch("/api/employees", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                name,
                department,
                email,
                salary: Number(salary)
            })
        });

        document.getElementById("name").value = "";
        document.getElementById("department").value = "";
        document.getElementById("email").value = "";
        document.getElementById("salary").value = "";

        loadEmployees();
    }

    async function loadEmployees() {
        const res = await fetch("/api/employees");
        const data = await res.json();

        document.getElementById("list").innerHTML =
            data.map(e => `
                <li>
                    <b>$${e.name}</b><br>
                    Dept: $${e.department} | Email: $${e.email} | Salary: ₹$${e.salary}
                </li>
            `).join("");
    }

    loadEmployees();

/* Animation */
document.addEventListener("DOMContentLoaded", () => {
  const worker = document.getElementById("worker");

  function runAnimationCycle() {
    // 1. Reset classes and place character back at the far left start position
    worker.classList.remove("state-walk-out");
    worker.style.left = ""; 
    worker.style.transform = "";
    
    // Force a browser reflow/repaint so the browser registers the reset position
    void worker.offsetWidth; 

    // 2. Start walking in from the left
    worker.classList.add("state-walk-in");

    // 3. Arrive in the center (4.5s matches CSS animation time)
    setTimeout(() => {
      worker.classList.remove("state-walk-in");
      worker.style.left = "50%";
      worker.style.transform = "translateX(-50%)";
      
      // Enter working/typing state
      worker.classList.add("state-working");

      // 4. Simulate working for 5 seconds
      setTimeout(() => {
        worker.classList.remove("state-working");
        
        // Brief 0.8s pause to close laptop lid
        setTimeout(() => {
          worker.style.left = ""; // Clear inline center styles
          worker.classList.add("state-walk-out");

          // 5. Arrives off-screen right after 4.5 seconds.
          // Then wait exactly 5 seconds (5000ms) before starting the next loop!
          setTimeout(() => {
            setTimeout(runAnimationCycle, 5000); 
          }, 4500);

        }, 800);
      }, 5000);
    }, 4500);
  }

  // Kick off the first cycle
  runAnimationCycle();
});
</script>

</body>
</html>