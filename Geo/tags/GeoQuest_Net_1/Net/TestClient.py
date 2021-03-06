from struct import pack, unpack
from time import time
from twisted.internet import reactor, protocol
from zlib import crc32

PACKET_HEADER_SIZE = 16
PACKET_KEYWORD     = 'PARTICLE'

class TestClient(protocol.Protocol):
    
    def __init__(self):
        self.inBuffer = ""
        
    def sendTestPacket(self, message):

        timestamp = time()
        gameState = 1
        packetCounter = 0
        packetSize = len(message)
        
        crc = crc32(pack('! Q B B H %ss' % str(packetSize), 0, gameState, packetCounter, packetSize, message))

        packedData = pack('! 8s l Q B B H %ss' % str(packetSize), PACKET_KEYWORD, crc, timestamp, gameState, packetCounter, packetSize, message)
        
        self.send(packedData)
        
        print 'Sending Test Packet '

    def connectionMade(self):
        self.send('bad data')
        self.sendTestPacket('Hello World!!')
        self.send('trash abc')
        self.sendTestPacket('Good Bye!!')
        
        # Done testing        
        #self.transport.loseConnection()

    def processPacket(self, crc, timestamp, gameState, packetCounter, dataSize, data):
        self.DEBUG_printPacket(crc, timestamp, gameState, packetCounter, dataSize, data)
        
        
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
        print 'CRC            :: ' + hex(crc)
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
    reactor.connectTCP("finium.homedns.org", 80, factory)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
