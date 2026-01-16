const { Server } = require("socket.io");

const port = process.env.PORT || 3000;
const io = new Server(port, {
    cors: {
        origin: "*", // Allow all connections (Vercel frontend)
        methods: ["GET", "POST"]
    },
});

// Store games in memory
// Map<roomCode, GameState>
const games = new Map();

io.on("connection", (socket) => {
    console.log("Client connected:", socket.id);

    // ### LOBBY EVENTS ###

    socket.on("createLobby", (initialGameState) => {
        // initialGameState contains: roomCode, players (host), gamePhase...
        const roomCode = initialGameState.roomCode;

        // Store game
        games.set(roomCode, initialGameState);

        // Join socket to room
        socket.join(roomCode);

        console.log(`Lobby created: ${roomCode} by ${socket.id}`);

        // Confirm creation (optional, but good for ack)
        socket.emit("createLobby", roomCode);
    });

    socket.on("joinLobby", (data) => {
        // data: { roomCode, player: { id, name } }
        const { roomCode, player } = data;

        if (games.has(roomCode)) {
            const game = games.get(roomCode);

            // Add player to game state
            // Check if already in
            const existingPlayer = game.players.find(p => p.id === player.id);
            if (!existingPlayer) {
                // Assign unassigned role by default
                game.players.push({
                    ...player,
                    role: 'unassigned', // match dart enum string
                    isAlive: true,
                    isHost: false,
                });
            }

            // Join socket
            socket.join(roomCode);

            // Broadcast updated state to room
            io.to(roomCode).emit("gameStateUpdate", game);

            console.log(`Player ${player.name} joined ${roomCode}`);
        } else {
            // Error handling
            socket.emit("error", "Lobby not found");
        }
    });

    // ### GAME FLOW EVENTS ###

    socket.on("startGame", (gameState) => {
        // Host sends updated state with roles assigned
        const roomCode = gameState.roomCode;
        if (games.has(roomCode)) {
            games.set(roomCode, gameState);
            io.to(roomCode).emit("gameStateUpdate", gameState);
            console.log(`Game started in ${roomCode}`);
        }
    });

    socket.on("nextPhase", (gameState) => {
        // Host advances phase
        const roomCode = gameState.roomCode;
        if (games.has(roomCode)) {
            games.set(roomCode, gameState);
            io.to(roomCode).emit("gameStateUpdate", gameState);
            console.log(`Phase advanced in ${roomCode} to ${gameState.gamePhase}`);
        }
    });

    // ### DISCONNECT ###

    socket.on("disconnect", () => {
        console.log("Client disconnected:", socket.id);
        // Real logic needs to handle clean up or reconnect windows
    });
});

console.log("Werwolf Server running on port 3000");
