browser.runtime.sendMessage({op: "get-status"}).then(result => {
    document.getElementById("status").textContent = result.status;
}).catch(error => {
    document.getElementById("status").textContent = String(error);
});
