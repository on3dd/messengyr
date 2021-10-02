import { Socket } from "phoenix";

let socket = new Socket("/live", {
  params: {
    guardianToken: window.jwtToken,
  }
});

socket.connect();

const roomId = 1;

socket
  .channel(`room:${roomId}`)
  .join()
  .receive("ok", resp => {
    console.info(`Joined room ${roomId} successfully`, resp);
  })
  .receive("error", resp => {
    console.error(`Unable to join ${roomId}`, resp);
  });

export default socket;