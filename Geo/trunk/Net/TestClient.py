from twisted.internet import reactor, protocol
from struct import pack, unpack
from zlib import crc32

PACKET_HEADER_SIZE = 16

class TestClient(protocol.Protocol):
    
    def __init__(self):
        self.inBuffer = ""
        
    def sendTestPacket(self, message):

        crc = crc32(message)
        timestamp = 5678
        gameState = 2
        packetCounter = 0
        packetSize = len(message)

        packedData = pack('! l Q B B H ' + str(packetSize) + 's', crc, timestamp, gameState, packetCounter, packetSize, message)
        
        self.send(packedData)
        
        print 'Sending Test Packet '

    def connectionMade(self):
        self.sendTestPacket('Hello World!!')
        self.sendTestPacket('Good Bye!!')
        
        # Done testing        
        #self.transport.loseConnection()

    def processPacket(self, crc, timestamp, gameState, packetCounter, dataSize, data):
        self.DEBUG_printPacket(crc, timestamp, gameState, packetCounter, dataSize, data)
        
        
    def dataReceived(self, data):

        self.inBuffer = self.inBuffer + data

        # Check if there is enough data to process
        while (len(self.inBuffer) >= PACKET_HEADER_SIZE):

            crc, timestamp, gameState, packetCounter, dataSize = unpack('! l Q B B H', self.inBuffer[: PACKET_HEADER_SIZE])
            
            # Check if we received enough data.
            if (len(self.inBuffer) >= PACKET_HEADER_SIZE + dataSize):
                packetData = self.inBuffer[PACKET_HEADER_SIZE : PACKET_HEADER_SIZE + dataSize]

            # Extracted data from inBuffer, move data down the pipe
            self.inBuffer = self.inBuffer[PACKET_HEADER_SIZE + dataSize :]
            
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

class TestFactory(protocol.ClientFactory):
    protocol = TestClient

    def clientConnectionFailed(self, connector, reason):
        print "Connection failed - goodbye!"
        reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "Connection lost - goodbye!"
        reactor.stop()


# this connects the protocol to a server runing on port 8000
def main():
    factory = TestFactory()
    reactor.connectTCP("192.168.1.100", 80, factory)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
