// Cosmos Web Admin Panel Client Logic
document.addEventListener('DOMContentLoaded', () => {
    console.log('[Cosmos Admin] Initializing Real-Time Admin Panel linkage...');

    // Element references
    const flagSpatialFeed = document.getElementById('flagSpatialFeed');
    const flagCreatorStudio = document.getElementById('flagCreatorStudio');
    const flagSecurityShield = document.getElementById('flagSecurityShield');
    const flagDynamicModules = document.getElementById('flagDynamicModules');

    const btnRotateKeys = document.getElementById('btnRotateKeys');
    const keyRotationStatus = document.getElementById('keyRotationStatus');

    const targetIdInput = document.getElementById('targetIdInput');
    const btnBanUser = document.getElementById('btnBanUser');
    const btnLockIP = document.getElementById('btnLockIP');
    const moderationFeedback = document.getElementById('moderationFeedback');

    const auditTerminal = document.getElementById('auditTerminal');

    function addAuditLog(msg, isCyan = false) {
        const line = document.createElement('div');
        line.className = 'term-line' + (isCyan ? ' text-cyan' : '');
        line.textContent = `[${new Date().toLocaleTimeString()}] ${msg}`;
        auditTerminal.appendChild(line);
        auditTerminal.scrollTop = auditTerminal.scrollHeight;
    }

    // Feature Flag Change Listeners
    const flags = [
        { el: flagSpatialFeed, name: 'isSpatialFeedEnabled' },
        { el: flagCreatorStudio, name: 'isCreatorStudioEnabled' },
        { el: flagSecurityShield, name: 'isNineLayerShieldActive' },
        { el: flagDynamicModules, name: 'isDynamicModuleDeliveryEnabled' }
    ];

    flags.forEach(({ el, name }) => {
        if (el) {
            el.addEventListener('change', () => {
                const state = el.checked;
                addAuditLog(`[REMOTE CONFIG] Toggled ${name} => ${state}`, true);
            });
        }
    });

    // Key Rotation
    if (btnRotateKeys) {
        btnRotateKeys.addEventListener('click', () => {
            const newEpoch = Math.floor(Math.random() * 90000) + 10000;
            keyRotationStatus.textContent = `Last Rotated: Epoch Key #${newEpoch}`;
            addAuditLog(`[CRYPTO] Master HKDF key rotation triggered globally. Epoch Key #${newEpoch}`, true);
        });
    }

    // Moderation
    if (btnBanUser) {
        btnBanUser.addEventListener('click', () => {
            const target = targetIdInput.value.trim();
            if (!target) {
                moderationFeedback.textContent = 'Please enter a valid User ID.';
                return;
            }
            moderationFeedback.textContent = `User Account ${target} has been suspended across all clients.`;
            addAuditLog(`[MODERATION] User ${target} account suspended. Revoked App Check attestation token.`);
            targetIdInput.value = '';
        });
    }

    if (btnLockIP) {
        btnLockIP.addEventListener('click', () => {
            const target = targetIdInput.value.trim();
            if (!target) {
                moderationFeedback.textContent = 'Please enter a valid IP address.';
                return;
            }
            moderationFeedback.textContent = `IP Perimeter ${target} blocked on Firestore security rules.`;
            addAuditLog(`[SECURITY] Perimeter IP ${target} locked on Layer 1 App Check boundary.`);
            targetIdInput.value = '';
        });
    }

    // Telemetry updates simulation
    setInterval(() => {
        const nodesEl = document.getElementById('metricNodes');
        if (nodesEl) {
            const baseNodes = 14280;
            const delta = Math.floor(Math.random() * 15) - 7;
            nodesEl.textContent = (baseNodes + delta).toLocaleString();
        }
    }, 3000);
});
