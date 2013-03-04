from GameStates import GameStates
from PacketHandler import PacketHandler
from Packet import Packet
from uuid import uuid1
from twisted.internet import reactor, protocol

ENOUGH_PACKET_DATA = 24
PACKET_HEADER_SIZE = 16
PACKET_KEYWORD     = 'PARTICLE'

class TestStates(protocol.Protocol):

    def __init__(self):
        self.inBuffer = ""
        self.packetHandler = PacketHandler()
        self.gameStates = GameStates()


    def sendTestPacket(self, gameState, data):
        self.packetHandler.create(gameState, data)
        self.send(self.packetHandler.getPackedData())
        print 'Sending Test Packet: ' + str(gameState) + ': ' + str(data)


    def connectionMade(self):
        self.send('bad data')
        self.sendTestPacket(self.gameStates.PLAYER_INIT, '7b7f6bcc-8450-11e2-91ae-001fd09c26b1')
                #str(uuid1()))
        self.send('trash abc')
        self.sendTestPacket(self.gameStates.PLAYER_HISTORY, 'Request')
        self.sendTestPacket(self.gameStates.MATCH_INIT, '901feb88-847d-11e2-9e06-001fd09c26b1')

        # Done testing
        #self.transport.loseConnection()


    def processPacket(self, packet):
        print 'Received Packet: ' + str(packet.GameState) + ': '+ str(packet.Data)


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


    def send(self, message):
        self.transport.write(message)


class TestFactory(protocol.ClientFactory):
    protocol = TestStates

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
