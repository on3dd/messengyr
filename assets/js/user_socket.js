import { Socket } from "phoenix";

let socket = new Socket("/live", {
  params: {
    guardian_token: window.jwtToken,
  }
});

socket.connect();

const roomId = 1;

const channel = socket.channel(`room:${roomId}`)

channel
  .join()
  .receive("ok", (resp) => {
    console.info(`Joined room ${roomId} successfully`, resp);
  })
  .receive("error", (resp) => {
    console.error(`Unable to join ${roomId}`, resp);
  });

channel.push('message:new', {
  text: "nigger",
  room_id: roomId,
});

channel.on('message:new', (resp) => {
  const messageId = resp.message_id;

  fetch(`/api/messages/${messageId}`, {
    headers: {
      "Authorization": `Bearer ${window.jwtToken}`,
    },
  })
    .then((response) => response.json())
    .then((response) => console.log(response))
    .catch((err) => console.error(err));
});

export default socket;