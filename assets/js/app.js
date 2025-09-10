// If you want to use Phoenix channels and transports,
// uncomment the following lines and the socket import below
// import {Socket} from "phoenix"
// import socket from "./socket"

import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Custom JavaScript for Job Sheet application
document.addEventListener("DOMContentLoaded", () => {
  // Auto-hide flash messages after 5 seconds
  const alerts = document.querySelectorAll('.alert')
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.5s'
      alert.style.opacity = '0'
      setTimeout(() => alert.remove(), 500)
    }, 5000)
  })

  // Confirm before deleting
  document.addEventListener('click', e => {
    if (e.target.matches('[data-confirm]')) {
      if (!confirm(e.target.dataset.confirm)) {
        e.preventDefault()
        e.stopPropagation()
        return false
      }
    }
  })

  // Copy task functionality
  const copyButtons = document.querySelectorAll('[data-copy-task]')
  copyButtons.forEach(button => {
    button.addEventListener('click', () => {
      const taskId = button.dataset.copyTask
      // This will be handled by LiveView
    })
  })
})
