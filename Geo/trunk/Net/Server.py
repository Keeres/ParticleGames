import sqlite3
from time import time
from GameStates import GameStates 
from struct import pack, unpack
from PacketHandler import PacketHandler
from Packet import Packet
from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

ENOUGH_PACKET_DATA = 24

class Player(object):
    def __init__(self, protocol, playerId, alias):
        self.protocol = protocol
        self.playerId = playerId
        self.alias = alias
        self.match = None
        self.lastLogin = time()
        
        # TODO: Look up server history to see player status
        self.protocol.sendPacket(self.protocol.gameState.playerConnected('PlayerConnected:Success'))
        
        print 'Player Connected: ' + playerId
        

    def processState(self, state, data):
        if (state == GameStates.PLAYER_HISTORY):
            # TODO: Need to give more player history
            self.protocol.sendPacket(self.protocol.gameState.playerHistory("LastLogin:{0}".format(self.lastLogin)))

        if (state == GameStates.REQUEST_PLAYER_INFO):
            self.protocol.sendPacket(self.protocol.gameState.requestPlayerInfo("Player:{0}".format(self)))
    
    
    def __repr__(self):
        return "%s:%s" % (self.playerId, self.alias)


class Factory(Factory):
    def __init__(self):
        self.protocol = Protocol
        self.players = []


    def connectionLost(self, protocol):
        for existingPlayer in self.players:
            # Search through list of players to find who disconnected
            # Remove player from list of players
            if existingPlayer.protocol == protocol:
                existingPlayer.protocol = None


    def playerConnected(self, protocol, playerId, alias, continueMatch):
        for existingPlayer in self.players:
            if existingPlayer.playerId == playerId:
                existingPlayer.protocol = protocol
                protocol.player = existingPlayer

        newPlayer = Player(protocol, playerId, alias)
        protocol.player = newPlayer
        self.players.append(newPlayer)


class Protocol(Protocol):
    def __init__(self):
        self.inBuffer = ""
        self.player = None
        self.packetHandler = PacketHandler()
        self.gameState = GameStates()


    def log(self, message):
        if (self.player):
            print "%s: %s" % (self.player.alias, message)
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
                self.factory.playerConnected(self, packet.Data, '', False)
                self.sendPacket(self.gameState.playerInit('PlayerInit:Success'))
            else:
                # Client trying to send invalid packets before player initalized
                self.sendPacket(self.gameState.playerInit('PlayerInit:Fail'))

        else:
            # Let player class determine player and game actions
            self.player.processState(packet.GameState, packet.Data)
            
            #if (packet.GameState >= GameStates.REQUEST_SERVER_STATS)
                # Process server related packets
            
        # if gameState == 1:  # PLAYER_INIT
            # print 'INFORMATION: Sending Player Init Ack'
            # self.sendPlayerInitAck(data)
# 
        # if gameState == 5:  # PLAYER_HISTORY
            # self.sendPlayerHistory()
# 
        # if gameState == 207:  # REQUEST_SERVER_TERRITORIES
            # self.sendServerTerritories()

            
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



                    


    def sendPlayerInitAck(self, data):
        print 'sendPlayerInitAck: ' + data
        cursor.execute("""CREATE TABLE IF NOT EXISTS [PLAYERSTATS] ([Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, [ID] VARCHAR(32) UNIQUE NOT NULL, [NAME] TEXT NOT NULL, [TYPE] TEXT, [PICTURE] TEXT, [DATA] TEXT)""")
        cursor.execute("""CREATE TABLE IF NOT EXISTS [PLAYERCHALLENGERS] ([Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, [ID] VARCHAR(32) UNIQUE NOT NULL, [NAME] TEXT NOT NULL, [EMAIL] TEXT, [PICTURE] TEXT, [WIN] INTEGER, [LOSS] INTEGER,[MATCHSTARTED] TEXT, [LASTPLAYED] TEXT)""")
        data = 'Player Init Ack: ' + data
        timestamp = 2345
        gameState = 1  # Player_Init
        packetCounter = 0
        packetSize = len(data)
        crc = crc32(data)
        packedData = pack('! 8s l Q B B H ' + str(packetSize) + 's', PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, data)
        self.send(packedData)

    def sendPlayerConnectAck(self):
        data = "Player Connect Ack"
        timestamp = 2345
        gameState = 2  # Player_Connected
        packetCounter = 0
        packetSize = len(data)
        crc = crc32(data)
        packedData = pack('! 8s l Q B B H ' + str(packetSize) + 's', PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, data)
        self.send(packedData)


    def sendPlayerHistory(self):
        print 'sendPlayerHistory'
        cursor.execute("""SELECT * FROM PLAYERCHALLENGES""")
        data = ""

        for row in cursor:
            data += '('
            for item in row:
                if row[len(row) - 1] == item:
                    data += str(item)
                else:
                    data += str(item) + ','
            data += ')'

        # data = "Player History Ack"
        timestamp = 2345
        gameState = 5  # Player_History
        packetCounter = 0
        packetSize = len(data)
        crc = crc32(data)
        packedData = pack('! 8s l Q B B H ' + str(packetSize) + 's', PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, data)
        self.send(packedData)

    def sendServerTerritories(self):
        print 'sendServerTerritories'
        cursor.execute("""SELECT * FROM TERRITORIES""")
        data = ""

        for row in cursor:
            data += '('
            for item in row:
                if row[len(row) - 1] == item:
                    data += str(item)
                else:
                    data += str(item) + ','
            data += ')'

        timestamp = 3456
        gameState = 207  # Request_Server_Territories
        packetCounter = 0
        packetSize = len(data)
        crc = crc32(data)
        packedData = pack('! 8s l Q B B H ' + str(packetSize) + 's', PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, data)
        self.send(packedData)




# conn = sqlite3.connect("/Users/kelvin/Documents/iPhone/Projects/Current/SVN/GeoQuestPortrait/Net/GeoQuestServerDB.sqlite")
# cursor = conn.cursor()
# cursor.execute("""CREATE TABLE IF NOT EXISTS [AllPlayers] ([Index] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ID] INTEGER UNIQUE NOT NULL, [Name] TEXT NOT NULL, [Email] TEXT UNIQUE NOT NULL, [Picture] TEXT)""")
# conn.commit()
# print "Database loaded"

factory = Factory()
factory.clients = []
reactor.listenTCP(80, factory)
print "GEOQUEST server started"
reactor.run()
