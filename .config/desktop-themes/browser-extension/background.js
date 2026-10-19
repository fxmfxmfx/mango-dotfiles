/* No network, tab access or browsing data. Only installed theme IDs are used. */
let port;
let retry;
let desired = null;
let applied = null;
let status = "Connecting to the local theme host…";
let applying = false;

async function report(text, ok, id) {
    status = text;
    browser.browserAction.setBadgeText({text: ok ? "" : "!"});
    browser.browserAction.setBadgeBackgroundColor({color: "#bf616a"});
    if (port) {
        try { port.postMessage({op: "status", ok, theme_id: id, message: text}); }
        catch (_) { /* Native port is reconnecting. */ }
    }
}

async function applyDesired() {
    if (applying) return;
    applying = true;
    try {
        while (desired && desired !== applied) {
            const id = desired;
            try {
                const themes = (await browser.management.getAll()).filter(addon => addon.type === "theme");
                const selected = themes.find(addon => addon.id === id);
                if (!selected) throw new Error("The requested theme is not installed in this browser profile: " + id);
                if (!selected.enabled) await browser.management.setEnabled(id, true);
                applied = id;
                await report("Applied: " + selected.name, true, id);
            } catch (error) {
                await report(String(error.message || error), false, id);
                if (id !== desired) continue;
                break;
            }
        }
        if (!desired) await report("No browser preset assigned; keeping the current theme.", true, null);
    } finally { applying = false; }
}

function connect() {
    clearTimeout(retry);
    try {
        port = browser.runtime.connectNative("io.github.fxmfxmfx.desktop_theme");
        port.onMessage.addListener(message => {
            if (message.type !== "state") return;
            desired = typeof message.theme_id === "string" ? message.theme_id : null;
            applyDesired();
        });
        port.onDisconnect.addListener(disconnected => {
            status = disconnected.error ? disconnected.error.message : "Local theme host disconnected.";
            port = null;
            retry = setTimeout(connect, 2500);
        });
        port.postMessage({op: "watch"});
    } catch (error) {
        status = String(error.message || error);
        retry = setTimeout(connect, 2500);
    }
}

browser.management.onInstalled.addListener(() => { applied = null; applyDesired(); });
browser.management.onEnabled.addListener(addon => {
    if (addon.type === "theme" && addon.id !== desired) applied = null;
});
browser.management.onDisabled.addListener(addon => {
    if (addon.type === "theme" && addon.id === desired) applied = null;
});
browser.runtime.onMessage.addListener(message => {
    if (message.op === "get-status") return Promise.resolve({status, desired, applied});
    return undefined;
});
connect();
