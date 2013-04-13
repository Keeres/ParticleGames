import sqlite3
from time import time
from GameStates import GameStates
from struct import pack, unpack
from PacketHandler import PacketHandler
from Packet import Packet
from Player import Player
from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

ENOUGH_PACKET_DATA = 24

class Factory(Factory):
    def __init__(self):
        self.protocol = Protocol
        self.active_players = []
        self.db_session = Session()

    def connection_lost(self, protocol):
        for existingPlayer in self.active_players:
            # Search through list of players to find who disconnected
            # Remove player from list of players
            if existingPlayer.protocol == protocol:
                existingPlayer.protocol = None


    def player_connected(self, protocol, data, continueMatch):
        for existing_player in self.active_players:
            # Check if player already logged in
            if existing_player.info.uuid == data:
                existing_player.protocol = protocol
                protocol.player = existing_player

        active_player = Player(protocol, self.db_session, data)
        protocol.player = active_player
        self.active_players.append(active_player)


class Protocol(Protocol):
    def __init__(self):
        self.inBuffer = ""
        self.player = None
        self.packetHandler = PacketHandler()
        self.gameState = GameStates()


    def log(self, message):
        if (self.player):
            print "%s: %s" % (self.player.info.uuid, message)
        else:
            print "%s: %s" % (self, message)


    def connectionMade(self):
        self.factory.clients.append(self)
        self.log("Connection made.")
        self.log("Clients List: %s" % str(self.factory.clients))


    def connectionLost(self, reason):
        self.factory.clients.remove(self)
        self.log("Connection lost: %s" % str(reason))


    def processPacket(self, packet):

        if (self.player == None):
            if (packet.GameState == GameStates.PLAYER_INIT):
                # Initialize player
                self.factory.player_connected(self, packet.Data, False)
                self.sendPacket(self.gameState.player_init('PlayerInit:Success'))
            else:
                # Client trying to send invalid packets before player initalized
                self.sendPacket(self.gameState.player_init('PlayerInit:Fail'))

        else:
            # Let player class determine player and game actions
            self.player.process_state(packet.GameState, packet.Data)

            #if (packet.GameState >= GameStates.REQUEST_SERVER_STATS)
                # Process server related packets

    def dataReceived(self, data):
        self.inBuffer = self.inBuffer + data

        # Check if there is enough data to process
        while (len(self.inBuffer) >= ENOUGH_PACKET_DATA):

            packetPos = self.packetHandler.findNext(self.inBuffer)

            if (packetPos > -1):
                dataExtracted = self.packetHandler.extract(self.inBuffer[packetPos :])
                if (dataExtracted > -1):
                    self.inBuffer = self.inBuffer[packetPos + dataExtracted :]
                    self.processPacket(self.packetHandler.get())
                    print 'Received Packet --'
                    self.packetHandler.DEBUG_PRINT_PACKET()


    def sendPacket(self, packet):
        self.transport.write(self.packetHandler.getPackedDataFromPacket(packet))


    def send(self, message):
        self.transport.write(message)


engine = create_engine('sqlite:///server_test.sqlite', echo=True)
Session = sessionmaker(bind=engine)

factory = Factory()
factory.clients = []
reactor.listenTCP(80, factory)


print "GEO server started"
reactor.run()
