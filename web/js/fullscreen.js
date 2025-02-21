// Toggles fullscreen mode
function toggleFullScreen() {
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch(err => {
            console.error(`Error trying to enable fullscreen: ${err.message}`);
        });
    } else {
        document.exitFullscreen();
    }
}
