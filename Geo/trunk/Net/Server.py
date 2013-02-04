import time
import datetime
from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from struct import pack, unpack
from zlib import crc32

PACKET_HEADER_SIZE = 16
PACKET_KEYWORD     = 'PARTICLE'

class Player:
    def __init__(self, protocol, playerId, alias):
        self.protocol = protocol
        self.playerId = playerId
        self.alias = alias
        self.match = None
        self.email = None

    def __repr__(self):
        return "%s:%s" % (self.playerId, self.email)

 
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

    def sendDataEcho(self, data):
        self.send(data)
        print 'Echo Packet'
        
    def formatData(self, gameState, data):
        timestamp = 1234
        packetCounter = 0
        packetSize = len(data)

        # TBD Calculate CRC for whole data packet
        crc = crc32(data)

        packedData = pack('! 8s l Q B B H ' + str(packetSize) + 's', PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, data)
        
        self.send(packedData)
        
    def processPacket(self, crc, timestamp, gameState, packetCounter, dataSize, data):
        self.DEBUG_printPacket(crc, timestamp, gameState, packetCounter, dataSize, data)
        
        print 'Sending Packet Echo Response'
        self.formatData(gameState + 1, 'Response-' + data)
        
    def dataReceived(self, data):

        self.inBuffer = self.inBuffer + data
        
        print 'length:      :'  + str(len(self.inBuffer))

        # Check if there is enough data to process
        while (len(self.inBuffer) >= PACKET_HEADER_SIZE + 8):

            packetStart = self.inBuffer.find(PACKET_KEYWORD)
            
            if (packetStart > -1):
                crc, timestamp, gameState, packetCounter, dataSize = unpack('! l Q B B H', self.inBuffer[packetStart + 8: packetStart + 8 + PACKET_HEADER_SIZE])
            
                self.inBuffer = self.inBuffer[packetStart + 8 + PACKET_HEADER_SIZE :]

                # Check if we received enough data.
                if (len(self.inBuffer) >= dataSize):
                    packetData = self.inBuffer[: dataSize]
    
                    # Extracted data from inBuffer, move data down the pipe
                    self.inBuffer = self.inBuffer[dataSize :]
                    
                    # Process data
                    self.processPacket(crc, timestamp, gameState, packetCounter, dataSize, packetData)

        
    def DEBUG_printPacket(self, crc, timestamp, gameState, packetCounter, dataSize, packetData):
        print 'Data Received - Packet Dump'
        print 'CRC            :: ' + str(crc)
        print 'Timestamp      :: ' + str(timestamp)
        print 'Game State     :: ' + str(gameState)
        print 'Packet Counter :: ' + str(packetCounter)
        print 'Data Size      :: ' + str(dataSize)
        print 'Data           :: ' + packetData

    def send(self, message):
        self.transport.write(message)

factory = Factory()
factory.clients = []
reactor.listenTCP(80, factory)
print "GEOQUEST server started"
reactor.run()
