import "../css/app.css";
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

const userId =
  (localStorage && localStorage.userId) ||
  Math.random()
    .toFixed(20)
    .substring(2, 16);

if (localStorage) {
  localStorage.userId = userId;
}

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken, user_id: userId }
});

liveSocket.connect();
